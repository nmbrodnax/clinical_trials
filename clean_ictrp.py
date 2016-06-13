# Functions for cleaning the ICTRP data

import re


def main():
    # terms that I want to classify into sponsor categories
    hospital_terms = ["hospital", "medical center", "health center", "clinic",
                      "hopitaux", "hospitalier"]
    academic_terms = ["university", "college", "universitas", "universidad"]
    government_terms = ["department", "centers for disease control",
                        "authority", "va office", "government funding body"]
    ngo_terms = ["institute", "institut", "institulet", "center", "centre",
                 "foundation", "fundacion", "fondazione", "association",
                 "associates", "academy"]
    commercial_terms = ["AbbVie", "Sanofi", "Pfizer", "Eli Lilly", "Bayer",
                        "Novartis", "GlaxoSmithKline", "Merck"]

    # categories used for different types of sponsors
    categories = [
        (hospital_terms, "Hospital"),
        (academic_terms, "University"),
        (government_terms, "Government"),
        (ngo_terms, "NGO"),
        (commercial_terms, "Commercial")
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
    test_sponsors = ["Butler Hospital",
                     "University of Pennsylvania",
                     "Boston Medical Center",
                     "National Heart, Lung, and Blood Institute",
                     "American Academy of Family Physicians",
                     "Kaiser Permanente"]

    # the way to rank categories in case there is a tie (e.g., if matches
    # include hospital and university, choose hospital)
    sponsor_category_ranking = [
        "Hospital",
        "University",
        "Government",
        "NGO",
        "Commercial"
    ]

    # load in data from xml file

    for sponsor in test_sponsors:
        matches = match_text(sponsor, match_list)
        all_categories = [sponsor_categories.get(match) for match in matches]
        category = map_category(all_categories, sponsor_category_ranking)
        print(category, "\n")


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
