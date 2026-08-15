#! /usr/bin/env python3

import argparse
import sys

from semantics import Word
from semantics import words
from parsing import CodeReader, Tokenizer, TokenStreamParser, Optimizer
from generators import Ac3puGenerator, OutputWriter



def parse_args():
    parser = argparse.ArgumentParser(
        description = 'compile forth code to ac3puasm')
    parser.add_argument('input_file', nargs='?', default='-', help='Path to input file. Default: stdin (-).')
    parser.add_argument('-o', '--output', dest='output_file', type=str, default='-', help='Path to output file. Default: stdout (-).')
    parser.add_argument('-O', '--optimize', type=int, default=2, help='Number of optimization passes. Default: 2')
    return parser.parse_args()



def main():
    args = parse_args()
    code_reader = CodeReader(args)
    tokenizer = Tokenizer()
    tsp = TokenStreamParser(args)
    optimizer = Optimizer(args)
    generator = Ac3puGenerator()
    writer = OutputWriter(args)

    try:
        code = code_reader.get_code()
    except FileNotFoundError:
        print(f"Error: file '{args.input_file}' not found.", file=sys.stderr)
        sys.exit(1)

    tokens = tokenizer.parse_code(code)
    tokens = tsp.parse(tokens)
    opt_immediate = optimizer.optimize(tokens)
    asm = generator.generate(opt_immediate)
    writer.write(asm)



if __name__ == "__main__":
    main()
