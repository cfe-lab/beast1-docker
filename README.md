# beast1-docker
Docker file for building old beast and beagle (version 1.8.4)

Use the provided Makefile to build, run and test the required beast1.4.8 docker image.

Currently, three images are provided, all compiling the same source code:

compiler   OS
gcc        centos
gcc        alpine
gcc(pgc)   ubuntu


Currently, the preferred image to use with Kive is gcc-alpine because it is optimised for size.
The gcc-centos image was the first one used and is retained, but is no longer used in Kive.

The aim of the ubuntu image is to compile beagle with the optimising Portland Group compiler,
which should provide for faster execution. However, currently, compilation of beagle
with this compiler fails (an issue as been lodged with the beagle developers) and beagle
is also compiled with gcc for now.
