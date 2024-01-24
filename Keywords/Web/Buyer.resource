*** Settings ***
Resource          ../../Global/super.robot

*** Keywords ***
Validate buyer email id and phone number
    [Arguments]    ${Email}    ${Buyer_Phoneno}
    Comment    Enter email id
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.buyeremail.text}    ${Medium_Wait}
    SeleniumLibrary.Input Text    ${textbox.buyeremail.text}    ${Email}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.getotp}    ${Medium_Wait}
    SeleniumLibrary.Click Button    ${button.getotp}
    Wait Until Time    2
    Comment    To validate otp
    Validate OTP Email    ${Email}
    Comment    Enter phone no
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.buyerphoneno.text}
    SeleniumLibrary.Input Text    ${textbox.buyerphoneno.text}    ${Buyer_Phoneno}
    SeleniumLibrary.Click Button    ${button.signup}
    SeleniumLibrary.Wait Until Element Is Visible    ${button.done}
    SeleniumLibrary.Click Button    ${button.done}

Validate Registration Of Buyer With Email And Phone
    [Arguments]    ${email}
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Create Your Account"]    ${Short_Wait}    Create Account Page is not visible after waiting ${Short_Wait}
    Click and Select Dropdown    //div[@id="Select Country"]    United States
    Click and Select Dropdown    //div[@id="Type of registration number"]    EIN
    SeleniumLibrary.Input Text    //input[@id="Enter EIN"]    ${test_data}[EIN]
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${Short_Wait}    Next button was not enabled
    Wait Until Element Clickable and Click    ${button.next}
    Wait Until Time    2
    SeleniumLibrary.Wait Until Element Is Visible    //input[@id="Email Address"]    ${Short_Wait}    Email address is not visible
    SeleniumLibrary.Input Text    //input[@id="Email Address"]    ${email}
    Wait Until Time    3
    ${email_id}    Set Variable    ${email}
    Wait Until Time    2
    SeleniumLibrary.Wait Until Element Is Visible    //button[text()="Get OTP"]    ${Short_Wait}    Email address is not visible
    Wait Until Element Clickable and Click    //button[text()="Get OTP"]
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="OTP Verification"]    ${Short_Wait}    OTP Verifcation is not visible
    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Run Keyword If    '${OTP}'!='None'    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    ...    ELSE    Wait Until Element Clickable and Click    ${textbox.otp1.text}
    Run Keyword If    '${OTP}'=='None'    Wait Until Time    60
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    (//input[@id="Email Address"]//following::div//img)[1]    ${Medium_Wait}    Icon is not visible after waiting ${Medium_Wait} seconds
    Run Keyword If    ${status}==False    Wait Until Element Clickable and Click    //section[@class="modal-main otp-modal"]//button//img
    Run Keyword If    ${status}==False    Wait Until Element Clickable and Click    //button[text()="Get OTP"]
    Run Keyword If    ${status}==False    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="OTP Verification"]    ${Short_Wait}    OTP Verifcation is not visible
    Run Keyword If    ${status}==False    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Wait Until Time    5
    SeleniumLibrary.Wait Until Element Is Visible    //input[@placeholder="Enter Phone Number"]    ${Short_Wait}    Phone number is not visible
    SeleniumLibrary.Input Text    //input[@placeholder="Enter Phone Number"]    ${test_data}[Phone]
    Wait Until Time    1
    SeleniumLibrary.Wait Until Element Is Visible    //button[text()="Sign Up"]    ${Short_Wait}    Sign up button is not visible
    Wait Until Element Clickable and Click    //button[text()="Sign Up"]
    [Return]    ${email_id}

