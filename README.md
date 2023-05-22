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

First we import the two stations datasets. In these datasets the variables are already aggregated to a daily format, thus each row corresponds to a single day of measurements. The timeframe ranges from 01/01/2014 until the end of 2019. Station 1 is the more extensive dataset and ends on 03/12/2019 so we will use it as a template for creating the master dataset. However, it has a few data gaps in between. We use the `pad()` function from the `padr` library which fills in gaps in datetime variables. This way we end up with a uninterrupted dataset that has a row for each day between 01/01/2014 - 03/12/2019.
https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L1-L12

Let's have a look at the datasets:
https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L14
| X | Group.1    | Mean_snowheight | SH_max.Max_snowheight | SH_min.Min_snowheight | SH_sd.SD_snowheight | TS_0_mean.Mean_t_snow_0cm | TS_0_max.Max_t_snow_0cm | TS_0_min.Min_t_snow_0cm | TS_0_sd.SD_t_snow_0cm | TS_5_mean.Mean_t_snow_5cm | TS_5_max.Max_t_snow_5cm | TS_5_min.Min_t_snow_5cm | TS_5_sd.SD_t_snow_5cm | TS_50_mean.Mean_t_snow_50cm | TS_50_max.Max_t_snow_50cm | TS_50_min.Min_t_snow_50cm | TS_50_sd.SD_t_snow_50cm | TS_100_mean.Mean_t_snow_100cm | TS_100_max.Max_t_snow_100cm | TS_100_min.Min_t_snow_100cm | TS_100_sd.SD_t_snow_100cm | IC_mean.Mean_ice_content | IC_max.Max_ice_content | IC_min.Min_ice_content | IC_sd.SD_ice_content | WC_mean.Mean_water_content | WC_max.Max_water_content | WC_min.Min_water_content | WC_sd.SD_water_content | SD_mean.Mean_snow_density | SD_max.Max_snow_density | SD_min.Min_snow_density | SD_sd.SD_snow_density | date       |
|---|------------|-----------------|-----------------------|-----------------------|---------------------|---------------------------|-------------------------|-------------------------|-----------------------|---------------------------|-------------------------|-------------------------|-----------------------|-----------------------------|---------------------------|---------------------------|-------------------------|-------------------------------|-----------------------------|-----------------------------|---------------------------|--------------------------|------------------------|------------------------|----------------------|----------------------------|--------------------------|--------------------------|------------------------|---------------------------|-------------------------|-------------------------|-----------------------|------------|
| 1 | 01/01/2014 | 31.56041667     | 37.2                  | 24.1                  | 2.096424487         | -1.764583333              | -1.6                    | -1.9                    | 0.116155641           | -3.071527778              | -2.6                    | -3.4                    | 0.226454335           | -5.319444444                | 5.2                       | -9.6                      | 3.84651832              | -4.199305556                  | 4                           | -7.5                        | 2.488589246               | 4.447222222              | 8.7                    | 1                      | 2.869856468          | 1.6625                     | 3.5                      | 0.7                      | 0.732547523            | 57.3125                   | 104                     | 17                      | 32.69106692           | 01/01/2014 |
| 2 | 02/01/2014 | 31.13125        | 33.7                  | 28.5                  | 1.222828817         | -1.834722222              | -1.6                    | -1.9                    | 0.096309121           | -3.3875                   | -2.8                    | -3.9                    | 0.338832838           | -3.797222222                | -0.3                      | -8.4                      | 1.859804653             | -3.252777778                  | -0.5                        | -6.9                        | 1.585729386               | 10.15555556              | 13.7                   | 0.6                    | 4.147824061          | 2.641666667                | 3.4                      | 0.7                      | 0.84452163             | 119.4375                  | 159                     | 15                      | 46.43662028           | 02/01/2014 |
| 3 | 03/01/2014 | 31.14583333     | 32.4                  | 28                    | 1.121305121         | -1.777777778              | -1.6                    | -1.9                    | 0.120861965           | -2.8625                   | -2.6                    | -3.1                    | 0.17456239            | -4.238194444                | 3.6                       | -9                        | 3.512256194             | -2.597916667                  | 4                           | -6.6                        | 2.847682624               | 11.43958333              | 14.6                   | 9.1                    | 1.619557859          | 2.947222222                | 4.4                      | 2.2                      | 0.534141288            | 134.2916667               | 172                     | 107                     | 18.29818096           | 03/01/2014 |
| 4 | 04/01/2014 | 31.02430556     | 32.4                  | 29.4                  | 0.63126541          | -1.652777778              | -1.3                    | -1.8                    | 0.162129381           | -2.452083333              | -1.8                    | -2.7                    | 0.310643084           | -1.535416667                | 0                         | -4.8                      | 1.033729669             | -0.992361111                  | 2.2                         | -3.4                        | 1.274279166               | 13.93125                 | 19.7                   | 9                      | 3.304086657          | 3.14375                    | 5.8                      | 2.2                      | 0.679543116            | 158.9444444               | 238                     | 105                     | 36.03024716           | 04/01/2014 |
| 5 | 05/01/2014 | 26.74375        | 32.6                  | 12.5                  | 5.865159889         | -1.275                    | -1.2                    | -1.3                    | 0.043452409           | -1.770138889              | -1.7                    | -1.9                    | 0.073930473           | -3.770138889                | -0.4                      | -8.6                      | 2.264752101             | -4.233333333                  | 0.2                         | -8.8                        | 2.835193411               | 14.42430556              | 16.3                   | 12.6                   | 0.98805782           | 3.189583333                | 3.5                      | 2.6                      | 0.314391131            | 163.8125                  | 179                     | 143                     | 11.6216393            | 05/01/2014 |
| 6 | 06/01/2014 | 32.35069444     | 36.5                  | 23.8                  | 3.08726227          | -1.364583333              | -1.2                    | -1.5                    | 0.090429241           | -1.972222222              | -1.6                    | -2.2                    | 0.171967001           | -1.629166667                | 8                         | -10.5                     | 5.444736664             | -0.310416667                  | 9                           | -9.4                        | 5.562508348               | 9.538194444              | 14.9                   | 3.4                    | 5.09049569           | 2.704861111                | 5.1                      | 0.9                      | 1.206528272            | 114.4583333               | 171                     | 46                      | 56.66005549           | 06/01/2014 |

