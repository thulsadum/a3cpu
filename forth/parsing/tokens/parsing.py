from .base import Token


class ParsingToken(Token):
    def __init__(self):
        self.has_arg = True



class VariableToken(ParsingToken):
    pass


class CreateToken(ParsingToken):
    pass


class RequireToken(ParsingToken):
    pass


class ColonToken(ParsingToken):

    def __init__(self):
        super().__init__()
        self.symbol = None
        self.program = []



class SemicolonToken(ParsingToken):

    def __init(self):
        self.has_arg = False