Navigate To User Profile
    [Arguments]    ${user}    ${field}    ${user_option}
    SeleniumLibrary.Wait Until Element Is Visible    //span[text()="${user}"]    ${Short_Wait}    ${user} radio button is not visible after waiting ${Long_wait} seconds
    Wait Until Element Clickable and Click    //span[text()="${user}"]
    ${status}    Run Keyword And Return Status    SeleniumLibrary.Wait Until Element Is Visible    (//div[@data-field="${field}"])[2]    ${Short_Wait}    Buyer id is not visible after waiting ${Long_wait} seconds
    Run Keyword If    ${status}==False    Wait Until Element Clickable and Click    //span[text()="${user_option}"]
    Run Keyword If    ${status}==False    Wait Until Element Clickable and Click    //span[text()="${user}"]
    SeleniumLibrary.Wait Until Element Is Visible    (//div[@data-field="${field}"])[2]    ${Short_Wait}    Buyer id is not visible after waiting ${Long_wait} seconds
    Wait Until Time    3
    ${address_name}    Get Text    (//div[@class="MuiDataGrid-row"]//following::div[text()][3])[1]
    Set Test Variable    ${address_name}
    Wait Until Keyword Succeeds    14s    2s    Wait Until Element Clickable and Click    (//div[@data-field="${field}"])[2]
    Wait Until Time    5
    ${address_name1}    Get Text    (//div[@class="outer-container"]//span[text()])[1]
    Set Test Variable    ${address_name1}
    Wait Until Time    1
    ${status}    Run Keyword And Return Status    Should Be Equal    ${address_name}    ${address_name1}
    Run Keyword If    ${status}==False    LOG    ${user} Name is not matched
    Run Keyword If    ${status}==True    LOG    ${user} name is matched

Validate Approving The User
    [Arguments]    ${button}    ${user}=None    ${rate1}=None    ${rate2}=None    ${rate3}=None    ${rate4}=None    ${rate5}=None    ${rate6}=None
    SeleniumLibrary.Wait Until Element Is Visible    ${button.mjadmin.ratings}    ${Short_Wait}    Rating field is not visible
    Wait Until Element Clickable and Click    ${button.mjadmin.ratings}
    Validate Button functionality    Ratings & review    ${button}
    Run Keyword If    '${user}'=='seller'    SeleniumLibrary.Wait Until Element Is Visible    ${label.mjadmin.ratings.trustscore}    ${Short_Wait}    Trust Score page is not visible after waiting ${Short_Wait}
    Run Keyword If    '${user}'=='seller'    Validate Button functionality    Manage Profile Trust Score    Cancel
    Run Keyword If    '${user}'=='seller'    Validate Button functionality    Ratings & review    ${button}
    Run Keyword If    '${user}'=='seller'    SeleniumLibrary.Wait Until Element Is Visible    ${button.mjadmin.ratings.page}    ${Long_Wait}    Manufacturing Score is not visible after waiting ${Short_Wait}
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate1} Stars"])[1]
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate2} Stars"])[2]
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate3} Stars"])[3]
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate4} Stars"])[4]
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate5} Stars"])[5]
    Run Keyword If    '${user}'=='seller'    Wait Until Keyword Succeeds    12s    2s    Wait Until Element Clickable and Click    (//span[text()="${rate6} Stars"])[6]
    Run Keyword If    '${user}'=='seller'    Validate Button functionality    Manage Profile Trust Score    Submit
    SeleniumLibrary.Wait Until Element Is Visible    ${label.mjadmin.ratings.status}    ${Short_Wait}    Rating field is not visible
    Click and Select Dropdown    ${dropdown.mjadmin.ratings.status}    Approved
    Validate Button functionality    Remarks    Save

Create an Account for Buyer
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Create Your Account"]    ${SHORT_WAIT}    'Create Your Account' page is not visible after waiting ${SHORT_WAIT}
    Click And Select Dropdown    //div[@id="Select Country"]    United States
    Click And Select Dropdown    //div[@id="Type of registration number"]    EIN
    SeleniumLibrary.Input Text    //input[@id="Enter EIN"]    ${test_data}[EIN]
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${SHORT_WAIT}    'Next' button is not visible after waiting ${SHORT_WAIT}
    Wait Until Element Clickable And Click    ${button.next}

Sign up for Buyer Account
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Create Your Account"]    ${LONG_WAIT}    'Create Your Account' page is not visible after waiting ${LONG_WAIT}
    SeleniumLibrary.Wait Until Element Is Visible    //input[@id="Email Address"]    ${SHORT_WAIT}    'Email address' textbox is not visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Input Text    //input[@id="Email Address"]    ${test_data}[Email]
    Get OTP
    SeleniumLibrary.Wait Until Element Is Visible    //input[@placeholder="Enter Phone Number"]    ${SHORT_WAIT}    'Phone number' textbox is not visible visible after waiting ${SHORT_WAIT}
    SeleniumLibrary.Input Text    //input[@placeholder="Enter Phone Number"]    329230532
    CustomLibrary.Wait Until Time    1
    SeleniumLibrary.Wait Until Element Is Visible    //button[text()="Sign Up"]    ${LONG_WAIT}    'Sign Up' button is not visible visible after waiting ${LONG_WAIT}
    Wait Until Element Clickable And Click    //button[text()="Sign Up"]

Get OTP
    Wait Until Element Clickable And Click    //button[text()="Get OTP"]
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="OTP Verification"]    ${LONG_WAIT}    'OTP Verifcation' pop up page is not visible after waiting ${LONG_WAIT}
    FOR    ${key}    IN RANGE    1    7
        SeleniumLibrary.Wait Until Element Is Visible    //input[@data-testid='otp'][${key}]    ${LONG_WAIT}    'OTP' textbox is not visible after waiting ${LONG_WAIT}
        SeleniumLibrary.Click Element    //input[@data-testid='otp'][${key}]
        SeleniumLibrary.Input Text    //input[@data-testid='otp'][${key}]    1
    END

