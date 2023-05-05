import numpy as np
import matplotlib.pyplot as plt
from math import pi, cos, sqrt
from argparse import ArgumentParser


# Values of the parameters
J = 1  # Exchange parameter
S = 1  # Spin
l = 1  # Length of lattice vectors
n = 6  # Number of neighbors

b1 = np.array((2 * pi / l, 0, 0))
b2 = np.array((0, 2 * pi / l, 0))
b3 = np.array((0, 0, 2 * pi / l))


def plot_dispersion(disp_func, name, output_path):
    r"""
    Plot dispersion.

    Parameters
    ----------
    disp_func : function
        Function for computing dispersion values.
    name : str
        Name for the output.
    output_path : str
        Path for the output file.
    """

    # Prepare path in reciprocal space for magnon dispersion
    points = {
        "Y": 0.5 * b1 + 0 * b2 + 0 * b3,
        "$\Gamma$": 0 * b1 + 0 * b2 + 0 * b3,
        "M": 0.5 * b1 + 0.5 * b2 + 0 * b3,
        "R": 0.5 * b1 + 0.5 * b2 + 0.5 * b3,
        "X": 0 * b1 + 0.5 * b2 + 0 * b3,
    }

    path = [["$\Gamma$", "X", "M", "$\Gamma$", "R", "X", "M", "R"]]
    labels = []  # Labels of high symmetry points
    labels_c = []  # Coordinates of high symmetry points
    n = 100
    kvec = np.array([], dtype=float)  # array of k vectors
    kvec_c = np.array([], dtype=float)  # array of linearised coordinates of k vectors
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
                kvec = np.append(
                    kvec, np.linspace(points[prev_point], points[point], n)
                )
                if kvec_c.shape == (0,):
                    extend = np.linalg.norm(
                        np.linspace(np.zeros(3), delta_k, n), axis=1
                    )
                else:
                    extend = (
                        np.linalg.norm(np.linspace(np.zeros(3), delta_k, n), axis=1)
                        - np.linalg.norm(np.linspace(np.zeros(3), delta_k, n), axis=1)[
                            0
                        ]
                        + kvec_c[-1]
                    )

                kvec_c = np.append(
                    kvec_c,
                    extend,
                )

    kvec = kvec.reshape(kvec.shape[0] // 3, 3)

    # Plot dispersion
    fig, ax = plt.subplots(figsize=(6, 3))
    ax.set_ylabel("E, meV", fontsize=20)
    ax.set_xticks(labels_c, labels, fontsize=20)
    yticks = [0, 8, 16, 24]
    ax.set_yticks(yticks, yticks)
    ax.hlines(
        yticks,
        0,
        1,
        transform=ax.get_yaxis_transform(),
        color="black",
        linewidths=0.5,
        linestyles="dashed",
    )

    ax.vlines(
        labels_c,
        0,
        1,
        transform=ax.get_xaxis_transform(),
        color="black",
        linewidths=0.5,
    )
    ax.set_xlim(labels_c[0], labels_c[-1])
    disp_spinw = []
    disp = []
    for i in kvec:
        disp.append(disp_func(i))
        disp_spinw.append(disp_func(i)/2)
    ax.plot(kvec_c, disp,"-", label="Textbooks")
    ax.plot(kvec_c, disp_spinw, "--" ,label="SpinW")
    ax.legend(fontsize=15, framealpha=1)
    plt.savefig(f"{output_path}/{name}.pdf", dpi=400, bbox_inches="tight")


def main_dispersion(qvec):
    r"""
    Dispersion from the main formula in the text.

    E = 2JSn(1 - 1/3*(cos(kx*l) + cos(ky*l) + cos(kz*l)))
    """
    return (
        2
        * S
        * J
        * n
        * (1 - 1 / 3 * (cos(qvec[0] * l) + cos(qvec[1] * l) + cos(qvec[2] * l)))
    )


def custom_moaw(output_path):
    n = 100
    path_100 = np.linspace([0, 0, 0], b1 / 2, n)
    path_110 = np.linspace([0, 0, 0], b1 / 2 + b2 / 2, n)
    path_111 = np.linspace([0, 0, 0], b1 / 2 + b2 / 2 + b3 / 2, n)
    disp_100 = []
    disp_110 = []
    disp_111 = []
    for i in range(0, n):
        disp_100.append(main_dispersion(path_100[i]))
        disp_110.append(main_dispersion(path_110[i]))
        disp_111.append(main_dispersion(path_111[i]))
    disp_100 = np.array(disp_100)
    disp_110 = np.array(disp_110)
    disp_111 = np.array(disp_111)
    path_100 = np.linalg.norm(path_100, axis=1)
    path_110 = np.linalg.norm(path_110, axis=1)
    path_111 = np.linalg.norm(path_111, axis=1)

    fig, ax = plt.subplots(figsize=(3, 3))
    ax.set_ylabel("E / 4SJ, meV", fontsize=20)
    ax.set_xlabel("$k_{\\alpha}l$", fontsize=20)
    ax.plot(
        path_100 * l,
        disp_100 / 4 / S / J,
        linewidth=2,
        label="$\langle 100\\rangle$",
    )
    ax.plot(
        path_110 * l,
        disp_110 / 4 / S / J,
        linewidth=2,
        label="$\langle 110\\rangle$",
    )
    ax.plot(
        path_111 * l,
        disp_111 / 4 / S / J,
        linewidth=2,
        label="$\langle 111\\rangle$",
    )
    ax.legend(fontsize=12)
    ax.set_xticks(
        [pi, pi * sqrt(2), pi * sqrt(3)], ["$\pi$", "$\pi\sqrt{2}$", "$\pi\sqrt{3}$"]
    )
    ax.set_xlim(0, 6.1)
    ax.set_ylim(0, 6.1)
    ax.vlines(pi, 0, 2, color="black", linewidth=1)
    ax.vlines(pi * sqrt(2), 0, 4, color="black", linewidth=1)
    ax.vlines(pi * sqrt(3), 0, 6, color="black", linewidth=1)
    plt.savefig(f"{output_path}/custom-moaw.pdf", dpi=400, bbox_inches="tight")


# Plot dispersion with formulas from several sources.
def main(output_path):
    plot_dispersion(main_dispersion, "main_dispersion", output_path=output_path)
    custom_moaw(output_path=output_path)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "-op", "--output_path", type=str, default=".", help="Path to the output file."
    )

    args = parser.parse_args()
    main(**vars(args))
