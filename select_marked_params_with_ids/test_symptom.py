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
def test_overlap_marks_and_ids(a):
    pass
