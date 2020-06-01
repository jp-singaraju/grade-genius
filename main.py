# imports the defined packages
import threading
import numpy as np
import pandas as pd
import requests
from bs4 import BeautifulSoup
from flask import *
from session_hac import session_hac


# ALL FUNCTIONS HAVE TO RUN IN THE ORDER AS IN BELOW

# defines the flask app
app = Flask(__name__)

# creates a secret key for the app
secret_key = b'\xad7\xe7\x04\xb6^\x9a\x95\xb97k\xdd\x06w\x00\xc7BlX\xc0\x88JBM\x07\x8c\xf8k\xf5\x17\xb5\xf0\xed\x81EU' \
             b'\x01\xbc\x85\xcc '

# update the keys
app.config['SECRET_KEY'] = secret_key
app.config['SESSION_TYPE'] = 'filesystem'
app.config['FLASK_ENV'] = 'production'

# define users and headers
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                         'Chrome/81.0.4044.138 Safari/537.36'}


# defines the app route for login
@app.route('/login', methods=['GET', 'POST'])
# function in order to get login
def login():
    try:
        # log-in site at hac website and set dictionary values
        base_site = "https://hac.friscoisd.org/HomeAccess/Account/LogOn?ReturnUrl=%2fhomeaccess%2f"
        user_name = str(request.args['username'])
        session['username'] = user_name
        pass_word = str(request.args['password'])

        # define session variables
        session['server_status'] = False
        session['nosvr'] = False

        # sets session variables to default
        session['check'] = 'unused'
        session['expo'] = 'unused'

        # define a function for the 17 sec time
        @copy_current_request_context
        def time_exceed(bool):
            # if False or server error
            if not bool:
                session['nosvr'] = True
                timer.cancel()
            else:
                timer.cancel()

        # sets a dictionary and assigns login success variable
        login_data = {
            "Database": 10,
            "VerificationOption": "UsernamePassword",
            "LogOnDetails.UserName": user_name,
            "LogOnDetails.Password": pass_word
        }

        # set the timer for 17 seconds, so it will execute a code if nothing is returned in 17 sec
        timer = threading.Timer(17, time_exceed, [session['server_status']])
        timer.start()
        session_hac = requests.Session()

        # posts info to login and then goes to the logged in page
        login_status = session_hac.post(base_site, data=login_data, headers=headers)
        hacSecurePin = session_hac.cookies.get_dict()
        session['hac cookies'] = hacSecurePin

        # defines soup object
        r_text = login_status.content
        soup_main = BeautifulSoup(r_text, "lxml")
        error = soup_main.find("div", {"class": "validation-summary-errors"})

        # checks if the username/password is wrong
        if error is not None:
            timer.cancel()
            return_login = {"status": "error", "msg": "incorrect username and/or password"}
            return jsonify(return_login)

        # get the .aspx page
        class_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx"
        class_page = session_hac.get(class_site, cookies=session.get('hac cookies'), headers=headers)

        # get class.content from the response
        r_class = class_page.content

        # sets the session to true
        session['server_status'] = True

        #Added by Krishna

        # if nosvr is False
        if not session['nosvr']:
            return redirect(url_for("info"))
         # return jsonify({"redirect": "info"})

        else:
            return jsonify({"status": "error", "msg": "fisd server down"})
    except (AttributeError, KeyError, TypeError, ValueError):
        return jsonify({"status": "error", "msg": "fisd server down"})


