*** Settings ***
Documentation       Exercise 1. Dorne House
Library    SeleniumLibrary
Library    RequestsLibrary
Library    String
Library    Collections
Library    RPA.JSON


*** Variables ***
# API link to get Dorne's House information
${API_LINK}    https://www.anapioficeandfire.com/api/   
# Browser used to perform API Test
${BROWSER}    Chrome                                                        
# Get Request Info for DorneHouse
${DorneHousesRequest}    houses?region=Dorne    




*** Test Cases ***
Get Listing of Dorne's Houses and Compare
    
    # List with Houses name expected to be in the same list returned by get request
    ${ExpectedList}    Create List    House Allyrion of Godsgrace    House Blackmont of Blackmont    House Briar    House Brook    House Brownhill    House Dalt of Lemonwood    House Dayne of High Hermitage    House Dayne of Starfall    House Drinkwater    House Dryland

    ${response} =    Get    ${API_LINK}${DorneHousesRequest}       
    
    # Validation of status code
    Status Should Be    200    ${response}         
    
    # Variable response.json() is a list of dictionaries 
    Log    ${response.json()}[0][name]
    
    # Creates list for Houses of Dorne
    ${ListOfHouses}    Create List
    # Gets Length of response.json()
    ${Length}=    Get Length    ${response.json()}    
    
    # Iterate over the list of dictionarys and add each House Name to a particular list
    FOR    ${index}    IN RANGE      ${Length}
        #adds each House name to a List
        Append To List    ${ListOfHouses}    ${response.json()}[${index}][name] 
        #prints house
        Log    ${response.json()}[${index}][name]  
    END
    
    # Prints List of Houses
    Log List    ${ListOfHouses}

    # Compare API retrieved list with expected list
    Lists Should Be Equal    ${ListOfHouses}    ${ExpectedList}

    
  
