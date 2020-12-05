#!/usr/bin/env python

# Modified from Kraken template code
# Usage: ./krakentickercsv symbol start
# Example: ./krakenhistory XXBTZUSD 1559347200 1559433600

import sys
import time

import json
import platform


if int(platform.python_version_tuple()[0]) > 2:
	import urllib.request as urllib2
else:
	import urllib2


api_domain = "https://api.kraken.com"
api_path = "/0/public/"
api_method = "Ticker"
api_data = ""



api_symbol = sys.argv[1].upper()

try:
	while True:
		api_data = "?pair=%(pair)s" % {"pair":api_symbol}
		api_request = urllib2.Request(api_domain + api_path + api_method + api_data)
		try:
			api_data = urllib2.urlopen(api_request).read()
		except Exception:
			time.sleep(3)
			continue
		api_data = json.loads(api_data)
		if len(api_data["error"]) != 0:
			time.sleep(3)
			continue

#<pair_name> = pair name
#    a = ask array(<price>, <whole lot volume>, <lot volume>),
#    b = bid array(<price>, <whole lot volume>, <lot volume>),
#    c = last trade closed array(<price>, <lot volume>),
#    v = volume array(<today>, <last 24 hours>),
#    p = volume weighted average price array(<today>, <last 24 hours>),
#    t = number of trades array(<today>, <last 24 hours>),
#    l = low array(<today>, <last 24 hours>),
#    h = high array(<today>, <last 24 hours>),
#    o = today's opening price


		ask = api_data["result"][api_symbol]["a"]
		bid = api_data["result"][api_symbol]["b"]
		trade = api_data["result"][api_symbol]["c"]
		volume = api_data["result"][api_symbol]["v"]
		o = api_data["result"][api_symbol]["o"]
		numberOfTrades = api_data["result"][api_symbol]["t"][1]
		lPart = api_data["result"][api_symbol]["l"][1]
		hPart = api_data["result"][api_symbol]["h"][1]

		aPart = "{0},{1}".format(ask[0],ask[2])
		bPart = "{0},{1}".format(bid[0],bid[2])
		cPart = "{0},{1}".format(trade[0],trade[1])

		timePart = time.ctime(time.time())

		#print("{0},{1},{2},{3},{4}".format(aPart,bPart,cPart,lPart,hPart))
		fileName = "{0}.csv".format(api_symbol)
		with open(fileName, 'a') as f:
    			#print >> f, "{0},{1},{2},{3},{4},{5}".format(timePart,aPart,bPart,cPart,lPart,hPart)
				f.write("{0},{1},{2},{3},{4},{5}\n".format(timePart,aPart,bPart,cPart,lPart,hPart))
			#print("{0},{1},{2},{3},{4},{5}".format(timePart,aPart,bPart,cPart,lPart,hPart),file=f)



		#print "out"
		time.sleep(3.5)
except KeyboardInterrupt:
	None

sys.exit(0)
