# List CSV Network Status
###### v0.0.5 by Jason Regula <br/>

![](https://s3-us-west-2.amazonaws.com/cdn.rayregula.com/CDN/csv-network-status.png)

## Description:
 Will read a CSV file, pinging all listed devices, outputs a formatted list showing network device hierarchy and ping status for each. <br/>
### 


## Usage:
`./get-csv-status.sh [-ctfh]` <br/>

 * get-csv-status.sh -c \<value> #set how many packets to ping with, (defualt = 1) <br/>
 * get-csv-status.sh -t \<value> #set timeout for ping response, (defualt = 2) <br/>
 * get-csv-status.sh -f \<file_path> #read from the specified CSV file, expects ip's in column "B" (ignores row 1) <br/>
 * get-csv-status.sh -h #will print help <br/>

###### Basic Usage:
`./get-csv-status.sh` will create (if it does not already exist) a subfolder in the script's location called "resourses". It checks this folder for a file called "ip-list.csv". <br/>
`./get-csv-status.sh -f <filepath>` will only read the CSV file given. <br/>

## CSV FILE:
 File should Ideally contain four columns: <br/>
 A=Name, B=IP, C=Group, D=Layer <br/>
 <br/>
Header (first row) is ignored so you can name your columns whatever you want, just make sure to add something. <br/>
Due to how current version handles malformed CSV files to minimize issues when given blank values `Group` and `Layer` should not be equal to `0`. For core devices use `00` or `000` (as I've used in the sample below). <br/>

sample.csv: <br/>

| Name:                 | IP:       | Group: | Layer: |
|-----------------------|-----------|--------|--------|
| Core Server           | 10.5.0.1  | 000    | 000    |
| DHCP Server           | 10.5.0.36 | 000    |      1 |
| Server1               | 10.5.0.53 |      1 |      1 |
| Switch_1              | 10.5.0.48 |      2 |      2 |
| Wireless Access Point | 10.5.0.34 |      1 |      2 |
| Minecraft Server #1   | 10.5.0.37 |      1 |      2 |
| Minecraft Server #2   | 10.5.0.41 |      1 |      2 |
| Switch_2              | 10.5.0.60 |      2 |      3 |
| Wireless Access Point | 10.5.0.66 |      2 |      3 |
| Xerox Copier          | 10.5.0.35 |      2 |      3 |
| HP Printer            | 10.5.0.49 |      2 |      3 |
| Server2               | 10.5.0.46 |      3 |      1 |
| Switch 4              | 10.5.0.65 |      3 |      2 |
| Minecraft Server #3   | 10.5.0.43 |      3 |      3 |
| Minecraft Server #4   | 10.5.0.58 |      3 |      3 |
| File Server           | 10.5.0.67 |      3 |      3 |

###### Note: Randomly created the above CSV file for testing purposes before deciding to use it as an example file, so it's not setup like a typical network would be. Though it works until I come up with something better. <br/>
`Groups` tell the script what network branch each device is connected too. <br/>
`Layers` tell it how far it should be on the branch, currently up to 5 branches are supported (not counting 00/000). I plan to get the script to auto detect how many branches it should show in the output but that may be a ways off. <br/>