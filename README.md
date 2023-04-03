# MongoDB Dynamic DNS IP Updater

This script is used to update the Dynamic DNS (DDNS) service based on MongoDB, specifically for those using Indih*ome ISP :skull:. It is written in Bash and can automatically change the access list in MongoDB.

## Installation

```bash
git clone https://github.com/z3rsa/mongodb-ddns-updater.git
```

## Usage
This script is used with crontab. Specify the frequency of execution through crontab.

```bash
# ┌───────────── minute/menit (0 - 59) 
# │ ┌───────────── hour/jam (0 - 23)
# │ │ ┌───────────── day/hari of the month (1 - 31)
# │ │ │ ┌───────────── month/bulan (1 - 12)
# │ │ │ │ ┌───────────── day/hari of the week (0 - 6) (Sunday to Saturday 7 is also Sunday on some systems)
# │ │ │ │ │ ┌───────────── command to issue                                
# │ │ │ │ │ │
# │ │ │ │ │ │
# * * * * * /bin/bash {Location of the script}
```

## Special Case
If you're using Raspberry Pi, make sure to add a delay before running the script:
```
@reboot sleep 180 && bash /path/to/your/script
```

## Discord Embed
Success Add IP Address on Access List\
<img src="https://github.com/z3rsa/mongodb-ddns-updater/blob/main/images/mongodb_success.png?raw=true" alt="MongoDB success image" width="300">

Fail to add, Already IP Address on Access List\
<img src="https://github.com/z3rsa/mongodb-ddns-updater/blob/main/images/mongodb_fail.png?raw=true" alt="MongoDB fail image" width="300">

## Reference
This script was made with reference from [K0p1-Git | Cloudflare Dynamic DNS IP Updater](https://github.com/K0p1-Git/cloudflare-ddns-updater) Github.
