# Unoptimised, ugly solution; ran low on time.

with open('input.txt', 'r') as f:
	input = f.read()

stacks = {}
start = 2

def show():
    for i in range(len(stacks)):
        print(f'{i + 1}: {stacks[i + 1]}')
    print()

def splitat(string, n):
    return [string[i:i+n] for i in range(0, len(string), n)]

def move(n, p, q):
    boxes = stacks[p][:n]
    boxes.reverse()
    del stacks[p][:n]
    stacks[q] = boxes + stacks[q]

for line in input.split('\n'):
    if line[:2] == ' 1': break
    items = splitat(line, 4)
    start += 1
    for i in range(len(items)):
        if items[i][1] == ' ':
            continue
        if i+1 in stacks:
            stacks[i+1].append(items[i][1])
        else:
            stacks[i+1] = [items[i][1]]

for line in input.split('\n')[start:]:
    if line == '': break
    l = line.split()
    move(int(l[1]), int(l[3]), int(l[5]))

out = ''
for i in range(len(stacks)):
    if len(stacks[i + 1]) > 0:
        out += stacks[i + 1][0]

print(out)
