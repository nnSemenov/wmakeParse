cmake_minimum_required(VERSION 3.28)
project(wmakeParse LANGUAGES CXX VERSION 0.1.0)

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