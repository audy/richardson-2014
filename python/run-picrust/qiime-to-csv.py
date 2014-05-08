#!/usr/bin/env python

import argparse

import pandas as pd

def parse_args():
  parser = argparse.ArgumentParser()

  parser.add_argument('--input', default='/dev/stdin')
  parser.add_argument('--output', default='/dev/stdout')

  return parser.parse_args()


def main():

  args = parse_args()

  dat = pd.read_csv(args.input, sep="\t", index_col=0, skiprows=1)

  transposed = dat.T 

  transposed.to_csv(args.output)

if __name__ == '__main__':
  main()
