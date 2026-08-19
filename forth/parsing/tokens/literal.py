from enum import Enum, auto

from .base import Token


class LiteralRepresentation(Enum):
    DECIMAL = auto()
    HEX = auto()
    CHAR = auto()


class LiteralToken(Token):
    __match_args__ = ('value',)

    def __init__(self, value, file, line, column, repr  = LiteralRepresentation.DECIMAL):
        super().__init__(file, line, column)
        self.value = value
        self.repr = repr


