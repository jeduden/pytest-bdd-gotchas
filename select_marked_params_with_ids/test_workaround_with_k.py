from pytest import mark


@mark.parametrize(
    ['a'],
    [
        (144,)
    ],
    ids=[
        "MarkA",
        ]
    )
def test_just_ids(a):
    pass
