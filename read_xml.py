# Import an XML document and parse tree into list of dictionaries

import xml.etree.ElementTree
tree = xml.etree.ElementTree.parse('telemed_trials_may30.xml')
root = tree.getroot()

all_trials = []
i = 0
j = 0

while i < len(root):
    trial = {}
    while j < len(root[i]):
        trial[root[i][j].tag] = root[i][j].text
        j += 1
    all_trials.append(trial)
    i += 1

print(all_trials[:10])
