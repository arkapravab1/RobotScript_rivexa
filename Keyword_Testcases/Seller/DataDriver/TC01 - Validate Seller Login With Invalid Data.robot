*** SETTINGS ***
Documentation     This button file has all checkbox type locators of web application
Suite Setup       Login To The Rivexa Application    Seller Login
Suite Teardown    Close Browser
Test Template     Login With Invalid Data
Resource          ../../../Global/super.resource
Library           DataDriver    file=${EXECDIR}//TestData//TestData.xlsx    sheet_name=Seller_Invalid

*** Test Cases ***
${test_case_name}

*** Keywords ***
Login With Invalid Data
    [Arguments]    ${test_case_name}
    [Documentation]    This Keyword contains all login data
    ${details}    Read TestData From Excel    ${test_case_name}    Seller_Invalid
    Validate Invalid Data For Seller Login    ${details}
    Validate Success Or Error Message    ${details}[ErrorMessage]
