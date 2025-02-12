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

if [[ -d build_atlas_nlohmann ]]; then
    echo -e "\n# rm -rf build_atlas_nlohmann\n"
    rm -rf build_atlas_nlohmann
fi

echo -e "\n# cmake -DATLAS_PACKAGE_FILTER_FILE=atlas_cmake/package_filters.txt -S atlas_cmake/Projects/WorkDir -B build_atlas_nlohmann\n"
cmake \
    -DATLAS_PACKAGE_FILTER_FILE=atlas_cmake/package_filters.txt \
    -S atlas_cmake/Projects/WorkDir \
    -B build_atlas_nlohmann

echo -e "\n# cmake build_atlas_nlohmann -LH\n"
cmake build_atlas_nlohmann -LH

echo -e "\n# cmake --build build_atlas_nlohmann --clean-first --parallel 8\n"
# cmake \
#     --build build_atlas_nlohmann \
#     --clean-first \
#     --parallel $(nproc --ignore=1)
cmake \
    --build build_atlas_nlohmann \
    --clean-first \
    --parallel 8

echo -e "\n# cd build_atlas_nlohmann\n"
cd build_atlas_nlohmann

echo -e "\n# Setup environment\n# . $(find . -type f -iname "setup.sh")\n"
. $(find . -type f -iname "setup.sh")

echo -e "\n# $(find . -type f -iname example)\n"
$(find . -type f -iname example)