# defines the app route for info
@app.route('/info')
# function in order to get info
def info():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    print(session.get('hac cookies'))
    try:
        # creates a soup object
        info_text = "https://hac.friscoisd.org/HomeAccess/Content/Student/MyProfile.aspx"
        r_info = session_hac.get(info_text, cookies=session.get('hac cookies'), headers=headers)
        r_text = r_info.content
        soup_info = BeautifulSoup(r_text, "lxml")

        # proceeds with the right login and sets name of student
        div_main = soup_info.find("div", {"class": "sg-profile-header sg-content-grid-container sg-container-content"})
        span = div_main.find("span", id="plnMain_lblName").text.split()
        span = span[0] + " " + span[len(span) - 1]
        name_student = span
        session['student name'] = name_student

        # gets the info from the specified site and sets grade of student
        reg_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx"
        reg_info = session_hac.get(reg_site, cookies=session.get('hac cookies'), headers=headers)
        reg_text = reg_info.content
        soup_reg = BeautifulSoup(reg_text, "lxml")
        grade_student = soup_reg.find("span", id="plnMain_lblGrade").text
        session['student grade'] = grade_student

        # finds and prints and text value of the <span> tabs for school and grade
        school_student = soup_reg.find("span", id="plnMain_lblBuildingName").text

        # creates a soup object
        class_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Classes.aspx"
        r_class = session_hac.get(class_site, cookies=session.get('hac cookies'), headers=headers)
        r_class = r_class.content
        soup_id = BeautifulSoup(r_class, "lxml")

        # gets the text value of span tag
        student_id = soup_id.find("span", id="plnMain_lblStudentIDValue").text
        # sets the user info to a dictionary and then returns it
        info_dict = {'Name': name_student, 'Home Campus': school_student, 'Grade': grade_student, 'ID': student_id}
        return jsonify(info_dict)
    except (AttributeError, KeyError, TypeError) as e:
        if x == y:
            print(e)
            session['check'] = 'used'
            return redirect(url_for("info"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for report run
@app.route('/run', methods=['GET'])
# function in order to get run
def report_run():
    # report run dict
    report_dict = {'report run': str(request.args['number'])}

    # gets report run from users input
    run_input = report_dict['report run']

    # report card-run data and input
    # can't run all report card
    report_run_main = run_input
    session['report run'] = report_run_main

    # return the redirected url
    return redirect(url_for("averages"))


# defines the app route for averages
@app.route('/averages')
# function in order to get averages
def averages():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        # checks if report run is in session, when opening app
        # defines the link
        grade_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx"

        # if report is not there, then do this, if it is new
        if 'report run' not in session:
            # creates a soup object with specified info
            classes = session_hac.get(grade_site, cookies=session['hac cookies'], headers=headers)
            classes_text = classes.content
            soup = BeautifulSoup(classes_text, "lxml")

            # finds all <a> tabs in the class specified
            a = soup.find_all("a", {"class": "sg-header-heading"})

            # find the <span> tab with run number and get current run number
            select = soup.find("select", id="plnMain_ddlReportCardRuns")
            select_run = select.find('option', selected="selected").text
            session['report run'] = select_run

            # get and set class names
            class_name = []
            for i in range(len(a)):
                class_name.append(" ".join((a[i].text.rstrip().split())[3:]))

            # find <span> tab in specified class
            score = soup.find_all("span", {"class": "sg-header-heading sg-right"})
            class_score = []
            class_avg = []

            # create a list by extracting text from each <span> tab
            for i in range(len(score)):
                class_score.append(score[i].text)

            # create a average grades list by splitting and taking the second substring if class score not blank
            for i in range(len(class_score)):
                if class_score[i] == "":
                    class_avg.append("")
                else:
                    class_avg.append(class_score[i].split(" ")[2])

            # creates a dict with list class_name and class_avg and return the json file in flask
            dict_class = {'Class Name': class_name, 'Class Average': class_avg}
            session['class names'] = class_name
            session['class averages'] = class_avg
            return jsonify(dict_class)

        # else, if report run is already there then get it
        else:
            # get the report run
            report_run = session.get('report run')

            # sets the dictionary for the form
            payload = {
                "__EVENTTARGET": "ctl00$plnMain$btnRefreshView",
                "__VIEWSTATE": "e69pCkQ6DDWYmckQvmZnCqnTB+JjussjBFdovwrP05kwZMeDfEf0rPfS0Yar2"
                               "+Fb21UnPAscpf5MsGZqUylxwFWZr8p+uuKGEwUmYRI2Q64mgzEuD5/vnu8pfOSl"
                               "+GMF4RkpkUAQzS2guNSeD3HDk69BfiY"
                               "+KmeEu9gf6a9eCy4TMEtpwHW8is21rgB7yZBuFvVzOxWgH1v7wSf1MHH3U01qeDQiondHF/TctIGAnVcJFwP"
                               "+uTUtC/LZUfI269H1RHrx4l0AOBVa6AgQdb8CYC1DelOsApEDpga8uTX0gGpEqfsUyLVzEC4"
                               "/cud7gMBVQ3Uc000aMHqS3V1yg7al20rkL"
                               "+rUyDJpszeJ5Sts26TOPeJDubniO6Ykkmbx0jIJbH1iR777JRwnMj4Xt0XgQ5/MCnIoAQToQqoc"
                               "/0CUjOset7jIEzURKkpYA59AJHr4Y/ZBHBGTf4W4n93mSS+YP5Vo7VD1B1dVEIbgEVz9G8MEh"
                               "+eVkCDxwdPK5JzggmbzvxY7D1cfgTyKmGBVBiVNzmgOVjrYF4a0NDubfs+9xloZwa+nakwWy"
                               "+aDOaTTdPO71bz/oZp4OOrAsI4ODj/NfltgwZLma1PyR0K32ap+uirb8jORcRnXX+7XrOEF7"
                               "/0L5nPL6CfUnwFQFW3Fk8x4HIWBaempULPYG9qCQrXepsm5xg7sRbXesB8bcI6VWDlbMcXqEDFyksuhxvQCfpvF1FRIjWEDCPOg5DfZQkNsCg5ZKT8z0VEjuBeCafg/gaIxtgrcmjPx6+HeW103A3gBjXPK+I3G7pJIE6qnf2YOq26E0wLVXD4Ic3Z/tOZ/ZBCGbAE0NsvbfH8aHgs19lQ0qJ5uy513iLseed1rZYEByxdqiJkbj8WCRZEIFh92FiUvUexuc1PcDySQ61V+gGU58CAffPTwulV3RshoiYF7sC3NRpycV1GWdJg0bQhKHzDowWe/J84oc0cWnsfDEkcWor4hkK6rvHM/qOEMInigoeoiR3+bAUFPwqTuEN6NtGR5Emzz1pbkDN3c99DYjFMR9QtbdCrKsjH9QOWD2SBxsZH3yjlM05FCsm0XohpNtGmJp+OdwC2CeiPMNXZOi2ozPqjhHwj3eWJAwwtyyuHHhboXvbOFmgjuaC4L+kAkJNLnLcrtdPu6+fQKtYTlUW2IF462vvLu+QeJk9KCvbjiXwmeDwKKFZdBGGOSWGckzcnqjGO6Q48m4qkaNGDtaHS8DMY+AV6DgRDVIzaQDIN52OkIafozR/5HANXZxJOWXaLwDfPQKk3/irwMdAQQvw1MIX4afmcdhl7/V6d9ozh0PU9ZbM91FmB7amLBUUDaHBpjdinTe+yDbtHCwQtQrg8r5u/qkRexoRFjgn4cnNzjs2QKY2GZY85pTO7cLkHE3Y3CNidHIHsq7+nchNNHu6/h//QggyjiSyEYaTRCELKHQf9kbXYp4l9aj6w5YvHu4cUVtCGb06So9WNJySV5M7ulm/U2/KOJb+wbvBRE1T2nhH8ibENK6caF+5kaq9Oshnwr4QpGt0WTf85ZbmJpL0/rBb+NQsSTuCXj7q8y635Ba+hTR66ovJa45q9CMoK5Lo0L3/ZnM8qdvECzmxy59U+hiki3aoq3zXhGyMdH85xzamj4tTIcQUcIOq6XOA69crIeFoc0kHnRbQ1oLyUtuqelS/a/Ch8WE5psGR1DDMsjna64vKWS7JEkm33tJ8Kdy+lRqA24Z8i7DnT1OvOnfOiQGZPl67RpxZfmdc4pzvP/le3TAOqpgagaRBxOtyZcIKZY6uLN6pDFJimrMXcfeOM9inzVbCGKmqZN2PQazrN9ZjQ=",
                "__VIEWSTATEGENERATOR": "B0093F3C",
                "__EVENTVALIDATION": "bELah0Vt48qlV7YUIDZbmPQIQhg66EDLI4Zkw79rKB6Kf"
                                     "/iK7EzHNwWYUFSwnSY4k2trIkNKWuRkNo3UtWd7C6Z9"
                                     "/U9KNZviyLtV4cHtyoZtGJNtATfSXw0y3cdFJMmoKzmWFhsMvYkrPE9k786yK4QgLHOoMZhRKGQHNPiLS4iehScdP3vTe9138mFtDv84Z7Ppy46Kl48g47Nc7oZksB6OJ4RlQEQCbkA23e0RyRoklXhPfDBIBLzsefW3n+pMl4vEiHT43stnPfzfZ9Maxf7lQlu+rkexqOFJksrL1VR5l7G2Kp5Dv8sAKJuEHTWoisXI3uv6CTnweH7UCMz2bUv/qyMiATAElJCMxXZrGDPv5yDkijxjRhrsm6Fvu7VNxBCaIVr2KT4l6NQmzQI5LUOGJ1R1+3hsTL7WuAryzD01A+VEv+4P1rIosX8c8G5L5/i88gKm2JKct2tAC0NbzYSAbcaOKyJZ7ehWQRk9GlLwGTIGhB6YgLuP+BAIbS+KxhG+H68syqseLpdSZ9mXD2/tuBSHN6Ijlno3+fpoKZMXDFgr5kgzmpA6eTYmClBRwULTlQgdJ+cSV8GaiwDZCfxD6BYgTicFitSW93Yj37JpCO/KY2zyPGrBc+Mk/vEUn151BhCRmOn8X/sZbm6DFrFj17LwAya2Wt05b7FBW4dx0GkkyQE52ZZIQYSEnaL9yJoeeH4kHZhNT6qNh8YCsEYQzZ4zYfs2iyCJJNXUbBo/gz7Rmcg4D7pXadI6q/XhcMgRMOVf2XliL+ZeFJM/RP0C+YmfwuwC0quej/yaqTJ+SqS3cg8AYoyZFaanEpk8Fn8nSrkoKnZ65jT7bLu/uMgne9gOOK8Us142aNjGXtOGXLw/PIawyb/mfuzNDxvtSNYJL0TEQ19r2xXgh4hyXBN0WoFxhRyWo7D2pNvpEm912TRcXDGHvaPq4EtAr8Vi0X5TUUj8BI7OfNeOeyu2KW/Vj2OL68AhWGNWYAM8nww2zvo0jNRhXFKhIxowB87qFJ+Ung9D+crKR276nmBBaLMfpPkjpTDcLBOC9VeWAHC79oPZ4AE6GgDjXhbI+vXGsCgU5H6IvwWpEjfeaEZLMGKLThy37ycURE8PUCGWWiEeyakViztT5lhAvwdjsd4ia3d1OioIF5Hv8n7ftLNZkt26YivuumzqG/Pm6EFz2u/dbITddni9rrr7M2pjIZ299Z+mUVJzXrWTWyzhKIekBObNAWCmOdkCGOh11XcnoubbogTbtcP5yF6VCCbBIShhB4L+V9D43a+EAvp2WU6NNsX7CcCMu/g6RLIR14cY636au7+XtCC0kLKtj9vRJcIMn6kwqW9tyt7QLp2jY0VSriszwboEGVGSDvyB+Xn3GLR/7Gx8KOBpK6NVQBTmpoAOrKjmd7FWrZzXoASv+lxuDuWBXThWoX+K9Wn0nCOL5as8J5z72P+vHbkIDiZTHVbumkAqJews76rEukB4skvln8hmHJDCqMZRAWgA2aBpFk10g8cV2V/Enom1XaT0deglfJjaX1kwYSsEfHmpsa8mMKubQVobSf36GVI9NOX/CychnQzVqaAkwD9nGO5rLHLrQHKA66IHbo7pasGzxGBYBYBGIDXtUhGmDMUJB1W2pdk=",
                "ctl00$plnMain$ddlReportCardRuns": report_run + "-2020"
            }

            # report card-run posts and gets info from updated run
            r_classes = session_hac.post(grade_site, data=payload, cookies=session['hac cookies'], headers=headers)
            classes_text = r_classes.content
            soup = BeautifulSoup(classes_text, "lxml")

            # finds all <a> tabs in the class specified
            a = soup.find_all("a", {"class": "sg-header-heading"})

            # get and set class names
            class_name = []
            for i in range(len(a)):
                class_name.append(" ".join((a[i].text.rstrip().split())[3:]))

            # find <span> tab in specified class
            score = soup.find_all("span", {"class": "sg-header-heading sg-right"})
            class_score = []
            class_avg = []

            # create a list by extracting text from each <span> tab
            for i in range(len(score)):
                class_score.append(score[i].text)

            # create a average grades list by splitting and taking the second substring if class score not blank
            for i in range(len(class_score)):
                if class_score[i] == "":
                    class_avg.append("")
                else:
                    class_avg.append((class_score[i].split(" "))[2])

            # creates a dict with list class_name and class_avg and return the json file in flask
            dict_class = {'Class Name': class_name, 'Class Average': class_avg}
            session['class names'] = class_name
            session['class averages'] = class_avg
            return jsonify(dict_class)
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("averages"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for assignments
@app.route('/assignments')
# function in order to get assignments
def assignments():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        # grade url site
        grade_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx"

        # creates a soup object with specified info
        classes = session_hac.get(grade_site, cookies=session['hac cookies'], headers=headers)
        classes_text = classes.content
        soup = BeautifulSoup(classes_text, "lxml")

        # create arrays for the specified data
        assignment = []
        category = []
        due_date = []
        score = []
        weight = []
        weighted_score = []
        weighted_total_points = []
        percentage = []
        count_class_list = []

        # find all tables in url for extraction
        tables = soup.find_all("table")

        # find every third <tr> tab
        for i in range(0, len(tables), 3):
            tr = tables[i].find_all("tr", {"class": "sg-asp-table-data-row"})

            # in each <tr> tab find the length and the <td> tabs
            count = 0
            for j in range(len(tr)):
                td = (tr[j]).find_all("td")

                # for each <td> tab, get the text and assign it to the specific list
                # if the string is blank then assign it value of None
                for k in range(len(td)):
                    string = td[k].text
                    if string == '\xa0':
                        string = ''
                    elif string == '':
                        string = ''
                    if k == 0:
                        due_date.append(string)
                    elif k == 2:
                        assignment.append((string.split("\r\n")[1]).strip())
                    elif k == 3:
                        category.append(string)
                    elif k == 4:
                        score.append(string.strip())
                    elif k == 6:
                        weight.append(string)
                    elif k == 7:
                        weighted_score.append(string)
                    elif k == 8:
                        weighted_total_points.append(string)
                    elif k == 9:
                        percentage.append(string)
                count += 1
            count_class_list.append(count)

        # set 0's for the count of assignments if there is no score in class_avg
        # returns the number of total assignments in each class
        class_avg = session.get('class averages')
        for index in range(len(class_avg)):
            if class_avg[index] == "":
                count_class_list.insert(index, 0)
        count_assignments = count_class_list
        session['current'] = count_assignments

        # perform function for number of assignments in each class
        def func_count_sum(len_tot):
            sum_total = 0
            for i in range(len_tot):
                sum_total += count_assignments[i]
            return sum_total

        # declaring the grades for each class
        # class_1
        class_1_assignments = assignment[0:func_count_sum(1)]
        class_1_category = category[0:func_count_sum(1)]
        class_1_due_date = due_date[0:func_count_sum(1)]
        class_1_score = score[0:func_count_sum(1)]
        class_1_weight = weight[0:func_count_sum(1)]
        class_1_weighted_score = weighted_score[0:func_count_sum(1)]
        class_1_weighted_total_points = weighted_total_points[0:func_count_sum(1)]
        class_1_percentage = percentage[0:func_count_sum(1)]
        session['1 assignments'] = class_1_assignments
        session['1 score'] = class_1_score

        # class_2
        class_2_assignments = assignment[func_count_sum(1):func_count_sum(2)]
        class_2_category = category[func_count_sum(1):func_count_sum(2)]
        class_2_due_date = due_date[func_count_sum(1):func_count_sum(2)]
        class_2_score = score[func_count_sum(1):func_count_sum(2)]
        class_2_weight = weight[func_count_sum(1):func_count_sum(2)]
        class_2_weighted_score = weighted_score[func_count_sum(1):func_count_sum(2)]
        class_2_weighted_total_points = weighted_total_points[func_count_sum(1):func_count_sum(2)]
        class_2_percentage = percentage[func_count_sum(1):func_count_sum(2)]
        session['2 assignments'] = class_2_assignments
        session['2 score'] = class_2_score

        # class_3
        class_3_assignments = assignment[func_count_sum(2):func_count_sum(3)]
        class_3_category = category[func_count_sum(2):func_count_sum(3)]
        class_3_due_date = due_date[func_count_sum(2):func_count_sum(3)]
        class_3_score = score[func_count_sum(2):func_count_sum(3)]
        class_3_weight = weight[func_count_sum(2):func_count_sum(3)]
        class_3_weighted_score = weighted_score[func_count_sum(2):func_count_sum(3)]
        class_3_weighted_total_points = weighted_total_points[func_count_sum(2):func_count_sum(3)]
        class_3_percentage = percentage[func_count_sum(2):func_count_sum(3)]
        session['3 assignments'] = class_3_assignments
        session['3 score'] = class_3_score

        # class_4
        class_4_assignments = assignment[func_count_sum(3):func_count_sum(4)]
        class_4_category = category[func_count_sum(3):func_count_sum(4)]
        class_4_due_date = due_date[func_count_sum(3):func_count_sum(4)]
        class_4_score = score[func_count_sum(3):func_count_sum(4)]
        class_4_weight = weight[func_count_sum(3):func_count_sum(4)]
        class_4_weighted_score = weighted_score[func_count_sum(3):func_count_sum(4)]
        class_4_weighted_total_points = weighted_total_points[func_count_sum(3):func_count_sum(4)]
        class_4_percentage = percentage[func_count_sum(3):func_count_sum(4)]
        session['4 assignments'] = class_4_assignments
        session['4 score'] = class_4_score

        # class_5
        class_5_assignments = assignment[func_count_sum(4):func_count_sum(5)]
        class_5_category = category[func_count_sum(4):func_count_sum(5)]
        class_5_due_date = due_date[func_count_sum(4):func_count_sum(5)]
        class_5_score = score[func_count_sum(4):func_count_sum(5)]
        class_5_weight = weight[func_count_sum(4):func_count_sum(5)]
        class_5_weighted_score = weighted_score[func_count_sum(4):func_count_sum(5)]
        class_5_weighted_total_points = weighted_total_points[func_count_sum(4):func_count_sum(5)]
        class_5_percentage = percentage[func_count_sum(4):func_count_sum(5)]
        session['5 assignments'] = class_5_assignments
        session['5 score'] = class_5_score

        # class_6
        class_6_assignments = assignment[func_count_sum(5):func_count_sum(6)]
        class_6_category = category[func_count_sum(5):func_count_sum(6)]
        class_6_due_date = due_date[func_count_sum(5):func_count_sum(6)]
        class_6_score = score[func_count_sum(5):func_count_sum(6)]
        class_6_weight = weight[func_count_sum(5):func_count_sum(6)]
        class_6_weighted_score = weighted_score[func_count_sum(5):func_count_sum(6)]
        class_6_weighted_total_points = weighted_total_points[func_count_sum(5):func_count_sum(6)]
        class_6_percentage = percentage[func_count_sum(5):func_count_sum(6)]
        session['6 assignments'] = class_6_assignments
        session['6 score'] = class_6_score

        # class_7
        class_7_assignments = assignment[func_count_sum(6):func_count_sum(7)]
        class_7_category = category[func_count_sum(6):func_count_sum(7)]
        class_7_due_date = due_date[func_count_sum(6):func_count_sum(7)]
        class_7_score = score[func_count_sum(6):func_count_sum(7)]
        class_7_weight = weight[func_count_sum(6):func_count_sum(7)]
        class_7_weighted_score = weighted_score[func_count_sum(6):func_count_sum(7)]
        class_7_weighted_total_points = weighted_total_points[func_count_sum(6):func_count_sum(7)]
        class_7_percentage = percentage[func_count_sum(6):func_count_sum(7)]
        session['7 assignments'] = class_7_assignments
        session['7 score'] = class_7_score

        # class_8
        class_8_assignments = assignment[func_count_sum(7):len(assignment)]
        class_8_category = category[func_count_sum(7):len(assignment)]
        class_8_due_date = due_date[func_count_sum(7):len(assignment)]
        class_8_score = score[func_count_sum(7):len(assignment)]
        class_8_weight = weight[func_count_sum(7):len(assignment)]
        class_8_weighted_score = weighted_score[func_count_sum(7):len(assignment)]
        class_8_weighted_total_points = weighted_total_points[func_count_sum(7):len(assignment)]
        class_8_percentage = percentage[func_count_sum(7):len(assignment)]
        session['8 assignments'] = class_8_assignments
        session['8 score'] = class_8_score

        # create an overall dictionary for all values
        dict_main_assignments = {"Class 1":
                                     {"Assignments": class_1_assignments,
                                      "Category": class_1_category,
                                      "Due Date": class_1_due_date,
                                      "Score": class_1_score,
                                      "Weight": class_1_weight,
                                      "Weighted Score": class_1_weighted_score,
                                      "Weighted Total Points": class_1_weighted_total_points,
                                      "Percentage": class_1_percentage},
                                 "Class 2":
                                     {"Assignments": class_2_assignments,
                                      "Category": class_2_category,
                                      "Due Date": class_2_due_date,
                                      "Score": class_2_score,
                                      "Weight": class_2_weight,
                                      "Weighted Score": class_2_weighted_score,
                                      "Weighted Total Points": class_2_weighted_total_points,
                                      "Percentage": class_2_percentage},
                                 "Class 3":
                                     {"Assignments": class_3_assignments,
                                      "Category": class_3_category,
                                      "Due Date": class_3_due_date,
                                      "Score": class_3_score,
                                      "Weight": class_3_weight,
                                      "Weighted Score": class_3_weighted_score,
                                      "Weighted Total Points": class_3_weighted_total_points,
                                      "Percentage": class_3_percentage},
                                 "Class 4":
                                     {"Assignments": class_4_assignments,
                                      "Category": class_4_category,
                                      "Due Date": class_4_due_date,
                                      "Score": class_4_score,
                                      "Weight": class_4_weight,
                                      "Weighted Score": class_4_weighted_score,
                                      "Weighted Total Points": class_4_weighted_total_points,
                                      "Percentage": class_4_percentage},
                                 "Class 5":
                                     {"Assignments": class_5_assignments,
                                      "Category": class_5_category,
                                      "Due Date": class_5_due_date,
                                      "Score": class_5_score,
                                      "Weight": class_5_weight,
                                      "Weighted Score": class_5_weighted_score,
                                      "Weighted Total Points": class_5_weighted_total_points,
                                      "Percentage": class_5_percentage},
                                 "Class 6":
                                     {"Assignments": class_6_assignments,
                                      "Category": class_6_category,
                                      "Due Date": class_6_due_date,
                                      "Score": class_6_score,
                                      "Weight": class_6_weight,
                                      "Weighted Score": class_6_weighted_score,
                                      "Weighted Total Points": class_6_weighted_total_points,
                                      "Percentage": class_6_percentage},
                                 "Class 7":
                                     {"Assignments": class_7_assignments,
                                      "Category": class_7_category,
                                      "Due Date": class_7_due_date,
                                      "Score": class_7_score,
                                      "Weight": class_7_weight,
                                      "Weighted Score": class_7_weighted_score,
                                      "Weighted Total Points": class_7_weighted_total_points,
                                      "Percentage": class_7_percentage},
                                 "Class 8":
                                     {"Assignments": class_8_assignments,
                                      "Category": class_8_category,
                                      "Due Date": class_8_due_date,
                                      "Score": class_8_score,
                                      "Weight": class_8_weight,
                                      "Weighted Score": class_8_weighted_score,
                                      "Weighted Total Points": class_8_weighted_total_points,
                                      "Percentage": class_8_percentage},
                                 }

        # return the json object mentioned
        return jsonify(dict_main_assignments)
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("assignments"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for schedule
@app.route('/schedule')
# function in order to get schedule
def schedule():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        # get schedule
        schedule_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/Classes.aspx"
        schedule_get = session_hac.get(schedule_site, cookies=session['hac cookies'], headers=headers)
        schedule_text = schedule_get.content

        # find the num of tables and <td> tags
        soup_schedule = BeautifulSoup(schedule_text, "lxml")
        schedule = soup_schedule.find_all("table")

        # find the <td> tags in the second table
        td = schedule[1].find_all("td")

        # get the values starting from the 9th value and assign lists
        td = td[9:]
        schedule_course = []
        schedule_class = []
        periods = []
        teacher = []
        room = []
        days = []
        marking_period = []
        building = []

        # get the value of each from the <td> tags and append it to the specific list
        for j in range(0, len(td), 9):
            schedule_course.append(td[j].text.strip())
        for j in range(1, len(td), 9):
            schedule_class.append(td[j].text.strip())
        for j in range(2, len(td), 9):
            periods.append(td[j].text.strip())
        for j in range(3, len(td), 9):
            teacher.append((td[j].text.strip()).upper())
        for j in range(4, len(td), 9):
            room.append(td[j].text.strip())
        for j in range(5, len(td), 9):
            days.append(td[j].text.strip())
        for j in range(6, len(td), 9):
            marking_period.append(td[j].text.strip())
        for j in range(7, len(td), 9):
            building.append(td[j].text.strip())

        # create a dictionary for the values and return it
        schedule_dict = {"Course": schedule_course,
                         "Class": schedule_class,
                         "Period": periods,
                         "Teacher": teacher,
                         "Room": room,
                         "Days": days,
                         "Marking Period": marking_period,
                         "Building": building
                         }
        return jsonify(schedule_dict)
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("schedule"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for ipr
@app.route('/ipr')
# function in order to get ipr
def ipr():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        # gets info from specified site and creates another soup object
        ipr_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/InterimProgress.aspx"
        ipr_info = session_hac.get(ipr_site, cookies=session['hac cookies'], headers=headers)
        ipr_text = ipr_info.content
        soup_ipr = BeautifulSoup(ipr_text, "lxml")
        div = soup_ipr.find("div", {"class": "sg-header"})

        # sets the ipr run_date to the <div> tab text value
        ipr_run_date = div.text.strip()

        # find the table and <td> tabs
        table = soup_ipr.find("table", {"class": "sg-asp-table"})
        td = table.find_all("td")

        # find the first <tr> tab and the length of it
        tr = soup_ipr.find("tr", {"class": "sg-asp-table-header-row"})
        num_row1 = len(tr)

        # assign lists
        ipr_course = []
        ipr_class = []
        period = []
        teacher = []
        room = []
        grade = []

        # get the value of each from the <td> tags and append it to the specific list
        # if the first row has 10 values, elementary school, then run specific code
        if num_row1 == 10:
            td = td[8:]
            for j in range(0, len(td), 8):
                ipr_course.append(td[j].text.strip())
            for j in range(1, len(td), 8):
                ipr_class.append(td[j].text.strip())
            for j in range(2, len(td), 8):
                period.append(td[j].text.strip())
            for j in range(3, len(td), 8):
                teacher.append((td[j].text.strip()).upper())
            for j in range(4, len(td), 8):
                room.append(td[j].text.strip())
            for j in range(5, len(td), 8):
                grade.append(td[j].text.strip())

        # else if the first row has 13 values, middle and high school, then run specific code
        elif num_row1 == 13:
            td = td[11:]
            for j in range(0, len(td), 11):
                ipr_course.append(td[j].text.strip())
            for j in range(1, len(td), 11):
                ipr_class.append(td[j].text.strip())
            for j in range(2, len(td), 11):
                period.append(td[j].text.strip())
            for j in range(3, len(td), 11):
                teacher.append((td[j].text.strip()).upper())
            for j in range(4, len(td), 11):
                room.append(td[j].text.strip())
            for j in range(5, len(td), 11):
                grade.append(td[j].text.strip())

        # create a new dictionary for the ipr run
        ipr_run_dict = {"Run": ipr_run_date,
                        "Schedule": {
                            "Course": ipr_course,
                            "Class": ipr_class,
                            "Period": period,
                            "Teacher": teacher,
                            "Room": room,
                            "Grade": grade
                        }
                        }
        return jsonify(ipr_run_dict)
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("ipr"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for rc
@app.route('/reportcard')
# function in order to get rc
def report_card():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        # gets info from specified site and creates another soup object
        rc_site = "https://hac.friscoisd.org/HomeAccess/Content/Student/ReportCards.aspx"
        rc_info = session_hac.get(rc_site, cookies=session['hac cookies'], headers=headers)
        rc_text = rc_info.content
        soup_rc = BeautifulSoup(rc_text, "lxml")

        # created a list named 'df' with all the tables and gets the one with index 0
        df = pd.read_html(str(soup_rc.find_all('table')))
        df = df[0]

        # creates a variable called 'report' and converts it to a dataframe and replaces all 'NaN' with a blank space
        report = pd.DataFrame(df)
        report.replace(np.NaN, '', inplace=True)
        for i in range(1, len(report[3])):
            df[3][i] = df[3][i].upper()
        header = report.iloc[0]
        report = report[1:]
        report_card = report.rename(columns=header)

        # return the report card (table) in dictionary format
        return jsonify(report_card.to_dict())
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("reportcard"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# defines the app route for gpa
@app.route('/gpa')
# function in order to get gpa
def gpa():
    # define variables for try and except
    x = session.get('check')
    y = session.get('expo')
    try:
        grade_student = session.get('student grade')
        # get transcript if grade is 09 - 12
        if grade_student == '09' or grade_student == '10' or grade_student == '11' or grade_student == '12':
            transcript = "https://hac.friscoisd.org/HomeAccess/Content/Student/Transcript.aspx"
            transcript_get = session_hac.get(transcript, cookies=session['hac cookies'], headers=headers)
            transcript_text = transcript_get.content

            # find the table with specified id and then get the text values of the <span> tags with specified ids
            # print the result
            soup_transcript = BeautifulSoup(transcript_text, "lxml")
            table_transcript = soup_transcript.find("table", id="plnMain_rpTranscriptGroup_tblCumGPAInfo")
            weighted_gpa = table_transcript.find("span", id="plnMain_rpTranscriptGroup_lblGPACum1").text
            weighted_gpa += "/6.0000"
            unweighted_gpa = table_transcript.find("span", id="plnMain_rpTranscriptGroup_lblGPACum2").text
            unweighted_gpa += "/4.0000"

            # create a gpa dict and return the dictionary
            gpa_dict = {"Weighted GPA": weighted_gpa, "Unweighted GPA": unweighted_gpa}
            return jsonify(gpa_dict)

        # else print GPA is N/A
        else:
            gpa_dict = {"Weighted GPA": "None", "Unweighted": "None"}
            return jsonify(gpa_dict)
    except (AttributeError, KeyError, TypeError):
        if x == y:
            session['check'] = 'used'
            return redirect(url_for("gpa"))
        else:
            session['check'] = 'unused'
            return jsonify({"status": "error", "msg": "unable to receive info, please retry"})


# runs the python flask apps
if __name__ == '__main__':
    app.run()
