def rekS(n):
    nFloat = float(n)
    if nFloat > 1.0:
        re = rekS(nFloat - 1.0) + (1.0 / nFloat)
        print(re)
        return re
    elif nFloat == 1.0:
        return 1.0
    else:
        return "FEHLER"

def sumS(n):
    re = 0.0;
    for i in range(n):
        if (n - i) != 0:
            re += (1.0 / (n - i))
            print(re)
    return re

n = 2 ** 5
s_1 = rekS(n)

print("_____________")

s_2 = sumS(n)

print("_____________")

print(s_1, s_2)
print(s_1 == s_2)

def V(n):
    if n == 1:
        return 0.0;
    elif n > 1:
        re = 2 * V(n / 2) + n
        print(re)
        return re
    else:
        return "FEHLER"

V(n)

potenzen = []
ergs = []
test = []
for i in range(10):
    if i != 0:
        potenzen.append(2 ** i)
        ergs.append(V(2 ** i))
        test.append(float((2 ** i) * i))

for i in range(len(ergs)):
    print(potenzen[i], ergs[i], test[i])

def kurzV(n):

    return
print(V(n), kurzV(n))
