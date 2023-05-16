FROM alpine

# install requirements
RUN apk add\
 git\
 linux-headers\
 musl-dev\
 llvm14-dev\
 clang14-dev\
 libgcc\
 libstdc++\
 go-task\
 bash

RUN \
 ln -s $(which go-task) /usr/bin/task &&\
 ln -s $(which clang-14) /usr/bin/clang
