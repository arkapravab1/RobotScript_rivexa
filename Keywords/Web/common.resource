*** Settings ***
Library           SeleniumLibrary
Library           ExcelLibrary
Resource          ../../Global/super.robot

*** Keywords ***
Launch Browser And Navigate To The URL
    [Arguments]    ${url}    ${type}    ${variable}
    Open Browser    ${url}    ${BROWSERNAME}
    Maximize Browser Window
    Wait Until Time    3
    Run Keyword If    '${type}'=='Register'    SeleniumLibrary.Wait Until Element Is Visible    ${button.createaccount}    ${Long_Wait}    Create account button is not visible
    Run Keyword If    '${type}'=='Register'    Wait Until Element Clickable And Click    ${button.createaccount}
    Wait Until Time    3
    Run Keyword If    '${type}'=='Register'    SeleniumLibrary.Wait Until Element Is Visible    //a[text()="${variable}"]    ${Long_Wait}    Register button is not visible
    Run Keyword If    '${type}'=='Register'    Wait Until Element Clickable And Click    //a[text()="${variable}"]
    Run Keyword If    '${type}'=='Register'    SeleniumLibrary.Wait Until Element Is Visible    ${label.createpage}    ${Long_Wait}    Home Page is not visible
    Run Keyword If    '${type}'=='Login'    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.mainpage}    ${Long_Wait}    Login button is not visible
    Run Keyword If    '${type}'=='Login'    Wait Until Element Clickable And Click    ${button.login.mainpage}
    Run Keyword If    '${type}'=='Login'    SeleniumLibrary.Wait Until Element Is Visible    //a[text()="${variable} Login"]    ${Long_Wait}    Home Page is not visible
    Run Keyword If    '${type}'=='Login'    Wait Until Element Clickable And Click    //a[text()="${variable} Login"]
    Run Keyword If    '${type}'=='MJ OPS'    SeleniumLibrary.Wait Until Element Is Visible    ${button.mjadmin.signin}    ${Long_Wait}    Login button is not visible
    Run Keyword If    '${type}'=='MJ OPS'    Wait Until Element Clickable And Click    ${button.mjadmin.signin}
    Run Keyword If    '${type}'=='MJ OPS'    Click And Select Label    ${dropdown.mjadmin.page}    ${variable}
    Run Keyword If    '${type}'=='MJ OPS'    Wait Until Element Clickable And Click    ${button.mjadmin.signin.submit}

Validate OTP Email
    [Arguments]    ${Email}
    Open Chrome Browser    ${YopURL}
    Maximize Browser Window
    Wait Until Element Is Visible    ${textbox.yopemil.text}    ${Medium_Wait}
    Input Text    ${textbox.yopemil.text}    ${Email}
    Click button    ${button.refreshbtn}
    Wait Until Time    2
    Select Frame    ${lable.iframe}
    Wait Until Element Is Visible    ${lable.otptext}    ${Medium_Wait}
    ${string}    Get Text    ${lable.otptext}
    @{list}    Split String    ${string}
    ${newotp}    Remove String    ${list}[5]    .Please
    Wait Until Time    2
    Close Browser
    Switch Browser    1
    Input Text    ${textbox.otp1.text}    ${newotp}

Validate Seller Email
    [Arguments]    ${Email}
    Wait Until Element Is Visible    ${textbox.selleremail.text}    ${Medium_Wait}
    SeleniumLibrary.Input Text    ${textbox.selleremail.text}    ${Email}
    Wait Until Element Is Visible    ${button.getotp}    ${Medium_Wait}
    SeleniumLibrary.Click Button    ${button.getotp}
    Wait Until Time    2
    Validate OTP Email    ${Email}
    Wait Until Element Is Visible    ${button.loginbtn}    ${Medium_Wait}
    Click Button    ${button.loginbtn}

