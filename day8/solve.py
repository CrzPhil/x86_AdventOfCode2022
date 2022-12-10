
with open("input.txt", "r") as f:
	rows = [l.strip() for l in f.readlines()]

seen = set()	# will hold x,y coord of seen tree
blocked = set()	# blocked rows/cols

# Get rid of edges
#total += len(rows) + len(rows[0])
#rows = rows[1:-1]
#rows = [row[1:-1] for row in rows]



def getVisTrees(grid):
	for y, row in enumerate(rows):
		tallest = 0
		for x, tree in enumerate(row):
			if int(tree) > tallest:
				tallest = int(tree)
			else:
				isblocked = False
				for i in range(x+1, len(row[x+1:])):
					if isblocked:
						break
					if int(row[i]) >= int(tree):
						if int(row[i]) == 9:
							blocked.add((y,x))
						isblocked = True 
				if not isblocked:
					seen.add((y,x))

			if (y,x) in seen:
				continue
			if tree == 9:
				seen.add((y,x))
				blocked.add((y,x))
				break

getVisTrees(rows)
rows = list(zip(*rows[::-1]))
getVisTrees(rows)

for i in seen:
	if i[0] == 5:
		print(rows[5])
		print(i)

print(len(seen))
