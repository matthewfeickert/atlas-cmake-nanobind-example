cmake_minimum_required(VERSION 3.15...3.31)
atlas_subdir(nanobind_example)

if (CMAKE_VERSION VERSION_LESS 3.18)
  set(DEV_MODULE Development)
else()
  set(DEV_MODULE Development.Module)
endif()

find_package(Python 3.8 COMPONENTS Interpreter ${DEV_MODULE} REQUIRED)

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Detect the installed nanobind package and import it into CMake
execute_process(
  COMMAND "${Python_EXECUTABLE}" -m nanobind --cmake_dir
  OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE nanobind_ROOT)
find_package(nanobind CONFIG REQUIRED)

# High level API: https://nanobind.readthedocs.io/en/latest/api_cmake.html#high-level-interface
# nanobind_add_module(
#   # Name of the extension
#   nanobind_example_ext

#   # Target the stable ABI for Python 3.12+, which reduces
#   # the number of binary wheels that must be built. This
#   # does nothing on older Python versions
#   STABLE_ABI

#   # Build libnanobind statically and merge it into the
#   # extension (which itself remains a shared library)
#   #
#   # If your project builds multiple extensions, you can
#   # replace this flag by NB_SHARED to conserve space by
#   # reusing a shared libnanobind across libraries
#   NB_STATIC

#   # Source code goes here
#   "${CMAKE_CURRENT_SOURCE_DIR}/src/nanobind_example_ext.cpp"
# )

message("# DEBUG PRINT STATEMENTS")
message(AnalysisBaseExternals_INCLUDE_DIR="${AnalysisBaseExternals_INCLUDE_DIR}")
message(nanobind_ROOT="${nanobind_ROOT}")
message(CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}")

# Low level API: https://nanobind.readthedocs.io/en/latest/api_cmake.html#low-level-interface
# Build the core parts of nanobind once
nanobind_build_library(nanobind SHARED)

# Compile an extension library
add_library(
  nanobind_example_ext
  MODULE
  "${CMAKE_CURRENT_SOURCE_DIR}/src/nanobind_example_ext.cpp"
)

# .. and link it against the nanobind parts
target_link_libraries(nanobind_example_ext PRIVATE nanobind)

# # .. enable size optimizations
# nanobind_opt_size(nanobind_example_ext)

# # .. enable link time optimization
# nanobind_lto(nanobind_example_ext)

# # .. set the default symbol visibility to 'hidden'
# nanobind_set_visibility(nanobind_example_ext)

# # .. strip unneeded symbols and debug info from the binary (only active in release builds)
# nanobind_strip(nanobind_example_ext)

# # .. disable the stack protector
# nanobind_disable_stack_protector(nanobind_example_ext)

# # .. set the Python extension suffix
# nanobind_extension(nanobind_example_ext)

# # .. set important compilation flags
# nanobind_compile_options(nanobind_example_ext)

# # .. set important linker flags
# nanobind_link_options(nanobind_example_ext)

# # Statically link against libstdc++/libgcc when targeting musllinux
# nanobind_musl_static_libcpp(nanobind_example_ext)
