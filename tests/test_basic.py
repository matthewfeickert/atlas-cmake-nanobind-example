import nanobind_example as module

def test_add():
    assert module.add(1, 2) == 3
