cmake_minimum_required(VERSION 3.16...3.31)
project(cpython_api_cmake_example)

find_package(Python 3.8 COMPONENTS Interpreter Development Development.Embed REQUIRED)

if (NOT TARGET Python::Python)
  message(
    FATAL_ERROR
    "As component Development.Embed was not found"
    " (Python_Development.Embed_FOUND=${Python_Development.Embed_FOUND}) the"
    " required imported target Python::Python was not defined."
    )
endif()

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

add_executable(cpython_api_example src/cpython_api_example.cpp)

# Need to find Python.h
target_include_directories(cpython_api_example PUBLIC "${Python_INCLUDE_DIRS}")
# Imported target Python::Python defined if component Development.Embed is found
target_link_libraries(cpython_api_example PRIVATE Python::Python)
