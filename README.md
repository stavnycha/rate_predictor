# Rate forecast

Service, which helps you find best possible time for converting money from one currency to another, using historical currency rates.

The algorithm used is a regression type of Support Vector Machine. The moving window of last 5 rates is used as an input vector for making a prediction.

Based on the following articles:
- https://machinelearningmastery.com/time-series-forecasting-supervised-learning (moving window approach)
- http://scialert.net/fulltext/?doi=jas.2010.950.958 ("A Comparison of Time Series Forecasting using Support Vector Machine and Artificial Neural Network Model")
- https://c.mql5.com/forextsd/forum/35/kim2003.pdf ("Financial time series forecasting using support vector machines")
- http://www.svms.org/finance/VanGestel-etal2001.pdf ("Financial Time Series Prediction Using Least Squares Support Vector Machines Within the Evidence Framework")

## Setup

```
  bundle install
  rake db:setup
  sidekiq
```

and run in parallel:

```
  redis-server
```
