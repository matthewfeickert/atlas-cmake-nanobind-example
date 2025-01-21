#include <nanobind/nanobind.h>
#include <nanobind/operators.h>

namespace nb = nanobind;

using namespace nb::literals;

// c.f. https://nanobind.readthedocs.io/en/latest/classes.html
class Vector2 {
public:
    Vector2(float x, float y) : x(x), y(y) { }

    Vector2 operator+(const Vector2 &v) const { return Vector2(x + v.x, y + v.y); }
    Vector2 operator*(float value) const { return Vector2(x * value, y * value); }
    Vector2 operator-() const { return Vector2(-x, -y); }
    Vector2& operator+=(const Vector2 &v) { x += v.x; y += v.y; return *this; }
    Vector2& operator*=(float v) { x *= v; y *= v; return *this; }

    friend Vector2 operator*(float f, const Vector2 &v) {
        return Vector2(f * v.x, f * v.y);
    }

    std::string to_string() const {
        return "[" + std::to_string(x) + ", " + std::to_string(y) + "]";
    }
private:
    float x, y;
};

NB_MODULE(nanobind_example_ext, module) {
    module.doc() = "This is a \"hello world\" example with nanobind";
    module.def("add", [](int a, int b) { return a + b; }, "a"_a, "b"_a);

    // There might be a better way to handle the __repr__
    nb::class_<Vector2>(module, "Vector2")
        .def(nb::init<float, float>())
        .def(nb::self + nb::self)
        .def(nb::self += nb::self)
        .def(nb::self *= float())
        .def(float() * nb::self)
        .def(nb::self * float())
        .def(-nb::self)
        .def("__repr__", [](const Vector2 &v) { return nb::str(v.to_string().c_str()); });
}
