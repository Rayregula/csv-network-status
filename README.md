# List CSV Network Status
###### v0.0.4 by Jason Regula <br/>
## Description:
 Will read a CSV file, pinging all devices, outputs a formatted list showing network device hierarchy and ping status for each. <br/>
### 


## Usage:
`./get-csv-status.sh [-ctfh]` <br/>

 * get-csv-status.sh -c \<value> #set how many packets to ping with, (defualt = 1) <br/>
 * get-csv-status.sh -t \<value> #set timeout for ping response, (defualt = 2) <br/>
 * get-csv-status.sh -f \<file_path> #read from specified csv file with ip's in column "B" (ignores row 1) <br/>
 * get-csv-status.sh -h #will print help <br/>

###### Basic Usage:
`./get-csv-status.sh` will create (if it does not already exist) a subfolder in the script's location called "resourses". It checks this folder for a file called "ip-list.csv". <br/>
`./get-csv-status.sh -f <filepath>` will only read the CSV file given. <br/>

## CSV FILE:
#### **File should Ideally contain four columns:** <br/>
Header (first row) is ignored so you can name them whatever you want, just make sure to add something.

sample.csv: <br/>

| Name:                 | IP:       | Group: | Layer: |
|-----------------------|-----------|--------|--------|
| Core Server           | 10.5.0.1  |      0 |      0 |
| Server1               | 10.5.0.53 |      1 |      1 |
| Server2               | 10.5.0.46 |      2 |      1 |
| Switch 4              | 10.5.0.65 |      2 |      2 |
| Switch_1              | 10.5.0.48 |      1 |      2 |
| Switch_2              | 10.5.0.60 |      1 |      3 |
| Wireless Access Point | 10.5.0.66 |      1 |      3 |
| Wireless Access Point | 10.5.0.34 |      1 |      2 |
| Xerox Copier          | 10.5.0.35 |      1 |      3 |
| HP Printer            | 10.5.0.49 |      1 |      3 |
| DHCP Server           | 10.5.0.36 |      0 |      1 |
| Minecraft Server #1   | 10.5.0.37 |      1 |      2 |
| Minecraft Server #2   | 10.5.0.41 |      1 |      2 |
| Minecraft Server #3   | 10.5.0.43 |      2 |      3 |
| Minecraft Server #4   | 10.5.0.58 |      2 |      3 |
| File Server           | 10.5.0.67 |      2 |      3 |
<br/>
`Groups` tell the script what network branch each device is connected too. <br/>
`Layers` tell it how far it should be on the branch, currently up to 5 branches are supported (not counting 0). I plan to get the script to auto detect how many branches it should show in the output but may be a ways off. <br/>