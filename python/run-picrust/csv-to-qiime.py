#!/usr/bin/env python

import argparse

import pandas as pd

def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument('--input', default='/dev/stdin')
    parser.add_argument('--output', default='/dev/stdout')
    parser.add_argument('--remove-unclassified', default=False, action='store_true')

    return parser.parse_args()



def main():

    args = parse_args()

    dat = pd.read_csv(args.input)

    if args.remove_unclassified:
        try:
            del dat['unclassified_reads']
        except KeyError:
            pass

    tp_dat = dat.T

    with open(args.output, 'w') as handle:
        handle.write('# OTU TABLE\n')
        tp_dat.to_csv(handle, sep="\t", index_label="#SAMPLE")


if __name__ == '__main__':
    main()
