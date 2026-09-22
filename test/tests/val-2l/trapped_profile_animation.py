"""
Animate mobile and trapped deuterium concentration profiles over the TDS ramp.

Current Layout (2 x 2):
  [0,0] Mobile  – whole domain (0–200 µm)
  [0,1] Mobile  – near surface (0–1 µm)
  [1,0] Trapped – bulk & near surface (0–7 µm)
  [1,1] Trapped – near surface (0–1 µm)

A temperature-ramp axes sits above the panels; a marker tracks the current frame.
This script is modular, so add and remove panels as traps are changed and added.
"""

import argparse
from pathlib import Path

import matplotlib.animation as animation
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# File paths
SCRIPT_DIR = Path(__file__).resolve().parent
GOLD_DIR = SCRIPT_DIR / "gold"
MOBILE_DIR = GOLD_DIR / "deuterium_mobile_concentration_profile"
TRAPPED_DIR = GOLD_DIR / "deuterium_trapped_concentration_profile"
MOBILE_COL = "mobile"
TRAPPED_COL = "trapped_1"
MAIN_CSV = GOLD_DIR / "val-2l_out.csv"
OUTPUT_FILE = SCRIPT_DIR / "val-2l_profile_animation.gif"

# Animation settings
FRAME_STRIDE = 1
FPS = 8
OUTPUT_DPI = 100
FIGURE_SIZE = (9, 6.75)

# Panel definitions
# Each entry: (row, col, species, label, x_min, x_max)
PANELS = [
    (0, 0, "mobile", "Mobile – whole domain", 0.0, 200.0),
    (0, 1, "mobile", "Mobile – near surface", 0.0, 1.0),
    (1, 0, "trapped", "Trapped – bulk & near surface", 0.0, 7.0),
    (1, 1, "trapped", "Trapped – near surface", 0.0, 1.0),
]

COLOR_MOBILE = "steelblue"
COLOR_TRAPPED = "darkorange"
COLOR_TRAP_BOUNDARY = "dimgray"


# Helpers


def detect_value_column(df, hint):
    cols = list(df.columns)
    if hint in cols:
        return hint
    matches = [c for c in cols if hint in c]
    if matches:
        return matches[0]
    candidates = [c for c in cols if c not in ("x", "id")]
    if candidates:
        print(f"  Warning: '{hint}' not found; using '{candidates[0]}'.")
        return candidates[0]
    raise KeyError(f"Cannot find value column in {cols}; expected '{hint}'.")


def profile_number(path):
    """Return the output number at the end of a profile CSV filename."""
    return int(path.stem.rsplit("_", maxsplit=1)[-1])


def load_profile_series(directory, col_hint, scale=1.0):
    files = sorted(directory.glob("val-2l_out_*.csv"), key=profile_number)
    if not files:
        raise FileNotFoundError(
            f"No profile CSVs found in '{directory}'.\n"
            "Check that the VectorPostprocessor output block is active in val-2l.i."
        )
    xs, cs = [], []
    col_name = None
    for f in files:
        df = pd.read_csv(f, skipinitialspace=True).sort_values("x")
        if col_name is None:
            col_name = detect_value_column(df, col_hint)
        xs.append(df["x"].values)
        cs.append(df[col_name].values * scale)
    return xs, cs


def global_ylim(c_series, x_series, x_min, x_max, pad=0.08):
    masked = [c[(x >= x_min) & (x <= x_max)] for c, x in zip(c_series, x_series)]
    g_max = max((v.max() for v in masked if v.size), default=0.0)
    return 0.0, max(g_max * (1.0 + pad), 1e-30)


def region_mask(x, x_min, x_max):
    return (x >= x_min) & (x <= x_max)


# Main


