*** SETTINGS ***
Documentation     This button file has all checkbox type locators of web application
Suite Setup       Register To The Application    Buyer
Suite Teardown    Close Browser
Test Template     Buyer Registation With Invalid Data
Library           DataDriver    file=${EXECDIR}//TestData//TestData.xlsx    sheet_name=Buyer_Registration
Resource          ../../../Global/super.resource

*** Test Cases ***
${test_case_name}

*** Keywords ***
Buyer Registation With Invalid Data
    [Arguments]    ${test_case_name}
    [Documentation]    This Keyword contains all invalid data
    ${details}    Read TestData From Excel    ${test_case_name}    Buyer_Registration
    Validate Invalid Data For Buyer Registration    ${details}
    Validate Success Or Error Message    ${details}[ErrorMessage]
