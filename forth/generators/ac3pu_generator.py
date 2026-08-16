from semantics import words
from parsing.tokens import *

class Ac3puGenerator:

    def __init__(self):
        self.definitions = {}

    def gen_tok(self, token):
        match token:
            case WordToken(word):
                word = words.CORE[str(word).upper()]
                return f"{word.asm}"
            case DefinitionToken(symbol) as dt:
                # TO DO add function pro-/epilogue
                self.definitions[symbol] = f""";; definition of `{symbol}`
  {dt.token}: #res 1
{self.generate(dt.tokens, emit_definitions=False)}
  ret {dt.token}
  ;; end of definition of `{symbol}`
                """
                return ''
            case token:
                return str(token)

    def generate(self, tokens, emit_definitions=True):
        asm = [ self.gen_tok(tok) for tok in tokens ]
        if emit_definitions:
            asm.extend(self.definitions.values())
        return "\n".join(asm)

