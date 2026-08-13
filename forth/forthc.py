#! /usr/bin/env python3

import argparse
import sys

from semantics import Word
from semantics import words
from parsing import CodeReader, Tokenizer, Optimizer
from generators import Ac3puGenerator, OutputWriter



def parse_args():
    parser = argparse.ArgumentParser(
        description = 'compile forth code to ac3puasm')
    parser.add_argument('input_file', nargs='?', default='-', help='Path to input file. Defaults to stdin (-).')
    parser.add_argument('-o', '--output', dest='output_file', type=str, default='-', help='Path to output file. Defaults to stdout (-).')
    return parser.parse_args()



def main():
    args = parse_args()
    code_reader = CodeReader(args)
    tokenizer = Tokenizer()
    optimizer = Optimizer()
    generator = Ac3puGenerator()
    writer = OutputWriter(args)

    try:
        code = code_reader.get_code()
    except FileNotFoundError:
        print(f"Error: file '{args.input_file}' not found.", file=sys.stderr)
        sys.exit(1)

    tokens = tokenizer.parse_code(code)
    opt_immediate = optimizer.optimize(tokens)
    asm = generator.generate(opt_immediate)
    writer.write(asm)



if __name__ == "__main__":
    main()
