from dr_markov import MarkovWord, MarkovChar

class latest_opt:
    @staticmethod
    def research(amount): 
        return _research(amount)
class get_opt:
    @staticmethod
    def latest():
        return  latest_opt
def get():
    return get_opt


def _research(amount):
    study_box = []
    for x in range(0, amount):
        study_box.append({"filename": _gen_rand_filename(), "contents": _gen_rand_contents()})
    return study_box

def _gen_rand_filename(count = 0):
        #prevent infinite loops
        if(count > 255):
            return "ultimate.sh"

        _file = open('./fertilizer/filenames-bash')
        markov = MarkovChar(_file)

        _fn = markov.generate_markov_text(size=10) + '.sh'
        _fn = _fn.replace('\n', '')
        print(_fn)
        if(len(_fn) < 4):
            return _gen_rand_filename(count = count + 1)
        return _fn

def _gen_rand_contents():
        _file = open('./fertilizer/bash.sh')
        markov = MarkovChar(_file)
        return markov.generate_markov_text(size=3500)