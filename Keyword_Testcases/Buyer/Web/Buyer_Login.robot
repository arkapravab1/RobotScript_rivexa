*** Settings ***
Resource          ../../../Global/super.robot

*** Test Cases ***
TC_BY_01 Validate User is able to Create a New Account for Buyer
    [Setup]    Read TestData From Excel    TC_001    Buyer
    Register To The Application    Buyer
    Create an Account for Buyer
    Sign up for Buyer Account
    Upload File    ${EXECDIR}\\ImportFiles\\GST.pdf    Next
    Enter Mandatory Details in Business Information Page for Buyer Registration    Fashion & Home Textiles    Woven Apparels
    Enter Mandatory Details in Personal Information Page for Registration    Contact Details    Buyer Agreement    buyer
    Validate Success Message and Click on Skip Profile Button
    [Teardown]    Close Browser

TC_BY_02 Validate MJ OPS User Is Able To Approve The Buyer Profile
    [Tags]    P1
    [Setup]    Read TestData From Excel    TC_002    Buyer
    Launch Browser    ${BROWSERNAME}    ${MJOPS_URL}
    Login To The MJ OPS Module    ${test_data}[User]
    Navigate To The Menu    ${test_data}[Category]    ${test_data}[Subcategory]
    Navigate To User Profile    ${test_data}[Term]    ${test_data}[Label]    Sellers
    Validate Approving The User    ${test_data}[Button]
    [Teardown]    Close Application

TC_BY_03 Validate If User Is Able To Navigate From Buyer Registration To MJ OPS Approval
    [Tags]    P1
    [Setup]    Read TestData From Excel    TC_003    Buyer
    Launch Browser And Navigate To The URL    ${RIVEXA_URL}    ${test_data}[Page]    ${test_data}[User]
    Comment    Validating the registration of buyer with valid email and phone number
    ${email_id}    Validate Registration Of Buyer With Email And Phone    ${test_data}[Email]
    Comment    Validating the Upload of Document
    Upload File    ${EXECDIR}\\ImportFiles\\GST.pdf    Next
    Comment    Validating the business information
    Enter Mandatory Details in Business Information Page for Buyer Registration    Fashion & Home Textiles    Woven Apparels
    Comment    Validating Personal information
    Enter Mandatory Details in Personal Information Page for Registration    Contact Details    Buyer Agreement    buyer
    Comment    Validating the success page
    Validate Button Functionality    ${test_data}[Label]    ${test_data}[Button]    ${test_data}[Priority]
    Comment    Closing the Application
    Close Application
    Comment    Navigating to the Application
    Launch Browser And Navigate To The URL    ${MJOPS_URL}    MJ OPS    qa-ops.rivexa.com
    Comment    Navigating to the Buyer Profile
    Login To The Application    MJ OPS    ${MJ_USER}
    Comment    Navigating to the preferred module
    Navigate To The Menu    Profiles    Category
    Comment    Navigating to the Buyer Profile from MJ OPS page
    Navigate To User Profile    Buyers    buyerId    Sellers
    Comment    Approving the Buyer Profile
    Validate Approving The User    Manage Profile Status
    Comment    Closing the Application
    Close Application
    Comment    Navigating to the Apllication
    Launch Browser And Navigate To The URL    ${RIVEXA_URL}    Login    Buyer
    Comment    Navigating to the Buyer Profile
    Login To The Application    Regular    ${email_id}    Buyer
    [Teardown]    Close Application

TC_BY_04 Validate If Buyer is Able to Login to the application
    [Tags]    P1
    Login To The Rivexa Application    Buyer Login
    Enter Buyer Email Id    ${BUYER}
    Validate Dashboard Is Displayed
    [Teardown]    Close Browser
