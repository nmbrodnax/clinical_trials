# Functions for cleaning the ICTRP data

import re


def main():
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

    categories = [
        (hospital_terms, "Hospital"),
        (academic_terms, "University"),
        (government_terms, "Government"),
        (ngo_terms, "NGO"),
        (commercial_terms, "Commercial")
    ]

    sponsor_categories = {}
    for pair in categories:
        for term in pair[0]:
            sponsor_categories[term] = pair[1]

    # print(sponsor_categories)
    match_list = [x for x in sponsor_categories.keys()]
    # print(match_list)
    test_sponsors = ["Butler Hospital",
                     "University of Pennsylvania",
                     "Boston Medical Center",
                     "National Heart, Lung, and Blood Institute",
                     "American Academy of Family Physicians"]
    for sponsor in test_sponsors:
        print(match_text(sponsor, match_list))
        print("\n")


def match_text(text, match_list):
    """Returns a list of phrases in text from a list of possible phrases
    str, list of str -> list of str"""
    matches = [item for item in match_list for match in
               [re.search(r'.*(%s).*' % item, text, flags=re.I)] if match]
    return matches


def sponsor_type(matches, ranked_list):
    """Returns the most likely sponsor based on ranking of phrases
    str -> str"""
    for sponsor in ranked_list:
        if sponsor in matches:
            return sponsor


if __name__ == '__main__':
    main()
