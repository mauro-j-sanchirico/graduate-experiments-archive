# Goals

These tools aim to compare nonlinear filter approaches against the standard matched filter with the goal of identifying designs which most effectively increase range measurement resolution. To achieve a more accurate characterization of detection filter resolution, this analysis focuses on fixing the location of one target while walking another from further downrange toward the location of the first. The entire radar frontend and detection process is modeled to account for nonlinear effects.

Example nonlinear filters are compared:

1. **Filter-Enhance-Chain (FEC) Filters:** Recurring chains of filters and nonlinear enhancements
2. **Delay-Product (DP) Filters:** Delayed copies of a filter with a product "AND" step to keep only the time sidelobes common between them
3. **Filter-Smooth-Fit (FSF) Filters:** Filters the signal, smooths the result, and fits a function to identify unknown parameters
4. **Filter-Enhance-Smooth-Fit (FESF) Filters:** - Filters the signal, applied nonlinear enhancement, smooths the result, then fits a function to identify unknown parameters (combination of 1 and 3)

Each example filter is compared for multiple waveform types with coherent and non-coherent integration.

These filters are compared to identify the best:
1.  **Single target resolution:** Smallest uncertainty about target range measurement
2.  **Multiple target resolution:** Smallest distance between two adjacent targets for which they are still separable)
3.  **Single target PSL:** Peak to Sidelobe ratio for a single target
4.  **Detectable SNR:** The SNR at which a single target becomes detectable with > 90% PD

The goal of the analysis is to populate the following table.

|     | Standard | FEC | DP | FSF | FESF |
|-----| -------- | --- | ---| --- | ---- |
| STR |          |     |    |     |      |
| MTR |          |     |    |     |      |
| PSL |          |     |    |     |      |
| SNR |          |     |    |     |      |

# Assumptions

Beamforming and direction finding are not modeled.