Buyer Login To The Application
    [Arguments]    ${Email}
    Comment    Launch the browser and navigate to the url
    Launch Browser And Navigate To The URL    ${RIVEXA_URL}    Login    Buyer
    Comment    Validate Seller Email
    Validate Buyer Email    ${Email}
    Comment    Validate OTP Email

Validate Buyer Email
    [Arguments]    ${Email}
    Wait Until Element Is Visible    ${textbox.buyeremail.text}    ${Medium_Wait}
    SeleniumLibrary.Input Text    ${textbox.buyeremail.text}    ${Email}
    Wait Until Element Is Visible    ${button.getotp}    ${Medium_Wait}
    SeleniumLibrary.Click Button    ${button.getotp}
    Wait Until Time    2
    Comment    To Validate OTP
    Validate OTP Email    ${Email}
    Wait Until Element Is Visible    ${button.loginbtn}    ${Medium_Wait}
    Click Button    ${button.loginbtn}

Close Application
    Wait until time    2
    SeleniumLibrary.Close All Browsers

Click And Select Dropdown
    [Arguments]    ${locator}    ${label}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}    ${Short_Wait}    Dropdown was not visible
    SeleniumLibrary.Click Element    ${locator}
    Wait Until Time    1
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Select From List By Label    ${locator}    ${label}
    Run Keyword If    ${status}==False    SeleniumLibrary.Wait Until Element Is Visible    //li[text()='${label}']    ${Short_Wait}    List was not visible
    Run Keyword If    ${status}==False    SeleniumLibrary.Click Element    //li[text()='${label}']

Read TestData From Excel
    [Arguments]    ${testcaseid}    ${sheet_name}
    ${test_data}    CustomLibrary.Get Ms Excel Row Values Into Dictionary Based On Key    ${TESTDATA_FOLDER}/Testdata.xlsx    ${testcaseid}    ${sheet_name}
    Set Global Variable    ${test_data}
    [Return]    ${test_data}

Wait Until Element Clickable And Click
    [Arguments]    ${locator}    ${time_interval}=2s
    Wait Until Keyword Succeeds    14s    ${time_interval}    Javascript Click By Xpath    ${locator}

Upload Document File
    [Arguments]    ${locator}    ${location}    ${button}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}    ${Short_Wait}    Document Upload is not visible
    Wait Until Element Clickable And Click    ${locator}
    Upload Attachment    ${location}
    Upload Attachment    ${location}
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Wait Until Element Is Enabled    //button[contains(text(),'${button}')]    ${Short_Wait}    Next button is not enabled
    Run Keyword If    ${status}==False    Wait Until Element Clickable And Click    //button[@title="Close"]
    Wait Until Keyword Succeeds    12s    2s    SeleniumLibrary.Wait Until Element Is Enabled    //button[contains(text(),'${button}')]    ${Short_Wait}    Next button is not enabled
    Wait Until Element Clickable And Click    //button[contains(text(),'${button}')]

Upload Attachment
    [Arguments]    ${attachment}
    sleep    3s
    AutoItLibrary.Process Wait    ${EMPTY}    1
    AutoItLibrary.Control Send    Open    ${EMPTY}    [CLASS:Edit]    ${attachment}
    AutoItLibrary.Process Wait    ${EMPTY}    2
    AutoItLibrary.Control Command    Open    ${EMPTY}    [CLASS:ComboBox; INSTANCE:2]    SelectString    All Files (.)
    AutoItLibrary.Process Wait    ${EMPTY}    2
    AutoItLibrary.Control Click    Open    ${EMPTY}    [TEXT:&Open]
    Wait Until Time    2

