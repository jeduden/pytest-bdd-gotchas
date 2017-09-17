def pytest_bdd_apply_tag(tag, function):
    function.temp_storage = tag
    return True
