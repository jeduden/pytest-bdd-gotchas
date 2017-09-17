# Gotchas: Pytest Marks, Parameter IDs and Parameterization, Pytest-BDD Tags

The effort to fix the pytest mark related bugs is tracked [here](https://github.com/pytest-dev/pytest/projects/1#card-4588520)

## Requirements to run examples

Make, Python 3.5 or 3.6

## Symptoms 

### Tests with single parameterization where values have marks -m doesn't select parameterization

This happens if id's are identical with marks. This is described in [Issue 2407](https://github.com/pytest-dev/pytest/issues/2407).

`make select_marked_params_with_ids/symptom` runs the following test:

```python
@mark.parametrize(
    ['a'],
    [
        mark.MarkA((1,)),
        mark.MarkB((2,))
    ],
    ids=[
        "MarkA",
        "MarkB",
        ]
    )
def test_overlap_marks_and_ids(a):
    pass
```

Running `py.test` with `-m MarkA` selects 0 tests


#### Work around: Prefix ids

Never let the id namespace overlap with the mark space. I.E.:

prefix ids with "idForMark"

Drawback if running the suite you'll see the test with parameter ids but not the actual mark names:

    test_overlap_marks_and_ids[idForMarkA] - PASSED
    test_overlap_marks_and_ids[idForMarkB] - PASSED

in order to select one of these you need to run

    py.test -m MarkA 

and not:

    py.test -m idForMarkA 

See `make select_marked_params_with_ids/workaround` the result of `py.test -m MarkA`

#### Work around 2: Use -k

You can use:

    py.test -k MarkA

However, -k also supports operators: "AND", "OR", "NOT", but it applies to more that just the markers.
It might also run tests where ids (unintentially having the same name as the mark)


```python
@mark.parametrize(
    ['Mark'],
    [
        (11,)),
    ],
    ids=[
        "MarkA",
        ]
    )
def test_with_id_but_no_marks(a):
    pass
```

`py.test -k MarkA` will select the test. As expected, `py.test -m MarkA` will not select the test. See `make select_marked_params_with_ids/workaround_with_k`. 

#### Work around 3: Introduce a new parameter

Since the issue only occurs for functions with a single parameter. Introducing the dummy parameter helps.

`make select_marked_params_with_ids/workaround_with_dummy` runs the following test:

```python
@mark.parametrize(
    ['a'],
    [
        mark.MarkA((1,)),
        mark.MarkB((2,))
    ],
    ids=[
        "MarkA",
        "MarkB",
        ]
    )
@mark.parametrize(
    ['dummy'],
    [
    ("dummy",)
    ]
    )
def test_overlap_marks_and_ids(a, dummy):
    pass
```

using `py.test` with `-m MarkA`.

### Using parameterized fixtures in already parameterized given statements results in exception

`make parameterization_of_fixtures_for_parameterized_given/symptom` runs a scenario using:

```python
[...]

@fixture(params=["smtp.gmail.com", "mail.python.org"])
def smtp(request):
    return request.param

[...]

@given("I sent an email to <to>")
def i_sent_an_email(to, smtp):
    return "result"
```

The test using this given statement fails with exception:

    "Failed: The requested fixture has no parameter defined for the current test."

#### work around

Use `pytest.usefixture`:

```python
@mark.usefixtures("smtp")
@scenario('email.feature', 'Email sending')
def test_email():
    pass
```

This will inject smtp into the functions that scenario wraps and provide the missing fixture parameter.

When using the `scenarios` function that discovers scenarios and generates tests, you can use the pytestmark module variable to make sure the generated tests receive the fixture

```python
pytestmark = pytest.mark.usefixtures("smpt")
scenarios("somefolder")
```


### Pytest-BDD's tags and using func as storage for tags

When a scenario is tagged in a feature file pytest BDD calls `pytest_bdd_apply_tag` to let you translate this tag to a pytest mark (or something else).
Related: [Issue 891](https://github.com/pytest-dev/pytest/issues/891#issuecomment-126283402)

When decorating the test function using a property (to postpone processing at a later stage), it's name becomes a keyword.

```python
def pytest_bdd_apply_tag(tag, func):
 func.temp_storage = tag
``` 


Run `make func_properties_as_tag_storage/symptom` to see how `py.test --k temp_storage` will select the test.


### Pytest-BDD's `pytest_bdd_apply_tag` and `pytest_generate_tests` call order

`pytest_bdd_apply_tag` is called before `pytest_generate_tests`. 

This means if you apply a mark directly in `pytest_bdd_apply_tag` and 
then parameterize the test in `pytest_generate_tests` each of the parameterization's 
will have the mark from `pytest_bdd_apply_tag`.

Run `make apply_tags_generate_tests_call_order/symptom` to see this
