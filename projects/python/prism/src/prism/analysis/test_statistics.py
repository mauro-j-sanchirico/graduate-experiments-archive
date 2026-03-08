import numpy as np
import matplotlib.pyplot as plt

##
# Accuracy computation
#
def compute_accuracy(metadata_df, column_name, threshold):
    """Computes accuracy for a metadata dataframe"""
    values = np.array(metadata_df.loc[:, column_name])
    defects = values > threshold
    correct = np.array((defects == metadata_df.loc[:, 'true_defect']))
    accuracy = np.count_nonzero(correct)/len(correct)
    return accuracy

##
# TPR and FPR for MALE Psi
#
def compute_tpr(metadata_df, column_name, threshold):
    """Computes true positive rate for a metadata dataframe"""
    values = np.array(metadata_df.loc[:, column_name])
    defects = values > threshold
    true_defects = metadata_df.loc[:, 'true_defect']
    tp = np.logical_and(defects, true_defects)
    tpr = np.count_nonzero(tp)/np.count_nonzero(true_defects)
    return tpr

def compute_fpr(metadata_df, column_name, threshold):
    """Computes false positive rate for a metadata dataframe"""
    values = np.array(metadata_df.loc[:, column_name])
    defects = values > threshold
    true_defects = metadata_df.loc[:, 'true_defect']
    fp = np.logical_and(defects, np.logical_not(true_defects))
    fpr = np.count_nonzero(fp)/np.count_nonzero(true_defects)
    return fpr

def compute_roc(
        metadata_df, column_name,
        min_threshold, max_threshold, n_steps):
    """Computes a ROC curve for the given column"""
    thresholds = np.linspace(min_threshold, max_threshold, n_steps)
    tprs = np.zeros(thresholds.shape)
    fprs = np.zeros(thresholds.shape)

    for idx, threshold in enumerate(thresholds):
        tprs[idx] = compute_tpr(metadata_df, column_name, threshold)
        fprs[idx] = compute_fpr(metadata_df, column_name, threshold)
    
    return tprs, fprs, thresholds

def compute_accuracy_sweep(
        metadata_df, column_name,
        min_threshold, max_threshold, n_steps):
    """Computes a ROC curve for the given column"""
    thresholds = np.linspace(min_threshold, max_threshold, n_steps)
    accuracy = np.zeros(thresholds.shape)

    for idx, threshold in enumerate(thresholds):
        accuracy[idx] = compute_accuracy(
            metadata_df, column_name, threshold)
    
    return accuracy, thresholds

def get_best_accuracy(
        metadata_df, column_name,
        min_threshold, max_threshold, n_steps):
    """Gets best accuracy and cooresponding threshold"""
    thresholds = np.linspace(min_threshold, max_threshold, n_steps)
    accuracy = np.zeros(thresholds.shape)

    for idx, threshold in enumerate(thresholds):
        accuracy[idx] = compute_accuracy(
            metadata_df, column_name, threshold)

    max_idx = np.argmax(accuracy)

    return accuracy[max_idx], thresholds[max_idx]


def plot_tpr_fpr(
        metadata_df, column_names, labels, styles,
        min_threshold, max_threshold, n_steps):
    """Plots a TPR Curve"""
    
    fig, ax = plt.subplots(2, 1, figsize=(9,7), constrained_layout=True)

    for column_name, label, style in zip(column_names, labels, styles):
        tprs, fprs, thresholds = compute_roc(
            metadata_df, column_name,
            min_threshold, max_threshold, n_steps)

        # Plot the function and the approximation
        ax[0].plot(
            thresholds, tprs,
            lw=2, ls=style, color='black',
            label=label)

        ax[1].plot(
            thresholds, fprs,
            lw=2, ls=style, color='black',
            label=label)

    ax[0].grid()
    ax[0].set_ylabel('TPR')

    ax[1].grid()
    ax[1].set_ylabel('FPR')

def plot_roc(
        metadata_df, column_names, labels, styles,
        min_threshold, max_threshold, n_steps):
    """Plots a ROC Curve"""
    
    fig, ax = plt.subplots(1, 1, figsize=(9,7), constrained_layout=True)

    for column_name, label, style in zip(column_names, labels, styles):
        tprs, fprs, thresholds = compute_roc(
            metadata_df, column_name,
            min_threshold, max_threshold, n_steps)

        # Plot the function and the approximation
        ax.plot(
            fprs, tprs,
            lw=2, ls=style, color='black', marker='x',
            label=label)

    ax.grid()

def plot_accuracy(
        metadata_df, column_names, labels, styles,
        min_threshold, max_threshold, n_steps):
    """Plots a ROC Curve"""
    
    fig, ax = plt.subplots(1, 1, figsize=(9,7), constrained_layout=True)

    for column_name, label, style in zip(column_names, labels, styles):
        accuracy, thresholds = compute_accuracy_sweep(
            metadata_df, column_name,
            min_threshold, max_threshold, n_steps)

        # Plot the function and the approximation
        ax.plot(
            thresholds, accuracy,
            lw=2, ls=style, color='black', marker='x',
            label=label)

    ax.grid()