
with open("input.txt", "r") as f:
	lines = [l.strip() for l in f.readlines()]

visited = set()

# init
h = (0, 0)
t = (0, 0)

def isNear(h, t):
	return 0 <= abs(h[0]-t[0]) <= 1 and 0 <= abs(h[1]-t[1]) <= 1

for line in lines:
	d, v = line.split(' ')	# direction, value

	for i in range(1, int(v)+1):
		tmp = h

		if d == 'U':
			h = (h[0]+1, h[1])
		elif d == 'R':
			h = (h[0], h[1]+1)
		elif d == 'D':
			h = (h[0]-1, h[1])
		else:
			h = (h[0], h[1]-1)

		if not isNear(h,t):
			# If not diagonal
			t = tmp

		print(f"{d} {v} -> {t}")
		visited.add(t)

print(len(visited))
