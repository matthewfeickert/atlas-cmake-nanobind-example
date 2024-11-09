cmake_minimum_required(VERSION 3.15...3.30)
# ATLAS CMake requires "atlas_subdir" instead of "project"
# atlas_subdir(simple_project)
project(simple_project)

# taken from https://gitlab.com/CLIUtils/modern-cmake/-/tree/861f0ce7052b0826261378e412e58533e1982ce4/examples/simple-project
# If you set any CMAKE_ variables, that can go here.
# (But usually don't do this, except maybe for C++ standard)

# Find packages go here.

# You should usually split this into folders, but this is a simple example

# This is a "default" library, and will match the *** variable setting.
# Other common choices are STATIC, SHARED, and MODULE
# Including header files here helps IDEs but is not required.
# Output libname matches target name, with the usual extensions on your system

# add_library(examplelib simple_lib.cpp include/simple_lib.h)
set(HEADER_LIST "${simple_project_SOURCE_DIR}/include/simple_lib.h")
add_library(examplelib src/simple/simple_lib.cpp ${HEADER_LIST})

# We need this directory, and users of our library will need it too
target_include_directories(examplelib PUBLIC include)


# Link each target with other targets or add options, etc.

# Adding something we can run - Output name matches target name
add_executable(example-bin src/simple_example.cpp)

# Make sure you link your targets with this command. It can also link libraries and
# even flags, so linking a target that does not exist will not give a configure-time error.
target_link_libraries(example-bin PRIVATE examplelib)

## [main]

# This part is so the Modern CMake book can verify this example builds. For your code,
# you'll probably want tests too
enable_testing()
add_test(NAME example-bin COMMAND example-bin)
