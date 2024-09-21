#!/bin/bash

echo -e "\n# setupATLAS\n"
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
# Allows for working with wrappers as well
source "${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh" --quiet || echo "~~~ERROR: setupATLAS failed!~~~"

echo -e "\n# lsetup git\n"
lsetup git

echo -e "\n# rm -rf build\n"
rm -rf build

echo -e "\n# asetup AnalysisBase,main,latest\n"
asetup AnalysisBase,main,latest

if [[ ! -x $(command -v cvmfs-venv) ]]; then
    # Ensure https://github.com/matthewfeickert/cvmfs-venv installed
    mkdir -p ~/.local/bin
    export PATH=~/.local/bin:"${PATH}"  # If ~/.local/bin not on PATH already
    curl -sL https://raw.githubusercontent.com/matthewfeickert/cvmfs-venv/main/cvmfs-venv.sh -o ~/.local/bin/cvmfs-venv
    chmod +x ~/.local/bin/cvmfs-venv
fi

if [[ ! -d .venv ]]; then
    # Ensure user controlled virtual environment
    cvmfs-venv .venv
    . .venv/bin/activate
    uv pip install --upgrade nanobind pytest
    deactivate
fi

echo -e "\n# . .venv/bin/activate\n"
. .venv/bin/activate

mkdir -p build

echo -e "\n# cmake -S atlas-cmake-nanobind-example -B build\n"
cmake \
    -S atlas-cmake-nanobind-example \
    -B build

echo -e "\n# cmake build -LH\n"
cmake build -LH

echo -e "\n# cmake --build build --clean-first --parallel 8\n"
# cmake \
#     --build build \
#     --clean-first \
#     --parallel $(nproc --ignore=1)
cmake \
    --build build \
    --clean-first \
    --parallel 8

echo -e "\n# cd build\n"
cd build

echo -e "\n# python -c 'import my_ext; print(my_ext.add(1, 2))'\n"
python -c 'import my_ext; print(my_ext.add(1, 2))'

echo -e "\n# python -c 'import my_ext; print(my_ext.add(a=1, b=2))'\n"
python -c 'import my_ext; print(my_ext.add(a=1, b=2))'
