*** Settings ***
Documentation     Opening and closing browsers
Suite Teardown    Close All Browsers
Resource          resource.robot

*** Test Cases ***
Browser Should Open And Close
    [Documentation]    Opens and closes browser
    Open Browser To Start Page Without Testing Default Options
    Close Browser

Browser Open With Implicit Wait Should Not Override Default
    [Documentation]    Opens browser with implicit wait
    Open Browser To Start Page And Test Implicit Wait    10
    Close Browser

There Should Be A Good Error Message If Browser Is Not Opened
    [Documentation]    Tests error message
    Run Keyword And Expect Error    No browser is open    Title Should Be    foo

Close Browser Does Nothing When No Browser Is Opened
    [Documentation]    Close already closed browser
    Close Browser

Browser Open With Not Well-Formed URL Should Close
    [Documentation]    Verify after incomplete 'Open Browser' browser closes
    ...    LOG 2.1:10 DEBUG STARTS: Opened browser with session id
    ...    LOG 2.1:10 DEBUG REGEXP: .*but failed to open url.*
    ...    LOG 3:2 DEBUG STARTS: DELETE
    ...    LOG 3:3 DEBUG Finished Request
    Cannot Be Executed In PhantomJS    # It does not have error, page is blank.
    Run Keyword And Expect Error    *    Open Browser    bad.url.bad    ${BROWSER}
    Close All Browsers
