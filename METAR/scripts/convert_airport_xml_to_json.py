#!/usr/bin/env python3
import sys
import xmltodict
import json

if __name__ == "__main__":
	with open(sys.argv[1]) as xml:
		d = xmltodict.parse(xml.read())
		stations = d["response"]["data"]["Station"]
		for station in stations:
			site_type_dict = {}
			if "site_type" in station:
				site_type_dict = station["site_type"]
				del station["site_type"]
			station["types"] = list(site_type_dict.keys())
		s = json.dumps(stations, indent=4)
		print(s)