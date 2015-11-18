*** Settings ***
Documentation     Tests elements changes (Highlight)
Test Setup        Go To Page "links.html"
Resource          ../resource.robot

*** Test Cases ***
Highlights Links
    [Documentation]    Highlights Links
    @{links}=    Get WebElements    //div[@id="div_id"]/a
    : FOR    ${link}    IN    @{links}
    \    Highlight    ${link}

Highlights Image
    [Documentation]    Highlights Image
    Highlight    id=image_id

Highlights Assigned Id
    [Documentation]    Highlights Assigned Id
    Assign ID to Element    xpath=//div[@id="first_div"]    my id
    Highlight    my id

Highlights Unexisting Element
    [Documentation]    Highlights Unexisting Element
    Highlight    //input[@id="unexisting"]

Highlights Checkboxes
    [Documentation]    Highlights Checkboxes (No effect)
    [Setup]    Go To Page "forms/prefilled_email_form.html"
    @{checkboxes}=    Get WebElements    //input[@type="checkbox"]
    : FOR    ${checkbox}    IN    @{checkboxes}
    \    Highlight    ${checkbox}

Highlights Radios
    [Documentation]    Highlights Radio Buttons (No effect)
    [Setup]    Go To Page "forms/prefilled_email_form.html"
    @{radios}=    Get WebElements    //input[@type="radio"]
    : FOR    ${radio}    IN    @{radios}
    \    Highlight    ${radio}

Highlights Text
    [Documentation]    Highlights Input Text Boxes
    [Setup]    Go To Page "forms/prefilled_email_form.html"
    @{texts}=    Get WebElements    //input[@type="text"]
    : FOR    ${text}    IN    @{texts}
    \    Highlight    ${text}

Highlights Table Rows
    [Documentation]    Highlights Table Rows
    [Setup]    Go To Page "forms/prefilled_email_form.html"
    @{trs}=    Get WebElements    //tr[.]
    : FOR    ${tr}    IN    @{trs}
    \    Highlight    ${tr}
