*** Settings ***
Resource          ../../Global/super.robot

*** Keywords ***
Validate Seller Email Id And Phone Number
    [Arguments]    ${gst}    ${RegisterEmail}    ${Mobile_number}
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.gstno.text}    20s    Gst text field is not visible after waiting for 20 seconds
    SeleniumLibrary.Input Text    ${textbox.gstno.text}    ${gst}
    Validate Button Functionality    Create Your Account    Next
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.registeremail.text}    ${Short_Wait}    Email text field is not visible after waiting ${Short_Wait}
    SeleniumLibrary.Input Text    ${textbox.registeremail.text}    ${RegisterEmail}
    Wait Until Element Clickable And Click    ${button.getotp}
    Wait Until Time    2
    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Run Keyword If    '${OTP}'!='None'    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    ...    ELSE    Wait Until Element Clickable And Click    ${textbox.otp1.text}
    Run Keyword If    '${OTP}'=='None'    Wait Until Time    60
    SeleniumLibrary.Wait Until Element Is Visible    ${textbox.mobileno.text}    ${Short_Wait}    Mobile field is not visible after waiting ${Short_Wait}
    SeleniumLibrary.Input Text    ${textbox.mobileno.text}    ${Mobile_number}
    Wait Until Time    2
    Wait Until Element Clickable And Click    ${button.getotp}
    Wait Until Time    5
    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Run Keyword If    '${OTP}'!='None'    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    ...    ELSE    Wait Until Element Clickable And Click    ${textbox.otp1.text}
    Run Keyword If    '${OTP}'=='None'    Wait Until Time    60
    Wait Until Time    2
    SeleniumLibrary.Wait Until Element Is Visible    ${button.signup}    20s    sign up button is not visible
    Validate Button Functionality    Create Your Account    Sign Up

