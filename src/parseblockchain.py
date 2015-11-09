#!/usr/bin/env python
"""
Parse the Bitcoin blockchain into Python datastructures.
"""
import json
import struct
import codecs
import hashlib
import webbrowser
from collections import namedtuple
from bitcoin import *

import sh
from path import path
BITCOINDIR = path("/farmshare/user_data/spinto2/share/").expand().abspath()


#############
# Utilities #
#############
def unpack_u32(b):
    u32 = struct.unpack('<I', b[0:4])
    return (u32[0], b[4:])


def unpack_u64(b):
    u64 = struct.unpack('<Q', b[0:8])
    return (u64[0], b[8:])


def unpack_compact_int(bytestr):
    b0 = bytestr[0]
    if b0 < 0xfd:
        return (b0, bytestr[1:])
    elif b0 == 0xfd:
        return (struct.unpack('<H', bytestr[1:3])[0], bytestr[3:])
    elif b0 == 0xfe:
        return (struct.unpack('<I', bytestr[1:5])[0], bytestr[5:])
    elif b0 == 0xff:
        return (struct.unpack('<Q', bytestr[1:9])[0], bytestr[9:])
    else:
        return None


def unpack_var_str(b):
    strlen, b0 = unpack_compact_int(b)
    return (b0[:strlen], b0[strlen:])


def hashbytes_to_str(b):
    revb = b[::-1]
    return codecs.encode(revb, 'hex_codec').decode('ascii')


def dhash(b):
    return hashlib.sha256(hashlib.sha256(b).digest()).digest()


##############
# Validation #
##############
def getblockcount():
    return int(sh.bitcoin_cli("--datadir="+BITCOINDIR, "getblockcount"))

def getbestblockhash():
    out = sh.bitcoin_cli("--datadir="+BITCOINDIR, "getbestblockhash")
    return out.stdout.decode('utf-8').rstrip("\n")

def getblockhash(height):
    out = sh.bitcoin_cli("--datadir="+BITCOINDIR, "getblockhash", height)
    return out.stdout.decode('utf-8').rstrip("\n")


def getblock(hash):
    try:
        foo = sh.bitcoin_cli("--datadir="+BITCOINDIR, "getblock", hash).stdout.decode('utf-8')
        out = json.loads(foo)
    except sh.ErrorReturnCode_5:
        out = None
    return out


def getblock_from_index(height):
    return getblock(getblockhash(height))


def validate(block):
    blockchain_block = getblock(block.block_header)
    assert blockchain_block is not None
    assert block.length == blockchain_block['size']


def browse(block):
    url = "https://blockchain.info/block-index/%s" % block.block_header
    webbrowser.open(url)


###########
# Parsing #
###########
Script = namedtuple('Script', 'raw')
Input = namedtuple('Input', 'hash index script sequenceNumber')
Output = namedtuple('Output', 'value script')
Transaction = namedtuple('Transaction', 'version inputs outputs lock_time')
Block = namedtuple('Block', 'length version prev_block_hash ' +
                   'merkle_root_hash time bits nonce txns block_header')


def datfiles(BITCOINDIR=BITCOINDIR):
    return sorted(path.joinpath(BITCOINDIR, "blocks").listdir("blk*.dat"))


def bytes2script(b):
    raw_script, b = unpack_var_str(b)
    return Script(hashbytes_to_str(raw_script)), b


def bytes2tx_inputs(b):
    outpoint = hashbytes_to_str(b[0:32])
    outpoint_index, b1 = unpack_u32(b[32:])
    script, b1 = bytes2script(b1)
    sequence_num, b1 = unpack_u32(b1)
    return Input(outpoint, outpoint_index, script, sequence_num), b1


def bytes2tx_outputs(b):
    value, b0 = unpack_u64(b)
    script_len, b0 = unpack_compact_int(b0)
    script = Script(hashbytes_to_str(b0[:script_len]))
    return Output(value, script), b0[script_len:]


def bytes2txns(b):
    version = struct.unpack('<I', b[:4])[0]
    b1 = b[4:]

    num_inputs, b1 = unpack_compact_int(b1)
    inputs = []
    for i in range(num_inputs):
        inp, b1 = bytes2tx_inputs(b1)
        inputs.append(inp)

    num_outputs, b1 = unpack_compact_int(b1)
    outputs = []
    for o in range(num_outputs):
        out, b1 = bytes2tx_outputs(b1)
        outputs.append(out)

    lock_time = struct.unpack('<I', b1[:4])[0]
    return Transaction(version, inputs, outputs, lock_time), b1[4:]


def bytes2blocks(fh):
    magicnum = struct.unpack("<I", fh.read(4))[0]
    assert magicnum == 3652501241 == 0xd9b4bef9
    length = struct.unpack("<I", fh.read(4))[0]
    b = fh.read(length)

    # Compute block header before advancing byte position
    block_header = hashbytes_to_str(dhash(b[0:80]))

    # Now parse everything up to the nonce
    version, b = unpack_u32(b)
    prev_block_hash, b = hashbytes_to_str(b[0:32]), b[32:]
    merkle_root_hash, b = hashbytes_to_str(b[0:32]), b[32:]
    time, b = unpack_u32(b)
    bits, b = unpack_u32(b)
    nonce, b = unpack_u32(b)

    # Iterate over each transaction
    num_txns, b = unpack_compact_int(b)
    txns = []
    for i in range(num_txns):
        t, b = bytes2txns(b)
        txns.append(t)

    return Block(length, version, prev_block_hash, merkle_root_hash, time,
                 bits, nonce, txns, block_header), fh


def dat2blocks(dat, offset=None):
    fh = open(dat, 'rb')
    blocks = []
    while fh.tell() < dat.size:
        block, fh = bytes2blocks(fh)
        blocks.append(block)
        print("file:%s position:%s nblocks:%s header:%s" %
              (dat, fh.tell(), len(blocks), block.block_header))
    fh.close()


def dats2blocks():
    for dat in datfiles():
        dat2blocks(dat)


if __name__ == '__main__':
    dats2blocks()
