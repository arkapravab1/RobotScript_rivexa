*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           FakerLibrary
Library           AutoItLibrary
Library           String
Library           ../Library/CustomLibrary.py
Resource          common_variables.resource
Resource          ../Keywords/Web/common.resource
Resource          ../Keywords/Web/Buyer.resource
Resource          ../Keywords/Web/Seller.resource
Resource          ../Object_Repository/Web/textBox.resource
Resource          ../Object_Repository/Web/buttons.resource
Resource          ../Object_Repository/Web/Label.resource
Resource          ../Object_Repository/Web/dropdown.resource
Resource          ../Object_Repository/Web/checkbox.resource
Resource          ../Object_Repository/Web/icon.resource
Library           DateTime
