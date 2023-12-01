#/bin/env bash
build_dir=${EASIFEM_BUILD_DIR}/tests/build
mkdir -p ${build_dir}
mkdir -p ${EASIFEM_APP}/bin
rm -rf ${build_dir}
cmake -G "Ninja" -B ${build_dir}
cmake --build ${build_dir}
cp ${build_dir}/md2src ${EASIFEM_APP}/bin/md2src
