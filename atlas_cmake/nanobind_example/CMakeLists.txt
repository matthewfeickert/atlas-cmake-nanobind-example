cmake_minimum_required(VERSION 3.16...3.31)
atlas_subdir(nanobind_example)

# Though nanobind only needs Development.Module it seems ATLAS CMake requires
# the full Development (Development.Module and Development.Embed) to be used.
if (CMAKE_VERSION VERSION_LESS 3.18)
  set(DEV_MODULE Development)
else()
  # Development.Embed required for Python::Python imported target
  set(DEV_MODULE Development.Module Development.Embed)
endif()

find_package(Python 3.8 COMPONENTS Interpreter ${DEV_MODULE} REQUIRED)

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

# Detect the installed nanobind package and import it into CMake
execute_process(
  COMMAND "${Python_EXECUTABLE}" -m nanobind --cmake_dir
  OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE nanobind_ROOT)
find_package(nanobind CONFIG REQUIRED)

# Variable to allows switching between using shared or static libnanobind
# for users in an ATLAS Analysis Release environment with ATLAS CMake
# c.f. https://github.com/wjakob/nanobind/blob/e13448781a608efd3b1cb97a92e756a426400c60/docs/api_cmake.rst#high-level-interface
if(NOT DEFINED NANOBIND_LIBRARY_LINK_TYPE)
  set(NANOBIND_LIBRARY_LINK_TYPE NB_SHARED)
endif()

# High level API: https://nanobind.readthedocs.io/en/latest/api_cmake.html#high-level-interface
nanobind_add_module(
  # Name of the extension
  nanobind_example_ext

  # Target the stable ABI for Python 3.12+, which reduces
  # the number of binary wheels that must be built. This
  # does nothing on older Python versions
  STABLE_ABI

  # Perform link time optimization
  LTO

  # Build libnanobind statically and merge it into the
  # extension (which itself remains a shared library)
  #
  # If your project builds multiple extensions, you can
  # replace this flag by NB_SHARED to conserve space by
  # reusing a shared libnanobind across libraries
  "${NANOBIND_LIBRARY_LINK_TYPE}"

  # Source code goes here
  "${CMAKE_CURRENT_SOURCE_DIR}/src/nanobind_example_ext.cpp"
)

# ATLAS CMake needs to be told about the Python libraries at link time.
# This is NOT required for normal CMake.

# Required if and only if using NB_SHARED
if (NANOBIND_LIBRARY_LINK_TYPE STREQUAL "NB_SHARED")
  # Imported target Python::Python defined if component Development.Embed is found
  target_link_libraries(nanobind PRIVATE Python::Python)
endif()

target_link_libraries(nanobind_example_ext PRIVATE Python::Python)
