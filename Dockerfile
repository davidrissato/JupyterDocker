FROM ubuntu

ARG CONDA_INSTALL_SOURCE=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
ARG CONDA_INSTALL_FOLDER="/root/miniconda"

# Expose Jupyter http port
EXPOSE 8080

# Basic tools install
RUN apt-get update

RUN apt-get install -y curl net-tools telnet iputils-ping \
                       libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 \
                       libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

# Install coda
RUN curl $CONDA_INSTALL_SOURCE -o /tmp/condainstaller.sh
RUN ( cd tmp && bash /tmp/condainstaller.sh -b -p $CONDA_INSTALL_FOLDER )
ENV PATH "${PATH}:${CONDA_INSTALL_FOLDER}/bin"

# Update conda to latest version
RUN conda update -n base -c defaults conda
RUN conda init bash

# Create a virtual environment for jupyter
ADD ./environment.yml /root/environment.yml
RUN conda env update -f ~/environment.yml

# Generate notebook configuration
RUN jupyter notebook --generate-config

# Run jupyter server
CMD jupyter notebook --ip=0.0.0.0 --port=8080 --no-browser --allow-root
