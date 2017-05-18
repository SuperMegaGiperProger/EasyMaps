import xml.etree.ElementTree as etree

fname = input('Filename: ')

tree = etree.parse(fname + '.osm')
root = tree.getroot()

vertices = set()
edges = []
w = {'motorway' : '3', 'trunk' : '2', 'primary' : '2', 'secondary' : '2', 'tertiary' : '2', 'unclassified' : '1', 'residential' : '1', 'service' : '1', 'track' : '1'}

for way in root.findall('way'):
    #if way.attrib['visible'] == 'false': continue
    exist = False
    rever = False
    revch = False
    sidewalk = False
    weight = '2'
    weich = False
    movingType = 'foot'
    for tag in way.findall('tag'):
        k = tag.attrib['k']
        v = tag.attrib['v']
        if k == 'oneway':
            rever = (v == 'no')
            revch = True
            continue
        if k == 'sidewalk':
            if v != 'no': sidewalk = True
        if k == 'lanes':
        	if v[0] != 'q': 
        		weight = v[0]
        		weich = True
        	continue
        if k == 'highway':
            if v == 'road':
                exist = False
                break
            if v in {'living_street', 'pedestrian', 'footway', 'bridleway', 'steps', 'path', 'crossing'}:
                movingType = 'foot'
                if not weich: weight = '1'
                exist = True
                if not revch: rever = True
                continue
            if v in {'track', 'trunk', 'primary', 'secondary', 'tertiary', 'unclassified', 'residential', 'service'}:
                movingType = 'car'
                exist = True
                if not revch: rever = True
                if not weich:
                	weight = w[v]
                continue
            if v in {'motorway_link', 'trunk_link', 'primary_link', 'secondary_link', ' tertiary_link'}:
                movingType = 'car'
                exist = True
                if not revch: rever = False
                if not weich:
                	weight = w[v[:-5]]
                continue
            if v == 'motorway':
                movingType = 'car'
                exist = True
                if not revch: rever = False
                if not weich:
                	weight = w[v]
                continue
    if not exist: continue 	
    if movingType == 'car': weight = str(1 + int(weight))
    sidewalk = True
    edges += [[movingType, weight, rever]]
    for v in way.findall('nd'):
        vertices |= {v.attrib['ref']}
        edges[-1] += [v.attrib['ref']]
    if movingType == 'car' and sidewalk:
        edges += [edges[-1][:]]
        edges[-1][0] = 'foot'
        edges[-1][1] = '1'
        edges[-1][2] = True

f = open(fname + '.txt', 'w')
f.write('vertices\n')
# id
# lat
# lon
for node in root.findall('node'):
    if node.attrib['id'] in vertices:
        f.write('\n'.join((node.attrib['id'], node.attrib['lat'], node.attrib['lon'])) + '\n')

f.write('\nedges\n')
# movingType(car, foot, plane)
# weight(lanes number)(if foot then weight = 1)
# reversed(oneway=no)
# links
# \n
for edge in edges:
    edge[2] = str(edge[2])
    f.write('\n'.join(edge) + '\n\n')

f.close()