https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L15
| X | Group.1    | x           | SH_max.x | SH_min.x | SH_sd.x     | T_mean.x     | T_max.x | T_min.x | T_sd.x      | Rad_mean.x  | Rad_max.x | Rad_min.x | Rad_sd.x    | Per_mean.x  | Per_max.x | Per_min.x | Per_sd.x    | Per_sum.x | date       | cum_rad     |
|---|------------|-------------|----------|----------|-------------|--------------|---------|---------|-------------|-------------|-----------|-----------|-------------|-------------|-----------|-----------|-------------|-----------|------------|-------------|
| 1 | 01/01/2014 | 100.3708333 | 101.4    | 96.7     | 0.80859673  | -2.102777778 | 0.5     | -4.7    | 1.330331703 | 46.27777778 | 242       | 0         | 80.68816296 | 0.243055556 | 3         | 0         | 0.545118551 | 35        | 01/01/2014 | 46.27777778 |
| 2 | 02/01/2014 | 101.0111111 | 101.8    | 100      | 0.45452059  | -1.310416667 | 0.9     | -4      | 1.247359098 | 28.6875     | 221       | 0         | 49.53355418 | 0.256944444 | 4         | 0         | 0.588307134 | 37        | 02/01/2014 | 74.96527778 |
| 3 | 03/01/2014 | 99.52708333 | 100.8    | 96.1     | 0.713135375 | 0.070833333  | 4       | -3.1    | 1.84826038  | 46          | 250       | 0         | 74.78771822 | 0.229166667 | 2         | 0         | 0.468873818 | 33        | 03/01/2014 | 120.9652778 |
| 4 | 04/01/2014 | 100.4       | 101.3    | 99.5     | 0.339635264 | 0.713286713  | 2.8     | -2.3    | 1.197899439 | 30.1958042  | 202       | 0         | 48.03025143 | 0.636363636 | 43        | 0         | 3.798712633 | 91        | 04/01/2014 | 151.161082  |
| 5 | 05/01/2014 | 100.5736111 | 104.7    | 98.5     | 1.093719266 | -2.807638889 | 2.4     | -6.1    | 3.208404171 | 19.00694444 | 91        | 0         | 28.3924782  | 1.708333333 | 65        | 0         | 9.06455095  | 246       | 05/01/2014 | 170.1680264 |
| 6 | 06/01/2014 | 103.425     | 104.5    | 100.8    | 0.962405204 | 1.376388889  | 7.3     | -6.2    | 4.558723078 | 51.85416667 | 260       | 0         | 89.05965383 | 0.256944444 | 2         | 0         | 0.483959886 | 37        | 06/01/2014 | 222.0221931 |

