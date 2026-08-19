
class ForthCompilerException(Exception):
    pass

class TokenizerError(ForthCompilerException):

    def __init__(self, file, line, column):
        self.file=file
        self.line=line
        self.column=column


    def pos(self):
        return f'{self.file}:{self.line}:{self.column}'


class MissingClosingCommentError(TokenizerError):
    def __init__(self, file, line, column):
        super().__init__(file,line,column)

    def __str__(self):
        return f"missing closing ')' in inline comment.\n{self.pos()}"

