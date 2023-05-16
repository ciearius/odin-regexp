FROM mcr.microsoft.com/vscode/devcontainers/base:alpine-3.17

# install requirements
RUN apk add \
git \
linux-headers \
musl-dev \
llvm14-dev \
clang14-dev \
libgcc \
libstdc++ \
go-task \
bash

RUN ln -s $(which go-task) /usr/bin/task
