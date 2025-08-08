# Win apps tutorial

## My convince script

For you convince I have created a starter script. This script will:

- Download Docker, which is used to host the windows virtual machine office will run in
- Download the dependencies required for winapps
- Create a compose file which tells docker what to do
- Create command aliases to start, pause, stop etc. the Windows VM
- Download the winapps config files
- Set up aliases for easy managment

The script takes the instructions from [this](https://github.com/winapps-org/winapps/blob/main/docs/docker.md#docker) and the main [win apps tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#installation) part of the setup and tries to make it as automatic as possible.

To view the script [click here](/setup.sh).

Either run in the terminal:

```bash
curl -fsSL %%URL%%/install.sh | bash
```

to run with default options.

OR download it:

```bash
curl -fsSL -o winapps-setup.sh %%URL%%/install.sh
```

and edit using nano, or your favorite text editor to edit the username and password this setup will give the windows virtual machine. After editing run it using:

```bash
sudo chmod +x install.sh
./install.sh
```

You will have to run the script twice as it needs to install Docker and change user permissions which require either a log-out or restart.

After the restart just re-open the terminal and re-run the same command.

After the script has finished open a new terminal (or run `source ~/.bashrc`). This is because the convince script creates aliases and the terminal needs to be reset for them to appear.

## WinVM Command Reference

| Command         | Description                                               |
|-----------------|----------------------------------------------------------|
| winvm-start     | Start the Windows VM container                           |
| winvm-pause     | Pause the Windows VM container                           |
| winvm-unpause   | Unpause the Windows VM container                         |
| winvm-restart   | Restart the Windows VM container                         |
| winvm-stop      | Stop the Windows VM container                            |
| winvm-kill      | Force kill the Windows VM container                      |
| winvm-create    | Create and start the Windows VM container in detached mode|
| winvm-logs      | Show logs for the Windows VM container                   |
| winvm-rdp       | Connect to the Windows VM via RDP                        |
| winvm-help      | Show this help message                                   |


## Creating the windows VM

In your new terminal run 

```bash
winvm-help
```

Just to make sure that the aliases are working.

Then run:

```bash
winvm-create
```

This will start the installation process for the Windows VM. This process can take a while (somewhere between 10 minutes and 1 hour)

To keep an eye on things you can run 

```bash
winvm-logs
```

To see what it is doing.

If you see `TODO` you can go to [http://localhost:8006](http://localhost:8006) in the browser to see either the current process of the install or if you see the desktop go to the next step.

## Remote Desktop Protocol (RDP)

To test rpd (which is required for win apps to work)

```bash
winvm-rpd
```

Which will test the rpd connection to the vm which is how it runs applications natively (also known as magic)

This should pop up the Windows desktop in a new window and is just using remote desktop. You can also use this to install office if you want and will probably be smoother than using `localhost:8006` in the browser

If there is a problem that mentions certificates or a Warning view a troubleshooting step in [the main tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#step-4-test-freerdp)

My convince script should deal with this so shouldn't be a problem in theory.

## First time on desktop

When you first reach the desktop, either through rdp or the browser, there should be a terminal that pops up.

Follow the instructions and it will do magic win apps confguration and should launch the installer for Microsoft office. Install office then you are good to close the browser or the rdp session and luanch the win apps installer.

## Win apps installer

For the main tutorial go [here](https://github.com/winapps-org/winapps?tab=readme-ov-file#step-5-run-the-winapps-installer)

It should be as easy as going to a terminal (on the linux desktop) and running:

```bash
bash <(curl https://raw.githubusercontent.com/winapps-org/winapps/main/setup.sh)
```

and then following the instructions.

Once WinApps is installed, a list of additional arguments can be accessed by running `winapps-setup --help`