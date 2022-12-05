def main():
	with open("input.txt", "r") as f:
		lines = f.readlines()
	mm = 0
	tmp = 0
	for i in lines:
		if i != '\n':
			tmp += int(i)
		else:
			if tmp > mm:
				mm = tmp
			tmp = 0

	return mm 

print(main())
