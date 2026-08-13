


class OutputWriter:

    def __init__(self, args):
        self.args = args

    def write(self, asm):
        if self.args.output_file == '-':
            print(asm)
        else:
            with open(self.args.output_file, 'w', encoding='utf-8') as file:
                file.write(asm)
