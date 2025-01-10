# zig call torch cpp

## install torch cpp lib

[pytorch](https://pytorch.org)

```bash
brew install libomp
```

compile torch_wrapper.cpp to libtorch_wrapper.so

```bash
c++ -std=c++17 \
    -I/Users/davirian/lib/libtorch/include \
    -I/Users/davirian/lib/libtorch/include/torch/csrc/api/include \
    -L/Users/davirian/lib/libtorch/lib \
    -ltorch -lc10 -ltorch_cpu -ltorch_global_deps \
    -lomp -shared -fPIC -o libtorch_wrapper.so torch_wrapper.cpp
```

setting libtorch_wrapper.so to LD_LIBRARY_PATH

```bash
export DYLD_LIBRARY_PATH=/opt/homebrew/opt/libomp/lib:$DYLD_LIBRARY_PATH
```


```bash
file /Users/davirian/lib/libtorch/lib/libtorch.dylib
```