Enter Mandatory Details in Business Information Page for Buyer Registration
    [Arguments]    ${category}    ${group}
    SeleniumLibrary.Wait Until Element Is Visible    ${label.business.information}    ${LONG_WAIT}    'Business Information' page is not visible after waiting ${LONG_WAIT}
    SeleniumLibrary.Input Text    ${textbox.companyname.text}    Macro1
    SeleniumLibrary.Input Text    ${textbox.companyaddress1.text}    ${test_data}[Address 1]
    SeleniumLibrary.Input Text    ${textbox.areacode.text}    ${test_data}[Area]
    SeleniumLibrary.Input Text    ${textbox.city.text}    Newark
    SeleniumLibrary.Input Text    ${textbox.state.text}    New York
    Wait Until Element Clickable And Click    ${checkbox.register.buyer.billaddress}
    Wait Until Element Clickable And Click    //div[text()="${category}"]
    Click And Select Label    ${label.register.subcategories}    ${group}
    CustomLibrary.Wait Until Time    2
    Wait Until Element Clickable And Click    ${button.register.page.savechanges}
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${SHORT_WAIT}    'Next' button is not visible after waiting ${LONG_WAIT}
    Wait Until Element Clickable And Click    ${button.next}

Enter Mandatory Details in Personal Information Page for Registration
    [Arguments]    ${page}    ${user}    ${term}
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="${page}"]    ${LONG_WAIT}    'Contact Details' page is not visible after waiting ${LONG_WAIT}
    Wait Until Keyword Succeeds    10s    2s    SeleniumLibrary.Input Text    ${textbox.name.text}    Girija
    Click And Select Dropdown    ${dropdown.register.info.role}    Proprietor/Owner
    Accept Terms And Agreement In Personal Details    ${user}    ${term}
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${SHORT_WAIT}    'Next' button is not visible after waiting ${SHORT_WAIT}
    Wait Until Element Clickable And Click    ${button.next}

Enter Mandatory Details in Import Experience Page for Buyer Profile Completion
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Import Experience"]    ${LONG_WAIT}    'Import Experience' page is not visible after waiting ${LONG_WAIT}
    SeleniumLibrary.Input Text    //input[@id="Total Import Experience"]    7
    SeleniumLibrary.Click Element    //div[text()="Select multiple"]
    SeleniumLibrary.Click Element    //span[text()="India"]
    Wait Until Element Clickable And Click    //button[text()='PROCEED']
    SeleniumLibrary.Wait Until Element Is Visible    //span[text()="Macro1"]    ${LONG_WAIT}    'Profile name' is not visible after waiting ${LONG_WAIT}

Validate Success Message and Click on Skip Profile Button
    Wait Until Element Is Visible    //div[contains(text(),'Congratulations!')]    ${SHORT_WAIT}    'Success Message' is not visible after waiting ${SHORT_WAIT}
    Wait Until Element Clickable And Click    //button[text()='COMPLETE PROFILE']
    SeleniumLibrary.Wait Until Element Is Visible    ${button.register.success.popup}    ${SHORT_WAIT}    Skip to Profile is not visible after waiting for ${SHORT_WAIT}
    Wait Until Element Clickable And Click    ${button.register.success.popup}

Enter Buyer Email Id
    [Arguments]    ${username}
    Wait Until Element is Visible    //input[@id="Email Address"]    ${LONG_WAIT}    Sign In page is not visible after waiting for ${LONG_WAIT}
    SeleniumLibrary.Input Text    //input[@id="Email Address"]    ${username}
    Wait Until Time    3
    Seleniumlibrary.Wait Until Element Is Visible    //button[text()="Get OTP"]
    Wait Until Element Clickable And Click    //button[text()="Get OTP"]    2
    Seleniumlibrary.Wait Until Element Is Visible    ${textbox.otp1.text}    ${SHORT_WAIT}    OTP Verifcation is not visible
    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    SeleniumLibrary.Click Button    //button[@type='submit']

Scroll Up /Down View List
    [Documentation]    Description : This Keyword perform scroll element in to view list in Create Work Order Screen
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
