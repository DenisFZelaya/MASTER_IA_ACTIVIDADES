# Dockerfile script to create and install singularity using docker.
# Author: Gabriel Gutierrez
#
# Build Command
# docker build . -t singularity
#
# Run Command
# docker run -it --privileged singularity
#
# Once inside the VM, execute the following command to test the singularity program (it will take a while)
#
# ./test.sh

FROM ubuntu:22.04

# Update system
RUN apt update && apt -y upgrade && apt -y autoremove
RUN apt install -y wget git \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    pkg-config \
    golang-go 

# Install singularity
RUN wget https://github.com/sylabs/singularity/releases/download/v4.1.1/singularity-ce_4.1.1-jammy_amd64.deb && apt install -y ./singularity-ce_4.1.1-jammy_amd64.deb && rm singularity-ce_4.1.1-jammy_amd64.deb

# Set working directory
WORKDIR /workspace

# Create test.sh file
RUN echo '#!/bin/bash' > /workspace/test.sh && \
    echo "cd /workspace/" >> /workspace/test.sh && \
    echo "singularity build /home/planner.img Singularity" >> /workspace/test.sh && \
    echo "cd /home" >> /workspace/test.sh && \
    echo "git clone https://bitbucket.org/ipc2018-classical/demo-submission.git" >> /workspace/test.sh && \
    echo "RUNDIR=\"$PWD/demo-submission/misc/tests/benchmarks/miconic/\"" >> /workspace/test.sh && \
    echo "DOMAIN=\"$RUNDIR/domain.pddl\"" >> /workspace/test.sh && \
    echo "PROBLEM=\"$RUNDIR/s1-0.pddl\"" >> /workspace/test.sh && \
    echo "PLANFILE=\"$RUNDIR/sas_plan\"" >> /workspace/test.sh && \
    echo "COSTBOUND=42" >> /workspace/test.sh && \
    echo "ulimit -t 1800" >> /workspace/test.sh && \
    echo "ulimit -v 8388608" >> /workspace/test.sh && \
    echo "singularity run -C -H $RUNDIR /home/planner.img \$DOMAIN \$PROBLEM \$PLANFILE \$COSTBOUND" >> /workspace/test.sh && \
    chmod +x /workspace/test.sh

