# Graduate Experiments Archive

This is a personal monorepo for experimental code, academic examples, and prototypes written from 2012-2022 while performing research at Villanova University's [Villanova Center for Analytics of Dynamic Systems (VCADS)](https://www.texstudio.org/). It is pushed here as an archived virtual notebook.

Topics are eclectic but mostly cover mathematical analyses of nonlinear systems' responses to non-trivial excitations, including systems and excitations encountered music, sports, circuits, and neural networks. Most of this work culminated in a master's thesis available [here](https://github.com/mauro-j-sanchirico/graduate-experiments-archive/blob/main/thesis/main.pdf). Some of this work is summarized briefly in an IEEE Transactions on Neural Networks and Learning Systems (TNNLS) paper [here](https://ieeexplore.ieee.org/document/9650758). An ArXiv copy is available [here](https://arxiv.org/pdf/2007.06226).

## Summary and Abstract

The main thesis stemming from this work developed a polynomial expansion technique well suited for projecting deeply nested and strongly nonlinear systems (such as neural networks, fluid dynamical systems, and nonlinear circuits) into a space in which they could be meaningfully compared over a bounded interval. The technique was employed in a main application study to stimulate deep neural networks with interrogation vectors in order to copy the models into surrogate neural networks, and to quantify success rate of this distillation process with respect to degree of label noise. The same technique was employed to study properties of shallow water waves and response of nonlinear circuits to biased sinusoidal excitation.

### Abstract

```
This thesis presents a novel polynomial expansion technique designed to facilitate detailed and
exact analysis of a broad class of nonlinear functions. The primary motivation for this development
is to formulate a polynomial expansion which is suitable for application to nonlinear activation
functions often employed in neural networks. In the study of neural networks, polynomial
expansions have been applied to address well-known difficulties in the verifiable, explainable, and
secure deployment thereof. Existing approaches span classical Taylor and Chebyshev methods,
asymptotics, and many numerical and algorithmic approaches. While these individually have
useful properties such as exact error formulas, monic form, adjustable domain, and robustness
to undefined derivatives, there are no approaches that provide a consistent method yielding an
expansion with all these properties.

To address this gap, an analytically modified integral transform expansion technique, referred
to as AMITE, is developed. The AMITE technique is a novel expansion via integral transforms
modified using a derived criterion for convergence. The AMITE technique is applied to a broad
class of functions arising in nonlinear systems, including the rectified linear unit (ReLU), the
hyperbolic secant, the hyperbolic secant squared, and the hyperbolic tangent. Compared with
existing state of the art expansion techniques such as Chebyshev, Taylor Series, Fourier-Legendre,
and many modern numerical approximations, AMITE is the first polynomial expansion that can
provide six previously mutually exclusive desired expansion properties such as exact formulas for
the coefficients and exact expansion errors while remaining robust to undefined derivatives. The
utility of the expansion is demonstrated through a main in-depth case study where its use to
address the equivalence testing problem of the Multi-layered Perceptron (MLP) is demonstrated.
In this case study, a blackbox network under test is stimulated and a replicated multivariate
polynomial form is efficiently extracted from the response to enable comparison against the
original network. A comparison procedure enabled by the expansions is developed and called a
conformance test, i.e., a test to check that a neural network implemented conforms to an original,
designed network.

The general utility of the technique is then further demonstrated through a series of case
studies in nonlinear waves and nonlinear circuits, motivated by applications in naval radar systems
and signal processing. First, a problem involving waves traveling in shallow water is solved
where the mean height of a shallow water wave with an uncertain wavenumber is derived. Further,
two problems relating to characterization of biased and unbiased nonlinear amplifiers are
solved. In solving these problems, several families of novel integer sequences are derived and
tabulated for the first time. Throughout, a number of nontrivial relationships among the special
functions were derived to enable the results obtained. These relationships and their proofs are
cataloged in the appendix. We conclude that the AMITE technique presents a new dimension
of expansion methods that are suitable for precise analysis of nonlinearities arising in a wide
variety of nonlinear circuits and systems, and specifically has noteworthy utility in opening new
directions and opportunities for the theoretical analysis and testing of neural networks.
```

## Contents

* **examples**: Basic helpful examples.
* **projects**: Standalone projects covering topics in nonlinear circuit analysis, sports, physics, and neural networks.
* **scratch**: Archives of personal scratch work in solving math problems of interest.
* **thesis**: Master's thesis developing a novel polynomial expansion and studying applications thereof to neural networks, shallow water waves, and nonlinear circuits.
* **throwaway**: One-off prototypes and fun experiments!

The main code to reproduce results in the thesis is available in `projects/python/prism_*`.

## Usage and Dependencies

Maple worksheets (`.ws`) require [Maple](https://www.maplesoft.com/). Maple worksheets can be viewed for free with [Maple Player](maplesoft.com/products/maple/Mapleplayer/). Matlab scripts (`.m`) and Matlab Live notebooks (`.mlx`) require [Matlab](https://www.mathworks.com/products/matlab.html). Python modules and packages require Python 3.7 or higher. [TeXstudio](https://www.texstudio.org/) was used for TeX documents.

This work is archived and code here is not actively maintained, though the author is open to requests to collaborate on future work!

## License

Code in this repository is prototype and experimental in nature. It is provided with an MIT license in case it is helpful to use elsewhere. See the `LICENSE` file.

## Advisement

Much of this work, including the thesis, paper, and associated studies were developed and performed under the much appreciated advisement of Dr. C. Nataraj and Dr. Xun Jiao.

## Contact

Contact Mauro J. Sanchirico III ([sanchirico.mauro@gmail.com](sanchirico.mauro@gmail.com)) for inquiries.


