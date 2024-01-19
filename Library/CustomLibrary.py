from robot.libraries.BuiltIn import BuiltIn
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver import ActionChains
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
import xlrd
import calendar
import time
from PIL import Image,ImageChops
import re
import configparser
import os
import random
import string
import names
from appdirs import user_data_dir

class CustomLibrary(object):

        def __init__(self):
                pass

        @property
        def _sel_lib(self):
            return BuiltIn().get_library_instance('SeleniumLibrary')

        @property
        def _driver(self):
            return self._sel_lib.driver
        
        def open_chrome_browser(self,url):
            """Return the True if Chrome browser opened """
            selenium = BuiltIn().get_library_instance('SeleniumLibrary')
            try:
                options = webdriver.ChromeOptions()
                options.add_argument("disable-extensions")
                options.add_experimental_option("excludeSwitches",["enable-automation","load-extension"])
                selenium.create_webdriver('Chrome',chrome_options=options)
                selenium.go_to(url)
                return True
            except:
                return False

        def javascript_click_by_xpath(self,xpath):
            element = self._driver.find_element("xpath", xpath) 
            self._driver.execute_script("arguments[0].click();", element)    

        def wait_until_time(self,arg):
                time.sleep(int(arg))

        
        def get_ms_excel_row_values_into_dictionary_based_on_key(self,filepath,keyName,sheetName=None):
            """Returns the dictionary of values given row in the MS Excel file """
            workbook = xlrd.open_workbook(filepath)
            snames=workbook.sheet_names()
            dictVar={}
            if sheetName==None:
                sheetName=snames[0]      
            if self.validate_the_sheet_in_ms_excel_file(filepath,sheetName)==False:
                return dictVar
            worksheet=workbook.sheet_by_name(sheetName)
            noofrows=worksheet.nrows
            dictVar={}
            headersList=worksheet.row_values(int(0))
            for rowNo in range(1,int(noofrows)):
                rowValues=worksheet.row_values(int(rowNo))
                if str(rowValues[0])!=str(keyName):
                    continue
                for rowIndex in range(0,len(rowValues)):
                    cell_data=rowValues[rowIndex]
                    if(str(cell_data)=="" or str(cell_data)==None):
                        continue                    
                    cell_data=self.get_unique_test_data(cell_data)
                    cell_data = self.get_random_name_test_data(cell_data)
                    cell_data=self.get_random_number_test_data(cell_data)
                    col_name = str(headersList[rowIndex])
                    cell_data = self.get_testdata_increment_value(col_name,cell_data)
                    dictVar[col_name]=str(cell_data)
            return dictVar

        def get_all_ms_excel_row_values_into_dictionary(self,filepath,sheetName=None):
            """Returns the dictionary of values all row in the MS Excel file """
            workbook = xlrd.open_workbook(filepath)
            snames=workbook.sheet_names()
            all_row_dict={}
            if sheetName==None:
                sheetName=snames[0]      
            if self.validate_the_sheet_in_ms_excel_file(filepath,sheetName)==False:
                return all_row_dict
            worksheet=workbook.sheet_by_name(sheetName)
            noofrows=worksheet.nrows
            headersList=worksheet.row_values(int(0))
            for rowNo in range(1,int(noofrows)):
                each_row_dict={}
                rowValues=worksheet.row_values(int(rowNo))
                for rowIndex in range(0,len(rowValues)):
                    cell_data=rowValues[rowIndex]
                    if(str(cell_data)=="" or str(cell_data)==None):
                        continue
                    cell_data=self.get_unique_test_data(cell_data)
                    each_row_dict[str(headersList[rowIndex])]=str(cell_data)
                all_row_dict[str(rowValues[0])]=each_row_dict
            return all_row_dict

        def get_all_ms_excel_matching_row_values_into_dictionary_based_on_key(self,filepath,keyName,sheetName=None):
            """Returns the dictionary of matching row values from the MS Excel file based on key"""
            workbook = xlrd.open_workbook(filepath)
            snames=workbook.sheet_names()
            all_row_dict={}
            if sheetName==None:
                sheetName=snames[0]      
            if self.validate_the_sheet_in_ms_excel_file(filepath,sheetName)==False:
                return all_row_dict
            worksheet=workbook.sheet_by_name(sheetName)
            noofrows=worksheet.nrows
            headersList=worksheet.row_values(int(0))
            indexValue=1
            for rowNo in range(1, int(noofrows)):
                rowValues=worksheet.row_values(int(rowNo))
                if str(rowValues[0])!=str(keyName):
                    continue
                each_row_dict={}
                for rowIndex in range(0,len(rowValues)):
                    cell_data=rowValues[rowIndex]
                    if(str(cell_data)=="" or str(cell_data)==None):
                        continue
                    cell_data=self.get_unique_test_data(cell_data)
                    
                    each_row_dict[str(headersList[rowIndex])]=str(cell_data)
                all_row_dict[str(indexValue)]=each_row_dict
                indexValue+=1
            return all_row_dict

        def get_unique_test_data(self,testdata):
            """Returns the unique if data contains unique word """
            ts = calendar.timegm(time.gmtime())
            unique_string=str(ts)
            testdata=testdata.replace("UNIQUE",unique_string)
            testdata=testdata.replace("Unique",unique_string)
            testdata=testdata.replace("unique",unique_string)
            return testdata

        def validate_the_sheet_in_ms_excel_file(self,filepath,sheetName):
            """Returns the True if the specified work sheets exist in the specifed MS Excel file else False"""
            workbook = xlrd.open_workbook(filepath)
            snames=workbook.sheet_names()
            sStatus=False        
            if sheetName==None:
                return True
            else:
                for sname in snames:
                    if sname.lower()==sheetName.lower():
                        sStatus=True
                        break
                if sStatus==False:
                    print ("Error: The specified sheet: "+str(sheetName)+" doesn't exist in the specified file: " +str(filepath))
            return sStatus

        
        def compare_images(self,expected_file_path,actual_image_path,):
            actual_image = Image.open(actual_image_path)
            expected_image = Image.open(expected_file_path)
            diff = ImageChops.difference(expected_image, actual_image)
            print(diff)
            if list(actual_image.getdata()) == list(expected_image.getdata()):
                    print ("Identical")
                    return False
            else:
                print ("Different")
                return True

        def wait_until_element_clickable(self,locator):
                """ An Expectation for checking that an element is either invisible or not present on the DOM."""
                if locator.startswith("//") or locator.startswith("(//"):
                        WebDriverWait(self._driver, 60).until(EC.element_to_be_clickable((By.XPATH, locator)))
                else:
                        WebDriverWait(self._driver, 60).until(EC.element_to_be_clickable((By.ID, locator)))
                        
        def wait_till_element_is_displayed(self,locator, time_out = 5):
            """ An Expectation for checking that an element is visible in the DOM and return true else false """
            try:
                if locator.startswith("//") or locator.startswith("(//"):
                    WebDriverWait(self._driver, time_out).until(EC.visibility_of_element_located((By.XPATH, locator)))
                else:
                    WebDriverWait(self._driver, time_out).until(EC.visibility_of_element_located((By.ID, locator)))
                return True
            except Exception as e:
                print(e)
                return False
                    
                          
        def scroll_to_element(self, locator):
            """scroll to element using javascript"""
            element = self._driver.find_element("xpath", locator)
            self._driver.execute_script("arguments[0].scrollIntoView(false);", element)
            
        def drag_and_drop_by_xpath(self, locator, target):
            """drag and drop using javascript"""
            try:
                element1 = self._driver.find_element("xpath", locator)
                target1 = self._driver.find_element("xpath", target)
                #xto = target.location['x']
                #yto = target.location['y']
                self._driver.execute_script("function createEvent(typeOfEvent) {\n" +"var event =document.createEvent(\"CustomEvent\");\n" +"event.initCustomEvent(typeOfEvent,true, true, null);\n" +"event.dataTransfer = {\n" +"data: {},\n" +"setData: function (key, value) {\n" +"this.data[key] = value;\n" +"},\n" +"getData: function (key) {\n" +"return this.data[key];\n" +"}\n" +"};\n" +"return event;\n" +"}\n" +"\n" +"function dispatchEvent(element, event,transferData) {\n" +"if (transferData !== undefined) {\n" +"event.dataTransfer = transferData;\n" +"}\n" +"if (element.dispatchEvent) {\n" + "element.dispatchEvent(event);\n" +"} else if (element.fireEvent) {\n" +"element.fireEvent(\"on\" + event.type, event);\n" +"}\n" +"}\n" +"\n" +"function simulateHTML5DragAndDrop(element, destination) {\n" +"var dragStartEvent =createEvent('dragstart');\n" +"dispatchEvent(element, dragStartEvent);\n" +"var dropEvent = createEvent('drop');\n" +"dispatchEvent(destination, dropEvent,dragStartEvent.dataTransfer);\n" +"var dragEndEvent = createEvent('dragend');\n" +"dispatchEvent(element, dragEndEvent,dropEvent.dataTransfer);\n" +"}\n" +"\n" +"var source = arguments[0];\n" +"var destination = arguments[1];\n" +"simulateHTML5DragAndDrop(source,destination);",element1, target1);
                #self._driver.execute_script("function simulate(f,c,d,e){var b,a=null;for(b in eventMatchers)if(eventMatchers[b].test(c)){a=b;break}if(!a)return!1;document.createEvent?(b=document.createEvent(a),a==\"HTMLEvents\"?b.initEvent(c,!0,!0):b.initMouseEvent(c,!0,!0,document.defaultView,0,d,e,d,e,!1,!1,!1,!1,0,null),f.dispatchEvent(b)):(a=document.createEventObject(),a.detail=0,a.screenX=d,a.screenY=e,a.clientX=d,a.clientY=e,a.ctrlKey=!1,a.altKey=!1,a.shiftKey=!1,a.metaKey=!1,a.button=1,f.fireEvent(\"on\"+c,a));return!0} var eventMatchers={HTMLEvents:/^(?:load|unload|abort|error|select|change|submit|reset|focus|blur|resize|scroll)$/,MouseEvents:/^(?:click|dblclick|mouse(?:down|up|over|move|out))$/}; simulate(arguments[0],\"mousedown\",0,0); simulate(arguments[0],\"mousemove\",arguments[1],arguments[2]); simulate(arguments[0],\"mouseup\",arguments[1],arguments[2]); ",element,xto,yto)
            except Exception as e:
                print(e)
                
        def drag_and_drop_by_actions(self, locator, target):
            """drag and drop using actions class"""
            try:
                element1 = self._driver.find_element("xpath", locator)
                target1 = self._driver.find_element("xpath", target)
                action = ActionChains(self._driver)
                action.drag_and_drop(element1, target1).perform()
            except Exception as e:
                    print(e)
                    
        def assign_job_to_technician_in_empty_slot(self, job_name, technician_name):
            row_index = self.get_row_index_by_technician_name(technician_name)
            grid_boxes_element_based_on_technician_name = f"//span[text()]/../../../following-sibling::div[1]/div[1]/div[@class='ng-star-inserted'][{row_index}]/div/div/div"
            all_grid_boxes_of_technician = self._driver.find_element("xpath", grid_boxes_element_based_on_technician_name)
            grid_boxes_count = len(all_grid_boxes_of_technician)
            self.scroll_to_element("//span[text()='Unassigned & Jeopardy Jobs']")
            self.wait_until_time(1)
            self._driver.find_element("xpath", "//span[text()='Unassigned & Jeopardy Jobs']").click()
            for grid_box_index in range(1, grid_boxes_count):
                each_grid = grid_boxes_element_based_on_technician_name +"[" + str(grid_box_index) + "]"
                self.scroll_to_element(each_grid)
                self.wait_until_time(1)
                job_locator = f"//span[contains(text(),'{job_name}')]"
                self.scroll_to_element(job_locator)
                self.wait_until_time(1)
                self.drag_and_drop_by_actions(job_locator, each_grid)
                confirm_message_status = self.wait_till_element_is_displayed("//h1[text()='Confirm Schedule']", 2)
                if not confirm_message_status:
                    continue
                else:
                    return True
            return False
        
        def get_row_index_by_technician_name(self, exp_technician_name):
            technician_name_list_locator = f"//div[contains(@class,'dhtechnicianname')]/following-sibling::div"
            all_tech_names = self._driver.find_element("xpath", technician_name_list_locator)
            technician_count = len(all_tech_names)
            for technician_index in range(1, technician_count):
                technician_name_locator = technician_name_list_locator + "[" + str(technician_index) + "]//span[text() and not(@class)]"
                act_technician_name = self._driver.find_element("xpath", technician_name_locator).text
                print(act_technician_name)
                if exp_technician_name.lower() == act_technician_name.lower():
                    return technician_index
                else:
                    continue
            raise ValueError(f'{exp_technician_name} is not in the technician name list')  

        def wait_for_notification(self):
            for counter in range(0, 30):
                notifications = self._driver.find_element_by_css_selector("div.ui-growl-message")
                notifications_count = len(notifications)
                print(notifications_count)
                if notifications_count > 0:
                    return
                else:
                    self.wait_until_time(1)
                    continue
            raise Exception("no success notifications were found")

        def increment_value(self,value):
            incremented_value = re.sub(r'[0-9]+$',lambda x: f"{str(int(x.group())+1).zfill(len(x.group()))}",value)
            return incremented_value
        def get_testdata_increment_value(self,key,testdata):
                if(testdata == 'incrementvalue'):
                    value = self.get_incremented_value(key)


                    return value
                else:
                        return testdata
        def get_incremented_value(self,key):
            existing_value = self.get_value_from_file(key)

            print(existing_value)
            new_incremented_value = self.increment_value(str(existing_value))
            self.write_value_to_file(key,new_incremented_value)
            return new_incremented_value
        def _read_ini_file(self):
            config = configparser.ConfigParser()
            workingdirectory = os.getcwd()
            config.read(workingdirectory+'\\increment_data_file.ini')
            return config

        def get_value_from_file(self,key):
            config = self._read_ini_file()
            return config.get('data', key)

        def write_value_to_file(self,key,value):
            config = self._read_ini_file()
            config.set('data',key,value)
            with open(os.getcwd()+'\\increment_data_file.ini', 'w') as configfile:
                config.write(configfile)

        def create_config_file(self,map):
            """ Creates a new .ini file and it will add the details into the file according to the dictionary details """
            config = configparser.ConfigParser()
            config['loadtest'] = {}
            loadtest = config['loadtest']
            for key in map.keys():
                if key != "TCName":
                   loadtest[key] = map[key]
                   with open("loadtest.ini", 'w') as configfile:
                        config.write(configfile)
                        
        def get_random_number_test_data(self,testdata):
                num =''.join(random.choices(string.digits, k=9))
                randomNumber=str(num)
                testdata=testdata.replace("RANDOM",randomNumber)
                testdata=testdata.replace("Random",randomNumber)
                testdata=testdata.replace("random",randomNumber)
                return testdata

        def get_random_name_test_data(self,testdata):
                #randomText = names.get_full_name()
                randomText = names.get_first_name()
                testdata=testdata.replace("RANDOMNAME",randomText)
                testdata=testdata.replace("RandomName",randomText)
                testdata=testdata.replace("randomname",randomText)
                return testdata
        
        def get_driver_path_with_browser(self,browsername):
                if browsername.lower() == 'chrome':
                   driver_path=ChromeDriverManager().install()
                if browsername.lower() == 'headlesschrome':
                   driver_path=ChromeDriverManager().install()     
                if browsername.lower() == 'firefox':   
                   driver_path = GeckoDriverManager().install()
                print(driver_path)
                return driver_path

        def upload_supporting_documents(self, choosebutton, filepath):
                element = self._driver.find_element("xpath", choosebutton)
                self._driver.execute_script("arguments[0].setAttribute('style', 'top: 0px;');",element)
                sleep=2
                element = self._driver.find_element("xpath", choosebutton)
                element.send_keys(filepath)

