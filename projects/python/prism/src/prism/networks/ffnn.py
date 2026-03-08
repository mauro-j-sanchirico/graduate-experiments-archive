from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np
import pickle
import torch
import torch.nn as nn
import torch.optim as optim


def get_dated_filename(filename):

    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + "_" + dt_str + ".pickle"
    return filename


class TanhNet(nn.Module):
    def __init__(self, n_inputs=2, n_hidden=3):
        super(TanhNet, self).__init__()
        self.fc1 = nn.Linear(n_inputs, n_hidden)
        self.fc2 = nn.Linear(n_hidden, 1)

    def forward(self, x):
        x = self.fc1(x)
        x = torch.tanh(x)
        x = self.fc2(x)
        output = x
        return output


class ReluNet(nn.Module):
    def __init__(self, n_inputs=2, n_hidden=3):
        super(ReluNet, self).__init__()
        self.fc1 = nn.Linear(n_inputs, n_hidden)
        self.fc2 = nn.Linear(n_hidden, 1)

    def forward(self, x):
        x = self.fc1(x)
        x = torch.relu(x)
        x = self.fc2(x)
        output = x
        return output


class FFNN:
    """General FFNN Class"""

    def __init__(
        self,
        net_type="tanh",
        n_inputs=2,
        n_hidden=3,
        lr=0.001,
        momentum=0.9,
        rho=0.9,
        eps=1e-06,
        betas=(0.9, 0.999),
        weight_decay=0,
        ams_grad=False,
        use_gpu=True,
        optimizer_method="adam",
        optimization_tolerance=0.001,
        max_good_epochs=3,
        max_bad_epochs=5,
        lr_dec_factor=0.9,
        lr_inc_factor=1.01,
    ):
        """Initializes the FFNN wrapper class"""

        self.use_gpu = use_gpu
        self.optimizer_method = optimizer_method
        self.optimization_tolerance = optimization_tolerance

        self.max_good_epochs = max_good_epochs
        self.max_bad_epochs = max_bad_epochs
        self.lr_dec_factor = lr_dec_factor
        self.lr_inc_factor = lr_inc_factor

        self.n_inputs = n_inputs
        self.n_hidden = n_hidden
        self.net_type = net_type

        # Initialize the network
        if net_type == "tanh":
            self.net = TanhNet(n_inputs=n_inputs, n_hidden=n_hidden)
        else:
            self.net = ReluNet(n_inputs=n_inputs, n_hidden=n_hidden)

        # If using GPU and GPU is available set device to GPU
        if use_gpu:
            self.device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu"
            )
        else:
            self.device = torch.device("cpu")

        self.net.to(self.device)

        # Define a criterion and optimizer
        self.criterion = nn.MSELoss()

        if self.optimizer_method == "adadelta":
            self.optimizer = optim.Adadelta(
                self.net.parameters(),
                lr=lr,
                rho=rho,
                eps=eps,
                weight_decay=weight_decay,
            )
        elif self.optimizer_method == "adam":
            self.optimizer = optim.Adam(
                self.net.parameters(),
                lr=lr,
                betas=betas,
                eps=eps,
                weight_decay=weight_decay,
                amsgrad=ams_grad,
            )
        else:
            self.optimizer = optim.SGD(
                self.net.parameters(), lr=lr, momentum=momentum
            )

        self.net = self.net.float()

    def fit(self, x, y, n_epochs=2, silent=False):
        """Fits the model - like scikit fit"""

        if not silent:
            print("Fitting using device: {}".format(self.device))

        batch_size = x.shape[0]

        # Prepare for torch
        x = torch.from_numpy(x).float()
        y = torch.from_numpy(y).float()

        # get the data to the device
        x_device, y_device = x.to(self.device), y.to(self.device)

        last_running_loss = 0.0
        bad_epoch_count = 0
        good_epoch_count = 0

        for epoch in range(n_epochs):

            running_loss = 0.0

            for idx in range(batch_size):

                # Get the current sample
                x_sample = x_device[idx, :]
                y_sample = y_device[idx]

                # Zero the parameter gradients;
                # equivalent to self.optimizer.zero_grad()
                # but faster.
                for param in self.net.parameters():
                    param.grad = None

                # Resize to match the size of y_hat_sample
                y_sample = y_sample.reshape((1,))

                # Forward + backward + optimizer
                y_hat_sample = self.net(x_sample)
                loss = self.criterion(y_sample, y_hat_sample)
                loss.backward()
                self.optimizer.step()

                # Print statistics
                item_loss = loss.item()
                running_loss += item_loss

            if not silent:
                print(
                    "[%d] running loss: %f; bad epochs = %d; good epochs = %d"
                    % (
                        epoch + 1,
                        running_loss,
                        bad_epoch_count,
                        good_epoch_count,
                    )
                )

            # Stop early if running loss is less than a tolerance
            if running_loss < self.optimization_tolerance:
                if not silent:
                    print(
                        "Running loss less than tol={}".format(
                            self.optimization_tolerance
                        )
                    )
                break

            if running_loss > last_running_loss:
                bad_epoch_count += 1
                good_epoch_count = 0

            if running_loss < last_running_loss:
                good_epoch_count += 1
                bad_epoch_count = 0

            if bad_epoch_count >= self.max_bad_epochs:
                if not silent:
                    print(
                        "Decreasing learning rate by x{}...".format(
                            self.lr_dec_factor
                        )
                    )
                for param_group in self.optimizer.param_groups:
                    param_group["lr"] *= self.lr_dec_factor
                bad_epoch_count = 0

            elif good_epoch_count >= self.max_good_epochs:
                if not silent:
                    print(
                        "Increasing learning rate by x{}...".format(
                            self.lr_inc_factor
                        )
                    )
                for param_group in self.optimizer.param_groups:
                    param_group["lr"] *= self.lr_inc_factor
                good_epoch_count = 0

            last_running_loss = running_loss

        if not silent:
            print("Finished Training.")

    def infer(self, x):

        # Prep the data for torch
        x = torch.from_numpy(x).float()

        # Move the data to the device
        if self.use_gpu:
            x_device = x.to(self.device)
        else:
            x_device = x

        with torch.no_grad():
            y_device = self.net(x_device)

        if self.device == "cpu":
            y_numpy = y_device.detach().numpy()
        else:
            y_numpy = y_device.cpu().detach().numpy()

        return y_numpy

    def save(self, filename):
        filename = get_dated_filename(filename)
        with open(filename, "wb") as fh:
            pickle.dump(self, fh)
        return filename

    @classmethod
    def load(cls, filename):
        with open(filename, "rb") as f:
            return pickle.load(f)

    # Getters
    def get_w1(self):
        if self.device == "cpu":
            return self.net.fc1.weight.detach().numpy()
        else:
            return self.net.fc1.weight.cpu().detach().numpy()

    def get_b1(self):
        if self.device == "cpu":
            return self.net.fc1.bias.detach().numpy().reshape(-1, 1)
        else:
            return self.net.fc1.bias.cpu().detach().numpy().reshape(-1, 1)

    def get_w2(self):
        if self.device == "cpu":
            return self.net.fc2.weight.detach().numpy()
        else:
            return self.net.fc2.weight.cpu().detach().numpy()

    def get_b2(self):
        if self.device == "cpu":
            return self.net.fc2.bias.detach().numpy().reshape(-1, 1)
        else:
            return self.net.fc2.bias.cpu().detach().numpy().reshape(-1, 1)

    # Setters
    def set_w1(self, val):
        with torch.no_grad():
            val_device = torch.from_numpy(val)
            val_device = val_device.to(self.device).reshape(
                self.n_hidden, self.n_inputs
            )
            self.net.fc1.weight.data = val_device
            self.net = self.net.float()

    def set_b1(self, val):
        with torch.no_grad():
            val_device = torch.from_numpy(val)
            val_device = val_device.to(self.device).reshape(self.n_hidden)
            self.net.fc1.bias.data = val_device
            self.net = self.net.float()

    def set_w2(self, val):
        with torch.no_grad():
            val_device = torch.from_numpy(val)
            val_device = val_device.to(self.device).reshape(1, self.n_hidden)
            self.net.fc2.weight.data = val_device
            self.net = self.net.float()

    def set_b2(self, val):
        with torch.no_grad():
            val_device = torch.from_numpy(val)
            val_device = val_device.to(self.device).reshape(1)
            self.net.fc2.bias.data = val_device
            self.net = self.net.float()