Validate Navigation To The Profile Page
    [Arguments]    ${label}    ${module}
    SeleniumLibrary.Wait Until Element Is Visible    //button[@data-testid="icon-button"]    ${Short_Wait}    Welcome Note is not visible after waiting ${Short_Wait}
    Click And Select Label    //button[@data-testid="icon-button"]    ${label}
    SeleniumLibrary.Wait Until Element Is Visible    (//div[@class="outer-container"]//span[text()])[1]    ${Short_Wait}    Seller Name is not visible after waiting ${Short_Wait}
    Wait Until Keyword Succeeds    14s    2s    Wait Until Element Clickable And Click    //div[text()="${module}"]

Update The Certificate Data In Seller Profile
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Edit Factory details"]    ${Short_Wait}    Edit Factory Details Page is not visible after waiting ${Short_Wait}
    Click And Select Dropdown    //div[text()="Select Certificate"]    SEDEX
    Comment    Click And Select Label    //div[text()="Select Certificate"]    SEDEX
    Upload Document File    //div[text()="Upload File"]    ${EXECDIR}\\ImportFiles\\GST.pdf    SAVE & PROCEED
    Wait Until Element Clickable And Click    //button[@aria-label="Choose date"]
    Comment    SeleniumLibrary.Wait Until Element Is Visible    //input[@placeholder="MM/DD/YYYY"]    ${MEDIUM_WAIT}    Calendar icon is not displayed after waiting ${MEDIUM_WAIT} seconds
    Comment    Click Element    //input[@placeholder="MM/DD/YYYY"]
    ${date}    Date Functionality    5

Update The In House Facilities In Profile
    [Arguments]    ${facility}
    SeleniumLibrary.Wait Until Element Is Visible    //div[text()="Edit Factory details"]    ${Short_Wait}    Edit Factory Details Page is not visible after waiting ${Short_Wait}
    Click And Select Label    //div[text()="Select facility"]    ${facility}
    Validate Button Functionality    Edit Factory details    SAVE & PROCEED

Enter Seller Email Id
    [Arguments]    ${username}
    Seleniumlibrary.Wait Until Element Is Visible    //input[@id="Email Address/Phone Number"]    ${LONG_WAIT}    Sign In page is not visible after waiting for ${LONG_WAIT}
    SeleniumLibrary.Input Text    //input[@id="Email Address/Phone Number"]    ${username}
    Wait Until Time    5
    Seleniumlibrary.Wait Until Element Is Visible    //button[text()="Get OTP"]
    Wait Until Element Clickable And Click    //button[text()="Get OTP"]    2
    Seleniumlibrary.Wait Until Element Is Visible    ${textbox.otp1.text}    ${SHORT_WAIT}    OTP Verifcation is not visible
    SeleniumLibrary.Input Text    ${textbox.otp1.text}    ${OTP}
    Click Button    //button[@type='submit']

Accept Terms And Agreement In Personal Details
    [Arguments]    ${user}    ${term}
    Wait Until Keyword Succeeds    10s    2s    Wait Until Element Clickable And Click    ${button.register.info.termsncond}
    Wait Until Element Clickable And Click    ${icon.termsnconditions}
    Wait Until Element Clickable And Click    ${checkbox.register.terms.accept}
    Wait Until Element Clickable And Click    //button[text()="${user}"]
    Wait Until Element Clickable And Click    ${icon.termsnconditions}
    Wait Until Element Clickable And Click    //input[@name="${term}TermsAndConditionsAccepted"]

Enter GSTIN Number
    [Arguments]    ${gst_number}
    [Documentation]    This Keyword contains all about gst number
    Wait Until Element Is Visible    ${textbox.gstno.text}    ${MEDIUM_WAIT}    GSTIN text field is not displayed
    SeleniumLibrary.Input Text    ${textbox.gstno.text}    ${gst_number}
    Wait Until Element Clickable And Click    ${button.next}

Enter Seller Contact Information
    [Arguments]    ${email_Id}    ${mobile_number}
    Wait Until Element Is Visible    id=Email Address    ${MEDIUM_WAIT}    Email Address Is not displayed
    Input Text    id=Email Address    ${email_Id}
    Get OTP
    Wait Until Element Is Visible    id=Mobile Number    ${MEDIUM_WAIT}    Mobile Number\nIs not displayed
    Input Text    id=Mobile Number    ${mobile_number}
    CustomLibrary.Wait Until Time    2
    Get OTP
    Wait Until Element Is Visible    ${button.signup}    ${SHORT_WAIT}    Signup Button is not displayed
    Click Element    ${button.signup}

Enter Seller Business Information
    [Arguments]    ${group}    ${Category}
    Wait Until Element Clickable and Click    //div[text()="${group}"]
    Click and Select Label    ${label.register.subcategories}    ${Category}
    Wait Until Time    2
    Wait Until Element Clickable and Click    ${button.register.page.savechanges}
    Wait Until Element Clickable and Click    ${checkbox.register.seller.defaultaddress}
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${SHORT_WAIT}    Next button is not enabled
    Wait Until Element Clickable and Click    ${button.next}

Select Subcategories In Product Capabilities
    [Arguments]    ${group}    ${category}
    Comment    Scroll Up /Down View List
    Comment    SeleniumLibrary.Scroll Element Into View    //img[@alt='arrow']
    Comment    Click Element    //img[@alt='arrow']
    Comment    ${new}    Update Dynamic Value    //label[text()='replaceText']    ${category}
    Comment    Wait Until Element Is Visible    ${new}    ${MEDIUM_WAIT}    Subcategory dropdown not displayed
    Comment    Click Element    ${new}
    Comment    Click Element    //div[text()='Save Changes']
    Comment    ${selected_category}    Update Dynamic Value    //div[text()='replaceText'']    ${category}
    Comment    Wait Until Element Is Visible    ${selected_category}    ${MEDIUM_WAIT}    Subcategory is not selected
    Wait Until Element Clickable and Click    //div[text()="${group}"]
    Click and Select Label    ${label.register.subcategories}    ${category}
    Wait Until Element Clickable and Click    //div[text()='Save Changes']

Enter Buyer/Seller Business Information
    [Arguments]    ${user}    ${category}    ${group}
    Wait Until Element Is Visible    ${label.business.information}    ${SHORT_WAIT}    Business Information is not visible
    IF    '${user}'=='Buyer'
    SeleniumLibrary.Input Text    ${textbox.companyname.text}    Macro1
    SeleniumLibrary.Input Text    ${textbox.companyaddress1.text}    ${test_data}[Address 1]
    SeleniumLibrary.Input Text    ${textbox.areacode.text}    ${test_data}[Area]
    SeleniumLibrary.Input Text    ${textbox.city.text}    Newark
    SeleniumLibrary.Input Text    ${textbox.state.text}    New York
    Wait Until Element Clickable And Click    ${checkbox.register.buyer.billaddress}
    END
    Wait Until Element Clickable And Click    //div[text()="${category}"]
    Click And Select Label    ${label.register.subcategories}    ${group}
    Wait Until Time    2
    Wait Until Element Clickable And Click    ${button.register.page.savechanges}
    Run Keyword IF    '${user}'=='Seller'    Wait Until Element Clickable And Click    ${checkbox.register.seller.defaultaddress}
    SeleniumLibrary.Wait Until Element Is Enabled    ${button.next}    ${SHORT_WAIT}    Next button is not enabled
    Wait Until Element Clickable And Click    ${button.next}
