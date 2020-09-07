FROM ubuntu

ARG CONDA_INSTALL_SOURCE=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
ARG CONDA_INSTALL_FOLDER="/root/miniconda"

RUN apt-get update
RUN apt-get install -y curl \
                       libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 \
                       libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

RUN curl $CONDA_INSTALL_SOURCE -o /tmp/condainstaller.sh

RUN ( cd tmp && bash /tmp/condainstaller.sh -b -p $CONDA_INSTALL_FOLDER )

ENV PATH "${PATH}:${CONDA_INSTALL_FOLDER}/bin"

RUN conda update -n base -c defaults conda

RUN conda init bash

RUN conda create --name my_env python=3

RUN echo conda activate my_env >> ~/.bashrc

SHELL [ "/bin/bash", "-l", "-c"]

RUN conda list

# ENTRYPOINT [ "conda", "run", "-n", "my_env", "/bin/bash", "-l", "-i" ]
