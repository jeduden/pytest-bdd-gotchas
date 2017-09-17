from pytest import mark


def pytest_bdd_apply_tag(tag, function):
    getattr(mark, tag)(function)
    return True


def pytest_generate_tests(metafunc):
    # prod mark has been already applied
    assert "prod" in dir(metafunc.function)
