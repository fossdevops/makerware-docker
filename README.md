# makerware-docker
Docker image to run Makerbot makerware (Makerbot Desktop)

## Requires
 - x11docker - https://github.com/mviereck/x11docker
 - udev rule for makerbot to be installed (55-makerbot-dev.rules to /etc/udev/rules.d/) and applied () before plugging in/turning on the makerbot
 - docker
 - docker-compose

## TODO:
 - Try changing default device settings (dont know if that works)
 - Add some way to restart the conveyor service container triggered from the makerware container
   (hook the systemctl restart to rm conveyord.pid [used to mark service healthy])
 - try printing something
 - try a firmware update
 - only tested with a makerbot replicator 2
 - only tested on linux (but modern linux! debian unstable). meaning havent tried on Windows with wsl2 or OSX with docker desktop.
   These will likely not work.

## How to Use
 - Verify the pre-requisites from above have been met
 - Add your current user to the docker system group
 - Copy the `docker-compose.yml` file and the `run.sh` script to the current directory and give the `run.sh` script execute permissions if it doesnt have them
 - Run the `run.sh` script.  By default, the user's home directory will be applied as a mount and be visible in the Makerbot Desktop app, but nothing else

## Please note
The docker-compose file is not directed at nvidia user.  This doesnt mean it wont work, but may need some slight changes.  Notes for this are in the docker-compose.yml file