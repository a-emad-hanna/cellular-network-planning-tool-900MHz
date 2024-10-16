# Cellular Network Planning Tool

## Project Overview
This MATLAB-based tool helps service providers with 340 channels in the 900 MHz band plan their cellular networks. The tool calculates essential design parameters like:
- Cluster size
- Number of cells
- Cell radius
- Traffic intensity per cell and sector
- Base station transmitted power

The tool uses the Hata propagation model, assuming an urban-medium city environment, and provides plots for various scenarios, including MS received power versus distance.

## Input Parameters:
The user will be prompted for the following inputs:
- Grade of Service (GOS)
- City area (in square km)
- User density (in users per km²)
- Minimum Signal-to-Interference Ratio (SIR_min)
- Sectorization method (omni, 120°, 60°)

## Output Parameters:
The program will calculate and output:
1. Cluster size
2. Number of cells
3. Cell radius
4. Traffic intensity per cell and per sector
5. Base station transmitted power
6. A plot of MS received power versus distance from the BS

## Validation & Analysis
For validation, the tool provides additional plots based on a city area of 100 km², varying GOS, user density, and SIR_min. These plots include:
- Cluster size versus SIR_min
- Number of cells versus GOS
- Traffic intensity per cell versus GOS
- Number of cells and cell radius versus user density

