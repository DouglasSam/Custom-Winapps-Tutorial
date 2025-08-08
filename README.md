# Win apps tutorial

For you convience I have created a starter script. This script will:

- Dowload Docker, which is used to host the windows virtual machine office will run in
- Download the dependancies requried for winapps
- Create a compose file which tells docker what to do
- Create command aliases to start, pause, stop etc. the windows VM
- Download the winapps config files

The script takes the instructions from [this](https://github.com/winapps-org/winapps/blob/main/docs/docker.md#docker) and the main [win apps tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#installation) part of the setup and tries to make it as automatic as possible.

Either run in the terminal:

```bash
curl -fsSL wai.l.gladiatorsas.me/install.sh | bash
```

to run with defualt options.

OR download it:

```bash
curl -fsSL -o winapps-setup.sh wai.l.gladiatorsas.me/install.sh
```

and edit using nano, or your favorite text editor to edit the username and password this setup will give the windows virtual machine. After editing run it using:

```bash
sudo chmod +x install.sh
./install.sh
```

You will have to run the script twice as it needs to install Docker and change user permissions which require either a log out or restart.

After the restart just re-open the terminal and re run the same command.

After the script has finished running follow the instructions at the end of the script:

1. **Open a new terminal window** (or run `source ~/.bashrc`).
2. **Run** `winvm-create` to start the Windows VM.
3. Once it's running, **open** [http://localhost:8006](http://localhost:8006) in your browser and let Windows install.
   _This may take a while._
4. After reaching the Windows desktop, **install Microsoft Office** — either via the browser or through RDP.


To test rpd (which is required for win apps to work)

```bash
xfreerdp3 /u:"Winapps" /p:"pass" /v:127.0.0.1 /cert:tofu
```

Which will test the rpd connection to the vm which is how it runs applications nativly (also known as magic)

This should pop up the windows desktop in a new window and is just using remote desktop. You can also use this to install office if you want and will probably be smoother than using `localhost:8006` in the browser

If there is a problem that mentions certificates or a Warning view a troubleshooting step in [the main tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#step-4-test-freerdp)

After installing Office on the window VM, and you have verified rdp is working, run:
