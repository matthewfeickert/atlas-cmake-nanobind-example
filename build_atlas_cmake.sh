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
    echo -e "\n# asetup AnalysisBase,main,latest\n"
    asetup AnalysisBase,main,latest
fi

if [[ -d build_atlas_cmake ]]; then
    echo -e "\n# rm -rf build_atlas_cmake\n"
    rm -rf build_atlas_cmake
fi

echo -e "\n# cmake -S atlas_cmake -B build_atlas_cmake\n"
cmake \
    -S atlas_cmake \
    -B build_atlas_cmake

echo -e "\n# cmake build_atlas_cmake -LH\n"
cmake build_atlas_cmake -LH

echo -e "\n# cmake --build build_atlas_cmake --clean-first --parallel 8\n"
# cmake \
#     --build build_atlas_cmake \
#     --clean-first \
#     --parallel $(nproc --ignore=1)
cmake \
    --build build_atlas_cmake \
    --clean-first \
    --parallel 8

echo -e "\n# cd build_atlas_cmake\n"
cd build_atlas_cmake