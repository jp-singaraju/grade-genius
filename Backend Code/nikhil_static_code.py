from flask import *

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


# defines the app route for login
@app.route('/login', methods=['GET'])
# function in order to get login
def login():
    return redirect(url_for("grades"))


# defines the app route for grades
@app.route('/grades')
# function in order to get grades
def grades():
    try:
        # create an overall dictionary for all values
        dict_main_assignments = {
            "Averages": {"Class Average": ["", "100.00%", "98.57%", "", "", "99.17%", "98.33%", "98.33%"],
                         "Class Name": ["Art", "Language Arts (English grammar/composition and spelling)",
                                        "Mathematics", "Music", "PE", "Reading", "Science", "Social Studies"]},
            "Grades": {"Class 1": {"Assignments": [], "Category": [], "Due Date": [], "Percentage": [], "Score": [],
                                   "Weight": [], "Weighted Score": [], "Weighted Total Points": []}, "Class 2": {
                "Assignments": ["Final Memoir", "Memoir Draft", "Internal vs. External", "Narrative Draft",
                                "Memoir Brainstorm", "Memoir Journal"],
                "Category": ["Elementary Grades", "Elementary Grades", "Elementary Grades", "Elementary Grades",
                             "Elementary Grades", "Elementary Grades"],
                "Due Date": ["05/08/2020", "05/01/2020", "04/24/2020", "04/17/2020", "04/09/2020", "03/30/2020"],
                "Percentage": ["100.000%", "100.000%", "100.000%", "100.000%", "100.000%", "100.000%"],
                "Score": ["100.0", "100.0", "100.0", "100.0", "100.0", "100.0"],
                "Weight": ["1.00", "1.00", "1.00", "1.00", "1.00", "1.00"],
                "Weighted Score": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00"],
                "Weighted Total Points": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00"]}, "Class 3": {
                "Assignments": ["eLearning Participation", "Number Patterns Assessment", "Coordinate Plane Quiz",
                                "Classify 2d Figures Quiz", "Conversions Quiz", "Volume Assessment",
                                "Perimeter/Area Quiz"],
                "Category": ["Elementary Grades", "Elementary Grades", "Elementary Grades", "Elementary Grades",
                             "Elementary Grades", "Elementary Grades", "Elementary Grades"],
                "Due Date": ["05/15/2020", "05/08/2020", "04/24/2020", "04/17/2020", "04/09/2020", "04/03/2020",
                             "03/27/2020"],
                "Percentage": ["100.000%", "90.000%", "100.000%", "100.000%", "100.000%", "100.000%", "100.000%"],
                "Score": ["100.0", "90.00", "100.0", "100.0", "100.0", "100.0", "100.0"],
                "Weight": ["1.00", "1.00", "1.00", "1.00", "1.00", "1.00", "1.00"],
                "Weighted Score": ["100.00", "90.00", "100.00", "100.00", "100.00", "100.00", "100.00"],
                "Weighted Total Points": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00", "100.00"]},
                       "Class 4": {"Assignments": [], "Category": [], "Due Date": [], "Percentage": [], "Score": [],
                                   "Weight": [], "Weighted Score": [], "Weighted Total Points": []},
                       "Class 5": {"Assignments": [], "Category": [], "Due Date": [], "Percentage": [], "Score": [],
                                   "Weight": [], "Weighted Score": [], "Weighted Total Points": []}, "Class 6": {
                    "Assignments": ["Reading Response # 4", "Reading Response # 3",
                                    "Identifying Social Issues- A Bad Move", "Reader's Response # 2",
                                    "Video Reader's Response", "Reading Responses # 1"],
                    "Category": ["Elementary Grades", "Elementary Grades", "Elementary Grades", "Elementary Grades",
                                 "Elementary Grades", "Elementary Grades"],
                    "Due Date": ["05/08/2020", "05/01/2020", "04/24/2020", "04/17/2020", "04/09/2020", "03/30/2020"],
                    "Percentage": ["100.000%", "100.000%", "100.000%", "100.000%", "100.000%", "95.000%"],
                    "Score": ["100.0", "100.0", "100.0", "100.0", "100.0", "95.00"],
                    "Weight": ["1.00", "1.00", "1.00", "1.00", "1.00", "1.00"],
                    "Weighted Score": ["100.00", "100.00", "100.00", "100.00", "100.00", "95.00"],
                    "Weighted Total Points": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00"]}, "Class 7": {
                    "Assignments": ["eLearning Participation", "5.5A Concept Attainment", "Classifying Matter Quiz",
                                    "Traits Quiz", "Survival Guide Project", "Adaptations Quiz"],
                    "Category": ["Elementary Grades", "Elementary Grades", "Elementary Grades", "Elementary Grades",
                                 "Elementary Grades", "Elementary Grades"],
                    "Due Date": ["05/15/2020", "05/08/2020", "04/24/2020", "04/17/2020", "04/09/2020", "04/03/2020"],
                    "Percentage": ["100.000%", "100.000%", "100.000%", "100.000%", "100.000%", "90.000%"],
                    "Score": ["100.0", "100.0", "100.0", "100.0", "100.0", "90.00"],
                    "Weight": ["1.00", "1.00", "1.00", "1.00", "1.00", "1.00"],
                    "Weighted Score": ["100.00", "100.00", "100.00", "100.00", "100.00", "90.00"],
                    "Weighted Total Points": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00"]}, "Class 8": {
                    "Assignments": ["Holocaust Quiz", "World War II Quiz", "Susan B. Anthony Trading Card",
                                    "Dust Bowl Journal", "World War I/Great Depression Quiz", "World War I- KWL Chart"],
                    "Category": ["Elementary Grades", "Elementary Grades", "Elementary Grades", "Elementary Grades",
                                 "Elementary Grades", "Elementary Grades"],
                    "Due Date": ["05/08/2020", "04/29/2020", "04/17/2020", "04/09/2020", "04/03/2020", "03/27/2020"],
                    "Percentage": ["100.000%", "100.000%", "100.000%", "100.000%", "90.000%", "100.000%"],
                    "Score": ["100.0", "100.0", "100.0", "100.0", "90.00", "100.0"],
                    "Weight": ["1.00", "1.00", "1.00", "1.00", "1.00", "1.00"],
                    "Weighted Score": ["100.00", "100.00", "100.00", "100.00", "90.00", "100.00"],
                    "Weighted Total Points": ["100.00", "100.00", "100.00", "100.00", "100.00", "100.00"]}},
            "Info": {"Grade": "05", "Home Campus": "Liscano Elementary School", "ID": "228923",
                     "Name": "Nikhil Singaraju"}, "Report Run": "4"}

        # return the json object mentioned
        print(dict_main_assignments)
        return jsonify(dict_main_assignments)
    except (AttributeError, KeyError, TypeError):
        return jsonify({"status": "error", "msg": "unable to receive info now, please retry"}), 404


# defines the app route for report run
@app.route('/run', methods=['GET'])
# function in order to get run
def report_run():
    # report run dict
    report_dict = {'report run': str(request.args['number'])}
    print(report_dict)

    # gets report run from users input
    run_input = report_dict['report run']

    # report card-run data and input
    # can't run all report card
    session['report run'] = run_input
    return jsonify({'status': 'error'}), 404


@app.route('/schedule')
# function in order to get schedule
def schedule():
    try:
        schedule_dict = {
            "Building": ["Liscano Elementary School", "Liscano Elementary School", "Liscano Elementary School",
                         "Liscano Elementary School", "Liscano Elementary School", "Liscano Elementary School",
                         "Liscano Elementary School", "Liscano Elementary School"],
            "Class": ["Reading", "Language Arts (English grammar/composition and spelling)", "Mathematics", "Science",
                      "Social Studies", "PE", "Music", "Art"],
            "Course": ["GR5_RDG - 51", "GR5_LANG - 51", "GR5_MTH - 51", "GR5_SCI - 51", "GR5_SST - 51", "GR5_PE - 51",
                       "GR5_MUSIC - 51", "GR5_ART - 51"],
            "Days": ["M, T, W, R, F", "M, T, W, R, F", "M, T, W, R, F", "M, T, W, R, F", "M, T, W, R, F",
                     "M, T, W, R, F", "M, T, W, R, F", "M, T, W, R, F"],
            "Marking Period": ["M1, M2, M3, M4", "M1, M2, M3, M4", "M1, M2, M3, M4", "M1, M2, M3, M4", "M1, M2, M3, M4",
                               "M1, M2, M3, M4", "M1, M2, M3, M4", "M1, M2, M3, M4"],
            "Period": ["READ", "LANG", "MATH", "SCI", "SS", "PE", "MUS", "ART"],
            "Room": ["303", "303", "304", "304", "303", "130", "118", "132"],
            "Teacher": ["BIRD, SARAH", "BIRD, SARAH", "CROSSMAN, MEGAN", "CROSSMAN, MEGAN", "BIRD, SARAH",
                        "COOPER, SHARA", "STRADER, SHANNON", "SACHSE, YEARI"]}
        return jsonify(schedule_dict)
    except (AttributeError, KeyError, TypeError):
        return jsonify({"status": "error", "msg": "unable to receive info now, please retry"}), 404


# defines the app route for ipr
@app.route('/ipr')
# function in order to get ipr
def ipr():
    try:
        ipr_run_dict = {"Run": "Interim Progress Report For Thursday, February 6, 2020", "Schedule": {
            "Class": ["Reading", "Language Arts (English grammar/composition and spelling)", "Mathematics", "Science",
                      "Social Studies"],
            "Course": ["GR5_RDG - 51", "GR5_LANG - 51", "GR5_MTH - 51", "GR5_SCI - 51", "GR5_SST - 51"],
            "Grade": ["100", "100", "98", "100", "100"], "Period": ["READ", "LANG", "MATH", "SCI", "SS"],
            "Room": ["303", "303", "304", "304", "303"],
            "Teacher": ["BIRD, SARAH", "BIRD, SARAH", "CROSSMAN, MEGAN", "CROSSMAN, MEGAN", "BIRD, SARAH"]}}
        return jsonify(ipr_run_dict)
    except (AttributeError, KeyError, TypeError):
        return jsonify({"status": "error", "msg": "unable to receive info now, please retry"}), 404


# defines the app route for rc
@app.route('/reportcard')
# function in order to get rc
def report_card():
    try:
        final_dict = {
            "Att.Credit": {"1": "0.0000", "2": "0.0000", "3": "0.0000", "4": "0.0000", "5": "0.0000", "6": "0.0000",
                           "7": "", "8": "", "9": "0.0000", "10": "", "11": "", "12": "0.0000", "13": "", "14": ""},
            "COM1": {"1": "", "2": "", "3": "MATH8", "4": "SCI7", "5": "", "6": "", "7": "", "8": "", "9": "", "10": "",
                     "11": "", "12": "", "13": "", "14": ""},
            "COM2": {"1": "", "2": "", "3": "", "4": "", "5": "", "6": "", "7": "", "8": "", "9": "", "10": "",
                     "11": "", "12": "", "13": "", "14": ""},
            "Course": {"1": "GR5_RDG - 51", "2": "GR5_LANG - 51", "3": "GR5_MTH - 51", "4": "GR5_SCI - 51",
                       "5": "GR5_SST - 51", "6": "GR5_PE - 51", "7": "", "8": "", "9": "GR5_MUSIC - 51", "10": "",
                       "11": "", "12": "GR5_ART - 51", "13": "", "14": ""},
            "Description": {"1": "Reading", "2": "Language Arts (English grammar/composition and spelling)",
                            "3": "Mathematics", "4": "Science", "5": "Social Studies", "6": "PE", "7": "- PE",
                            "8": "- PE Conduct", "9": "Music", "10": "- Music", "11": "- Music Conduct", "12": "Art",
                            "13": "- Art", "14": "- Art Conduct"},
            "EOY": {"1": "", "2": "", "3": "", "4": "", "5": "913", "6": "", "7": "", "8": "", "9": "", "10": "",
                    "11": "", "12": "", "13": "", "14": ""},
            "Ern.Credit": {"1": "0.0000", "2": "0.0000", "3": "0.0000", "4": "0.0000", "5": "0.0000", "6": "0.0000",
                           "7": "", "8": "", "9": "0.0000", "10": "", "11": "", "12": "0.0000", "13": "", "14": ""},
            "FIN": {"1": "95", "2": "99", "3": "98", "4": "97", "5": "97", "6": "", "7": "", "8": "", "9": "", "10": "",
                    "11": "", "12": "", "13": "", "14": ""},
            "MP1": {"1": "90", "2": "99", "3": "98", "4": "91", "5": "97", "6": "", "7": "S", "8": "S", "9": "",
                    "10": "S", "11": "S", "12": "", "13": "S", "14": "S"},
            "MP2": {"1": "93", "2": "97", "3": "97", "4": "98", "5": "95", "6": "", "7": "S", "8": "S", "9": "",
                    "10": "S", "11": "S", "12": "", "13": "S", "14": "S"},
            "MP3": {"1": "98", "2": "100", "3": "98", "4": "100", "5": "99", "6": "", "7": "S", "8": "S", "9": "",
                    "10": "S", "11": "S", "12": "", "13": "S", "14": "S"},
            "MP4": {"1": "99", "2": "100", "3": "99", "4": "98", "5": "98", "6": "", "7": "S", "8": "S", "9": "",
                    "10": "S", "11": "S", "12": "", "13": "S", "14": "S"},
            "Period": {"1": "READ", "2": "LANG", "3": "MATH", "4": "SCI", "5": "SS", "6": "PE", "7": "", "8": "",
                       "9": "MUS", "10": "", "11": "", "12": "ART", "13": "", "14": ""},
            "Room": {"1": "303", "2": "303", "3": "304", "4": "304", "5": "303", "6": "130", "7": "", "8": "",
                     "9": "118", "10": "", "11": "", "12": "132", "13": "", "14": ""},
            "Teacher": {"1": "BIRD, SARAH", "2": "BIRD, SARAH", "3": "CROSSMAN, MEGAN", "4": "CROSSMAN, MEGAN",
                        "5": "BIRD, SARAH", "6": "COOPER, SHARA", "7": "", "8": "", "9": "STRADER, SHANNON", "10": "",
                        "11": "", "12": "SACHSE, YEARI", "13": "", "14": ""}}
        return jsonify(final_dict)
    except (AttributeError, KeyError, TypeError):
        return jsonify({"status": "error", "msg": "unable to receive info now, please retry"}), 404


# defines the app route for gpa
@app.route('/gpa')
# function in order to get gpa
def gpa():
    try:
        gpa_dict = {"Unweighted": "None", "Weighted GPA": "None"}
        return jsonify(gpa_dict)
    except (AttributeError, KeyError, TypeError):
        return jsonify({"status": "error", "msg": "unable to receive info now, please retry"}), 404


# runs the python flask apps
if __name__ == '__main__':
    app.run()