def build_animation(
    show=False,
    frame_stride=FRAME_STRIDE,
    fps=FPS,
    dpi=OUTPUT_DPI,
    output_file=OUTPUT_FILE,
):
    if frame_stride < 1:
        raise ValueError("frame_stride must be at least 1.")
    if fps <= 0:
        raise ValueError("fps must be positive.")
    if dpi <= 0:
        raise ValueError("dpi must be positive.")

    # Scalar CSV for time and temperature
    main_df = pd.read_csv(MAIN_CSV)
    required_columns = {"time", "temperature", "trap_per_free", "trap_depth"}
    missing_columns = required_columns.difference(main_df.columns)
    if missing_columns:
        raise KeyError(
            f"Missing required columns in '{MAIN_CSV}': "
            f"{', '.join(sorted(missing_columns))}"
        )

    all_times = main_df["time"].values
    all_temps = main_df["temperature"].values
    trap_per_free = main_df["trap_per_free"].iloc[0]
    trap_boundary = main_df["trap_depth"].iloc[0]

    # Load profile series
    mob_xs, mob_cs = load_profile_series(MOBILE_DIR, MOBILE_COL, scale=1.0)
    trp_xs, trp_cs = load_profile_series(TRAPPED_DIR, TRAPPED_COL, scale=trap_per_free)
    if len(mob_xs) != len(trp_xs):
        raise ValueError(
            "The mobile and trapped profile directories contain different numbers "
            f"of files ({len(mob_xs)} and {len(trp_xs)}, respectively)."
        )

    n_frames = len(mob_xs)
    if n_frames == len(all_times):
        # The profile output includes the initial state at t = 0.
        time_offset = 0
    elif all_times[0] == 0.0 and n_frames == len(all_times) - 1:
        # The scalar CSV includes t = 0, but profiles begin at the first timestep end.
        time_offset = 1
    else:
        raise ValueError(
            f"'{MAIN_CSV}' contains {len(all_times)} time rows, while the profile "
            f"directories contain {n_frames} frames. Expected either one profile "
            "per CSV row or one fewer profile when the CSV includes an initial row."
        )

    def frame_metadata(i):
        row = i + time_offset
        return all_times[row], all_temps[row]

    frame_indices = range(0, n_frames, frame_stride)

    series = {
        "mobile": (mob_xs, mob_cs, COLOR_MOBILE),
        "trapped": (trp_xs, trp_cs, COLOR_TRAPPED),
    }

    # Figure: temperature ramp on top, 2x2 panels below
    fig = plt.figure(figsize=FIGURE_SIZE)
    # Reserve top 15% for temperature axes, bottom 85% for the 2x2 grid
    temp_ax = fig.add_axes([0.10, 0.88, 0.82, 0.09])
    gs = fig.add_gridspec(
        2, 2, left=0.10, right=0.92, top=0.82, bottom=0.07, hspace=0.45, wspace=0.35
    )
    axes = gs.subplots()

    # Temperature ramp axes
    temp_ax.plot(all_times, all_temps, color="firebrick", linewidth=1.5)
    (temp_marker,) = temp_ax.plot(
        all_times[0], all_temps[0], "o", color="firebrick", markersize=6, zorder=5
    )
    temp_ax.set_xlim(0, all_times[-1])
    temp_ax.set_ylim(all_temps.min() * 0.95, all_temps.max() * 1.05)
    temp_ax.set_xlabel("Time (s)", fontsize=8)
    temp_ax.set_ylabel("T (K)", fontsize=8)
    temp_ax.tick_params(labelsize=7)
    temp_ax.grid(True, linestyle="--", alpha=0.35)
    state_text = temp_ax.text(
        0.99,
        0.90,
        "",
        transform=temp_ax.transAxes,
        ha="right",
        va="top",
        fontsize=8,
    )

    # Concentration panels
    lines = {}

    for row, col, species, label, xlo, xhi in PANELS:
        xs, cs, color = series[species]
        ax = axes[row, col]

        ylim = global_ylim(cs, xs, xlo, xhi)
        mask = region_mask(xs[0], xlo, xhi)
        (ln,) = ax.plot(xs[0][mask], cs[0][mask], color=color, linewidth=1.6)
        lines[(row, col)] = ln

        ax.set_xlim(xlo, xhi)
        ax.set_ylim(*ylim)
        ax.set_title(label, fontsize=9, pad=4)
        ax.set_xlabel("Position (µm)", fontsize=8)
        ax.set_ylabel("Concentration (at·µm⁻³)", fontsize=8)
        ax.grid(True, linestyle="--", alpha=0.35)
        ax.ticklabel_format(axis="y", style="sci", scilimits=(0, 0))

        if xlo <= trap_boundary <= xhi:
            ax.axvline(
                trap_boundary,
                color=COLOR_TRAP_BOUNDARY,
                linestyle=":",
                linewidth=1.1,
                label=f"Trap edge ({trap_boundary} µm)",
            )
            ax.legend(fontsize=7, loc="upper right")

    # Animation update
    def update(frame):
        time, temperature = frame_metadata(frame)
        temp_marker.set_data([time], [temperature])
        state_text.set_text(f"t = {time:.0f} s, T = {temperature:.1f} K")

        for row, col, species, _, xlo, xhi in PANELS:
            xs, cs, _ = series[species]
            mask = region_mask(xs[frame], xlo, xhi)
            lines[(row, col)].set_data(xs[frame][mask], cs[frame][mask])

        return list(lines.values()) + [temp_marker, state_text]

    ani = animation.FuncAnimation(
        fig,
        update,
        frames=frame_indices,
        interval=1000 / fps,
        blit=True,
    )

    if show:
        plt.show()
    else:
        output_path = Path(output_file)
        if not output_path.is_absolute():
            output_path = SCRIPT_DIR / output_path
        print(f"Saving animation to {output_path} …")
        ani.save(output_path, writer="pillow", fps=fps, dpi=dpi)
        print("Done.")

    plt.close(fig)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Animate mobile and trapped D profiles from val-2l TMAP8 output."
    )
    parser.add_argument(
        "--show",
        action="store_true",
        help="Preview interactively instead of saving to file.",
    )
    parser.add_argument(
        "--frame-stride",
        type=int,
        default=FRAME_STRIDE,
        help="Include every Nth profile in the animation (default: %(default)s).",
    )
    parser.add_argument(
        "--fps",
        type=float,
        default=FPS,
        help="Set the saved or interactive playback rate (default: %(default)s).",
    )
    parser.add_argument(
        "--dpi",
        type=int,
        default=OUTPUT_DPI,
        help="Set the saved GIF resolution in dots per inch (default: %(default)s).",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=OUTPUT_FILE,
        help="Set the output GIF path (default: %(default)s).",
    )
    args = parser.parse_args()
    build_animation(
        show=args.show,
        frame_stride=args.frame_stride,
        fps=args.fps,
        dpi=args.dpi,
        output_file=args.output,
    )
