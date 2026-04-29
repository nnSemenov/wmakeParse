cmake_minimum_required(VERSION 3.28)
project(wmakeParse LANGUAGES CXX)

add_library(wmakeParse STATIC
    parse_wmake.H
    parse_wmake.C
)

target_compile_features(wmakeParse PRIVATE
    cxx_std_23
)
target_compile_features(wmakeParse PUBLIC
    cxx_std_17
)
target_include_directories(wmakeParse PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

add_executable(test_wmakeParse test.cpp)
target_link_libraries(test_wmakeParse PRIVATE wmakeParse)
target_compile_features(test_wmakeParse PRIVATE cxx_std_23)

find_package(CLI11 REQUIRED)
add_executable(parse-wmake parser_exe.cpp)
target_compile_features(parse-wmake PRIVATE cxx_std_23)
target_link_libraries(parse-wmake PRIVATE
    wmakeParse
    CLI11::CLI11
)