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

if [[ ! -x $(command -v cvmfs-venv) ]]; then
    # Ensure https://github.com/matthewfeickert/cvmfs-venv installed
    mkdir -p ~/.local/bin
    export PATH=~/.local/bin:"${PATH}"  # If ~/.local/bin not on PATH already
    curl -sL https://raw.githubusercontent.com/matthewfeickert/cvmfs-venv/main/cvmfs-venv.sh -o ~/.local/bin/cvmfs-venv
    chmod +x ~/.local/bin/cvmfs-venv
fi

# if [[ ! -d .venv ]]; then
#     # Ensure user controlled virtual environment
#     cvmfs-venv .venv
#     . .venv/bin/activate
#     uv pip install --upgrade pytest
#     deactivate
# fi

# echo -e "\n# . .venv/bin/activate\n"
# . .venv/bin/activate

if [[ -d build_normal_cmake ]]; then
    echo -e "\n# rm -rf build_normal_cmake\n"
    rm -rf build_normal_cmake
fi

echo -e "\n# cmake -S normal_cmake -B build_normal_cmake\n"
cmake \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -S normal_cmake \
    -B build_normal_cmake

echo -e "\n# cmake build_normal_cmake -LH\n"
cmake build_normal_cmake -LH

echo -e "\n# cmake --build build_normal_cmake --clean-first --parallel 8\n"
# cmake \
#     --build build_normal_cmake \
#     --clean-first \
#     --parallel $(nproc --ignore=1)
cmake \
    --build build_normal_cmake \
    --clean-first \
    --parallel 8

echo -e "\n# cd build_normal_cmake\n"
cd build_normal_cmake

echo -e "\n# python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(1, 2))'\n"
python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(1, 2))'

echo -e "\n# python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(a=1, b=2))'\n"
python -c 'import nanobind_example_ext; print(nanobind_example_ext.add(a=1, b=2))'
