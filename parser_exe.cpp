//
// Created by joseph on 2026/4/29.
//
#include <filesystem>
#include <fstream>
#include <print>
#include <format>
#include <iostream>

#include <CLI/CLI.hpp>
#include <parse_wmake.H>

namespace fs = std::filesystem;

struct task_info {
  fs::path filename;
  bool print_files{false};
  bool print_all_vars{false};
  std::string get_variable_name;
  bool parse_brace_expression{false};
};

int run_task(const task_info& task);

int main(int argc, char** argv) {
  task_info task;

  CLI::App app{"Parse wmake file", "parse-wmake"};
  app.set_config("", "",
                 "Parse single wmake file and print required information. If "
                 "not specified, print everything.");
  app.add_option("file", task.filename, "File to parse")
      ->required()
      ->check(CLI::ExistingFile);
  app.add_flag("--print-files", task.print_files,
               "Print files (usually source files)");
  app.add_flag("--print-all-variables", task.print_all_vars,
               "Print all variables (with name)");
  app.add_option("--get", task.get_variable_name, "Get variable name");
  app.add_flag("--parse-brace-expression", task.parse_brace_expression,
               "Parse ${} expression");

  CLI11_PARSE(app, argc, argv);

  return run_task(task);
}

int run_task(const task_info& task) {
  const std::string file_content = [&task]() {
    std::string file_content;
    const auto file_len = file_size(task.filename);
    file_content.resize(file_len, '\0');
    std::ifstream ifs{task.filename};
    ifs.readsome(file_content.data(), file_len);
    return file_content;
  }();

  auto env = Foam::wmakeParse::get_environment_variables();
  std::map<std::string, std::string> new_vars = env;
  Foam::wmakeParse::wmake_parse_option option;
  option.parse_brace_expression = task.parse_brace_expression;

  std::vector<std::string> files;
  try {
    files = Foam::wmakeParse::parse_wmake_file(file_content, new_vars, option);
  } catch (const std::exception& e) {
    std::println(std::cerr, "Failed to parse {}: {}", task.filename.c_str(),
                 e.what());
    return 2;
  }

  for (const auto& [key, val] : env) {
    auto it = new_vars.find(key);
    if (it == new_vars.end()) {  // new vars doesn't contain env var, actually
                                 // not possible
      continue;
    }
    if (it->second not_eq val) {  // env var is changed
      continue;
    }
    // env var is not changed, pure inherited from env, not  actually updated in
    // this wmake file. Not considered to be a variable from this wmake file
    new_vars.erase(it);
  }

  if (task.print_files) {
    for (const auto& file : files) {
      std::println("{}", file);
    }
  }
  if (task.print_all_vars) {
    for (const auto& [key, val] : new_vars) {
      std::println("{}={}", key, val);
    }
  }

  if (not task.get_variable_name.empty()) {
    auto it = new_vars.find(task.get_variable_name);
    if (it == new_vars.end()) {
      std::println(std::cerr, "{} doesn't contains variable \"{}\"",
                   task.filename.c_str(), task.get_variable_name);
      return 1;
    }
    std::println("{}", it->second);
  }

  return 0;
}