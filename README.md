## Build machine learning environment on OrangePi Zero Plus(arm64)
Quickly build ML env by simply run a script. 
It will automatically install some programs and python packages used for machine learning. 
This also works on RaspberryPi 3(arm64).

Simply clone this repo or download zip file and run `bash run_me.sh`

This script will call `sudo nmtui` first, a CLI tool to configure your network, and 
type in the password when needed.

If you know how to use `apt` and `pip`, just read the script and 
select which line you want to run.

## Attention
- I dont need python3 so this `run_me.sh` script is only for **python2**. 
If you want python3 support, I recommand to read `run_me.sh` file and select 
lines you need then run them.

- Some python packages are difficult to install by `python setup.py install` 
because they depends on compiled C dynamically linked libraries, such as `numpy`, 
`tensorflow`, `pylsl` and so on. `setup.py` will call your compiler(gcc or others) 
to compile from source. This is slow and easy to cause errors(lack of dependences).

- But `apt-get install python-xxx` will download `.deb` file which contains already 
pre-compiled libs for current architecture, then your job is just unpackage it(apt 
will do this for you). So I prefer this method when installing huge, C lib dependes 
packages.

- Difference between `pip install xxx` and `apt install python-xxx`:
    - pip will put packages in `/usr/local/lib/pythonx.x/dist-packages`
    - apt will put them into `/usr/lib/pythonx.x/dist-packages`
    - search on stackoverflow.com for more details
