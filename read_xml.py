# Import an XML document and parse tree into python objects

import xml.etree.ElementTree as ET
tree = ET.parse('telmed_trials_may30.xml')
root = tree.getroot()