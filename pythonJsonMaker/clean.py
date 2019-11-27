import csv, json

data = {}
finalData = {}
arrayofCounties = []
with open('North Carolina Counties.csv') as csvfile:
    csvReader = csv.DictReader(csvfile)

    for rows in csvReader:
        name = rows['County Name']
        tempString = rows['geometry']
        tempString = tempString.replace('<Polygon><outerBoundaryIs><LinearRing><coordinates>', '')
        tempString = tempString.replace('</coordinates></LinearRing></outerBoundaryIs></Polygon>', '')
        seperatedCords = tempString.split(" ")
        arrayOfCords = []
        
        for cords in seperatedCords:
            tempArray = []
            latlng  = {}
            flip = cords.split(',')
            latlng['lat'] = float(flip[1])
            latlng['lng'] = float(flip[0])
            arrayOfCords.append(latlng)

        print(name)
        data["countyName"] = name
        data["coordinates"] = arrayOfCords
        arrayofCounties.append(data.copy())
        
        


finalData["counties"] = arrayofCounties

with open('counties.json', 'w') as jsonFile:
    jsonFile.write(json.dumps(finalData, indent=4))