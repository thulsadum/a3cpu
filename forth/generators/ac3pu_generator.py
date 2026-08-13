from semantics import words
from parsing.tokens import *

class Ac3puGenerator:

    def gen_tok(self, token):
        if isinstance(token, WordToken):
            word = words.CORE[str(token).upper()]
            return f"jal {word.xt}"
        else:
            return str(token)

    def generate(self, tokens):
        asm = [ self.gen_tok(tok) for tok in tokens ]
        return "\n".join(asm)

