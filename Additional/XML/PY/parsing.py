import xml.etree.ElementTree as etree

tree = etree.parse('map.osm')
root = tree.getroot()

vertices = set()
edges = []

# print(list(root))

for way in root.findall('way'):
    edges += [[]]
    for v in way.findall('nd'):
        vertices |= {v.attrib['ref']}
        edges[-1] += [v.attrib['ref']]

f = open('map.emm', 'w')

f.write('vertices\n')
# id
# lat
# lon
for node in root.findall('node'):
    if node.attrib['id'] in vertices:
        f.write('\n'.join((node.attrib['id'], node.attrib['lat'], node.attrib['lon'])) + '\n')

f.write('\nedges\n')

for edge in edges:
    for v in edge:
        f.write(v + '\n')
    f.write('\n')

#start
#finish

# print(list(root))
