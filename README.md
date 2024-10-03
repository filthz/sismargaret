### Prerequisites
- A machine with Linux installed (WSL 2 might work as well)
- Docker installed (here is [the official guide](https://docs.docker.com/engine/install/ubuntu/) on how to install Docker on Ubuntu)
- Knowing how to use the terminal (here is [a guide](https://ubuntu.com/tutorials/command-line-for-beginners#3-opening-a-terminal) on how to get started with Terminal on Ubuntu)
- If you want to allow others to factor the same number with you, set up port forwarding on TCP port 7777 and 24242 (google "your router brand or model number here" router port forwarding setup)

Let us know if you use Linux distribution other than Ubuntu and need help setting up Docker  
We don't have native Windows support yet, but [Docker on WSL 2](https://docs.docker.com/desktop/wsl) might work.

### 1. Register on Sister Margaret's and copy your API key
Go to https://sismargaret.fact0rn.io/ and register by clicking "new user". Afterwards, retype your username/password to login.  
Once you're in the dashboard, click on your username on the top left to enter the profile page. It's below "Sister Margaret's" and above "logout".  
At the profile page, copy your API key (it starts with `eyJhbGciOiJIUzUxMiJ9.` and is roughly 227 characters long)  
Keep the API key secret and don't send it to anyone else, including the developers.

### 2. Download the custom miner and add your API key to application.yml
Download the supplementary files from https://github.com/filthz/sismargaret/archive/refs/heads/main.zip and extract them somewhere.  
Next, download the main miner (sismargaret-miner) from https://github.com/filthz/sismargaret/releases and put it in the same location as the supplementary files. Dockerfile and sismargaret-miner should be in the same folder.  
Now, open application.yml with your favorite text editor and paste your API key into the `authToken` field, like this:
```
cadoPath: "/cado-nfs/cado-nfs.py"
cadoCliPath: "/cado-client.sh"

# Change this to the output of the "nproc" command
serverThreads: "16"
authToken: "eyJhbGciOiJIUzUxMiJ9.[REDACTED]"
```
Notice how the API key is within the double quotes  
You should also modify serverThreads to the amount of threads your CPU have. If you're not sure of the amount, you can run the `nproc` command and use its output instead. For instance, it'll be "32" on 7950X

### Notice: Updating from 1.0 to 1.1
If you were using miner version 1.0, first stop it with `sudo docker stop $(sudo docker ps -aq -f ancestor=margaret-miner); sudo docker rm $(sudo docker ps -aq -f ancestor=margaret-miner)`  
After doing that, or if it's your first time setting up the miner, proceed to step 3 like usual.

### 3. Build and start the custom miner with Docker
Open a Terminal in the miner's folder. This can usually be done by pressing shift + right clicking within the folder and choosing the right option  
Within the terminal, run the following command to install the miner:
```
sudo docker build -t sismargaret-miner .
```
Run this command in the folder again every time you update the miner or the `application.yml` file.  
This may take up to 10~20 minutes to run, depending on your CPU. During this period, the miner compiles Cado-NFS on your computer to make sure it's optimized for the CPU you have.  

Finally, start the miner by running:
```
sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker run --init -it -p 7777:7777 -p 24242:24242 --name sismargaret-miner sismargaret-miner
```
The commands above stops and removes previously running miner instances, so you can also use it to restart the miner (eg. after an update or reboot)  

If you want the miner to automatically restart after a reboot, add `-d --restart unless-stopped` to the command, like this:
```
sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker run --init -it -p 7777:7777 -p 24242:24242 -d --name sismargaret-miner --restart unless-stopped sismargaret-miner
```
In the case above, you can view the miner's status by running `sudo docker logs -f $(sudo docker ps -aq -f name=sismargaret-miner)`

### 4. Accept jobs or join existing factorizations
Now that the miner is started and connected to Sister Margaret's, there are two ways you can start contributing:  
- On the "Open jobs" interface, choose a job you want to perform by pressing "compute". A few seconds later, your miner will start factoring the number. You can see that the job moved to "Jobs in progress". You'll know the number is factored when it moves to "Finished Jobs" or by monitoring the miner's logs.  
- On the "Jobs in progress" interface, jobs with status "CALCULATING" allow you to help factoring the number by pressing "connect". This is especially helpful when the number is difficult (>= c130). You can't connect to jobs with status "NO_CONNECTION_MINER", because that means the owner of the miner didn't set up port forwarding on port 7777 and/or 24242.

The "c" column stands for the digit, or the "difficulty" of the number. c100 can be factored within 10 minutes if you have a fast computer, c110 takes 3x more work to factor than c100, c120 takes 9x more work to factor than c100, etc.

### Updating the miner
Repeat step 2 and 3 in the same folder, overwriting previously existing files.
