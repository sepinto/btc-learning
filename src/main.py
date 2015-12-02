#! /usr/bin/python
from parseblockchain import *
import numpy as np
from scipy.io import *
from urllib2 import Request, urlopen, URLError
from time import sleep

COINBASE_HASH = "0000000000000000000000000000000000000000000000000000000000000000"


def getNTxnHashesBeforeHeight(N, height):
	txn_ctr = 0
	txns = []
	while N - txn_ctr > 0:
		block = getblock(getblockhash(height))
		new_txns = [(tx, height) for tx in block['tx']]
		txns += new_txns
		height = height - 1
		txn_ctr += len(new_txns)
	return txns[0:N]


def queryTxnInfo(txn_hash):	
	request = Request('https://blockchain.info/rawtx/'+txn_hash)
	response = urlopen(request)
	txn_json = response.read()
	return json.loads(txn_json)


def getTxnData(txn_hash, height):
	data = deserialize(fetchtx(txn_hash))
	new_input_data = np.array([])
	new_output_data = np.array([])
	for txn_input in data["ins"]:
		if txn_input['outpoint']['hash'] == COINBASE_HASH:
			print("Ignoring a coinbase hash...")
			continue
		else:
			prev_tx = queryTxnInfo(txn_input['outpoint']['hash'])
			prev_tx_output = prev_tx['out'][txn_input['outpoint']['index']]
			new_input_data = np.append(new_input_data, {'numPeerSpends':len(data["ins"]),'value':prev_tx_output['value'],'locktime':prev_tx['lock_time'],'type':prev_tx_output['type']})
			new_output_data = np.append(new_output_data, height - prev_tx['block_height'])

	return (new_input_data, new_output_data)


# Exit Gracefully
output_data = np.array([])
input_data = np.array([])

import signal
def signal_handler(signal, frame):
	savemat('killed.mat', dict(x=input_data, y=output_data))
	print "Wrote to killed.mat and exiting"
        sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

if __name__=="__main__":
	err_cnt = 0
	goal = 10000
	start_height = getblockcount() - 1000
	print "Collecting at most %d spent txns started at top block height %d" % (goal, start_height)
	sleep_time = 3
	ctr = 0
	for (txn, height) in getNTxnHashesBeforeHeight(goal, getblockcount() - 1000): #Want spent txns so go back a bit
		sys.stdout.flush()
		ctr = ctr + 1
		try:
			new_input_data, new_output_data = getTxnData(txn, height)
			if input_data.size == 0:
				input_data = new_input_data
			else:
				input_data = np.concatenate((input_data, new_input_data), axis=0)
			output_data = np.concatenate((output_data, new_output_data), axis=0)
			if ctr % 10 == 0:
				print "%d txn(s) collected with %d errors..." % (len(input_data), err_cnt)
			if ctr % 200  == 0 and len(input_data) > 0:
				savemat('%d.mat'%(len(input_data)), dict(x=input_data, y=output_data))
				print "wrote %d points to .mat file" % (len(input_data))
			sleep(sleep_time)
		except Exception, e:
			err_cnt += 1
			print(e)
			if err_cnt >= 50:
				print "Have seen 50 errors. Cutting losses and writing to file."
				break	
			sleep(1800)
	print("total errors = " + str(err_cnt))
	savemat('big.mat', dict(x=input_data, y=output_data))
