from .tokens import *

class Optimizer:

    def __init__(self, args):
        self.passes = args.optimize

    def optimize(self, tokens):

        result = tokens

        for i in range(self.passes):

            result = []

            for token in tokens:

                result.append(token)

                match result[-3:]:
                    case [LiteralToken(a), LiteralToken(b), WordToken("+")]:
                        result[-3:] = [LiteralToken(a+b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("-")]:
                        result[-3:] = [LiteralToken(a-b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("SHL")]:
                        result[-3:] = [LiteralToken(a<<b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("SHR")]:
                        result[-3:] = [LiteralToken(a>>b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("AND")]:
                        result[-3:] = [LiteralToken(a & b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("OR")]:
                        result[-3:] = [LiteralToken(a | b)]
                    case [LiteralToken(a), LiteralToken(b), WordToken("XOR")]:
                        result[-3:] = [LiteralToken(a ^ b)]

            tokens = result

        return result

