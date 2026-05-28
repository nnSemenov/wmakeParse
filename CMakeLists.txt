#This file is part of wmakeParse (https://github.com/nnSemenov/wmakeParse).
#
#wmakeParse is free software: you can redistribute it and/or modify it under
#the terms of the GNU General Public License as published by the Free Software
#Foundation, either version 3 of the License, or (at your option) any later
#version.
#
#wmakeParse is distributed in the hope that it will be useful, but WITHOUT ANY
#WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
#A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with
#wmakeParse. If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.28)
project(wmakeParse LANGUAGES CXX VERSION 0.1.3)

include(cmake/3rdParty/cli11.cmake)

add_library(wmakeParse STATIC
    parse_wmake.H
    parse_wmake.C
)

set_target_properties(wmakeParse PROPERTIES
    POSITION_INDEPENDENT_CODE ON
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

#find_package(CLI11 REQUIRED)
add_executable(parse-wmake parser_exe.cpp)
target_compile_features(parse-wmake PRIVATE cxx_std_23)
target_include_directories(parse-wmake PRIVATE
    ${cli11_include_dir}
)
target_link_libraries(parse-wmake PRIVATE
    wmakeParse
)

# install operations
include(cmake/install.cmake)
# make package
include(cmake/pack.cmake)