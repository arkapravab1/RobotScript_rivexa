*** Settings ***
Documentation     This button file has all button type locators of web application    # robocop: disable

*** Variables ***
# robocop: disable
${lable.iframe}    //iframe[@id="ifmail"]
${lable.otptext}    //*[@id="mail"]/div
${lable.BusinesInfoage}    //div[contains(text(),'Buyer Registration')]
${lable.ContactDetails}    //div[contains(text(),'Contact Details')]
${label.createpage}    //div[text()="Create Your Account"]
${label.document.upload}    //div[text()="Document Upload"]
${label.business.information}    //div[text()="Business Information"]
${label.register.success}    //div[text()="Congratulations!"]
${label.mjadmin.ratings.trustscore}    //div[text()="Manage Profile Trust Score"]
${label.mjadmin.ratings.status}    //label[text()="Status"]
