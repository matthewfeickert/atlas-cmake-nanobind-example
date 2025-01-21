#!/bin/bash

# Setup release
if [[ -f /release_setup.sh ]]; then
    echo -e "\n# Assuming inside a Linux container"
    echo -e "\n# . /release_setup.sh\n"
    . /release_setup.sh
else
    echo -e "\n# setupATLAS\n"
    export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
    # Allows for working with wrappers as well
    . "${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh" --quiet || echo "~~~ERROR: setupATLAS failed!~~~"

    echo -e "\n# lsetup git\n"
    lsetup git

    # Just need to be post Analysis release v25.2.30
    echo -e "\n# asetup AnalysisBase,25.2.30\n"
    asetup AnalysisBase,25.2.30
fi

if [[ -d build_atlas_cmake ]]; then
    echo -e "\n# rm -rf build_atlas_cmake\n"
    rm -rf build_atlas_cmake
fi

echo -e "\n# cmake -DATLAS_PACKAGE_FILTER_FILE=atlas_cmake/package_filters.txt -S atlas_cmake/Projects/WorkDir -B build_atlas_cmake\n"
cmake \
    -DATLAS_PACKAGE_FILTER_FILE=atlas_cmake/package_filters.txt \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DNANOBIND_LIBRARY_LINK_TYPE=NB_SHARED \
    -S atlas_cmake/Projects/WorkDir \
    -B build_atlas_cmake

echo -e "\n# cmake build_atlas_cmake -LH\n"
cmake build_atlas_cmake -LH

rm -rf build_atlas_cmake.log
echo -e "\n# cmake --build build_atlas_cmake --clean-first --parallel 8\n"
# cmake \
#     --build build_atlas_cmake \
#     --clean-first \
#     --parallel $(nproc --ignore=1)
cmake \
    --build build_atlas_cmake \
    --clean-first \
    --parallel 8 2>&1 | tee build_atlas_cmake.log

echo -e "\n# cd build_atlas_cmake\n"
cd build_atlas_cmake

echo -e "\n# Setup environment\n# . $(find . -type f -iname "setup.sh")\n"
. $(find . -type f -iname "setup.sh")

echo -e "\n# find . -type f -iname '*examplelib*'\n"
find . -type f -iname '*examplelib*'

echo -e "\n# $(find . -type f -iname example-bin)\n"
$(find . -type f -iname example-bin)

echo -e "\n# python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(1, 2))'\n"
python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(1, 2))'

echo -e "\n# python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(a=1, b=2))'\n"
python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(a=1, b=2))'

echo -e "\n# python -c 'from nanobind_example_ext import Vector2; v1 = Vector2(1, 2.); v2 = Vector2(3., 4.); print(f"v1={v1}"); print(f"v2={v2}"); print(f"v1 + v2={v1 + v2}")'\n"
python -c 'from nanobind_example_ext import Vector2; v1 = Vector2(1, 2.); v2 = Vector2(3., 4.); print(f"v1={v1}"); print(f"v2={v2}"); print(f"v1 + v2={v1 + v2}")'
