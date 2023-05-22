# Snow gliding analysis
**Topic name:** Influence of environmental factors on snow gliding prior and after first snowfall event

**Written by:** Zorin Ivanov

**Supervision:** Prof. Dr. Georg Leitinger (UIBK), Dr. Peter Höller (UIBK, BFW)
## Description
Welcome to my project. As the title suggests, my aim was to idenfify the driving environmental factors for the process of snow gliding. The process is not well understood, hence forecasting of snow gliding and glide avalanches is still not possible. In order to build a reliable predictive model or an early-warning-system in the future, good-quality data, obtained over many measurement seasons, is needed. For this project, I was handled an extensive raw data obtained from two weather stations measuring environmental factors, as well as gliding data obtained from field loggers that detect very small movements in the snowpack. Here I showcase a part of the process of analyzing the dataset, as well as the statistical methods, techniques and tools I have used.

For the sake of simplicity, I don't follow the typical academic protocol. Instead, I showcase the project in two parts:

1. **Data cleaning and preparation of the master dataset.**
2. **Analysis and visualization.**
## Tools, Languages and Libraries Used
* R (dplyr, padr, data.table, ggplot2, scales, patchwork, lubridate, cowplot)
* SPSS
* MS Excel

## Part 1: Data cleaning and preparation of the master dataset.
In this part I import the data from two weather stations (Station 1 and Station 2) and the loggers data. The main idea of this part is to end up having a single homogeneous data set containing all the data necessary for analysis. The raw output of the weather stations has a measurement every 10 minutes. For our purpose we decided that a daily time series is detailed enough, yet not overly complicated; hence all data was agregated to daily averages (where sensible) and/or sums, maximums, minimums. For more details, let's dive straight into the dataset.

