with open("input.txt", "r") as f:
        lines = [l.strip() for l in f.readlines()]

total = 0
lines.pop(len(lines)-1)

for line in lines:
		f, s = line.split(',')
		x = f.split('-')
		y = s.split('-')
		if int(x[0]) <= int(y[1]) and int(x[1]) >= int(y[0]):
			total += 1

print(total)
