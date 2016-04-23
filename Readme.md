# How to get the PredictionIO stack and our anomaly detection template running on your machine.

Assuming you are using Linux or OS X:

Issue ```bash -c "$(curl -s https://install.prediction.io/install.sh)"``` and choose PostgreSQL as the data storage option.

[Download this](https://goo.gl/ue3udW) and put it in PredictionIO-0.9.6/conf. The ANOMALY folder can simply be placed inside the PredictionIO folder. 

You may also want to add this to your path: 
```
PATH=$PATH:/home/yourname/PredictionIO/bin; export PATH
```
If not just run ```pio``` from the bin folder. 


```
pio eventserver
pio build (while in the ANOMALY folder)
pio train
pio deploy
```