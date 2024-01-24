*** Settings ***
Documentation     This dropdown file has all dropdown type locators of web application    # robocop: disable

*** Variables ***
# robocop: disable
${dropdown.country}    //div[@id='Select Country']
${dropdown.listofcountry}    //li[contains(text(),"${CountryDropdown}")]
${dropdown.type_of_registration_no}    //div[@id='Type of registration number']
${dropdown.registrationno}    //li[contains(text(),"EIN")]
${dropdown.mjadmin.page}    //select[@id="idp_RelyingPartyDropDownList"]
${label.register.subcategories}    //div[text()="Select Subcategories"]
${dropdown.register.info.role}    //div[text()="Select Role"]
${dropdown.mjadmin.ratings.status}    //div[@role="combobox"]
${dropdown.replace}    //a[text()='replaceText']
