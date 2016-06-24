# Functions for cleaning the ICTRP data

import re
import csv


def main():
    # terms that I want to classify into sponsor categories
    hospital_terms = ["hospital", "medical center", "health center", "clinic",
                      "hopitaux", "hospitalier", "kaiser permanente"]
    academic_terms = ["university", "college", "universitas", "universidad",
                      "universitair", "school", "universiteit"]
    government_terms = ["department", "dept", "centers for disease control",
                        "authority", "va ", "government funding body",
                        "government body", "ministry", "government",
                        "board", "council"]
    ngo_terms = ["institute", "institut", "institulet", "center", "centre",
                 "foundation", "fundacion", "fondazione", "association",
                 "associates", "academy", "other collaborative groups",
                 "charities", "cooperative"]
    commercial_terms = ["AbbVie", "Sanofi", "Pfizer", "Eli Lilly", "Bayer",
                        "Novartis", "GlaxoSmithKline", "Merck", "commercial",
                        "pharma", "astrazeneca", "ltd", "corporation", " inc",
                        "company", "gmbh"]
    investigator_terms = ["Individual", "Professor", "Prof ", "Dr ", "Dr.",
                          "PhD", "MD", "M.D.", "Prof."]

    # categories used for different types of sponsors
    categories = [
        (hospital_terms, "Hospital"),
        (academic_terms, "University"),
        (government_terms, "Government"),
        (ngo_terms, "NGO"),
        (commercial_terms, "Commercial"),
        (investigator_terms, "Investigator")
    ]

    # create a dictionary assigning each term (key) to a category (value)
    sponsor_categories = {}
    for pair in categories:
        for term in pair[0]:
            sponsor_categories[term] = pair[1]

    # create a list of just the terms; each sponsor name will be searched
    # to determine whether it contains one of these terms
    match_list = [x for x in sponsor_categories.keys()]

    # example sponsor names from the dataset to use for testing
    # test_sponsors = ["Butler Hospital",
    #                  "University of Pennsylvania",
    #                  "Boston Medical Center",
    #                  "National Heart, Lung, and Blood Institute",
    #                  "American Academy of Family Physicians",
    #                  "Kaiser Permanente"]

    # the way to rank categories in case there is a tie (e.g., if matches
    # include hospital and university, choose hospital)
    sponsor_category_ranking = [
        "Hospital",
        "University",
        "Government",
        "NGO",
        "Commercial",
        "Investigator"
    ]

    # load in data from csv file
    fieldnames = [
        "TrialID",
        "Last_Refreshed_on",
        "Public_title",
        "Scientific_title",
        "Acronym",
        "Primary_sponsor",
        "Date_registration",
        "Export_date",
        "Source_Register",
        "web_address",
        "Recruitment_Status",
        "other_records",
        "Inclusion_agemin",
        "Inclusion_agemax",
        "Inclusion_gender",
        "Date_enrollement",
        "Target_size",
        "Study_type",
        "Phase",
        "Countries",
        "Contact_Lastname",
        "Contact_Address",
        "Contact_Email",
        "Contact_Tel",
        "Condition",
        "Intervention",
        "Primary_outcome",
        "Secondary_outcome",
        "Source_Support",
        "Secondary_Sponsor",
        "Secondary_ID",
        "Study_design",
        "Contact_Firstname",
        "Contact_Affiliation"
    ]

    with open("telemed_trials.csv", 'r') as csvfile:
        reader = csv.DictReader(csvfile, fieldnames)
        next(reader, None)
        all_trials = []
        for row in reader:
            all_trials.append(row)

    # create sponsor type counter
    sponsor_counter = {
        "Hospital": 0,
        "University": 0,
        "Government": 0,
        "NGO": 0,
        "Commercial": 0,
        "Other": 0,
        "Investigator": 0,
        "N/A": 0
    }

    # create new variable Sponsor_type
    for trial in all_trials:
        # print(trial.get("Primary_sponsor"))
        if trial.get("Primary_sponsor"):
            matches = match_text(trial.get("Primary_sponsor"), match_list)
            # print("Matches: " + str(matches))
            all_categories = [sponsor_categories.get(match)
                              for match in matches]
            category = map_category(all_categories, sponsor_category_ranking)
        else:
            category = "N/A"
        # print("Category: " + category + "\n")
        trial["Sponsor_Type"] = category
        sponsor_counter[category] += 1
    print(sponsor_counter)
    fieldnames.append("Sponsor_Type")

    # create new variable Locations
    for trial in all_trials:
        if trial.get("Countries"):
            temp = trial.get("Countries")
            locations = temp.split(";")
        else:
            locations = ["N/A"]
        # print("Locations: " + str(locations))
        trial["Locations"] = locations
    fieldnames.append("Locations")

    # create a list of countries
    countries = []
    for trial in all_trials:
        for location in trial.get("Locations"):
            location = location.strip(",.")
            if location not in countries:
                countries.append(location)

    with open("country_list.csv", 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        for country in countries:
            writer.writerow([country])

    # create a country counter
    country_counter = {}
    with open("country_list_clean.csv", 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            country_counter[row[0]] = 0

    # count number of trials taking place in each country
    for trial in all_trials:
        # print(str(trial), "\n")
        for location in trial.get("Locations"):
            if location in country_counter:
                print("Country added: " + str(location))
                country_counter[location] += 1
            else:
                print("Country not in list")

    print(country_counter)

    # export country counts to csv
    # to do

    # export data to csv
    with open("ictrp_trials.csv", 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames, extrasaction='ignore')
        writer.writeheader()
        for trial in all_trials:
            writer.writerow(trial)


def match_text(text, match_list):
    """Returns a list of phrases in text from a list of possible phrases
    str, list of str -> list of str"""
    matches = [item for item in match_list for match in
               [re.search(r'.*(%s).*' % item, text, flags=re.I)] if match]
    return matches


def map_category(matches, ranked_list, default_category="Other"):
    """Returns the most likely category based on ranking of categories
    list, list, str -> str"""
    if len(matches) > 0:
        for category in ranked_list:
            if category in matches:
                return category
    else:
        return default_category


if __name__ == '__main__':
    main()
