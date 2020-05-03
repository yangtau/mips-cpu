import os

def format_file(filename: str):
    with open(filename) as f:
        lines = f.readlines()
    lines = [l.replace('\r\n', '\n') for l in lines]
    lines = [l.replace('\t', '    ') for l in lines]
    with open(filename, "w") as f:
        f.writelines(lines)

if __name__ == "__main__":
    files = os.listdir()    
    for f in files:
        if f.endswith('.v'):
            format_file(f)