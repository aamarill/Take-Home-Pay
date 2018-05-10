# Take-Home Pay Calculator
[![CircleCI:](https://circleci.com/gh/aamarill/Take-Home-Pay.svg?style=svg)](https://circleci.com/gh/aamarill/Take-Home-Pay)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A calculator for US federal employees to calculate their take-home pay.
https://take-home-pay.herokuapp.com/


## Installation and configuration

You'll need Rails (recommend version 5.1.5 or newer) and Ruby (recommend version
  2.4.1 or newer).
  
Fork the [original project](https://github.com/aamarill/Take-Home-Pay) on GitHub.
![alt title](app/assets/images/forking_screenshot.png)

Clone your forked repo onto your computer. This will clone it into the current directory you are in, so make sure you are OK with that before cloning.
``` shell
$ git clone https://github.com/YOUR-USERNAME/Take-Home-Pay
```

Install postgreSQL (if not installed already)
```
brew install postgresql
```

If you just installed postgreSQL run the following to avoid any issues during installation.
```
brew services restart postgresql
```

Please go ahead and close and re-open your terminal.

Install all necessary gems.
```shell
$ bundle install
```

Navigate to the directory that you cloned in the previous step.

Start a local server
```shell
$ rails server
```

Then in your browser go to 
```
http://localhost:3000
```
You should see the sign-in page! :tada:

If you see the sign-in page, you are ready to modify your own copy of the
repo.

## Contributing
Once you are ready to submit a modification to the project, you can do so by
creating a pull request to the original repo you forked from on GitHub.

## Deployment
If you would like to host your own copy you can do so with any hosting service
you prefer. The original project was hosted using Heroku.

## Code of Conduct
This project adopted and will enforce the [Open Code of Conduct](http://todogroup.org/opencodeofconduct/)
as its code of conduct. If you experience or witness unacceptable behavior—or have any other concerns—please report it by creating a secret gist and sharing it with [me](https://github.com/aamarill).
