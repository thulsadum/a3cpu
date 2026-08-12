#!/usr/bin/env python3
import sys
import re
import argparse

# FLAGS register bit positions (LSB-0 notation)
# Corrected according to actual hardware spec:
FLAG_HALT   = 0  # Bit 0: Halt (H)
FLAG_IE     = 1  # Bit 1: Interrupt Enable (I)
FLAG_CARRY  = 4  # Bit 4: Carry (C)
FLAG_ZERO   = 5  # Bit 5: Zero (Z)
FLAG_OVER   = 6  # Bit 6: Overflow (V)
FLAG_NEG    = 7  # Bit 7: Negative (N)

def load_symbols(sym_file):
    symbols = {}
    if not sym_file:
        return symbols
    pattern = re.compile(r'^\s*([a-zA-Z_][a-zA-Z0-9_.]*)\s*=\s*(0x[0-9a-fA-F]+|[0-9]+)')
    try:
        with open(sym_file, 'r') as f:
            for line in f:
                match = pattern.match(line)
                if match:
                    name, val_str = match.groups()
                    if name.startswith('OP_'):
                        continue
                    val = int(val_str, 16) if val_str.lower().startswith('0x') else int(val_str)
                    if val not in symbols:
                        symbols[val] = []
                    symbols[val].append(name)
    except Exception as e:
        print(f"Error loading symbols: {e}", file=sys.stderr)
    return symbols

def visible_len(s):
    # Strips ANSI escape sequences to calculate the printable width
    return len(re.sub(r'\033\[[0-9;]*m', '', s))

def pad_visible(s, w):
    v_len = visible_len(s)
    return s + ' ' * max(0, w - v_len)

def format_pc_mar(name, val, symbols, changed, clean, use_color):
    val_str = f"0x{val:04X}"
    resolved = None
    
    # Resolve symbols that are NOT opcodes
    if val in symbols:
        non_oc = [s for s in symbols[val] if not s.startswith('OC_')]
        if non_oc:
            resolved = non_oc[0]

    C_RESET = "\033[0m" if use_color else ""
    C_CHANGED = "\033[1;33m" if use_color else ""  # Bold Yellow for changed
    C_UNCHANGED = "\033[90m" if use_color else ""  # Grey for unchanged
    C_SYM = "\033[36m" if use_color else ""        # Cyan for symbols
    
    if clean and resolved:
        display_val = resolved
    elif resolved:
        display_val = f"{val_str} ({C_SYM}{resolved}{C_RESET if use_color else ''})"
    else:
        display_val = val_str

    if changed:
        return f"{name}:{C_CHANGED}{display_val}{C_RESET}"
    else:
        return f"{name}:{C_UNCHANGED}{display_val}{C_RESET}"

def format_ir(name, val, symbols, changed, clean, use_color):
    val_str = f"0x{val:04X}"
    high = (val >> 8) & 0xFF
    low = val & 0xFF
    resolved = None
    
    # Resolve symbols that ARE opcodes (start with OC_) in the high byte
    if high in symbols:
        op_syms = [s for s in symbols[high] if s.startswith('OC_')]
        if op_syms:
            opcode_name = op_syms[0]
            if low > 0:
                resolved = f"{opcode_name} 0x{low:02X}"
            else:
                resolved = opcode_name

    C_RESET = "\033[0m" if use_color else ""
    C_CHANGED = "\033[1;33m" if use_color else ""  # Bold Yellow for changed
    C_UNCHANGED = "\033[90m" if use_color else ""  # Grey for unchanged
    C_OP = "\033[32m" if use_color else ""         # Green for opcodes

    if clean and resolved:
        display_val = f"{C_OP}{resolved}{C_RESET if use_color else ''}"
    elif resolved:
        display_val = f"{val_str} ({C_OP}{resolved}{C_RESET if use_color else ''})"
    else:
        display_val = val_str

    if changed:
        return f"{name}:{C_CHANGED}{display_val}{C_RESET}"
    else:
        return f"{name}:{C_UNCHANGED}{display_val}{C_RESET}"

