FROM alpine

# install requirements
RUN apk add git linux-headers musl-dev llvm14-dev clang14-dev go-task bash

RUN ln -s $(which go-task) /usr/bin/task && ln -s $(which clang-14) /usr/bin/clang

# # paths for building odin
# ENV LLVM_CONFIG="/usr/bin/llvm-config-14"
# ENV CXX="/usr/lib/llvm-14/bin/clang"

# RUN ln -s $(which $CXX) /usr/bin/clang

# # clone odin
# RUN git clone https://github.com/odin-lang/Odin /root/Odin

# # build odin
# WORKDIR /root/Odin
# RUN ./build_odin.sh release
# RUN ln -s /root/Odin/odin /usr/bin/odin

# # clone ols
# RUN git clone https://github.com/DanielGavin/ols.git /root/ols

# # build ols
# WORKDIR /root/ols
# RUN ./build.sh
# RUN ln -s /root/ols/ols /usr/bin/ols
