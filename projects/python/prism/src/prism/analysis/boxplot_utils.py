import matplotlib.pyplot as plt


def make_boxplot(
        name, df, xcol, ycol, lw, color,
        figsize, fontsize, xlabel):
    """Makes a customized boxplot to use for plotting dataframes"""

    bp = df.boxplot(
        column=ycol, by=xcol,
        figsize=figsize, backend='matplotlib',
        showfliers=False, showmeans=True,
        return_type='dict')

    # Set linewidths
    [[item.set_linewidth(lw) for item in bp[key]['boxes']] for key in bp.keys()]
    [[item.set_linewidth(lw) for item in bp[key]['fliers']] for key in bp.keys()]
    [[item.set_linewidth(lw) for item in bp[key]['medians']] for key in bp.keys()]
    [[item.set_linewidth(lw) for item in bp[key]['means']] for key in bp.keys()]
    [[item.set_linewidth(lw) for item in bp[key]['whiskers']] for key in bp.keys()]
    [[item.set_linewidth(lw) for item in bp[key]['caps']] for key in bp.keys()]

    # Set the colors
    [[item.set_color(color) for item in bp[key]['boxes']] for key in bp.keys()]
    [[item.set_color(color) for item in bp[key]['fliers']] for key in bp.keys()]
    [[item.set_color(color) for item in bp[key]['medians']] for key in bp.keys()]
    [[item.set_markerfacecolor(color) for item in bp[key]['means']] for key in bp.keys()]
    [[item.set_markeredgecolor(color) for item in bp[key]['means']] for key in bp.keys()]
    [[item.set_color(color) for item in bp[key]['whiskers']] for key in bp.keys()]
    [[item.set_color(color) for item in bp[key]['caps']] for key in bp.keys()]

    # Get rid of the automatic title
    # Get rid of "boxplot grouped by" title
    plt.suptitle("")
    plt.rcParams["font.family"] = "serif"
    plt.rcParams["mathtext.fontset"] = "dejavuserif"

    # Label adjustment
    p = plt.gca()
    f = plt.gcf()
    p.set_title('', fontsize=1)
    p.tick_params(axis='y', labelsize=fontsize)
    p.tick_params(axis='x', labelsize=fontsize)
    p.set_xlabel(xlabel, fontsize=fontsize)
    p.grid('minor')

    # Save plot
    f.savefig(name, format='png')