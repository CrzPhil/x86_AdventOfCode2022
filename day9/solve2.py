from dataclasses import dataclass
import numpy as np

@dataclass
class Knot:
    x: int
    y: int
    def __sub__(self, knot):
        return Knot(self.x - knot.x, self.y - knot.y)
    def norm(self):
        return np.linalg.norm([self.x, self.y])

with open("input.txt", "r") as f:
	data = f.read()

motions = [direction_steps.split(' ') for direction_steps in data.splitlines()]
n_knots = 10
rope = [Knot(0, 0) for _ in range(n_knots)]
tail_positions = {(rope[n_knots-1].x, rope[n_knots-1].y)}

for direction, steps in motions:
    for _ in range(1, int(steps)+1):
        match direction:
            case 'R': rope[0].x += 1
            case 'L': rope[0].x -= 1
            case 'U': rope[0].y += 1
            case 'D': rope[0].y -= 1
        for k in range(n_knots-1):
            if (rope[k]- rope[k+1]).norm() >= 2:
                rope[k+1].x += (rope[k+1].x != rope[k].x) * np.sign(rope[k].x - rope[k+1].x)
                rope[k+1].y += (rope[k+1].y != rope[k].y) * np.sign(rope[k].y - rope[k+1].y)
                if k+1 == n_knots-1:
                    tail_positions.add((rope[n_knots-1].x, rope[n_knots-1].y))

print(len(tail_positions))
