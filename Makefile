PY_VERSIONS=cp36-cp36m cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
BUILD_REQUIREMENTS=cython
#system packages (yum, manylinux_2_28 uses AlmaLinux)
SYSTEM_PACKAGES=libicu-devel libxml2-devel libxslt-devel libexttextcat zlib-devel bzip2-devel libtool autoconf-archive autoconf automake m4 wget
PRE_BUILD_COMMAND=/io/build-deps.sh
PACKAGE_PATH=
PIP_WHEEL_ARGS=-w ./dist --no-deps

.PHONY: wheels
wheels:
	docker pull quay.io/pypa/manylinux_2_28_x86_64
	docker run --rm -e PLAT=manylinux_2_28_x86_64 -v `pwd`:/io quay.io/pypa/manylinux_2_28_x86_64 /io/build-wheels.sh "${PY_VERSIONS}" "${BUILD_REQUIREMENTS}" "${SYSTEM_PACKAGES}" "${PRE_BUILD_COMMAND}" "${PACKAGE_PATH}" "${PIP_WHEEL_ARGS}"

.PHONY: devwheels
devwheels:
	#builds against latest development versions of everything, these wheels should NOT be published!
	docker pull quay.io/pypa/manylinux_2_28_x86_64
	docker run --rm -e PLAT=manylinux_2_28_x86_64 -v `pwd`:/io quay.io/pypa/manylinux_2_28_x86_64 /io/build-wheels.sh "${PY_VERSIONS}" "${BUILD_REQUIREMENTS}" "${SYSTEM_PACKAGES}" "${PRE_BUILD_COMMAND} --devel" "${PACKAGE_PATH}" "${PIP_WHEEL_ARGS}"
	echo "Built against development versions, DO NOT PUBLISH these wheels!"

.PHONY: install
install:
	pip install .

.PHONY: deps
deps:
	./build-deps.sh
