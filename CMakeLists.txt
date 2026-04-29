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

add_executable(test_wmakeParse test.cpp)
target_link_libraries(test_wmakeParse PRIVATE wmakeParse)
target_compile_features(test_wmakeParse PRIVATE cxx_std_23)