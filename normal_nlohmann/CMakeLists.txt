cmake_minimum_required(VERSION 3.15...3.31)
project(nlohmann_json_example)

find_package(nlohmann_json 3.2.0 REQUIRED)

add_executable(example src/README.cpp)

target_link_libraries(example PRIVATE nlohmann_json::nlohmann_json)
