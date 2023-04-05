import numpy as np
import matplotlib.pyplot as plt
from math import pi, cos
from argparse import ArgumentParser

b1 = np.array((2 * pi, 0, 0))
b2 = np.array((0, 2 * pi, 0))
b3 = np.array((0, 0, 2 * pi))

points = {
    "$\Gamma$": 0 * b1 + 0 * b2 + 0 * b3,
    "M": 0.5 * b1 + 0.5 * b2 + 0 * b3,
    "R": 0.5 * b1 + 0.5 * b2 + 0.5 * b3,
    "X": 0 * b1 + 0.5 * b2 + 0 * b3,
}

path = [["$\Gamma$", "X", "M", "$\Gamma$", "R", "X"], ["M", "R"]]
labels = []
labels_c = []
n = 100
kvec = np.array([], dtype=float)
kvec_c = np.array([], dtype=float)
for subpath in path:
    for i, point in enumerate(subpath):
        if i == 0:
            if len(labels) == 0:
                labels.append(subpath[i])
                labels_c.append(0)
            else:
                labels[-1] += f"$\\vert${subpath[i]}"
        else:
            prev_point = subpath[i - 1]
            delta_k = points[point] - points[prev_point]
            labels.append(subpath[i])
            labels_c.append(np.linalg.norm(delta_k) + labels_c[-1])
            kvec = np.append(kvec, np.linspace(points[prev_point], points[point], n))
            print(
                np.linalg.norm(
                    np.linspace(points[prev_point], points[point], n), axis=1
                )
            )
            if kvec_c.shape == (0,):
                extend = np.linalg.norm(
                    np.linspace(points[prev_point], points[point], n), axis=1
                )
            else:
                extend = (
                    np.linalg.norm(np.linspace(np.zeros(3), delta_k, n), axis=1)
                    - np.linalg.norm(np.linspace(np.zeros(3), delta_k, n), axis=1)[0]
                    + kvec_c[-1]
                )

            kvec_c = np.append(
                kvec_c,
                extend,
            )

kvec = kvec.reshape(kvec.shape[0] // 3, 3)
print(kvec_c)


J = 1
S = 1
l = 1


def main_dispersion(qvec):
    return (
        2
        * S
        * J
        * 6
        * (1 - 1 / 3 * (cos(qvec[0] * l) + cos(qvec[1] * l) + cos(qvec[2] * l)))
    )


def plot_dispersion(disp_func, name, output_path):
    fig, ax = plt.subplots(figsize=(6, 3))
    ax.set_ylabel("E, meV", fontsize=20)
    ax.set_xticks(labels_c, labels, fontsize=20)
    ax.vlines(
        labels_c,
        0,
        1,
        transform=ax.get_xaxis_transform(),
        color="black",
        linewidths=0.5,
    )
    ax.set_xlim(labels_c[0], labels_c[-1])
    disp = []
    for i in kvec:
        disp.append(disp_func(i))
    ax.plot(kvec_c, disp, color="green")
    plt.savefig(f"{output_path}/{name}.pdf", dpi=400, bbox_inches="tight")


def main(output_path):
    plot_dispersion(main_dispersion, "main_dispersion", output_path=output_path)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "-op", "--output_path", type=str, default=".", help="Path to the output file."
    )

    args = parser.parse_args()
    main(**vars(args))
