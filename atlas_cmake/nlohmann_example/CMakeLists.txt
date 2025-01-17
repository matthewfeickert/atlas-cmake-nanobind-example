cmake_minimum_required(VERSION 3.15...3.30)
# Note that in normal CMake this would be the `project` command and it could
# be anything, e.g. project(nlohmann_json_example).
# But in ATLAS CMake, it is a subdir command and so the "project name" must
# be an actual directory name.
atlas_subdir(nlohmann_example)

find_package(nlohmann_json 3.2.0 REQUIRED)

add_executable(example src/README.cpp)

target_link_libraries(example PRIVATE nlohmann_json::nlohmann_json)
