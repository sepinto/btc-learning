#! /usr/bin/python
from parseblockchain import *
import numpy as np
from scipy.io import *
from urllib2 import Request, urlopen, URLError

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
	try:
		response = urlopen(request)
		txn_json = response.read()
		return json.loads(txn_json)
	except URLError, e:
	    print 'QUERY FAILED. FUCK.', e


def getTxnData(txn_hash, height):
	data = deserialize(fetchtx(txn_hash))
	new_input_data = np.array([])
	new_output_data = np.array([])
	for txn_input in data["ins"]:
		if txn_input['outpoint']['hash'] == COINBASE_HASH:
			continue
		prev_tx = queryTxnInfo(txn_input['outpoint']['hash'])
		prev_tx_output = prev_tx['out'][txn_input['outpoint']['index']]
		new_input_data = np.append(new_input_data, {'value':prev_tx_output['value'],'locktime':prev_tx['lock_time'],'type':prev_tx_output['type']})
		new_output_data = np.append(new_output_data, height - prev_tx['block_height'])

	return (new_input_data, new_output_data)


if __name__=="__main__":
	input_data = np.array([])
	output_data = np.array([])
	for (txn, height) in getNTxnHashesBeforeHeight(1000, 200000):
		new_input_data, new_output_data = getTxnData(txn, height)
		if input_data.size == 0:
			input_data = new_input_data
		else:
			input_data = np.concatenate((input_data, new_input_data), axis=0)
		output_data = np.concatenate((output_data, new_output_data), axis=0)

	savemat('thousand_out.mat', dict(x=input_data, y=output_data))
