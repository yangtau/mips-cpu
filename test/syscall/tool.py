def gen(b0, b1, b2, b3, txt_file):
    xs = [[], [], [], []]
    for i, f in enumerate([b0, b1, b2, b3]):
        with open(f) as file:
            xs[i] = file.readlines()
        xs[i] = [x.strip() for x in xs[i]]
        xs[i] = [x for x in xs[i] if x != '']
    i, j = 0, 0
    res = []
    while j < len(xs[0]):
        if xs[0][j].startswith('@'):
            n = int(xs[0][j][1:], 16)
            while i < n:
                res.append('00000000\n')
                i += 1
        else:
            res.append(xs[3][j]+xs[2][j]+xs[1][j]+xs[0][j]+'\n')
            i += 1
        j += 1
    with open(txt_file, "w") as file:
        file.writelines(res)


if __name__ == "__main__":
    gen('ram_p0.txt', 'ram_p1.txt', 'ram_p2.txt', 'ram_p3.txt', 'im2.txt')
    gen('ram_b0.txt', 'ram_b1.txt', 'ram_b2.txt', 'ram_b3.txt', 'im1.txt')
