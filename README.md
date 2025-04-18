### Prerequisites
- A machine with Linux installed (WSL 2 might work as well)
- Docker installed (here is [the official guide](https://docs.docker.com/engine/install/ubuntu/) on how to install Docker on Ubuntu)
- Knowing how to use the terminal (here is [a guide](https://ubuntu.com/tutorials/command-line-for-beginners#3-opening-a-terminal) on how to get started with Terminal on Ubuntu)
- If you want to allow others to factor the same number with you, set up port forwarding on TCP port 7777 and 24242 (google "(your router brand or model number here) router port forwarding setup" without the ")

Let us know if you use Linux distribution other than Ubuntu and need help setting up Docker  
We don't have native Windows support yet, but [Docker on WSL 2](https://docs.docker.com/desktop/wsl) should work.

### 1. Register on Sister Margaret's and copy your API key
Go to https://sismargaret.fact0rn.io/ and register by clicking "new user". Afterwards, retype your username/password to login.  
Once you're in the dashboard, click on your username on the top left to enter the profile page. It's below "Sister Margaret's" and above "logout".  
At the profile page, copy your API key (it starts with `eyJhbGciOiJIUzUxMiJ9.` and is roughly 227 characters long)  
Keep the API key secret and don't send it to anyone else, including the developers.

### 2. Install the miner
First, create the folder that will contain the miner and data generated during factorization. You may want to put the miner in a HDD or a large SSD, since data per large factorization (>=c130) are measured in gigabytes.  
Now, open a Terminal in the miner's folder. This can usually be done by pressing shift + right clicking within the folder and choosing the right option  
Within the terminal, run the following command to install the miner:
```sh
wget -O setup.sh https://raw.githubusercontent.com/filthz/sismargaret/refs/heads/main/setup.sh && bash setup.sh
```
The script will ask you to provide the authToken. Paste the API key you got from step 1 and press enter to proceed.  

The installation may take up to 10~20 minutes, depending on your CPU's power. During this period, the miner compiles Cado-NFS on your computer to make sure it's optimized for the CPU you have.  

Once it's done, start the miner by running:
```
bash start-miner.sh
```
The commands above stops and removes previously running miner instances, so you can also use it to restart the miner (eg. after an update or reboot)  
The miner automatically restart after a reboot. To shutdown the miner, run this in the miner folder:  
```sh
bash stop-miner.sh
```

### 3. Accept jobs or join existing factorizations
Now that the miner is started and connected to Sister Margaret's, there are two ways you can start contributing:  
- On the "Open jobs" interface, choose a job you want to perform by pressing "compute". A few seconds later, your miner will start factoring the number. You can see that the job moved to "Jobs in progress". You'll know the number is factored when it moves to "Finished Jobs" or by monitoring the miner's logs.  
- On the "Jobs in progress" interface, jobs with status "CALCULATING" allow you to help factoring the number by pressing "connect". This is especially helpful when the number is difficult (>= c130). You can't connect to jobs with status "NO_CONNECTION_MINER", because that means the owner of the miner didn't set up port forwarding on port 7777 and/or 24242.

The "c" column stands for the digit, or the "difficulty" of the number. c100 can be factored within 10 minutes if you have a fast computer, c110 takes 4x more work to factor than c100, c120 takes 16x more work to factor than c100, etc.

## Post-install FAQ
### Where do I find the logs?
Check the logs folder under the miner folder. logs/miner.log contains most of the information you may need.

### How do I check factorization progress?
You can check the dashboard on http://localhost:7777 , or refer to the log files.

### How do I update the miner?
Enter the existing miner folder, then run the install script again:
```sh
wget -O setup.sh https://raw.githubusercontent.com/filthz/sismargaret/refs/heads/main/setup.sh && bash setup.sh
```
This will overwrite the old miner and replace it with the updated one.  
You wouldn't need to provide authToken again, since that'll be automatically extracted from the original application.yml  
Notice that this will revert any customization you've made to application.yml, so you may want to reapply them after the update.

### I just changed application.yml, how do I apply the new settings?
To apply any customization made to application.yml, run this in the miner folder:
```sh
bash rebuild-miner.sh
```
Then restart the miner like usual.

### How do I stop/uninstall the miner?
To stop the miner, run this in the miner folder:
```sh
bash stop-miner.sh
```
In case you also want to uninstall the miner, just remove the entire miner folder.  
