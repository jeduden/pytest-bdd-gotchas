from pytest_bdd import given, scenario, then, when


@scenario('email.feature', 'Email sending')
def test_email():
    pass


@given("I sent an email to <to>")
def i_sent_an_email(to):
    return "result"


@when("<to> checks the inbox")
def checking_the_inbox():
    pass


@then("<to> sees the email")
def sees_the_email():
    pass