##
# Visual Tests
#
# Basic visual tests to make sure the network is working
#


def get_test_data():
    """Produces some basic test data to try to fit a network"""

    # Create a stimulus
    n_samples = 500
    t = np.linspace(0, 2 * np.pi, n_samples)
    omega1 = 1.1
    omega2 = 1

    x1 = np.sin(omega1 * t)
    x2 = np.sin(omega2 * t)

    x = np.hstack((x1.reshape(-1, 1), x2.reshape(-1, 1)))

    # Create a target output
    y = -2 * (np.heaviside(t - np.pi, 0.5) - 0.5)

    return t, x, y


def relu(x):
    return np.maximum(x, 0)


def visual_test_fit_infer():
    """Test basic model fitting"""

    # Test stimulus and targets
    t, x, y = get_test_data()

    # Make a network
    ffnn = FFNN(
        net_type="relu",
        n_inputs=2,
        n_hidden=70,
        lr=0.01,
        momentum=0.1,
        rho=0.9,
        eps=1e-06,
        betas=(0.9, 0.99),
        use_gpu=True,
        optimizer_method="adam",
    )

    # Fit a function
    ffnn.fit(x, y, n_epochs=5)

    # Infer
    y_net = ffnn.infer(x)

    # Visualize
    fig, axs = plt.subplots(figsize=(8, 6))
    axs.plot(t, y_net)
    axs.plot(t, y)
    axs.legend(("Network", "Target"))


