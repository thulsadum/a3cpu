from .base import Token


class ControlFlowToken(Token):
    def __init__(self):
        super().__init__()
        self.symbol = None


class IfToken(ControlFlowToken):
    pass


class ElseToken(ControlFlowToken):

    def __init__(self):
        super().__init__()
        self.symbol2 = None


class ThenToken(ControlFlowToken):
    pass


class BeginToken(ControlFlowToken):
    pass


class UntilToken(ControlFlowToken):
    pass