Now let's merge the two datasets. For that we use the `data.table` library. We convert the data frames into data tables and join them by using the date as a key.
https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L20-L25

Here is the resulting master dataset now:
https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L27
| X | Group.1    | x           | SH_max.x | SH_min.x | SH_sd.x     | T_mean.x     | T_max.x | T_min.x | T_sd.x      | Rad_mean.x  | Rad_max.x | Rad_min.x | Rad_sd.x    | Per_mean.x  | Per_max.x | Per_min.x | Per_sd.x    | Per_sum.x | date       | cum_rad     | i.X | i.Group.1  | Mean_snowheight | SH_max.Max_snowheight | SH_min.Min_snowheight | SH_sd.SD_snowheight | TS_0_mean.Mean_t_snow_0cm | TS_0_max.Max_t_snow_0cm | TS_0_min.Min_t_snow_0cm | TS_0_sd.SD_t_snow_0cm | TS_5_mean.Mean_t_snow_5cm | TS_5_max.Max_t_snow_5cm | TS_5_min.Min_t_snow_5cm | TS_5_sd.SD_t_snow_5cm | TS_50_mean.Mean_t_snow_50cm | TS_50_max.Max_t_snow_50cm | TS_50_min.Min_t_snow_50cm | TS_50_sd.SD_t_snow_50cm | TS_100_mean.Mean_t_snow_100cm | TS_100_max.Max_t_snow_100cm | TS_100_min.Min_t_snow_100cm | TS_100_sd.SD_t_snow_100cm | IC_mean.Mean_ice_content | IC_max.Max_ice_content | IC_min.Min_ice_content | IC_sd.SD_ice_content | WC_mean.Mean_water_content | WC_max.Max_water_content | WC_min.Min_water_content | WC_sd.SD_water_content | SD_mean.Mean_snow_density | SD_max.Max_snow_density | SD_min.Min_snow_density | SD_sd.SD_snow_density |
|---|------------|-------------|----------|----------|-------------|--------------|---------|---------|-------------|-------------|-----------|-----------|-------------|-------------|-----------|-----------|-------------|-----------|------------|-------------|-----|------------|-----------------|-----------------------|-----------------------|---------------------|---------------------------|-------------------------|-------------------------|-----------------------|---------------------------|-------------------------|-------------------------|-----------------------|-----------------------------|---------------------------|---------------------------|-------------------------|-------------------------------|-----------------------------|-----------------------------|---------------------------|--------------------------|------------------------|------------------------|----------------------|----------------------------|--------------------------|--------------------------|------------------------|---------------------------|-------------------------|-------------------------|-----------------------|
| 1 | 01/01/2014 | 100.3708333 | 101.4    | 96.7     | 0.80859673  | -2.102777778 | 0.5     | -4.7    | 1.330331703 | 46.27777778 | 242       | 0         | 80.68816296 | 0.243055556 | 3         | 0         | 0.545118551 | 35        | 01/01/2014 | 46.27777778 | 1   | 01/01/2014 | 31.56041667     | 37.2                  | 24.1                  | 2.096424487         | -1.764583333              | -1.6                    | -1.9                    | 0.116155641           | -3.071527778              | -2.6                    | -3.4                    | 0.226454335           | -5.319444444                | 5.2                       | -9.6                      | 3.84651832              | -4.199305556                  | 4                           | -7.5                        | 2.488589246               | 4.447222222              | 8.7                    | 1                      | 2.869856468          | 1.6625                     | 3.5                      | 0.7                      | 0.732547523            | 57.3125                   | 104                     | 17                      | 32.69106692           |
| 2 | 02/01/2014 | 101.0111111 | 101.8    | 100      | 0.45452059  | -1.310416667 | 0.9     | -4      | 1.247359098 | 28.6875     | 221       | 0         | 49.53355418 | 0.256944444 | 4         | 0         | 0.588307134 | 37        | 02/01/2014 | 74.96527778 | 2   | 02/01/2014 | 31.13125        | 33.7                  | 28.5                  | 1.222828817         | -1.834722222              | -1.6                    | -1.9                    | 0.096309121           | -3.3875                   | -2.8                    | -3.9                    | 0.338832838           | -3.797222222                | -0.3                      | -8.4                      | 1.859804653             | -3.252777778                  | -0.5                        | -6.9                        | 1.585729386               | 10.15555556              | 13.7                   | 0.6                    | 4.147824061          | 2.641666667                | 3.4                      | 0.7                      | 0.84452163             | 119.4375                  | 159                     | 15                      | 46.43662028           |
| 3 | 03/01/2014 | 99.52708333 | 100.8    | 96.1     | 0.713135375 | 0.070833333  | 4       | -3.1    | 1.84826038  | 46          | 250       | 0         | 74.78771822 | 0.229166667 | 2         | 0         | 0.468873818 | 33        | 03/01/2014 | 120.9652778 | 3   | 03/01/2014 | 31.14583333     | 32.4                  | 28                    | 1.121305121         | -1.777777778              | -1.6                    | -1.9                    | 0.120861965           | -2.8625                   | -2.6                    | -3.1                    | 0.17456239            | -4.238194444                | 3.6                       | -9                        | 3.512256194             | -2.597916667                  | 4                           | -6.6                        | 2.847682624               | 11.43958333              | 14.6                   | 9.1                    | 1.619557859          | 2.947222222                | 4.4                      | 2.2                      | 0.534141288            | 134.2916667               | 172                     | 107                     | 18.29818096           |
| 4 | 04/01/2014 | 100.4       | 101.3    | 99.5     | 0.339635264 | 0.713286713  | 2.8     | -2.3    | 1.197899439 | 30.1958042  | 202       | 0         | 48.03025143 | 0.636363636 | 43        | 0         | 3.798712633 | 91        | 04/01/2014 | 151.161082  | 4   | 04/01/2014 | 31.02430556     | 32.4                  | 29.4                  | 0.63126541          | -1.652777778              | -1.3                    | -1.8                    | 0.162129381           | -2.452083333              | -1.8                    | -2.7                    | 0.310643084           | -1.535416667                | 0                         | -4.8                      | 1.033729669             | -0.992361111                  | 2.2                         | -3.4                        | 1.274279166               | 13.93125                 | 19.7                   | 9                      | 3.304086657          | 3.14375                    | 5.8                      | 2.2                      | 0.679543116            | 158.9444444               | 238                     | 105                     | 36.03024716           |
| 5 | 05/01/2014 | 100.5736111 | 104.7    | 98.5     | 1.093719266 | -2.807638889 | 2.4     | -6.1    | 3.208404171 | 19.00694444 | 91        | 0         | 28.3924782  | 1.708333333 | 65        | 0         | 9.06455095  | 246       | 05/01/2014 | 170.1680264 | 5   | 05/01/2014 | 26.74375        | 32.6                  | 12.5                  | 5.865159889         | -1.275                    | -1.2                    | -1.3                    | 0.043452409           | -1.770138889              | -1.7                    | -1.9                    | 0.073930473           | -3.770138889                | -0.4                      | -8.6                      | 2.264752101             | -4.233333333                  | 0.2                         | -8.8                        | 2.835193411               | 14.42430556              | 16.3                   | 12.6                   | 0.98805782           | 3.189583333                | 3.5                      | 2.6                      | 0.314391131            | 163.8125                  | 179                     | 143                     | 11.6216393            |
| 6 | 06/01/2014 | 103.425     | 104.5    | 100.8    | 0.962405204 | 1.376388889  | 7.3     | -6.2    | 4.558723078 | 51.85416667 | 260       | 0         | 89.05965383 | 0.256944444 | 2         | 0         | 0.483959886 | 37        | 06/01/2014 | 222.0221931 | 6   | 06/01/2014 | 32.35069444     | 36.5                  | 23.8                  | 3.08726227          | -1.364583333              | -1.2                    | -1.5                    | 0.090429241           | -1.972222222              | -1.6                    | -2.2                    | 0.171967001           | -1.629166667                | 8                         | -10.5                     | 5.444736664             | -0.310416667                  | 9                           | -9.4                        | 5.562508348               | 9.538194444              | 14.9                   | 3.4                    | 5.09049569           | 2.704861111                | 5.1                      | 0.9                      | 1.206528272            | 114.4583333               | 171                     | 46                      | 56.66005549           |