Validate Button Functionality
    [Arguments]    ${sdetails}    ${button}    ${page_name}=None
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()='${sdetails}']    ${Long_Wait}    ${sdetails}is not visible after waiting ${LONG_WAIT} seconds
    SeleniumLibrary.Wait Until Element Is Visible    //button[text()="${button}"]    ${Long_Wait}    ${button} is not visible after waiting ${Long_Wait} seconds
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Click Element    //button[text()="${button}"]
    Run Keyword If    '${page_name}'!='None'    SeleniumLibrary.Wait Until Element Is Visible    ${button.register.success.popup}    ${Short_Wait}    Skip to Profile is not visible after waiting for ${Short_Wait}
    Run Keyword If    '${page_name}'!='None'    Wait Until Element Clickable And Click    ${button.register.success.popup}

Navigate To The Menu
    [Arguments]    ${menu}    ${submenu}
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()='${menu}']    ${Long_Wait}    ${menu} is not visible after waiting ${Long_Wait} seconds
    Wait Until Element Clickable And Click    //div[text()='${menu}']
    SeleniumLibrary.Wait Until Element Is Visible    //span[contains(text(), '${submenu}')]    ${Short_Wait}    ${submenu} is not visible after waiting ${Long_Wait} seconds

Validate Success Or Error Message
    [Arguments]    ${message}
    Wait Until Time    3
    ${status}    Run Keyword And Return Status    Page Should Contain    ${message}
    Run Keyword If    ${status}==True    log    ${message} Message is Displayed
    ...    ELSE    Fail    ${message} Message is not displayed

Click And Select Label
    [Arguments]    ${locator}    ${label}
    Wait Until Element Clickable And Click    ${locator}
    Wait Until Time    2
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Select From List By Label    ${locator}    ${label}
    Run Keyword If    ${status}==False    SeleniumLibrary.Wait Until Element Is Visible    //label[text()="${label}"]    ${SHORT_WAIT}
    Run Keyword If    ${status}==False    SeleniumLibrary.Click Element    //label[text()="${label}"]

Login To The Application
    [Arguments]    ${type}    ${username}    ${user}=None
    Run Keyword If    '${type}'=='Regular'    SeleniumLibrary.Wait Until Element Is Visible    //label[contains(text(),"Email Address")]//following::div/input    ${Long_Wait}    Sign In page is not visible after waiting for ${LONG_WAIT}
    Run Keyword If    '${type}'=='Regular'    SeleniumLibrary.Input Text    //label[contains(text(),"Email Address")]//following::div/input    ${username}
    Run Keyword If    '${type}'=='Regular'    Wait Until Time    5
    Run Keyword If    '${type}'=='Regular'    SeleniumLibrary.Wait Until Element Is Visible    //button[text()="Get OTP"]    ${Short_Wait}    Email address is not visible
    Run Keyword If    '${type}'=='Regular'    Wait Until Element Clickable And Click    //button[text()="Get OTP"]
    Run Keyword If    '${type}'=='Regular'    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="OTP Verification"]    ${Short_Wait}    OTP Verifcation is not visible
    Run Keyword If    '${type}'=='Regular'    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Run Keyword If    '${type}'=='Regular'    Wait Until Time    1
    Run Keyword If    '${type}'=='Regular'    Validate Button Functionality    Login as a ${user}    Login
    Run Keyword If    '${type}'=='MJ OPS'    SeleniumLibrary.Wait Until Element Is Visible    //input[@id="userNameInput"]    ${Long_Wait}    Login button is not visible
    Run Keyword If    '${type}'=='MJ OPS'    SeleniumLibrary.Input Text    //input[@id="userNameInput"]    ${username}
    Run Keyword If    '${type}'=='MJ OPS'    Wait Until Time    1
    Run Keyword If    '${type}'=='MJ OPS'    SeleniumLibrary.Input Text    //input[@id="passwordInput"]    ${MJ_PSWD}
    Run Keyword If    '${type}'=='MJ OPS'    SeleniumLibrary.Wait Until Element Is Visible    //Span[text()="Sign in"]    ${Short_Wait}    Sign in button is not visible after waiting ${Long_wait} seconds
    Run Keyword If    '${type}'=='MJ OPS'    Wait Until Element Clickable And Click    //Span[text()="Sign in"]
    Run Keyword If    '${type}'=='MJ OPS'    Wait Until Time    2

