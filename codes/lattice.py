import matplotlib.pyplot as plt
from argparse import ArgumentParser


def plot_cell(ax, plot_type="lattice"):
    for i in range(-1, 2):
        for j in range(-1, 2):
            for k in range(-1, 2):
                if i == j == k == 0:
                    ax.scatter(i, j, k, c="orange", s=64, depthshade=True)
                else:
                    ax.scatter(i, j, k, c="black", s=16, depthshade=True)
    neighbors = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]
    if plot_type == "lattice":
        ax.quiver(0, 0, 0, 1, 0, 0, color="red", arrow_length_ratio=0.2)
        ax.quiver(0, 0, 0, 0, 1, 0, color="green", arrow_length_ratio=0.2)
        ax.quiver(0, 0, 0, 0, 0, 1, color="blue", arrow_length_ratio=0.2)
        ax.text(1.1, 0, 0, "$\mathbf{a}$", fontsize=15, color="red")
        ax.text(0.1, 1, 0, "$\mathbf{b}$", fontsize=15, color="green")
        ax.text(0.1, 0, 1, "$\mathbf{c}$", fontsize=15, color="blue")
    elif plot_type == "lattice-neighbors":
        for n in neighbors:
            ax.plot([0, n[0]], [0, n[1]], [0, n[2]], c="orange", linewidth=2)


def main(interactive=False, output_path=".", plot_type="lattice"):
    fig = plt.figure()
    ax = fig.add_subplot(projection="3d")
    ax.xaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.yaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.zaxis._axinfo["grid"]["color"] = (1, 1, 1, 0)
    ax.set_xlabel("x", fontsize=15)
    ax.set_ylabel("y", fontsize=15)
    ax.set_zlabel("z", fontsize=15)
    ax.set_xticks([-1, 0, 1], [-1, 0, 1])
    ax.set_yticks([-1, 0, 1], [-1, 0, 1])
    ax.set_zticks([-1, 0, 1], [-1, 0, 1])
    plot_cell(ax=ax, plot_type=plot_type)
    ax.view_init(elev=39, azim=-68)
    if interactive:
        plt.show()
    else:
        plt.savefig(f"{output_path}/{plot_type}.pdf", dpi=400)


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
    parser.add_argument(
        "-pt",
        "--plot-type",
        type=str,
        choices=["lattice", "lattice-neighbors"],
        default="lattice",
        help="Which plot to plot.",
    )
    args = parser.parse_args()
    main(**vars(args))
