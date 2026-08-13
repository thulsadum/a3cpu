import string


class Word:

    @classmethod
    def stack_effect_repr(pop: int, push: int):
        pops = ' '.join([string.asciii_lowercase[i] for i in range(pop)])
        pushes = ' '.join([string.asciii_lowercase[i] for i in range(push)])
        return f'( {pops} -- {pushes})'



    def __init__(self, word, * ,pop_count = 0, push_count = 0, asm = "", xt):
        self.word = word
        self.asm = asm
        self.pop_count = pop_count
        self.push_count = push_count
        self.xt = xt



    def __str__(self):
        return self.asm



    def __repr__(self):
        return self.word


