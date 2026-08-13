from semantics import words

class Ac3puGenerator:

    def generate(self, tokens):
        asm = []
        vasm = []
        is_asm = False
        for op in tokens:
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
            elif op.upper() in words.CORE:
                asm.append(f"; > {op}\n  {words.CORE[op.upper()].asm}")
            else:
                print(f"Error: Unknown token '{op.upper()}'")
        return "\n".join(asm)

