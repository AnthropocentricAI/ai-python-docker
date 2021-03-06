ARG ALPINE_VERSION=3.8
ARG PYTHON_VERSION=3.7.1
ARG PYTHON_BASE=3.7

# ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ #
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} as base
MAINTAINER Kacper Sokol <ks1591@bristol.ac.uk>

RUN rm -fr /usr/local/lib/python3.*/config-3.*m-x86_64-linux-gnu

# ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ #
FROM base as builder
ARG PYTHON_BASE

RUN mkdir /install

# RUN apk --no-cache --update-cache add gcc wget python python-dev py-pip
# RUN echo "http://dl-8.alpinelinux.org/alpine/v3.8/community" >> \
#   /etc/apk/repositories
# RUN apk --no-cache --update-cache add py-numpy@community py-scipy@community
# RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN apk --no-cache --update-cache add \
# numpy & scipy
  gfortran build-base openblas-dev \
# matplotlib
  freetype-dev libpng-dev \
# file & strip
  file binutils

ENV PYTHONPATH="/install/lib/python${PYTHON_BASE}/site-packages:${PYTHONPATH}"
ENV PATH="/install/bin:${PATH}"

COPY requirements*.txt /

# --target="/install"
RUN touch /requirements-dev.txt && \
    pip install --no-cache-dir \
                --install-option="--prefix=/install" \
                -r /requirements.txt \
                -r /requirements-aux.txt \
                -r /requirements-dev.txt

RUN find /install/lib/python3.*/site-packages/ \( -name '__pycache__' -o -name 'test' -o -name 'tests' \) -type d -print0 | xargs -0 rm -rf -- && \
    find /install/share/jupyter/lab/static/ -name '*.map' -print -exec rm "{}" \; && \
    rm -rf /root/.cache && \
    rm -rf /tmp/* && \
    find /install/lib/python3.*/site-packages/ -name '*.so' -print -exec /bin/sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \;

# ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ #
FROM base as scientific-python

RUN apk --no-cache add \
# numpy & scipy
  openblas \
# pyzmq (jupyter lab)
  libstdc++ \
# matplotlib
  freetype libpng && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

COPY --from=builder /install /usr/local

ENV A_USER=jovian \
    A_UID=1000 \
    A_HOME=/jovian \
    A_SHELL=/bin/sh
RUN mkdir ${A_HOME} && \
    adduser -D -s ${A_SHELL} -u ${A_UID} -h ${A_HOME} ${A_USER} && \
    chown ${A_USER} ${A_HOME}
WORKDIR ${A_HOME}
USER ${A_USER}

RUN jupyter serverextension enable --py jupyterlab

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
