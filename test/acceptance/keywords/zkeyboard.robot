*** Setting ***
Test Setup        Go To Page "forms/long_page.html"
Force Tags
Default Tags      keyboard
Variables         variables.py
Resource          ../resource.robot

*** Test Cases ***
Press Page-Down
    #Focus    english_input    # Here we should test element is not visible, and after page_down is.
    Press Keys    english_input    PAGE_DOWN

Press Home
    #Focus    english_input
    Press Keys    english_input    HOME

Press End
    #Focus    english_input
    Press Keys    english_input    END
    #Capture Page Screenshot    # We should have scrolled down the page

Press Keys a
    Press Keys    textarea    a
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    a

Press Keys \\032 quoted
    Press Keys    textarea    '\\032'    # If remove quotes, fails
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    '${SPACE}'

Press Keys ${SPACE}
    Press Keys    textarea    ${SPACE}    # If remove quotes, fails
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    ${SPACE}

Press Keys \\033 no quotes
    Press Keys    textarea    \\033
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    !


Press Keys \\108\\111\\108 no quotes
    Press Keys    textarea    \\108\\111\\108
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    lol    # \\009 ${TAB} is not defined

Press Keys a b
    Press Keys    textarea    a\\032b
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    a${SPACE}b

Press Shift-abc
    [Documentation]    This test fails with Opera, because it types "abc" ignoring SHIFT key.
    Press Keys    textarea    SHIFT-a
    Press Keys    textarea    SHIFT+b
    Press Keys    textarea    SHIFT-c
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    ABC
    #Capture Page Screenshot

Press Shift-def at Once
    Press Keys    textarea    SHIFT+def
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    DEF
    #Capture Page Screenshot

Press Home, End, Arrows, Backspace and Delete
    Input Text    textarea    ABC
    Press Keys    textarea    END
    Press Keys    textarea    LEFT
    Press Keys    textarea    BACKSPACE
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    AC
    Press Keys    textarea    HOME
    Press Keys    textarea    RIGHT
    Press Keys    textarea    DELETE
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    A
    #Capture Page Screenshot

Press Control, Shift, Arrow, Control C, Control V, Control Z
    [Documentation]    Use directional keys to select text, copy and paste. (using double-click to attempt to select element text).
    ...    Strange actions happens with Firefox if we use "block1" instead of "inside_text".
    Double Click Element    inside_text
    Press Keys    inside_text    CONTROL+SHIFT+RIGHT
    Press Keys    inside_text    CONTROL+SHIFT+RIGHT
    Press Keys    inside_text    CONTROL+SHIFT+RIGHT
    Press Keys    inside_text    CONTROL+SHIFT+RIGHT
    Press Keys    inside_text    CONTROL+c
    Press Keys    textarea    CONTROL+v
    ${value}=    Get Value    textarea
    Double Click Element    english_input
    #This block with Control+Shift+End makes firefox Navigation test fail by not reusing Tabbed windows
    #Control-A causes showing plugins tab
    #Press Keys    english_input    CONTROL+A
    Press Keys    english_input    HOME
    Press Keys    english_input    SHIFT-END
    #Press Keys    english_input    CONTROL+C    # Interrupts chromedriver (with caps C)?
    Press Keys    english_input    CONTROL+c    # Interrupts chromedriver (with caps C)?
    Press Keys    textarea    CONTROL+V
    #Press Keys    textarea    CONTROL+Z
    Press Keys    textarea    Text is:
    Press Keys    textarea    END
    Press Keys    textarea    CONTROL-v
    ${value2}=    Get Value    textarea
    Log    Value1 is "${value}" Value2 is "${value2}"    INFO
    #Should Be Equal    ${value}    A
    Capture Page Screenshot

Press Invalid Keys
    Run Keyword And Expect Error    *    Press Keys    textarea    ${NONE}
    Run Keyword And Expect Error    *    Press Keys    unknown    +WORNG_KEY+a
    #Run Keyword And Expect Error    *    Press Keys    textarea    a-WORNG_KEY

