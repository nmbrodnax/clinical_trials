# Import an XML document and parse tree into python objects

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

