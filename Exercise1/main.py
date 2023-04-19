from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time


def function():

    browser = webdriver.Chrome()

    browser.get('https://google.com')
    time.sleep(5)
    
    print(browser.title)

function()



