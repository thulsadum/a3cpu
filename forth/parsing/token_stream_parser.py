from .code_reader import CodeReader
from .tokenizer import Tokenizer
from .tokens import *

class TokenStreamParser:

    def __init__(self, args):
        self.args = args
        self.symbols = {}
        self.offset = 0
        self.cf_count = 0
        self.cf = []
        self.current_definition = None
        self.custom_words = {}


    def add_symbol(self, symbol, size = 1):
        self.symbols[symbol] = self.offset
        self.offset += size

    def clean_symbol(self, symbol):
        allowed_char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdeghijklmnopqrstuvwxyz0123456789_"
        mask_disallowed = '_'
        return self.generate_control_flow_label(prefix=''.join([c if c in allowed_char else mask_disallowed for c in symbol ]))

    def add_custom_word(self, symbol, defTok : DefinitionToken):
        self.custom_words[symbol] = defTok

    def has_symbol(self, symbol):
        return symbol in self.symbols


    def generate_control_flow_label(self,prefix="_",push=False):
        label = f'{prefix}{self.cf_count}'
        self.cf_count += 1
        if push:
            self.push_cf(label)
        return label


    def push_cf(self, label):
        self.cf.append(label)


    def pop_cf(self):
        return self.cf.pop()

    def include(self, file, once=False):
        code_reader = CodeReader(self.args, file=file)
        tokenizer = Tokenizer()
        return tokenizer.parse_code(code_reader.get_code())

    def parse(self, tokens, emit_symbol_table = True):
        max_passes = 5
        result = []
        unresolved_symbols = False

        for i in range(max_passes):

            for token in tokens:
                if self.current_definition:
                    match token:
                        case SemicolonToken():
                            cur_def = self.current_definition
                            self.current_definition = None
                            cur_def.tokens = self.parse(cur_def.tokens, emit_symbol_table=False)
                        case t:
                            self.current_definition.add_token(token)
                    continue

                result.append(token)

                match result[-2:]:

                    case [VariableToken(), SymbolToken(symbol)]:
                        self.add_symbol(symbol)
                        result[-2:] = []

                    case [RequireToken(), SymbolToken(symbol)]:
                        replacement = [CommentToken(f"--- BEGINNING OF {symbol} ---")]
                        replacement.extend(self.include(symbol, once=True))
                        replacement.append(CommentToken(f"--- END OF FILE: {symbol} ---"))
                        result[-2:] = replacement
                        unresolved_symbols = True # invoke second pass

                    case [CreateToken(), SymbolToken(symbol)]:
                        self.add_symbol(symbol, size = 0)
                        result[-2:] = []

                    case [LiteralToken(size) as lt, WordToken("CELLS")]:
                        result[-2:] = [lt]

                    case [LiteralToken(size), WordToken("ALLOT")]:
                        self.offset += size
                        result[-2:] = []

                    case [ColonToken(), SymbolToken(word)]:
                        if self.current_definition:
                            # TO DO: Raise error
                            pass
                        symbol = self.clean_symbol(word)
                        self.current_definition = DefinitionToken(word, token=f'xt_{symbol}')
                        self.add_custom_word(word, self.current_definition)
                        result[-2:] = [self.current_definition]


                match result[-1:]:
                    case [SymbolToken(symbol)]:
                        if self.has_symbol(symbol):
                            result[-1:] = [ SymbolReferenceToken(symbol, self.symbols[symbol]) ]
                        else:
                            unresolved_symbols = True

                    case [IfToken() as tok]:
                        tok.symbol = self.generate_control_flow_label(prefix="__if_",push=True)

                    case [ElseToken() as tok]:
                        tok.symbol = self.pop_cf()
                        tok.symbol2 = self.generate_control_flow_label(prefix="__else_",push=True)

                    case [ThenToken() as tok]:
                        tok.symbol = self.pop_cf()

                    case [BeginToken() as tok]:
                        tok.symbol = self.generate_control_flow_label(prefix="__begin_",push=True)

                    case [UntilToken() as tok]:
                        tok.symbol = self.pop_cf()

                    case [WordToken(word)]:
                        if word in self.custom_words:
                            result[-1] = CustomWordToken(word, token=self.custom_words[word].token)



            if not unresolved_symbols or i == max_passes-1:
                break

            tokens = result
            result = []


        if emit_symbol_table: result.insert(0, SymbolTableToken(self.offset))

        return result
