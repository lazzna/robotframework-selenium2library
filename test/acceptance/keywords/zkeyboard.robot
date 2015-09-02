*** Setting ***
Documentation     Tests pressing keyboard keys
Test Setup        Go To Page "forms/long_page.html"
Force Tags
Default Tags      keyboard
Variables         variables.py
Resource          ../resource.robot

*** Test Cases ***
Press Page-Down
    [Documentation]   Press Page-Down
    #Focus    english_input    # Here we should test element is not visible, and after page_down is.
    Press Keys    english_input    PAGE_DOWN

Press Home
    [Documentation]   Press Home
    #Focus    english_input
    Press Keys    english_input    HOME

Press End
    [Documentation]   Press End
    #Focus    english_input
    Press Keys    english_input    END
    #Capture Page Screenshot    # We should have scrolled down the page

Press Keys a
    [Documentation]   Press a letter
    Press Keys    textarea    a
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    a

Press Keys \\032 quoted
    [Documentation]   Send ASCII space quoted
    Press Keys    textarea    '\\032'    # If remove quotes, fails
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    '${SPACE}'

Press Keys ${SPACE}
    [Documentation]   Send RF space
    Press Keys    textarea    ${SPACE}
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    ${SPACE}

Press Keys \\033 no quotes
    [Documentation]   Send ASCII !
    Press Keys    textarea    \\033
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    !

Press Keys \\108\\111\\108 no quotes
    [Documentation]   Send ASCII lol letters
    Press Keys    textarea    \\108\\111\\108
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    lol    # \\009 ${TAB} is not defined

Press Keys a b
    [Documentation]   Send ASCII space between a and b
    Press Keys    textarea    a\\032b
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    a${SPACE}b

Press Keys END word
    [Documentation]   Send the word END key by key
    Press Keys    textarea    E    N    D
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    END

Press Keys quoted words
    [Documentation]   Sends words without special keys
    Press Keys    textarea    'This is my example text'
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    'This is my example text'

Press Keys words
    [Documentation]   Sends words without special keys
    Press Keys    textarea    This is another example text
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    This is another example text

#Press Keys complex text
#    [Documentation]   Sends words with special keys
#    Press Keys    textarea    his is +HOME+T-END-another example text
#    ${value}=    Get Value    textarea
#    Should Be Equal    ${value}    This is another example text

Press Control-End and Control-Home
    [Documentation]   Press Control-End and Control-Home
    Press Keys    english_input    CONTROL-END    CONTROL+HOME
    Capture Page Screenshot    # We should have scrolled down and up the page

Press Control-- Control++
    [Documentation]   Press Control-- Control++
    Press Keys    english_input    CONTROL--    CONTROL--    CONTROL--    CONTROL++
    Capture Page Screenshot    # We should have zoom out
    Press Keys    english_input    CONTROL++    CONTROL++
    Press Keys    english_input    HOME    SHIFT+CONTROL+END    DELETE    Zoom is at 100%
    Sleep    2 seconds
    Capture Page Screenshot    # We should have restored zoom

Press Shift-abc
    [Documentation]    This test fails with Opera, because it types "abc" ignoring SHIFT key.
    Press Keys    textarea    SHIFT-a
    Press Keys    textarea    SHIFT+b
    Press Keys    textarea    SHIFT-c
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    ABC
    #Capture Page Screenshot

Press Shift-def at Once
    [Documentation]   Press Shift-def at Once
    Press Keys    textarea    SHIFT+def
    ${value}=    Get Value    textarea
    Should Be Equal    ${value}    DEF
    #Capture Page Screenshot

Press Home, End, Arrows, Backspace and Delete
    [Documentation]   Press Home, End, Arrows, Backspace and Delete
    Press Keys    textarea    ABC
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
    [Documentation]    Use directional keys to select text, copy and paste.
    ...    (using double-click to attempt to select element text).
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
    # If we use Control+Shift+End makes firefox Navigation test fail by not reusing Tabbed windows
    # Control-A causes showing plugins tab
    # Press Keys    english_input    CONTROL+A
    Press Keys    english_input    HOME
    Press Keys    english_input    SHIFT-END
    Press Keys    english_input    CONTROL+c    # Interrupts chromedriver (with caps C)?
    Press Keys    textarea    CONTROL+V
    # Press Keys    textarea    CONTROL+Z
    Press Keys    textarea    Text is:
    Press Keys    textarea    END
    Press Keys    textarea    CONTROL-v
    ${value2}=    Get Value    textarea
    Log    Value1 is "${value}" Value2 is "${value2}"    INFO
    #Should Be Equal    ${value}    A
    Capture Page Screenshot

Press Invalid Keys
    [Documentation]   Press Invalid Keys and bad locator
    Run Keyword And Expect Error    *    Press Keys    textarea    ${NONE}
    Run Keyword And Expect Error    *    Press Keys    unknown    +WORNG_KEY+a
    # Run Keyword And Expect Error    *    Press Keys    textarea    a-WORNG_KEY

Press Key Words
    [Documentation]    Former Press Key with words
    [Setup]    Go To Page "forms/login.html"
    #Cannot Be Executed in IE
    Press Keys    username_field    James Bond
    Press Keys    username_field    HOME
    Press Keys    username_field    END
    Press Keys    username_field    ARROW_LEFT
    Press Keys    username_field    ARROW_LEFT
    Press Keys    username_field    ARROW_LEFT
    Press Keys    username_field    DELETE
    Press Keys    username_field    ARROW_LEFT
    Press Keys    username_field    ARROW_RIGHT
    Press Keys    username_field    \\108    #This is the 'l' char
    Press Keys    username_field    o
    ${text} =    Get Value    username_field
    Should Be Equal    ${text}    James Blond
    Press Keys    password_field    f9
    Press Keys    login_button    ENTER
    Verify Location Is "forms/submit.html"
