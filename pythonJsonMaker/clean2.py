import csv, json, random
data = {}
finalData = {}
arrayofcandidates = []
def Cities(i):
        switcher={
                'MATTHEWS':[35.1168, -80.7237],
                'CHARLOTTE':[35.2271, -80.8431],
                'CORNELIUS':[35.4868, -80.8601],
                'FUQUAY-VARINA':[35.5843, -78.8000],
                'WINGATE':[34.9843176, -80.4492319],
                'MARSHVILLE':[34.9885, -80.3670],
                'SALTER PATH':[34.1168, -76.8861],
                'HUNTERSVILLE':[35.4107, -80.8429],
                'PINEVILLE':[35.0832, -80.8923],
                'DAVIDSON':[35.4993, -80.8487],
                'WINGATE':[34.9843, -80.4492],
                'RALEIGH':[35.7796, -78.6382],
                'HARRISBURG':[40.2732, -76.8867],
             }
        return switcher.get(i,"Invalid")

with open('Candidate_Listing_2019.csv') as csvfile:
    csvReader = csv.DictReader(csvfile)

    for rows in csvReader:
        if (rows['county_name'] ==  'MECKLENBURG'):
            offset = random.uniform(.02, .08)
            data["county"] = rows['county_name']
            data["position"] = rows["contest_name"]
            data["name"] = rows["name_on_ballot"]
            data["lat"] = Cities(rows["city"])[0]+offset
            data["lng"] = Cities(rows["city"])[1]+offset
            data["city"] = rows["city"]
            arrayofcandidates.append(data.copy());       
        


finalData["elections"] = arrayofcandidates

with open('candidates.json', 'w') as jsonFile:
    jsonFile.write(json.dumps(finalData, indent=4))