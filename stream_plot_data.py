import subprocess

import numpy as np
from matplotlib.pyplot import colormaps
from matplotlib import pyplot as plt

INPUT_NAME = "input"
d = 600
W = 20480

def plot_embedding(ax, projected, title="TDE"):
    scores = []
    for point in projected:
        scores.append(np.linalg.norm(point))
    scores = np.array(scores)
    scores_norm = (scores - np.min(scores)) / (np.max(scores) - np.min(scores))
    ax.scatter(projected[:, 0], projected[:, 1], s=8, c=colormaps["turbo"](scores_norm))
    ax.axis("off")
    ax.set_title(title, fontsize=30)


subprocess.run(["./anomaly_detection", str(d), str(W), INPUT_NAME], check=True)

fingerprints = []
with open("output/output.txt") as file:
    for line in file:
        line = line.strip()
        if line == "---NEW-FINGERPRINT-START---":
            fingerprints.append([])
        elif line:
            fingerprints[-1].append([float(v) for v in line.split(",")])

for k, points in enumerate(fingerprints):
    fig, ax = plt.subplots(nrows=1, ncols=1)
    plot_embedding(ax, np.array(points), title=f"Fingerprint {k}")
    plt.savefig(f"results/tde_{k}.png")
    plt.close(fig)