Validate Login To The Application With Invalid Credentials
    [Arguments]    ${details}
    SeleniumLibrary.Wait Until Element Is Visible    //input[@id="Email Address"]
    Run Keyword If    '${details}[Email]'!='None'    Seleniumlibrary.Input Text    //input[@id="Email Address"]    ${details}[Email]
    Clear Element Text    //input[@id="Email Address"]
    Run Keyword If    '${details}[otp]'!='None'    Wait Until Element Clickable And Click    //button[text()='Get OTP']
    Run Keyword If    '${details}[otp]'!='None'    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="OTP Verification"]
    Run Keyword If    '${details}[otp]'!='None'    Seleniumlibrary.Input Text    //input[@data-testid="otp"][1]    ${details}[otp]

Validate Invalid Data For Seller Login
    [Arguments]    ${details}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.selleremail.text}
    Run Keyword If    '${details}[phone_number]'!='None'    Seleniumlibrary.Input Text    ${textbox.selleremail.text}    ${details}[phone_number]
    Clear Element Text    ${textbox.selleremail.text}

Validate Invalid Data For Buyer Registration
    [Arguments]    ${details}
    Run Keyword If    '${details}[Country]'!='None'    Click And Select Dropdown    //div[@id="Select Country"]    ${details}[Country]
    Run Keyword If    '${details}[EIN]'!='None'    Click And Select Dropdown    //div[@id="Type of registration number"]    ${details}[EIN]
    Run Keyword If    '${details}[EIN1]'!='None'    Seleniumlibrary.Input Text    //input[@id="Enter EIN"]    ${details}[EIN1]
    Run Keyword If    '${details}[EIN]'!='None'    Clear Element Text    //input[@id="Enter EIN"]
    Run Keyword If    '${details}[email]'!='None'    Wait Until Element Clickable And Click    //button[@type="submit"]
    Run Keyword If    '${details}[email]'!='None'    Wait Until Element Clickable And Click    //input[@id="Email Address"]
    Run Keyword If    '${details}[email]'!='None'    Seleniumlibrary.Input Text    //input[@id="Email Address"]    ${details}[email]
    Run Keyword If    '${details}[phone]'!='None'    Seleniumlibrary.Input Text    //input[@placeholder="Enter Phone Number"]    ${details}[phone]

Date Functionality
    [Arguments]    ${no_of_days}
    ${date}    Get Current Date
    @{date1}    Split String    ${date}
    ${today_date}    Split String    ${date1}[0]    -
    ${today_month}    Set Variable    ${today_date}[1]
    ${today_month1}    Convert To Integer    ${today_month}
    Set Test Variable    ${today_month1}
    ${tomorowdate}    Add Time To Date    ${date}    ${no_of_days} days
    @{date}    Split String    ${tomorowdate}
    @{actual_date}    Split String    ${date}[0]    -
    ${pre_two_date}    Set Variable    ${actual_date}[2]
    ${date}    Convert To Integer    ${pre_two_date}
    ${monthnumber}    Set Variable    ${actual_date}[1]
    ${nextmonth}    Convert To Integer    ${monthnumber}
    Set Test Variable    ${nextmonth}
    Wait Until Element Clickable And Click    //button[text()="${date}"]
    [Return]    ${date}

Fail And Take Screenshot
    [Arguments]    ${message}
    [Documentation]    Take a Screenshot Fail the test case and displays message.
    Capture Page Screenshot
    Fail    ${message}

Login To The Rivexa Application
    [Arguments]    ${usertype}
    [Documentation]    Launch the browser and application depending on the arguments we pass
    Launch Browser    ${BROWSERNAME}    ${RIVEXA_URL}
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Wait Until Element Is Visible    ${button.login.mainpage}    ${LONG_WAIT}    Login button is not displayed
    Wait Until Element Clickable And Click    ${button.login.mainpage}    2
    ${button.loginbtn.newuser}    Update Dynamic Value    //a[text()='replaceText']    ${usertype}
    Wait Until Element Clickable And Click    ${button.loginbtn.newuser}    2

