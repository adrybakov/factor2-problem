import matplotlib.pyplot as plt
from argparse import ArgumentParser
import numpy as np
from math import pi

b1 = np.array((2 * pi, 0, 0))
b2 = np.array((0, 2 * pi, 0))
b3 = np.array((0, 0, 2 * pi))


def plot_cell(ax):
    for i, j in [(-1, -1), (-1, 1), (1, -1), (1, 1)]:
        alpha1 = alpha2 = alpha3 = 1
        style1 = style2 = style3 = "-"
        if i == -1 and j == -1:
            alpha3 = 0.3
            style3 = "--"
        if i == -1 and j == -1:
            alpha2 = 0.3
            style2 = "--"
        if i == -1 and j == -1:
            alpha1 = 0.3
            style1 = "--"

        ax.plot(
            [-pi, pi],
            [i * pi, i * pi],
            [j * pi, j * pi],
            style1,
            color="black",
            alpha=alpha1,
        )
        ax.plot(
            [i * pi, i * pi],
            [-pi, pi],
            [j * pi, j * pi],
            style2,
            color="black",
            alpha=alpha2,
        )
        ax.plot(
            [i * pi, i * pi],
            [j * pi, j * pi],
            [-pi, pi],
            style3,
            color="black",
            alpha=alpha3,
        )


def plot_vectors(ax):
    ax.plot([0, b1[0]], [0, b1[1]], [0, b1[2]], "--", color="black", alpha=0.6)
    ax.plot([0, b2[0]], [0, b2[1]], [0, b2[2]], "--", color="black", alpha=0.6)
    ax.plot([0, b3[0]], [0, b3[1]], [0, b3[2]], "--", color="black", alpha=0.6)
    ax.quiver(*tuple(b1 / 2), *tuple(b1 / 2), color="black", arrow_length_ratio=0.2)
    ax.quiver(*tuple(b2 / 2), *tuple(b2 / 2), color="black", arrow_length_ratio=0.2)
    ax.quiver(*tuple(b3 / 2), *tuple(b3 / 2), color="black", arrow_length_ratio=0.2)
    ax.text(b1[0] + 2, 0, 0, "$\mathbf{b}_1$", fontsize=15, color="black")
    ax.text(0, b2[1] + 0.2, 0, "$\mathbf{b}_2$", fontsize=15, color="black")
    ax.text(0, 0, b3[2] + 0.2, "$\mathbf{b}_3$", fontsize=15, color="black")


def plot_path(ax):
    points = {
        "$\Gamma$": [(0, 0, 0), (1, -0.5, 0)],
        "M": [(b1[0] / 2, b2[1] / 2, 0), (b1[0] / 2, b2[1] / 2 + 0.4, -1)],
        "R": [
            (b1[0] / 2, b2[1] / 2, b3[2] / 2),
            (b1[0] / 2, b2[1] / 2 - 0.5, b3[2] / 2 + 0.2),
        ],
        "X": [(0, b2[1] / 2, 0), (0, b2[1] / 2, 0.3)],
    }
    for point in points:
        ax.text(*points[point][1], point, fontsize=25, color="red")
        ax.scatter(*points[point][0], color="red", s=36)
    path = [["$\Gamma$", "X", "M", "$\Gamma$", "R", "X"], ["M", "R"]]
    for subpath in path:
        for i in range(0, len(subpath) - 1):
            line = np.array([points[subpath[i]][0], points[subpath[i + 1]][0]])
            ax.plot(line.T[0], line.T[1], line.T[2], color="red", linewidth=2)


def main(interactive=False, output_path="."):
    fig = plt.figure()
    ax = fig.add_subplot(projection="3d")
    ax.xaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.yaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.zaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.set_xlabel("$k_x$", fontsize=15)
    ax.set_ylabel("$k_y$", fontsize=15)
    ax.zaxis.set_rotate_label(False)  # disable automatic rotation
    ax.set_zlabel("$k_z$", fontsize=15, rotation=0)
    ax.set_xticks([-4, -2, 0, 2, 4], [-4, -2, 0, 2, 4])
    ax.set_yticks([-4, -2, 0, 2, 4], [-4, -2, 0, 2, 4])
    ax.set_zticks([-4, -2, 0, 2, 4], [-4, -2, 0, 2, 4])
    ax.set_xlim(-4, 4)
    ax.set_ylim(-4, 4)
    ax.set_zlim(-4, 4)
    ax.set_aspect("equal")

    plot_cell(ax=ax)
    plot_vectors(ax=ax)
    plot_path(ax)
    ax.view_init(elev=10, azim=24)
    if interactive:
        plt.show()
    else:
        plt.savefig(f"{output_path}/path.pdf", dpi=400)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "-i",
        "--interactive",
        action="store_true",
        default=False,
        help="Turn on interactive mode.",
    )
    parser.add_argument(
        "-op", "--output_path", type=str, default=".", help="Path to the output file."
    )

    args = parser.parse_args()
    main(**vars(args))
