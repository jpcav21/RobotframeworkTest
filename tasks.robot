*** Settings ***
Documentation       Exercise 1. Saucedemo
Library    SeleniumLibrary
Library    RequestsLibrary
Library    String
Library    Collections
Library    RPA.JSON
Library    XML
#Library    RPA.Browser.Selenium



*** Variables ***
# API link to get Dorne's House information
${WEBSITE}    https://www.saucedemo.com/  
# Browser used to perform API Test
${BROWSER}    Chrome   

# List of Users to test
${username1}    standard_user
${username2}    locked_out_user
${username3}    problem_user
${username4}    performance_glitch_user

# Password common to all users
${password}     secret_sauce
  

*** Keywords ***
Login
    # Launch Website
    Open Browser  https://www.saucedemo.com/    Chrome
    # Maximize Browser Window
    Maximize Browser Window
    # Set Arguments for login action
    [Arguments]       ${username}    ${password}
    # Input Username and Password
    Input Text        id=user-name    ${username}
    Input Password    id=password    ${password}

    #Click button
    Click button    id=login-button

Open Cart
    Click Element    id=shopping_cart_container 
Validate if Cart is empty
    Page Should Not Contain Element    class=cart_quantity
    Capture Page Screenshot    empty-cart.png

Set price high to low
    Click Element   xpath=//*[@id="header_container"]/div[2]/div/span/select/option[4]
    Capture Page Screenshot    price-high-low.png

Set price low to high
    Click Element   xpath=//*[@id="header_container"]/div[2]/div/span/select/option[3]
    Capture Page Screenshot    price-high-low.png

Verify Cart Item Name
    [Arguments]       ${CartItemNameXPATH}    ${IntendedItemName}
    ${CartItemName}=    Get Text    xpath=${CartItemNameXPATH} 
    Should Be Equal    ${CartItemName}    ${IntendedItemName}    This item was not intended to be added to the cart!

Verify Cart Item Quantity
    [Arguments]       ${CartItemQuantityXPATH}    ${IntendedItemQuantity}
    ${ItemQuantity}=    Get Text    ${CartItemQuantityXPATH}
    Should Be Equal    ${ItemQuantity}    ${IntendedItemQuantity}    Item quantity is Incorrect!

Verify Cart Item Price
    [Arguments]       ${ItemPriceXPATH}    ${IntendedItemPrice}
    ${ItemPrice}=    Get Text    ${ItemPriceXPATH}
    Should Be Equal    ${ItemPrice}    ${IntendedItemPrice}    Item Price is Incorrect!   

Go to checkout
    Click Button    id=checkout

Fill checkout information
    [Arguments]    ${FirstName}    ${LastName}    ${PostalCode}
    Input Text    id=first-name   ${FirstName} 
    Input Text    id=last-name    ${LastName}
    Input Text    id=postal-code    ${PostalCode}
Click continue button
    Click Element    xpath=//*[@id="continue"]

Calculates Final Price with Tax
    [Arguments]    ${FirstItem}    ${SecondItem}    ${Tax}    ${ExpectedFinalPrice}
    ${CalculatedPriceWithTax}    Evaluate    ${FirstItem}+${SecondItem}+${Tax}
    ${CalculatedPriceWithTax}=    Convert To String    ${CalculatedPriceWithTax}
    Should Be Equal    ${CalculatedPriceWithTax}    ${ExpectedFinalPrice}    Calculated price with added tax is wrong!

Click Finish Button
    Click Button    id=finish

Verify successful order completion
    Element Text Should Be    //*[@id="checkout_complete_container"]/h2    Thank you for your order!
    Capture Page Screenshot    successful-order.png

Click back home button
    Click Button    id=back-to-products

Click burguer button
    Click Button    id=react-burger-menu-btn
Logout
    Wait Until Element Is Visible    xpath=//*[@id="menu_button_container"]/div/div[2]/div[1]/nav/a[3]    5
    Click Element    xpath=//*[@id="menu_button_container"]/div/div[2]/div[1]/nav/a[3]
    Capture Page Screenshot    logout-successful-homepage.png
    
