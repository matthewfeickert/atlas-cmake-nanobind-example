#include <nanobind/nanobind.h>

namespace nb = nanobind;

using namespace nb::literals;

NB_MODULE(nanobind_example_ext, module) {
    module.doc() = "This is a \"hello world\" example with nanobind";
    module.def("add", [](int a, int b) { return a + b; }, "a"_a, "b"_a);
}
