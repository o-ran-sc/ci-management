# CI builder images for O-RAN-SC at LF

The O-RAN-SC project runs most CI tasks in Docker instead of
maintaining build and compile tools in LF-managed Jenkins build
minions.  This area contains the Dockerfiles to assemble images that
are used as the first stage in a multi-stage Docker build.  These
images have large build and compile tools like C, C++, Golang, cmake,
ninja, etc.  These images are used to compile source and create binary
artifacts of O-RAN-SC software features, which are then wrapped in
minimal docker images for use.
