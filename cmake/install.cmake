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

install(FILES
    parse_wmake.H
    DESTINATION include
)

install(TARGETS wmakeParse parse-wmake
    EXPORT wmakeParseTargets
    PERMISSIONS OWNER_READ OWNER_EXECUTE OWNER_WRITE
                GROUP_READ GROUP_EXECUTE
                WORLD_READ WORLD_EXECUTE
)
include(CMakePackageConfigHelpers)
configure_package_config_file(cmake/wmakeParseConfig.cmake.in
    ${CMAKE_BINARY_DIR}/wmakeParseConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}
)
write_basic_package_version_file(${CMAKE_BINARY_DIR}/wmakeParseConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

install(FILES
    ${CMAKE_BINARY_DIR}/wmakeParseConfig.cmake
    ${CMAKE_BINARY_DIR}/wmakeParseConfigVersion.cmake
    DESTINATION lib/cmake/wmakeParse
)
install(EXPORT wmakeParseTargets
    FILE wmakeParseTargets.cmake
    DESTINATION lib/cmake/wmakeParse
    NAMESPACE wmakeParse::
)