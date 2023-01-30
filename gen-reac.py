from random import *
if __name__ == "__main__":
    for i in range(6):
        nb_reac = randint(0, 20)
        tab = []
        for j in range(nb_reac):
            caq = randint(0, 34)
            while (caq in tab):
                caq = randint(0, 34)
            tab = tab + [caq]
            if randint(0, 1) == 0:
                ronron = False
            else:
                ronron = True
            print("("+str(i+1)+", "+str(caq+1)+", "+str(ronron).upper()+"), ")
