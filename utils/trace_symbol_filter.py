#!/usr/bin/env python3
import sys
import re
import argparse

def load_symbols(sym_file):
    symbols = {}
    pattern = re.compile(r'^\s*([a-zA-Z_][a-zA-Z0-9_.]*)\s*=\s*(0x[0-9a-fA-F]+|[0-9]+)')
    with open(sym_file, 'r') as f:
        for line in f:
            match = pattern.match(line)
            if match:
                name, val_str = match.groups()
                # 1. Filter out symbols starting with OP_ as requested
                if name.startswith('OP_'):
                    continue
                val = int(val_str, 16) if val_str.lower().startswith('0x') else int(val_str)
                if val not in symbols:
                    symbols[val] = []
                symbols[val].append(name)
    return symbols

def visible_len(s):
    # Strips ANSI escape sequences to calculate the printable width
    return len(re.sub(r'\033\[[0-9;]*m', '', s))

def pad_visible(s, w):
    v_len = visible_len(s)
    return s + ' ' * max(0, w - v_len)

def format_ascii_preview(val, use_color=True):
    high = (val >> 8) & 0xFF
    low = val & 0xFF
    
    def char_rep(b):
        if b == 9: return r"\t"
        elif b == 10: return r"\n"
        elif b == 13: return r"\r"
        elif b == 0: return r"\0"
        elif 32 <= b <= 126: return chr(b)
        return "."
        
    has_ascii = False
    for b in (high, low):
        if b in (9, 10, 13) or (32 <= b <= 126):
            has_ascii = True
            break
            
    if has_ascii:
        C_RESET = "\033[0m" if use_color else ""
        C_GREEN = "\033[32m" if use_color else ""
        
        rep_high = f"'{char_rep(high)}'" if (high in (9, 10, 13) or 32 <= high <= 126) else "."
        if high == 0 and (low in (9, 10, 13) or 32 <= low <= 126):
            rep_high = r"'\0'"
            
        rep_low = f"'{char_rep(low)}'" if (low in (9, 10, 13) or 32 <= low <= 126) else "."
        if low == 0 and (high in (9, 10, 13) or 32 <= high <= 126):
            rep_low = r"'\0'"
            
        return f" {C_GREEN}[char: {rep_high} {rep_low}]{C_RESET}"
    return ""

