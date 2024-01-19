*** SETTINGS ***
Documentation     This button file has all checkbox type locators of web application
Suite Setup       Login To The Rivexa Application    \    Buyer Login
Suite Teardown    Close Browser
Test Template     Login With Invalid Data
Resource          ../../../Global/super.resource
Library           DataDriver    file=${EXECDIR}//TestData//TestData.xlsx    sheet_name=Login_Invalid

*** Test Cases ***
${test_case_name}

*** Keywords ***
Login With Invalid Data
    [Arguments]    ${test_case_name}
    [Documentation]    This Keyword contains all login data
    ${details}    Read TestData From Excel    ${test_case_name}    Login_Invalid
    Validate Login To The Application With Invalid Credentials    ${details}
    Validate Success Or Error Message    ${details}[ErrorMessage]
