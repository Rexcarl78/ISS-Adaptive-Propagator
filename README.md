# ISS Adaptive Propagator & Optimizer

**An open-source MATLAB tool for low-cost, high-precision orbital propagation and computational optimization.**

This repository contains the source code for an orbital propagator developed to predict the trajectory of the International Space Station (ISS) in Low Earth Orbit (LEO). The core mission of this project is to provide a tool that optimizes the trade-off between mathematical precision and computational cost, enabling students, educators, and researchers with limited hardware resources to run accurate astrodynamics simulations.

## Key Features

* **Custom RK4 Integrator:** A robust, from-scratch implementation of the 4th-order Runge-Kutta numerical integration method with a fixed time step.
* **Adaptive Gravitational Fidelity:** Users can switch between three physical models based on their precision needs and hardware capabilities:
  * *Model 1:* Two-Body Problem (Ideal for fast educational visualization).
  * *Model 2:* J2 Harmonic (Accounts for Earth's oblateness — The optimal choice for 24h LEO simulations).
  * *Model 3:* J2 + J3 Harmonics (Accounts for north-south asymmetry).
* **Real-World Validation:** Direct error calculation and validation against actual NASA Orbital Ephemeris Messages (OEM) data.
* **Smart Optimizer:** A weighted optimization algorithm that automatically selects the best combination of physical model and time step ($dt$) based on the user's specific constraints for maximum allowable error or maximum computation time.

## 📁 Repository Structure

* `ISS_v4.m`: Main simulation script. Executes the propagation, calculates trajectories, and logs computation times.
* `RK4.m`: Core numerical integrator function.
* `twobodies_acceleration.m`: Calculates acceleration for a perfect spherical Earth.
* `twobodies_J2_acceleration.m`: Calculates acceleration including the J2 perturbation.
* `twobodies_J2_J3_acceleration.m`: Calculates acceleration including both J2 and J3 perturbations.
* `ISS_state.m`: Function that parses and interpolates reference position/velocity from NASA OEM data.
* `analyse_results_v2.m`: Script for statistical analysis, error computation, and generation of logarithmic performance plots.
* `Optimize.m`: The optimization script that evaluates the cost-precision trade-off and outputs the ideal configuration.

## ⚙️ Getting Started

### Prerequisites
* MATLAB (Tested on recent versions, no specialized aerospace toolboxes are strictly required for the core numerical integration).

### Usage
1. **Clone the repository** to your local machine.
2. **Add to Path:** Ensure all downloaded folders and scripts are added to your MATLAB path.
3. **Run a Simulation:** Open `ISS_v4.m`. Set your desired time step (`dt`) and choose the physical model (`Model = 1, 2, or 3`). Run the script to generate the state vectors and computation time data.
4. **Analyze Performance:** Run `analyse_results_v2.m` to generate comparative graphs between your simulation and the NASA data.
5. **Optimize:** Run `Optimize.m` to find the most efficient setup. You can adjust the weights (`we` for error importance, `wt` for time importance) to suit your hardware capabilities.

## 🤝 Social Impact & Educational Use

Space simulation software is often prohibitively expensive or requires heavy computational power. This open-source framework serves as an accessible entry point for STEM literacy. Its modular architecture makes it an excellent teaching tool for visualizing gravitational perturbations, numerical error propagation, and algorithm efficiency. 

Feel free to edit this project, audit the code, or expand it by adding atmospheric drag models or solar radiation pressure components!

## 📄 License

This project is open-source and available under the MIT License.
