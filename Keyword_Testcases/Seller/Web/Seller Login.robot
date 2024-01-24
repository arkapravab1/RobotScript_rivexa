*** Settings ***
Resource          ../../../Global/super.robot

*** Test Cases ***
TC_SE_01 Validate User Is Able To Register As Textile Seller
    [Tags]    P1
    [Setup]    Read TestData From Excel    TC_01    Seller
    Register To The Application    Seller
    Enter GSTIN Number    29AMJPR0126P1ZI
    Enter Seller Contact Information    ${test_data}[Email]    ${test_data}[Phone]
    Upload File    ${EXECDIR}\\ImportFiles\\GST.pdf    Next
    Enter Seller Business Information    Fashion & Home Textiles    Woven Apparels
    Enter Mandatory Details in Personal Information Page for Registration    Personal Details    Seller Agreement    seller
    Validate Success Message and Click on Skip Profile Button
    [Teardown]

TC_SE_02 Validate MJ OPS User Is Able To Approve The Seller Profile
    [Tags]    P1
    [Setup]    Read TestData From Excel    TC_02    Seller
    Launch Browser    ${BROWSERNAME}    ${MJOPS_URL}
    Login To The MJ OPS Module    ${test_data}[User]
    Navigate To The Menu    ${test_data}[Category]    ${test_data}[Subcategory]
    Navigate To User Profile    ${test_data}[Info Page]    ${test_data}[Term]    Buyers
    Validate Approving The User    ${test_data}[Button]    ${test_data}[Label]    ${test_data}[Rate1]    ${test_data}[Rate2]    ${test_data}[Rate3]    ${test_data}[Rate4]    ${test_data}[Rate5]    ${test_data}[Rate6]
    [Teardown]    Close Application

TC_SE_03 Validate User Is Able To Get Register As IG Seller
    [Setup]    Read TestData From Excel    TC_01    Seller
    Register To The Application    Seller
    Validate Seller Email Id And Phone Number    33AASFB6292R1ZJ    ${test_data}[Email]    ${test_data}[Phone]
    Upload File    ${EXECDIR}\\ImportFiles\\GST.pdf    Next
    Enter Seller Business Information    Fashion & Home Textiles    Woven Apparels
    Enter Mandatory Details in Personal Information Page for Registration    Personal Details    Seller Agreement    seller
    Validate Button Functionality    ${test_data}[Label]    ${test_data}[Button]    ${test_data}[Priority]

TC_SE_04 Validate Seller is Able to Login to the application
    Login To The Rivexa Application    Seller Login
    Enter Seller Email Id    ${IG_SELLER}
    Validate Dashboard Is Displayed
    [Teardown]    Close Browser