*** Test Cases ***

# Exercise 2.1 - Login with all four users and validate each case

## Positive Scenario
Login To Saucedemo with Standard User
    
    # Validate user 1: standard user 
    Login    ${username1}     secret_sauce
    
    # Evidence of sucessful login as standard-user
    Capture Page Screenshot    standard-user.png

    # Closes Browser  
    Close Browser   

## Negative Scenarios
Login To Saucedemo with locked_out_user

    # Validate user 2: locked_out_user
    Login    ${username2}     secret_sauce

    # Evidence of sucessful login as locked_out_user
    Capture Page Screenshot    locked_out_user.png 

    # Closes Browser
    Close Browser
Login To Saucedemo with problem_user

    # Validate user 3: problem_user
    Login    ${username3}     secret_sauce

    # Evidence of sucessful login as problem_user
    Capture Page Screenshot    problem_user.png

    # Closes Browser
    Close Browser
Login To Saucedemo with performance_glitch_user
    # Validate user 4: performance_glitch_user
    Login    ${username4}     secret_sauce

    # Evidence of sucessful login as performance_glitch_user
    Capture Page Screenshot    performance_glitch_user.png

    # Closes Browser
    Close Browser

# Exercise 2.2 - Login with standard user and fill in orders

Login To Saucedemo with Standard User and Fill Orders
    
    # 2.2.1 and 2.2.2    Open https://www.saucedemo.com/ and login as standard-user
    Login    ${username1}     secret_sauce

    ## Evidence of sucessful login as standard-user
    Capture Page Screenshot    standard-user.png

    # 2.2.3    Open Shopping Cart
    Open Cart
    
    # 2.2.4    Validates that cart is empty. When cart is empty the class "cart_quantity" isnt present. If there is an item in the cart, the element exists.
    Validate if Cart is empty

    # 2.2.5    Select "All items in burger menu"
    ## Select All Items in burguer menu

    ### Opens burger menu
    Click burguer button

    ### Clicks All Items button
    Wait Until Element Is Visible    xpath=//*[@id="menu_button_container"]/div/div[2]/div[1]/nav/a[1]    5
    Click Element   xpath=//*[@id="menu_button_container"]/div/div[2]/div[1]/nav/a[1]

    # 2.2.6    Add "Sauce Labs Onesie" to cart
    Click Button    id=add-to-cart-sauce-labs-onesie
    ## Save price of "Sauce Labs Onesie"
    ${SauceLabsOnesiePrice}=    Get Text    xpath=//*[@id="inventory_container"]/div/div[5]/div[2]/div[2]/div
    
    # 2.2.7    Change sort order to “Price (high to low)
    Set price high to low
    
    # 2.2.8    Add "Sauce Labs Bike Light" to cart
    Click Button    id=add-to-cart-sauce-labs-bike-light
    ## Save price of "Sauce Labs Bike Light"
    ${SauceLabsBikeLightPrice}=    Get Text    xpath=//*[@id="inventory_container"]/div/div[5]/div[2]/div[2]/div

    # 2.2.9    Change sort order to “Price (low to high)
    Set price low to high

    # 2.2.10    Add "Sauce Labs Backpack" to cart
    Click Button    id=add-to-cart-sauce-labs-backpack
    ## Save price of "Sauce Labs Bike Light"
    ${SauceLabsBackpackPrice}=    Get Text    xpath=//*[@id="inventory_container"]/div/div[5]/div[2]/div[2]/div

    # 2.2.11    Open shopping cart
    Open Cart
    Capture Page Screenshot    cart-with-all-items-added.png
    # 2.2.12    Verify added items, quantities and prices in cart
    
    # Verify if 1 Sauce Labs Onesie is added with the price tag of ${SauceLabsOnesie}

    ## Verify item Name (Sauce Labs Onesie)
    Verify Cart Item Name    //*[@id="item_2_title_link"]/div     Sauce Labs Onesie
    ## Verify quantity (1)
    Verify Cart Item Quantity    //*[@id="cart_contents_container"]/div/div[1]/div[3]/div[1]    1
    ## Verify price ($7.99)
    Verify Cart Item Price    //*[@id="cart_contents_container"]/div/div[1]/div[3]/div[2]/div[2]/div    ${SauceLabsOnesiePrice}

    # Verify if 1 Sauce Labs Bike Light is added with the price tag of ${SauceLabsBikeLightPrice}

    ## Verify item Name (Sauce Labs Bike Light)
    Verify Cart Item Name    //*[@id="item_0_title_link"]/div     Sauce Labs Bike Light
    ## Verify quantity (1)
    Verify Cart Item Quantity    //*[@id="cart_contents_container"]/div/div[1]/div[4]/div[1]    1
    ## Verify price ($9.99)
    Verify Cart Item Price    //*[@id="cart_contents_container"]/div/div[1]/div[4]/div[2]/div[2]/div    ${SauceLabsBikeLightPrice}
    
    # Verify if 1 Sauce Labs Bike Light is added with the price tag of ${SauceLabsBackpack}
    ## Verify item Name (Sauce Labs Backpack)
    Verify Cart Item Name    //*[@id="item_4_title_link"]/div     Sauce Labs Backpack
    ## Verify quantity (1)
    Verify Cart Item Quantity    //*[@id="cart_contents_container"]/div/div[1]/div[5]/div[1]    1
     ## Verify price ($29.99)
    Verify Cart Item Price    //*[@id="cart_contents_container"]/div/div[1]/div[5]/div[2]/div[2]/div   ${SauceLabsBackpackPrice}

    # 2.2.13    Remove "Sauce Labs Onesie" from cart
    Click Button    id=remove-sauce-labs-onesie
    Capture Page Screenshot    cart-with-oneesie-removed.png

    # 2.2.14    Go to checkout
    Go to checkout

    # 2.2.15    Fill checkout information 
    Fill checkout information    Jose    Cavaleiro    3000-009

    # 2.2.16    Click continue button
    Click continue button
    
    # 2.2.17    Verify items, quantities and prices in checkout overview
    Capture Page Screenshot    checkout-overview.png
    # Verify Sauce Labs Bike

    ## Verify item Name (Sauce Labs Bike Light)
    Verify Cart Item Name    //*[@id="item_0_title_link"]/div     Sauce Labs Bike Light
    ## Verify quantity (1)
    Verify Cart Item Quantity    //*[@id="checkout_summary_container"]/div/div[1]/div[3]/div[1]    1
    ## Verify price ($9.99)
    Verify Cart Item Price    //*[@id="checkout_summary_container"]/div/div[1]/div[3]/div[2]/div[2]/div    ${SauceLabsBikeLightPrice}

    # Verify Sauce Labs Backpack
     ## Verify item Name (Sauce Labs Backpack)
    Verify Cart Item Name    //*[@id="item_4_title_link"]/div     Sauce Labs Backpack
    ## Verify quantity (1)
    Verify Cart Item Quantity    //*[@id="checkout_summary_container"]/div/div[1]/div[4]/div[1]    1
     ## Verify price ($29.99)
    Verify Cart Item Price    //*[@id="checkout_summary_container"]/div/div[1]/div[4]/div[2]/div[2]/div  ${SauceLabsBackpackPrice}

    ${BikeLightPrice}=    Remove String        ${SauceLabsBikeLightPrice}   ,    $
    ${BackpackPrice}=    Remove String        ${SauceLabsBackpackPrice}   ,    $
    
    #Sums up items values and adds tax value of 3.20
    Calculates Final Price with Tax    ${BikeLightPrice}    ${BackpackPrice}    3.20    43.18

    # 2.2.18    Click Finish Button
    Click Finish Button

    # 2.2.19    Verify successful order completion
    Verify successful order completion
      
    # 2.2.20     Click back home button
    Click back home button

    # 2.2.21    Logout
    Click burguer button
    Logout


    
    
    




