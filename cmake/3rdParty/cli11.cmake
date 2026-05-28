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

if (DEFINED cli11_include_dir)
    if (EXISTS ${cli11_include_dir}/CLI11.hpp)
        message(STATUS "cli11 found at " ${cli11_include_dir}/CLI11.hpp)
        return()
    else ()
        message(WARNING "Assigned cli11_include_dir to be " ${cli11_include_dir}
            " but failed to find CLI11.hpp")
        unset(cli11_include_dir)
    endif ()
endif ()

if (EXISTS ${CMAKE_BINARY_DIR}/3rdParty/cli11/CLI11.hpp)
    message(STATUS "cli11 found at " ${CMAKE_BINARY_DIR}/3rdParty/cli11/CLI11.hpp)
    set(cli11_include_dir ${CMAKE_BINARY_DIR}/3rdParty/cli11)
    return()
endif ()

message(STATUS "Downloading cli11.hpp ......")

file(DOWNLOAD
    https://github.com/CLIUtils/CLI11/releases/download/v2.4.1/CLI11.hpp
    ${CMAKE_BINARY_DIR}/3rdParty/cli11/CLI11.hpp
    EXPECTED_HASH SHA512=7DB1F5B879DF99639ADA29AD313D5E344E1B0FD30A44116DA00A6CA53BEF4BA840684CBC64290CF365569095B0915D181039777FCE780BC60E20F624623B98B9
    SHOW_PROGRESS)

if (NOT EXISTS ${CMAKE_BINARY_DIR}/3rdParty/cli11/CLI11.hpp)
    message(ERROR "Failed to download cli11.")
    return()
endif ()

message(STATUS "cli11 downloaded successfully.")
set(cli11_include_dir ${CMAKE_BINARY_DIR}/3rdParty/cli11)
