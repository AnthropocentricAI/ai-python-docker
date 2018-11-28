[![Build Status](https://travis-ci.com/AnthropocentricAI/ai-python-docker.svg?branch=master)](https://travis-ci.com/AnthropocentricAI/ai-python-docker)
[![Docker Stars](https://img.shields.io/docker/stars/anthropocentricai/ai-python.svg?style=flat-square)](https://hub.docker.com/r/anthropocentricai/ai-python/)
[![Docker Pulls](https://img.shields.io/docker/pulls/anthropocentricai/ai-python.svg?style=flat-square)](https://hub.docker.com/r/anthropocentricai/ai-python/)
[![Docker Meta](https://images.microbadger.com/badges/image/anthropocentricai/ai-python.svg)](http://microbadger.com/images/anthropocentricai/ai-python)

# Python AI Docker Image #

[This repository](https://github.com/AnthropocentricAI/ai-python-docker) contains a Docker template and a scrip to create AI Docker containers with [Python](https://hub.docker.com/_/python/), based on Alpine Linux. The containers come with `sipy`, `numpy`, `matplotlib`, `scikit-learn` and `jupyterlab`.

To create a new Dockerfile with updated Python packages, simply edit `env.sh` and execute `create_dockerfiles.sh`. This will tag and push the Docker files to GitHub, what will trigger automatic builds on Docker Hub. The images are available [here](https://hub.docker.com/r/anthropocentricai/ai-python/) and are built with the following settings:

| Branch/Tag | Source                                                                       | Location             | Name                          |
|------------|------------------------------------------------------------------------------|----------------------|-------------------------------|
| Tag        | `/^py-\d.\d_ap-\d.\d___np-\d+.\d+.\d+_sp-\d+.\d+.\d+_sk-\d+.\d+.\d+$/`       | `/_versioned`        | `latest`                      |
| Tag        | `/^py-\d.\d_ap-\d.\d___np-(\d+.\d+.\d+)_sp-(\d+.\d+.\d+)_sk-(\d+.\d+.\d+)$/` | `/_versioned`        | `np-{\1}_sp-{\2}_sk-{\3}`     |
| Tag        | `/^py-(\d.\d)_ap-\d.\d___np-(\d+.\d+.\d+)_sp-(\d+.\d+.\d+)_sk-\d+.\d+.\d+$/` | `/_versioned`        | `py-{\1}_np-{\2}_sp-{\3}`     |
| Branch     | `master`                                                                     | `/_versioned`        | `versioned`                   |
| Tag        | `/^py-(\d.\d)_ap-\d.\d___np-(\d+.\d+.\d+)_sp-(\d+.\d+.\d+)_sk-\d+.\d+.\d+$/` | `/_versioned-dev`    | `py-{\1}_np-{\2}_sp-{\3}-dev` |
| Branch     | `master`                                                                     | `/_versioned-dev`    | `versioned-dev`               |
| Branch     | `master`                                                                     | `/_experimental`     | `experimental`                |
| Branch     | `master`                                                                     | `/_experimental-dev` | `experimental-dev`            |

The image is only 95MB!

# Usage #

```bash
$ docker run -it -p 8888:8888 anthropocentricai/ai-python
```

Once you have run this command, point your web browser to [http://127.0.0.1:8888](http://127.0.0.1:8888) and paste the Jupyter Lab token displayed in the terminal.
