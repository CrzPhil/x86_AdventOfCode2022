def main():
	with open("input.txt", "r") as f:
		lines = f.readlines()

	total = 0
	lines = [l.strip() for l in lines]

	for line in lines:
		tmp = len(line)
		comp = line[:tmp//2]
		for i in comp:
			if i in line[tmp//2:]:
				print(i)
				if ord(i) > 90:
					total += ord(i) % 96
					break
				else:
					total += (ord(i) % 64) + 26
					break
	return total

if __name__ == "__main__":
	print(main())
#	abc = "abcdefghijklmnopqrstuvwxyz"
#	ABC = abc.upper()
#	for i in ABC:
#		print((ord(i) % 64)+26)