def format_flags(name, val, changed, use_color):
    val_str = f"0x{val:04X}"
    
    active_flags = []
    if val & (1 << FLAG_HALT): active_flags.append("H")
    if val & (1 << FLAG_IE): active_flags.append("I")
    if val & (1 << FLAG_CARRY): active_flags.append("C")
    if val & (1 << FLAG_ZERO): active_flags.append("Z")
    if val & (1 << FLAG_OVER): active_flags.append("V")
    if val & (1 << FLAG_NEG): active_flags.append("N")
    
    C_RESET = "\033[0m" if use_color else ""
    C_CHANGED = "\033[1;33m" if use_color else ""  # Bold Yellow for changed
    C_UNCHANGED = "\033[90m" if use_color else ""  # Grey for unchanged
    C_FLAG = "\033[1;35m" if use_color else ""      # Bold Magenta for active flags
    
    if active_flags:
        flags_str = ",".join(active_flags)
        display_val = f"{val_str} ({C_FLAG}{flags_str}{C_RESET if use_color else ''})"
    else:
        display_val = val_str

    if changed:
        return f"{name}:{C_CHANGED}{display_val}{C_RESET}"
    else:
        return f"{name}:{C_UNCHANGED}{display_val}{C_RESET}"

def format_generic(name, val, changed, use_color):
    val_str = f"0x{val:04X}"
    
    C_RESET = "\033[0m" if use_color else ""
    C_CHANGED = "\033[1;33m" if use_color else ""  # Bold Yellow for changed
    C_UNCHANGED = "\033[90m" if use_color else ""  # Grey for unchanged
    
    if changed:
        return f"{name}:{C_CHANGED}{val_str}{C_RESET}"
    else:
        return f"{name}:{C_UNCHANGED}{val_str}{C_RESET}"

def main():
    parser = argparse.ArgumentParser(description="Translate ac3pu register trace hex values into beautiful annotated output.")
    parser.add_argument("symbols_file", nargs="?", default=None, help="Path to the customasm symbols file")
    parser.add_argument("--clean", action="store_true", help="Replace values entirely with symbols instead of annotating them")
    parser.add_argument("--no-color", action="store_true", help="Disable ANSI color codes")
    args = parser.parse_args()

    symbols = load_symbols(args.symbols_file)
    use_color = not args.no_color

    C_RESET = "\033[0m" if use_color else ""
    C_PIPE = "\033[90m | \033[0m" if use_color else " | "

    # Width configurations for perfect column alignment
    widths = {
        'CYCLE': 9,
        'PC': 24 if not args.clean else 16,
        'MAR': 24 if not args.clean else 16,
        'MDR': 12,
        'IR': 28 if not args.clean else 20,
        'ACC': 12,
        'FLAGS': 18
    }

    # Match CYCLE:xxx | PC:0xVAL | MAR:0xVAL ...
    kv_pattern = re.compile(r'(\w+):(0x[0-9a-fA-F]+|\d+)')

    prev_state = {}

    for line in sys.stdin:
        line_stripped = line.strip()
        matches = kv_pattern.findall(line_stripped)
        
        current_keys = [m[0] for m in matches]
        if 'CYCLE' in current_keys and 'PC' in current_keys:
            current_state = {k: v for k, v in matches}
            
            output_parts = []
            
            # 1. Format CYCLE
            cycle_str = current_state.get('CYCLE', '000')
            formatted_cycle = f"CYCLE:{cycle_str}"
            output_parts.append(pad_visible(formatted_cycle, widths['CYCLE']))
            
            # For each register, determine if it changed
            registers = ['PC', 'MAR', 'MDR', 'IR', 'ACC', 'FLAGS']
            for reg in registers:
                if reg in current_state:
                    val_str = current_state[reg]
                    val = int(val_str, 16)
                    
                    prev_val_str = prev_state.get(reg)
                    changed = False
                    if prev_val_str is not None:
                        prev_val = int(prev_val_str, 16)
                        changed = (val != prev_val)
                    
                    # Format based on register type
                    if reg in ('PC', 'MAR'):
                        formatted = format_pc_mar(reg, val, symbols, changed, args.clean, use_color)
                    elif reg == 'IR':
                        formatted = format_ir(reg, val, symbols, changed, args.clean, use_color)
                    elif reg == 'FLAGS':
                        formatted = format_flags(reg, val, changed, use_color)
                    else:
                        formatted = format_generic(reg, val, changed, use_color)
                        
                    output_parts.append(pad_visible(formatted, widths[reg]))
                    
            # Print the formatted line with colored pipe separators
            print(C_PIPE.join(output_parts))
            
            # Update previous state
            prev_state = current_state
        else:
            # If the line doesn't match a register trace, print as-is
            print(line, end='')

if __name__ == '__main__':
    main()