def format_match(val, symbols, is_address=False, is_write=False, clean=False, use_color=True):
    val_str = f"0x{val:04X}"
    
    C_RESET = "\033[0m" if use_color else ""
    C_YELLOW = "\033[33m" if use_color else ""
    C_CYAN = "\033[36m" if use_color else ""
    
    # 1. Address Context:
    if is_address:
        if val in symbols:
            # Never resolve Opcodes (OC_) in address context
            non_oc = [s for s in symbols[val] if not s.startswith('OC_')]
            if non_oc:
                if clean:
                    return f"{C_CYAN}{non_oc[0]}{C_RESET}" if use_color else non_oc[0]
                colored_syms = [f"{C_CYAN}{s}{C_RESET}" if use_color else s for s in non_oc]
                return f"{val_str} ({'|'.join(colored_syms)})"
        return val_str

    # 2. Value Context (is_address=False):
    high = (val >> 8) & 0xFF
    low = val & 0xFF

    # Rule A: Check if there is a full 16-bit non-OC symbol (e.g. __start, __forth_start, labels)
    if val in symbols:
        non_oc = [s for s in symbols[val] if not s.startswith('OC_')]
        if non_oc:
            if clean:
                return f"{C_CYAN}{non_oc[0]}{C_RESET}" if use_color else non_oc[0]
            colored_syms = [f"{C_CYAN}{s}{C_RESET}" if use_color else s for s in non_oc]
            return f"{val_str} ({'|'.join(colored_syms)})"

    # Rule B: Decode as Instruction if high byte has an OC_ symbol, and high != 0x00 (unless val == 0x0000)
    is_instruction = False
    if high in symbols:
        op_syms = [s for s in symbols[high] if s.startswith('OC_')]
        if op_syms and (high != 0x00 or val == 0x0000):
            is_instruction = True

    # If it's a read, or if we couldn't find a 16-bit data symbol for a write:
    if is_instruction and (not is_write or val not in symbols):
        op_syms = [s for s in symbols[high] if s.startswith('OC_')]
        
        # Hardware-derived Logic: Only query low byte symbols (non-OC) if the Opcode's MSB is set (Bit 7 / 0x80)
        # This corresponds to 1-word (Immediate/ZP) instructions. 2-word instructions (MSB == 0) do not encode
        # ZP/Immediate operands in their lower byte.
        operand_syms = []
        is_one_word = (high & 0x80 != 0)
        
        if is_one_word and low in symbols:
            operand_syms = [s for s in symbols[low] if not s.startswith('OC_')]
        
        op_name = op_syms[0]
        if operand_syms:
            operand_str = operand_syms[0]
            operand_colored = f"{C_CYAN}{operand_str}{C_RESET}" if use_color else operand_str
        else:
            operand_str = f"0x{low:02X}"
            operand_colored = operand_str
            
        op_colored = f"{C_YELLOW}{op_name}{C_RESET}" if use_color else op_name
        
        if clean:
            return f"{op_colored} {operand_colored}"
            
        return f"{val_str} ({op_colored} {operand_colored})"

    # Rule C: Fallback to full 16-bit lookup (with OC_ symbols allowed only if high != 0x00)
    if val in symbols:
        allowed_syms = symbols[val]
        if high == 0x00:
            allowed_syms = [s for s in allowed_syms if not s.startswith('OC_')]
            
        if allowed_syms:
            if clean:
                best = allowed_syms[0]
                color = C_YELLOW if best.startswith('OC_') else C_CYAN
                return f"{color}{best}{C_RESET}" if use_color else best
            colored_syms = []
            for s in allowed_syms:
                color = C_YELLOW if s.startswith('OC_') else C_CYAN
                colored_syms.append(f"{color}{s}{C_RESET}" if use_color else s)
            return f"{val_str} ({'|'.join(colored_syms)})"

    return val_str

def main():
    parser = argparse.ArgumentParser(description="Translate ac3pu memory trace hex values into assembly symbols with context-aware instruction decoding.")
    parser.add_argument("symbols_file", help="Path to the customasm symbols file")
    parser.add_argument("--clean", action="store_true", help="Replace values entirely with symbols instead of annotating them")
    parser.add_argument("--no-color", action="store_true", help="Disable ANSI color codes")
    args = parser.parse_args()

    symbols = load_symbols(args.symbols_file)
    use_color = not args.no_color

    C_RESET = "\033[0m" if use_color else ""
    C_GRAY = "\033[90m" if use_color else ""
    C_READ = "\033[92m" if use_color else ""   # Bright Green for READ >
    C_WRITE = "\033[91m" if use_color else ""  # Bright Red for WRITE <

    mem_open = f"{C_GRAY}mem[{C_RESET}"
    mem_close = f"{C_GRAY}]{C_RESET}"

    # Regex matching "mem[0x0010]> 0x0020" or "mem[0x0010]< 0x0020"
    trace_re = re.compile(r'mem\[(0x[0-9a-fA-F]+)\]\s*([><])\s*(0x[0-9a-fA-F]+)')

    # Alignment width depending on mode
    align_width = 20 if args.clean else 35

    for line in sys.stdin:
        line_stripped = line.strip()
        match = trace_re.match(line_stripped)
        if match:
            addr_str, op, val_str = match.groups()
            addr = int(addr_str, 16)
            val = int(val_str, 16)

            is_write = (op == '<')

            translated_addr = format_match(addr, symbols, is_address=True, is_write=is_write, clean=args.clean, use_color=use_color)
            translated_val = format_match(val, symbols, is_address=False, is_write=is_write, clean=args.clean, use_color=use_color)
            ascii_preview = format_ascii_preview(val, use_color=use_color)

            colored_op = f"{C_READ}>{C_RESET}" if op == '>' else f"{C_WRITE}<{C_RESET}"

            mem_block = f"{mem_open}{translated_addr}{mem_close}"
            padded_mem_block = pad_visible(mem_block, align_width)

            print(f"{padded_mem_block} {colored_op} {translated_val}{ascii_preview}")
        else:
            print(line, end='')

if __name__ == '__main__':
    main()