Update Dynamic Value
    [Arguments]    ${locator}    ${value}
    [Documentation]    It replace the string where ever you want.
    ...    Example:
    ...    web_common.Update Dynamic Value locator replace_string
    ${xpath}    Replace String    ${locator}    replaceText    ${value}
    RETURN    ${xpath}

Launch Browser
    [Arguments]    ${browser_name}    ${url}
    [Documentation]    Launch the browser in Chrome or firefox.
    Open Browser    ${url}    ${browser_name}
    Maximize Browser Window

Login To The MJ OPS Module
    [Arguments]    ${variable}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.mjadmin.signin}    ${LONG_WAIT}    Login button is not visible
    Wait Until Element Clickable And Click    ${button.mjadmin.signin}
    Click And Select Label    ${dropdown.mjadmin.page}    ${variable}
    Wait Until Element Clickable And Click    ${button.mjadmin.signin.submit}
    SeleniumLibrary.Wait Until Element Is Visible    //input[@id="userNameInput"]    ${LONG_WAIT}    Login button is not visible
    SeleniumLibrary.Input Text    //input[@id="userNameInput"]    ${MJ_USER}
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Input Text    //input[@id="passwordInput"]    ${MJ_PSWD}
    SeleniumLibrary.Wait Until Element Is Visible    //Span[text()="Sign in"]    ${SHORT_WAIT}    Sign in button is not visible after waiting ${Long_wait} seconds
    Wait Until Element Clickable And Click    //Span[text()="Sign in"]
    Wait Until Time    2

Validate Add/Edit Icon In The Application
    [Arguments]    ${module}    ${action}
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="${module}"]    ${SHORT_WAIT}    ${module} is not visible after waiting ${SHORT_WAIT}
    Wait Until Keyword Succeeds    10s    2s    Wait Until Element Clickable And Click    //div[text()="${action}"]

Register To The Application
    [Arguments]    ${usertype}
    [Documentation]    Launch the browser and application depending on the arguments we pass
    Launch Browser    ${BROWSERNAME}    ${RIVEXA_URL}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.register.user}    ${LONG_WAIT}    Login button is not displayed
    Wait Until Element Clickable And Click    ${button.register.user}    2
    ${button.loginbtn.newuser}    Update Dynamic Value    ${dropdown.replace}    ${usertype}
    Wait Until Element Clickable And Click    ${button.loginbtn.newuser}    2

Validate Dashboard Is Displayed
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Wait Until Element Is Visible    //a[normalize-space()='Dashboard']    ${LONG_WAIT}    Dashboard is not displayed
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Element Should Be Visible    //button[@data-testid="icon-button"]    Welcome Note is not displayed

Upload File
    [Arguments]    ${location}    ${button}
    SeleniumLibrary.Wait Until Element Is Visible    //span[text()="Upload"]    ${SHORT_WAIT}    Document Upload is not visible
    Wait Until Keyword Succeeds    10s    2s    Wait Until Element Clickable And Click    //span[text()="Upload"]
    Upload Attachment    ${location}
    Upload Attachment    ${location}
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Wait Until Element Is Enabled    //button[contains(text(),'${button}')]    ${SHORT_WAIT}    Next button is not enabled
    Run Keyword If    ${status}==False    Wait Until Element Clickable And Click    //button[@title="Close"]
    Wait Until Keyword Succeeds    12s    2s    SeleniumLibrary.Wait Until Element Is Enabled    //button[contains(text(),'${button}')]    ${SHORT_WAIT}    Next button is not enabled
    Wait Until Element Clickable And Click    //button[contains(text(),'${button}')]
