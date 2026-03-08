from prism.networks.dnn import DNN

from datetime import datetime
import numpy as np
import pandas as pd

from verified_computing import intvmath

##
# Utils
#
def get_dated_filename(filename):

    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + "_" + dt_str + ".pickle"
    return filename


##
# Algorithms
#
def get_population_of_dnns(
    n_per_group,
    hidden_nodes_list,
    inputs_list,
    activation_list,
    lr=0.01,
    momentum=0.1,
    rho=0.9,
    eps=1e-06,
    betas=(0.9, 0.99),
    use_gpu=True,
    optimizer_method="adam",
    weight_decay=0.01,
):
    """Gets a population of DNNs"""
    population = []

    columns = [
        "activation",
        "n_inputs",
        "n_hidden_nodes_per_layer",
        "n_layers",
    ]

    metadata = []

    for n_hidden in hidden_nodes_list:
        for n_inputs in inputs_list:
            for activation in activation_list:
                for idx in range(n_per_group):
                    network = DNN(
                        net_type=activation,
                        n_inputs=n_inputs,
                        n_hidden=n_hidden,
                        lr=lr,
                        momentum=momentum,
                        rho=rho,
                        eps=eps,
                        betas=betas,
                        use_gpu=use_gpu,
                        optimizer_method=optimizer_method,
                        weight_decay=weight_decay,
                    )

                    metadata_row = [
                        activation,
                        n_inputs,
                        n_hidden[0],
                        len(network.net.layers),
                    ]

                    metadata.append(metadata_row)
                    population.append(network)

    metadata_df = pd.DataFrame(metadata, columns=columns)

    return population, metadata_df


def range_bound_dnn_numerical(target_dnn, x_min, x_max, n_points):
    """Range bounds a DNN numerically"""
    x_domain = np.random.uniform(
        low=x_min, high=x_max, size=(n_points, target_dnn.n_inputs)
    )

    x = x_domain.T

    n_layers = len(target_dnn.net.layers)

    v_min_list = []
    v_max_list = []

    for idx in range(n_layers - 1):
        v = target_dnn.get_w(idx) @ x + target_dnn.get_b(idx)
        x = np.tanh(v)
        v_min_list.append(np.min(v))
        v_max_list.append(np.max(v))

    y_range = target_dnn.get_w(n_layers - 1) @ x + target_dnn.get_b(
        n_layers - 1
    )
    y_min = np.min(y_range)
    y_max = np.max(y_range)

    return y_min, y_max, v_min_list, v_max_list


def range_bound_dnn_taylor_model(
    target_dnn, taylor_model, x_min, x_max, n_subdomains
):
    """Range bound a DNN via Taylor modeling"""

    x_intervals = intvmath.IntervalColumnVector(
        [intvmath.Interval(x_min, x_max)] * target_dnn.n_inputs
    )

    n_layers = len(target_dnn.net.layers)

    v_list = []

    # Compute initial layers
    for idx in range(n_layers - 1):
        b_vect = target_dnn.get_b(idx)
        w_mat = target_dnn.get_w(idx)
        w_times_x = intvmath.left_multiply_interval_column_vector_by_matrix(
            w_mat, x_intervals
        )
        v_vect = intvmath.add_real_vector_to_interval_column_vector(
            b_vect, w_times_x
        )
        x_intervals = taylor_model.bound_interval_vector(v_vect, n_subdomains)
        v_list.append(v_vect)

    # Compute the last layer
    b_vect = target_dnn.get_b(n_layers - 1)
    w_mat = target_dnn.get_w(n_layers - 1)

    w_times_x = intvmath.left_multiply_interval_column_vector_by_matrix(
        w_mat, x_intervals
    )

    y_range = intvmath.add_real_vector_to_interval_column_vector(
        b_vect, w_times_x
    )

    y_min = y_range.elems[0].x1
    y_max = y_range.elems[0].x2

    return y_min, y_max, v_list
