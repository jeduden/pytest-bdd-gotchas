Feature: Email

Scenario Outline: Email sending
  Given I sent an email to <to>
  When <to> checks the inbox
  Then <to> sees the email

  Examples:
    | to                | 
    | susan@example.com | 
    | fred@example.com  | 

