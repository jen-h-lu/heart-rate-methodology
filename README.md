# physioSim

**An open-source simulation framework for benchmarking statistical methods for physiological time-series data.**

---

## Overview

physioSim is an R-based simulation framework for generating realistic physiological time-series data and evaluating statistical methods under controlled experimental conditions.

The project was developed to investigate how statistical modeling choices influence inference for repeated-measures physiological signals such as heart rate.

Unlike generic longitudinal simulation frameworks, physioSim focuses on realistic physiological response dynamics including delayed responses, habituation, sustained activation, temporal dependence, participant heterogeneity, measurement noise, and missing observations.

---

## Research Motivation

Physiological experiments frequently collect hundreds of repeated observations from each participant.

Despite this rich temporal information, many analyses reduce these measurements to summary statistics such as:

- Mean response
- Maximum response
- Area under the curve (AUC)

While computationally convenient, these summaries may discard meaningful temporal information.

physioSim provides a reproducible environment for investigating when summary-based approaches remain appropriate and when trajectory-based statistical methods provide improved inference.

---

## Research Questions

This project investigates:

- How does sample size influence statistical power?
- How does temporal autocorrelation affect inference?
- How does missing data influence statistical performance?
- When do trajectory-based methods outperform summary statistics?
- Which statistical methods are most robust across realistic physiological response patterns?

---

## Features

Current functionality includes:

- Participant-level simulation
- Multiple physiological response profiles
- Subject-specific random effects
- Temporal dependence
- Measurement noise
- Missing-data simulation
- Linear mixed-effects model benchmarking
- Summary statistic benchmarking
- Reproducible simulation workflows

---

## Repository Structure

```text
R/
Reusable simulation and analysis functions

simulations/
Reproducible simulation experiments

results/
Simulation outputs

figures/
Publication-quality figures

docs/
Manuscript and documentation

tests/
Validation scripts
```

---

## Current Figures

The repository currently includes:

- Figure 1 – Simulated physiological response profiles
- Figure 2 – Statistical power versus sample size
- Figure 3 – Type I error under temporal autocorrelation
- Figure 4 – Effect of missing data on statistical power
- Figure 5 – Comparison of summary statistics and linear mixed-effects models

---

## Software

Language:

- R

Primary packages:

- tidyverse
- lme4
- lmerTest
- ggplot2

---

## Project Status

Current stage:

**Simulation framework complete**

Completed:

- Simulation engine
- Benchmarking framework
- Initial validation experiments
- Five manuscript figures

In progress:

- Generalized additive mixed models (GAMM)
- Functional data analysis
- Bayesian hierarchical modeling

---

## Reproducibility

All simulation experiments are fully reproducible.

Each figure can be regenerated directly from the scripts contained in the `simulations/` directory.

---

## Future Development

Planned additions include:

- Generalized additive mixed models
- Functional data analysis
- Bayesian hierarchical models
- R package development
- Expanded physiological modalities

---

## Citation

If you use or build upon physioSim, please cite this repository and the accompanying manuscript (forthcoming).

---

## Author

Jenna Lu

University of Florida

Department of Statistics

---

## License

MIT License
