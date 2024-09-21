# ATLAS CMake Nanobind example

Example `nanobind` CPython extension meant to be built in an ATLAS CMake environment.

This is the trivial example taken from the [`nanobind` docs](https://nanobind.readthedocs.io/en/latest/basics.html) and the [`nanobind_example` GitHub repository](https://github.com/wjakob/nanobind_example).
This repository intentionally produces a `nanobind` module and not an Python library.

## Requirements

* Any CVMFS enabled machine or an ATLAS analysis release Linux container

## Getting started

This example is meant to represent a repository that would be included as a module in an ATLAS CMake build.
So the build scripts inside of it should be used from _outside_ the repository.
You can of course build inside of the repository as well.

So clone the repository

```
git clone git@github.com:matthewfeickert/atlas-cmake-nanobind-example.git
```

and then copy the build script out and run it

```
cp atlas-cmake-nanobind-example/build.sh .
bash build.sh
```
