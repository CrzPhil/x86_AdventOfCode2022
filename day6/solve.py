
with open("input.txt", "r") as f:
	lines = f.read().strip()

for i, l in enumerate(lines):
	try:
		if len(set(lines[i:i+14])) == 14:
			print(lines[i:i+14])
			print(i+14)
			break
	except Exception as _:
		pass
