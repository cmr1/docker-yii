# Dockerized Yii Application

[![Build Status](https://travis-ci.org/cmr1/docker-yii.svg?branch=master)](https://travis-ci.org/cmr1/docker-yii)

### Usage

1. Change directory to your working dir
  - `cd ~/path/to/working/dir`
2. Clone this repo
  - `git clone https://github.com/cmr1/docker-yii.git`
3. Enter this repo directory
  - `cd docker-yii`
4. Create local GitHub token file (for PHP composer install during build)
  - [Generate a GitHub access token](https://github.com/settings/tokens)
    - *This token is for authentication only, it does not require ANY permissions!*
  - `echo "MY-SUPER-SECRET-GITHUB-TOKEN" > .github.token`
    - *Replace `MY-SUPER-SECRET-GITHUB-TOKEN` with the token generated above*
    - *This file must be created, because it is ignored in `.gitignore`*
5. Build Docker containers
  - `docker-compose build`
6. Install composer packages on mounted volume
  - `docker-compose run  app composer install`
7. Run Docker containers
  - `docker-compose up`
8. Visit in your browser!
  - [http://localhost](http://localhost)