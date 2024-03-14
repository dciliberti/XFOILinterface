# XFOIL interface for MATLAB

## Overview
This project is a fork of the original work by Rafael Oliveira: https://github.com/theolivenbaum/XFOILinterface

My fork includes the possibility to run inviscid analyses and includes MATLAB functions to read pressure coefficient and polar data files as MATLAB tables.

The main script file is about calculating and visualizing the center of pressure (xcp) and lift coefficients (Cl, Cm) for an airfoil using XFOIL. The script reads polar data from a file and calculates Cl, Cm, and xcp for different angles of attack. The results are then visualized using MATLAB's stackedplot function.

### Example
![image](https://github.com/dciliberti/XFOILinterface/assets/52099779/76029092-484a-4f7e-adb5-20224eb1f5df)

## Getting Started

### Prerequisites
- MATLAB
- XFOIL (should be downloaded automatically)

### Installation
1. Clone the repo: `git clone [https://github.com/dciliberti/XFOILinterface](https://github.com/dciliberti/XFOILinterface)
2. Navigate to the project directory: `cd XFOILinterface`

## Usage
Run the `xcpXFOIL.m` script in MATLAB. Make sure the polar data file ('Polar.txt') is in the same directory as the script.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[BSD-2-Clause license](/license.txt) the same of the original repository.
