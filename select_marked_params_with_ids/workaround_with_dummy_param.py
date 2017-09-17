from pytest import mark


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
def test_with_dummy(a, dummy):
    pass
