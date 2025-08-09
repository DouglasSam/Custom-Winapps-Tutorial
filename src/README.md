# Win apps tutorial

## My convenience script

For you convenience I have created a starter script. This script will:

- Download Docker, which is used to host the windows virtual machine office will run in
- Download the dependencies required for winapps
- Create a compose file which tells docker what to do
- Create command aliases to start, pause, stop etc. the Windows VM
- Download the winapps config files
- Set up aliases for easy managment

The script takes the instructions from [this](https://github.com/winapps-org/winapps/blob/main/docs/docker.md#docker) and the main [win apps tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#installation) part of the setup and tries to make it as automatic as possible.

To view the script [click here](/setup.sh?CPU_CORES=4&RAM_SIZE=4G).

Either run in the terminal:

```bash
curl -fsSL %%URL%%/install.sh | bash
```

which will default the VM to use 4 cpu cores and 4GB of RAM,

To change run

```bash
curl -fsSL %%URL%%/install.sh?CPU_CORES=2&RAM_SIZE=8G | bash
```

which makes the VM use 2 cpu cores and 8GB of RAM, you can change the numbers to suit your needs.

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

After the script has finished open a new terminal (or run `source ~/.bashrc`). This is because the convenience script creates aliases and the terminal needs to be reset for them to appear.

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

If you see `Windows started succesfully` you can go to [http://localhost:8006](http://localhost:8006) in the browser to see either the current process of the install or if you see the desktop go to the next step.

## Remote Desktop Protocol (RDP)

To test rpd (which is required for win apps to work)

```bash
winvm-rpd
```

Which will test the rpd connection to the vm which is how it runs applications natively (also known as magic)

This should pop up the Windows desktop in a new window and is just using remote desktop. You can also use this to install office if you want and will probably be smoother than using `localhost:8006` in the browser

If there is a problem that mentions certificates or a Warning view a troubleshooting step in [the main tutorial](https://github.com/winapps-org/winapps?tab=readme-ov-file#step-4-test-freerdp)

My convenience script should deal with this so shouldn't be a problem in theory.

## First time on desktop

When you first reach the desktop, either through rdp or the browser, there should be a terminal that pops up.

Follow the instructions, and it will do magic win apps configuration.

Afterwards go to the file explorer, go to `C:\OEM` and run the file `install-office.bat`. 

If that does not work, sorry, you will have to install office manually, which can be hard because this version of Windows 11 does not have a browser installed.

Wait for office to finish installing before continuing. This can take a while depending on the VM settings, internet and the physical machine.

You might also want to open the applications and follow any pop-ups, e.g. signing into office. I found that when installed through winapps it does not show popups and will seem like the application is frozen.

## Win apps installer

For the main tutorial go [here](https://github.com/winapps-org/winapps?tab=readme-ov-file#step-5-run-the-winapps-installer)

It should be as easy as going to a terminal (on the linux desktop) and running:

```bash
bash <(curl https://raw.githubusercontent.com/winapps-org/winapps/main/setup.sh)
```

and then following the instructions.

When you get to `Automatically install supported applications or choose manually>` make sure to choose manual. You can also just press enter three times.

After the blue selection screen it wil do some checks. If it fails saying it cannot connect to windows through rdp run the command:

```bash
rm -r ~/.config/freerdp
```

Afterwards continue until it asks:
> How would you like to handle officially supported applications?

Choose the second option: 
> Choose specific officially supported applications to set

![First option screen](/images/first-option.png)

This will just avoid bloat of other applications that you may not want to use.

Choose the applications you want to use with spacebar (DO NOT USER ENTER, that will go to the next step).

![WinApps selection screen](/images/select-apps.png)

On the **How would you like to handle other detected applications?** screen, you can probably choose:
> Do not set up any applications

![WinApps other applications screen](/images/other-apps.png)

Feel free to have a look at the other application but most probably aren't wanted. For example these were what was listed for me:

![WinApps other applications list](/images/other-apps-list.png)

After that you should be done with the setup, and should be able to see that apps that you selected inside the linux menu.

Once WinApps is installed, a list of additional arguments can be accessed by running `winapps-setup --help`

## Notes

It is very janky, the opening and moving of windows is not smooth and the windows things might show through at times. It does not seem to be able to handle multiple applications open as different apps, so if you for example open Word and Excel, it will only show one as one application in the taskbar.

<div class="window-images">

![Word-working](/images/word-working.png)

![Word-and-Excel](/images/word-and-excel.png)

</div>

If there are problems, like the window appears frozen you can get to the full desktop by running the windows application, which will launch it through rdp, or by running winvm-rdp in the terminal. Note this will close all applications and open the Linux desktop.

You might need to do this if the application pops something up that win apps does not display. Just launch rdp and open it on there.