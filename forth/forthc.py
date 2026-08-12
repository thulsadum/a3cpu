#! /usr/bin/env python3

import argparse
import sys


ASM = {
    "DROP": "jal xt_drop",
    "DUP": "jal xt_dup",
    "SWAP": "jal xt_swap",
    "OVER": "jal xt_over",
    "+": "jal xt_add",
    "-": "jal xt_sub",
    "SHL": "jal xt_shl",
    "AND": "jal xt_and",
    "OR": "jal xt_or",
    "0=": "jal xt_eq0",
    "=": "jal xt_eq",
    "<": "jal xt_lt",
    "@": "jal xt_fetch",
    "!": "jal xt_store",
    "KEY": "jal xt_key",
    "EMIT": "jal xt_emit",
}

PARSER_STATE = "R"

def get_code(args):
    if args.input_file == '-':
        return sys.stdin.read()
    else:
        try:
            with open(args.input_file, 'r', encoding='utf-8') as file:
                return file.read()
        except FileNotFoundError:
            print(f"Error: file '{args.input_file}' not found.", file=sys.stderr)
            sys.exit(1)



def write_asm(args, asm):
    if args.output_file == '-':
        print(asm)
    else:
        with open(args.output_file, 'w', encoding='utf-8') as file:
            file.write(asm)


def parse_code(args, code):
    tokens = code.split()
    return [ ltok for tok in tokens if (ltok := parse_token(tok)) ]



def parse_token(token):
    global PARSER_STATE
    if PARSER_STATE == 'R':
        if token.isdigit() or (token.startswith('-') and token[1:].isdigit()):
            return f'const({token})'
        elif token.upper().startswith("0X"):
            return f'const({token})'
        elif token.upper() == '[CHAR]':
            PARSER_STATE = 'C'
            return ''
        elif token.upper() == '[ASM':
            PARSER_STATE = 'A'
            return '[ASM'
        return token
    elif PARSER_STATE == 'A':
        if token == ']':
            PARSER_STATE = 'R'
        return token
    elif PARSER_STATE == 'C':
        PARSER_STATE = 'R'
        return f'const("{token}")'



def optimize_forth(args, immediate):
    return immediate


def generate_asm(args, immediate):
    asm = []
    vasm = []
    is_asm = False
    for op in immediate:
        if is_asm:
            if op == ']':
                is_asm = False
                asm.append(' '.join(vasm).rstrip())
                asm.append("\n; > ]")
                continue
            vasm.append(op.rstrip())
        elif op.startswith('const('):
            asm.append(f"; > {op}\n  {op.replace('const','push')}")
        elif op.upper() == "[ASM":
            is_asm = True
            asm.append("; > [ASM\n")
            vasm = []
        elif op.upper() in ASM:
            asm.append(f"; > {op}\n  {ASM[op.upper()]}")
        else:
            print(f"Error: Unknown token '{op.upper()}'")
    return "\n".join(asm)



def parse_args():
    parser = argparse.ArgumentParser(
        description = 'compile forth code to ac3puasm')
    parser.add_argument('input_file', nargs='?', default='-', help='Path to input file. Defaults to stdin (-).')
    parser.add_argument('-o', '--output', dest='output_file', type=str, default='-', help='Path to output file. Defaults to stdout (-).')
    return parser.parse_args()



def main():
    args = parse_args()
    code = get_code(args)
    immediate = parse_code(args, code)
    opt_immediate = optimize_forth(args, immediate)
    asm = generate_asm(args, opt_immediate)
    write_asm(args, asm)



if __name__ == "__main__":
    main()
