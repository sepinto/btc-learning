#! /usr/bin/python

################## Import ##################
from parseblockchain import *
import numpy as np
from scipy.io import *
from urllib2 import Request, urlopen, URLError
from time import sleep
import signal



################## Global ##################
COINBASE_HASH = "0000000000000000000000000000000000000000000000000000000000000000"
DATA_DIR = '../data'
TXO_DATA = np.array([])



##################  Fcns  ##################
def writeData(txo_data, filename):
	savemat('%s/%s'%(DATA_DIR,filename), dict(txo_data=txo_data))


def getNTxnHashesBeforeHeight(N, height):
	txns = []
	while len(txns) < N:
		block = getblock(getblockhash(height))
		txns += block['tx']
		height = height - 1
	return txns[0:N]


def queryTxnInfo(txnHash):	
	request = Request('https://blockchain.info/rawtx/'+txnHash)
	response = urlopen(request)
	txnJSON = response.read()
	return json.loads(txnJSON)


def getTxnData(endTxnHash):
	endTxnLocal = deserialize(fetchtx(endTxnHash))
	endTxn = queryTxnInfo(endTxnHash)
	txoData = np.array([])
	for txnInput in endTxnLocal["ins"]:
		if txnInput['outpoint']['hash'] == COINBASE_HASH:
			print("Ignoring a coinbase hash...")
			continue
		else:
			beginTxn = queryTxnInfo(txnInput['outpoint']['hash'])
			txo = beginTxn['out'][txnInput['outpoint']['index']]
			txoData = np.append(txoData, 
				{'beginTxn_numIns':beginTxn["vin_sz"],'beginTxn_numOuts':beginTxn["vout_sz"],
				'beginTxn_time':beginTxn['time'],'beginTxn_height':beginTxn['block_height'],
				'beginTxn_locktime':beginTxn['lock_time'],
				'endTxn_numIns':endTxn["vin_sz"],'endTxn_numOuts':endTxn["vout_sz"],
				'endTxn_time':endTxn['time'],'endTxn_height':endTxn['block_height'],
				'endTxn_locktime':endTxn['lock_time'],
				'value':txo['value']}, 'type':txo['type'])

	return txoData


def signal_handler(signal, frame):
	writeData('killed.mat', TXO_DATA)
	print "Wrote data. Exiting..."
        sys.exit(0)



##################  main  ##################
if __name__=="__main__":
	# Register Ctrl-C handler to exit gracefully
	signal.signal(signal.SIGINT, signal_handler)

	# Params
	goal = 10000 # transactions
	startHeight = getblockcount() - 1000  # Want spent txns so go back a bit
	shortSleep = 3 # seconds
	longSleep = 1800 # seconds
	errCutoff = 50; # How many errors before quit
	savePeriod = 200; # How many iterations between saves
	printPeriod = 10; # How many iterations between prints
	
	# Iterate through transactions	
	errCnt = 0
	iterCtr = 0
	print "Collecting at most %d spent txns started at top block height %d" % (goal, startHeight)
	for txn in getNTxnHashesBeforeHeight(goal, startHeight):
		sys.stdout.flush()
		iterCtr = iterCtr + 1
		try:
			newTxoData = getTxnData(txn)
			if TXO_DATA.size == 0:
				TXO_DATA = newTxoData
			else:
				TXO_DATA = np.concatenate((TXO_DATA, newTxoData), axis=0)

			if iterCtr % printPeriod == 0:
				print "%d txn(s) collected with %d errors..." % (len(TXO_DATA), errCnt)
			if iterCtr % savePeriod  == 0 and len(TXO_DATA) > 0:
				writeData('%d.mat'%len(TXO_DATA), TXO_DATA)
				print "wrote %d points to .mat file" % (len(TXO_DATA))
			sleep(shortSleep)
		except Exception, e:
			errCnt += 1
			print(e)
			if errCnt >= errCutoff:
				print "Have seen 50 errors. Cutting losses and writing to file."
				break	
			sleep(longSleep)
	
	# Write our hard-won data to a file			
	writeData('out.mat', TXO_DATA)