def visual_test_save_load():
    """Test the saving and loading of models"""

    # Test stimulus and targets
    t, x, y = get_test_data()

    # Make a network
    ffnn = FFNN(
        net_type="relu",
        n_inputs=2,
        n_hidden=70,
        lr=0.01,
        momentum=0.1,
        rho=0.9,
        eps=1e-06,
        betas=(0.9, 0.99),
        use_gpu=True,
        optimizer_method="adam",
    )

    # Fit a function
    ffnn.fit(x, y, n_epochs=5)

    # Infer the function
    y_net = ffnn.infer(x)

    # Save the model
    path = "./test_models/test_ffnn"
    filename = ffnn.save(path)

    # Load the model
    ffnn2 = FFNN.load(filename)

    # Use the infer interface on the loaded network
    y_net2 = ffnn2.infer(x)

    fig, axs = plt.subplots(figsize=(8, 6))
    axs.plot(t, y_net2, linewidth=8)
    axs.plot(t, y_net, linewidth=2)
    axs.plot(t, y)
    axs.legend(("Loaded", "Original", "Target"))


def visual_test_numpy_equivalence_relu():
    """Visually test that we can make an equivalent numpy net for relu"""

    # Test stimulus and targets
    t, x, y = get_test_data()

    # Make a network
    ffnn = FFNN(
        net_type="relu",
        n_inputs=2,
        n_hidden=70,
        lr=0.01,
        momentum=0.1,
        rho=0.9,
        eps=1e-06,
        betas=(0.9, 0.99),
        use_gpu=True,
        optimizer_method="adam",
    )

    # Fit a function
    ffnn.fit(x, y, n_epochs=5)

    # Infer the function
    y_net = ffnn.infer(x)

    y_relu_eq = (
        ffnn.get_w2() @ relu(ffnn.get_w1() @ x.T + ffnn.get_b1())
        + ffnn.get_b2()
    )

    fig, axs = plt.subplots(figsize=(8, 6))
    axs.plot(t, y_relu_eq.reshape(-1), linewidth=8)
    axs.plot(t, y_net, linewidth=2)
    axs.legend(("Network", "Equation"))


def visual_test_numpy_equivalence_tanh():
    """Visually test that we can make an equivalent numpy net for tanh"""

    # Test stimulus and targets
    t, x, y = get_test_data()

    # Make a network
    ffnn = FFNN(
        net_type="tanh",
        n_inputs=2,
        n_hidden=70,
        lr=0.01,
        momentum=0.1,
        rho=0.9,
        eps=1e-06,
        betas=(0.9, 0.99),
        use_gpu=True,
        optimizer_method="adam",
    )

    # Fit a function
    ffnn.fit(x, y, n_epochs=5)

    # Infer the function
    y_net = ffnn.infer(x)

    y_relu_eq = (
        ffnn.get_w2() @ np.tanh(ffnn.get_w1() @ x.T + ffnn.get_b1())
        + ffnn.get_b2()
    )

    fig, axs = plt.subplots(figsize=(8, 6))
    axs.plot(t, y_relu_eq.reshape(-1), linewidth=8)
    axs.plot(t, y_net, linewidth=2)
    axs.legend(("Network", "Equation"))
