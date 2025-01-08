# ATLAS CMake Nanobind example

Example `nanobind` CPython extension meant to be built in an ATLAS CMake environment.

This is the trivial example taken from the [`nanobind` docs](https://nanobind.readthedocs.io/en/latest/basics.html) and the [`nanobind_example` GitHub repository](https://github.com/wjakob/nanobind_example).
This repository intentionally produces a `nanobind` module and not an Python library.

## Requirements

* Any CVMFS enabled machine or an ATLAS analysis release `v25.2.30+` Linux container (e.g. `gitlab-registry.cern.ch/atlas/athena/analysisbase:25.2.30`)
   - `nanobind` was added to the ATLAS analysis release externals in release `25.2.30`. (c.f. [Athena MR 74980](https://gitlab.cern.ch/atlas/athena/-/merge_requests/74980))

## Getting started

This repository contains examples of projects that could be included as modules in an ATLAS CMake build.
First clone the repository and navigate inside of it

```
git clone git@github.com:matthewfeickert/atlas-cmake-nanobind-example.git && cd atlas-cmake-nanobind-example
```

To run the "normal" CMake example with `nanobind` run

```
bash build_normal_cmake.sh
```

and to run the ATLAS CMake example run

```
bash build_atlas_cmake.sh
```

## Other examples

To verify a simper example first for ATLAS CMake, first run

```
bash run_docker.sh
```

(or be already in an ATLAS Analysis Release environment) and then run

```
build_normal_nlohmann.sh
```
