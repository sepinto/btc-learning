#! /usr/bin/python
from parseblockchain import *
import numpy as np
from scipy.io import *

def getNTxnHashesBeforeHeight(N, height):
	txn_ctr = 0
	txns = []
	while N - txn_ctr > 0:
		block = getblock(getblockhash(height))
		txns += block['tx']
		height = height - 1
		txn_ctr += len(block['tx'])

	return txns[0:N]

def outputIsUTXO(txn_hash, index):
	return True

def getUTXOLifetime(txn_hash, index):
	return 10

def getTxnData(txn_hash):
	data = deserialize(fetchtx(txn_hash))
	new_input_data = np.array([[]])
	new_output_data = np.array([])
	for index in range(len(data["outs"])):
		if outputIsUTXO(txn_hash, index):
			if new_input_data.size == 0:
				new_input_data = np.array([[int(data['locktime']), int(data["outs"][index]["value"])]])
			else:
				new_input_data = np.concatenate((new_input_data, np.array([[int(data['locktime']), int(data["outs"][index]["value"])]])))
			new_output_data = np.append(new_output_data,getUTXOLifetime(txn_hash, index))

	return (new_input_data, new_output_data)

if __name__=="__main__":
	input_data = np.array([])
	output_data = np.array([])
	for txn in getNTxnHashesBeforeHeight(10, 123456):
		new_input_data, new_output_data = getTxnData(txn)
		if input_data.size == 0:
			input_data = new_input_data
		else:
			input_data = np.concatenate((input_data, new_input_data), axis=0)
		output_data = np.concatenate((output_data, new_output_data), axis=0)

	print input_data
	print output_data
	savemat('test.mat', dict(x=input_data, y=output_data))