The next step is to import the loggers. A raw logger data looks like this:

`head(logger_name, 10)`
| Date       | Time     | Time     | corImpulses | Distance | AccuDist |
|------------|----------|----------|-------------|----------|----------|
| 2.11.2015  | 0.691701 | 16:36:03 | 1           | 0.785    | 0.785    |
| 21.11.2015 | 0.287836 | 06:54:29 | 0           | 0.785    | 1.57     |
| 21.11.2015 | 0.392523 | 09:25:14 | 1           | 0.785    | 2.355    |
| 21.11.2015 | 0.445475 | 10:41:29 | 0           | 0.785    | 3.14     |
| 21.11.2015 | 0.542106 | 13:00:38 | 1           | 0.785    | 3.925    |
| 21.11.2015 | 0.589676 | 14:09:08 | 0           | 0.785    | 4.71     |
| 23.11.2015 | 0.513947 | 12:20:05 | 1           | 0.785    | 5.495    |
| 27.11.2015 | 0.202847 | 04:52:06 | 0           | 0.785    | 6.28     |
| 29.11.2015 | 0.869468 | 20:52:02 | 1           | 0.785    | 7.065    |
| 30.11.2015 | 0.950961 | 22:49:23 | 0           | 0.785    | 7.85     |

The logger stores impulses whenever it detects movement. Each impuse is equal to 0.785 mm of distance moved. It is important to mention that 0 and 1 in the "corImpulses" column does not say whether there is an impulse. In our case both are impulses so don't pay attention to this column. By design the loggers were mounted at the beginning of each season in three fall lines, each fall line consisting of 4-6 loggers. This means that we handle our logger data in groups organized by season (date) and by fall line. The aim in our next function is to import the loggers grouped by the fall line they are in, then to aggregate the distance data to daily sums (to fit the daily time series template of the master dataset) and finally to calculate the daily fall line distance average.
https://github.com/ZorinIvanov/Snow-gliding-analysis/blob/19204162b682a39c993bbbaf491881c6375fb412/snow_gliding_master_dataset.R#L31-L80

Here is a snippet of how the output looks like:
| date       | fall_line_mean |
|------------|----------------|
| 2015-11-02 | 0.785          |
| 2015-11-03 | 0.157          |
| 2015-11-04 | 0.000          |
| 2015-11-05 | 0.000          |
| 2015-11-06 | 0.000          |
| 2015-11-07 | 0.000          |
| 2015-11-08 | 0.157          |
| 2015-11-09 | 0.000          |
| 2015-11-10 | 0.000          |
| 2015-11-11 | 0.000          |

The next step is to repeat this for the other two fall lines of the 2015-16 winter season and do the same for the 2016-17, 2017-18, 2018-19 seasons. By the end of this we end up with daily averages for each fall line for each season, which we merge output row-wise by fall line. We join each fall line to the master dataset to adopt its frame. Finally, we calculate the overall distance average of the fall lines averages:
