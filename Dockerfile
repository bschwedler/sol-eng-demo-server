FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Install RStudio Server Pro session components -------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gdebi \
    libcurl4-gnutls-dev \
    libssl1.0.0 \
    libssl-dev \
    libuser \
    libuser1-dev \
    rrdtool \
    wget

ARG RSP_PLATFORM=xenial
ARG RSP_VERSION=1.4.1106-5
RUN curl -O https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    mkdir -p /usr/lib/rstudio-server && \
    tar -zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ && \
    mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ && \
    rm -rf /usr/lib/rstudio-server/rsp-session* && \
    rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz

EXPOSE 8788/tcp

# Install additional system packages ------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    libxml2-dev \
    # these are other package system requirements, should uncomment and re-run
    subversion \
    lmodern \
    bowtie2 \
    bwidget \
    cargo \
    cmake \
    coinor-libclp-dev \
    dcraw \
    gdal-bin \
    ggobi \
    haveged \
    imagej \
    imagemagick \
    jags \
    libapparmor-dev \
    libatk1.0-dev \
    libavfilter-dev \
    libcairo2-dev \
    #libcurl4-openssl-dev \
    libfftw3-dev \
    libfreetype6-dev \
    libgdal-dev \
    libgeos-dev \
    libgit2-dev \
    libgl1-mesa-dev \
    libglib2.0-dev \
    libglpk-dev \
    libglu1-mesa-dev \
    libgmp3-dev \
    libgpgme11-dev \
    libgsl0-dev \
    libgtk2.0-dev \
    libhdf5-dev \
    libhiredis-dev \
    libicu-dev \
    libimage-exiftool-perl \
    libjpeg-dev \
    libjq-dev \
    libleptonica-dev \
    libmagic-dev \
    libmagick++-dev \
    libmpfr-dev \
    libmysqlclient-dev \
    libnetcdf-dev \
    libopenmpi-dev \
    libpango1.0-dev \
    libpng-dev \
    libpoppler-cpp-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libqgis-dev \
    libraptor2-dev \
    librasqal3-dev \
    librdf0-dev \
    librrd-dev \
    librsvg2-dev \
    libsasl2-dev \
    libsecret-1-dev \
    libsndfile1-dev \
    libsodium-dev \
    libssh2-1-dev \
    libssl-dev \
    libtesseract-dev \
    libtiff-dev \
    libudunits2-dev \
    libv8-dev \
    libwebp-dev \
    libxft-dev \
    libxml2-dev \
    libxslt-dev \
    libzmq3-dev \
    make \
    nvidia-cuda-dev \
    ocl-icd-opencl-dev \
    openjdk-8-jdk \
    pari-gp \
    perl \
    protobuf-compiler \
    rustc \
    saga \
    saint \
    swftools \
    tcl \
    tesseract-ocr-eng \
    texlive \
    texlive-latex-extra \
    tk \
    tk-table \
    unixodbc-dev \
    wget \
    zlib1g-dev  \
    libfontconfig1-dev \
    # other dev dependencies
    vim \
    psmisc \
    qpdf \
    tree


# Install Arrow Sysdeps (Instructions here: https://arrow.apache.org/install/)
# RUN apt-get update -y && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y \
#     apt-transport-https \
#     gnupg \
#     lsb-release

# RUN wget -O /usr/share/keyrings/apache-arrow-keyring.gpg https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-keyring.gpg
# # RUN tee /etc/apt/sources.list.d/apache-arrow.list <<APT_LINE \
# #     deb [arch=amd64 signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main \
# #     deb-src [signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main \
# #     APT_LINE


# RUN apt-get update -y && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y \
#     libarrow-dev \
#     libarrow-glib-dev \
#     libarrow-flight-dev \
#     libplasma-dev \
#     libplasma-glib-dev \
#     libgandiva-dev \
#     libgandiva-glib-dev \
#     libparquet-dev \
#     libparquet-glib-dev


# Install R -------------------------------------------------------------------#

ARG R_VERSION=3.6.1
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION}_1_amd64.deb && \
    rm -f ./r-${R_VERSION}_1_amd64.deb

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

# Install R packages ----------------------------------------------------------#

RUN JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 /opt/R/${R_VERSION}/bin/R CMD javareconf

#COPY ./pkg_names.csv /opt/R/${R_VERSION}/lib/pkg_names.csv
#COPY ./pkg_installer.R /opt/R/${R_VERSION}/lib/pkg_installer.R

ARG R_REPO='https://colorado.rstudio.com/rspm/cran/__linux__/bionic/latest'
ARG R_REPO_LATEST='https://colorado.rstudio.com/rspm/cran/__linux__/bionic/latest'
RUN echo "options(\"repos\" = c(RSPM = \"${R_REPO}\"), \"HTTPUserAgent\" = \"R/${R_VERSION} R (${R_VERSION} x86_64-pc-linux-gnu x86_64-pc-linux-gnu x86_64-pc-linux-gnu)\");" >> \
	/opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

# need to install packages from list of packages...
#RUN /opt/R/${R_VERSION}/bin/R -e "source(\"/opt/R/${R_VERSION}/lib/pkg_installer.R\"); docker_pkg_install(\"/opt/R/${R_VERSION}/lib/pkg_names.csv\", \"/opt/R/${R_VERSION}/lib/R/library\")"

# Install jupyter -------------------------------------------------------------#

ARG JUPYTER_VERSION=3.6.9
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -bp /opt/python/jupyter && \
    /opt/python/jupyter/bin/conda install -y python==${JUPYTER_VERSION} && \
    rm -rf Miniconda3-latest-Linux-x86_64.sh && \
    /opt/python/jupyter/bin/pip install \
    jupyter \
    jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter && \
    /opt/python/jupyter/bin/jupyter kernelspec remove python3 -f && \
    /opt/python/jupyter/bin/pip uninstall -y ipykernel

# Install RSP/RSC Notebook Extensions --------------------#

RUN /opt/python/jupyter/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/python/jupyter/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/python/jupyter/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/python/jupyter/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/python/jupyter/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

# Install Python --------------------------------------------------------------#

ARG PYTHON_VERSION=3.7.3
COPY ./requirements.txt /opt/python/requirements.txt
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh && \
    bash Miniconda3-4.7.12.1-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/conda install -y python==${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    /opt/python/${PYTHON_VERSION}/bin/pip install -r /opt/python/requirements.txt && \
    rm -rf Miniconda3-*-Linux-x86_64.sh && \
    /opt/python/${PYTHON_VERSION}/bin/python -m ipykernel install --name py${PYTHON_VERSION} --display-name "Python ${PYTHON_VERSION}"

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"
ENV RETICULATE_PYTHON="/opt/python/${PYTHON_VERSION}/bin/python"

# Install VSCode code-server --------------------------------------------------#
ARG CODE_SERVER_VERSION=3.2.0
# TODO: remove the temporary regex to resolve different behavior for code-server
RUN curl -o code-server.tar.gz -L https://github.com/cdr/code-server/releases/download/$( echo $CODE_SERVER_VERSION | sed -r 's/(3\.2\.0)/\1/; t; s/([0-9]\.[0-9]\.[0-9])/v\1/' )/code-server-${CODE_SERVER_VERSION}-linux-$( echo $CODE_SERVER_VERSION | sed -r 's/(3\.2\.0)/x86_64/; t; s/([0-9]\.[0-9]\.[0-9])/amd64/' ).tar.gz && \
    mkdir -p /opt/code-server && \
    tar -zxvf ./code-server.tar.gz -C /opt/code-server/ --strip-components 1 && \
    rm -f ./code-server.tar.gz

RUN curl -o Ikuyadeu.r-1.1.0.vsix.gz -L https://rstd.io/vs-code-r-ext  && \
    gunzip Ikuyadeu.r-1.1.0.vsix.gz && \
    /opt/code-server/code-server --extensions-dir /opt/code-server/extensions --install-extension Ikuyadeu.r-1.1.0.vsix && \
    rm -rf Ikuyadeu.r-1.1.0.vsix.gz Ikuyadeu.r-1.1.0.vsix

RUN /opt/code-server/code-server --extensions-dir /opt/code-server/extensions --install-extension ms-python.python

# Install RStudio Professional Drivers ----------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev gdebi

ARG DRIVERS_VERSION=1.7.0
RUN curl -O https://drivers.rstudio.org/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    rm rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    cat /opt/rstudio-drivers/odbcinst.ini.sample | tee /etc/odbcinst.ini && \
    # Fix odbcinst.ini until we release 1.6.1 .deb/.rpm
    sed -i '/Installer = RStudio$/cInstaller = RStudio Pro Drivers' /etc/odbcinst.ini && \
    # Fix Snowflake cacert issue
    sed -i 's_\[INSTALLDIR\]_/opt/rstudio-drivers/snowflake/bin_' /opt/rstudio-drivers/snowflake/bin/lib/rstudio.snowflakeodbc.ini

# Install Instant Client for Oracle Driver
RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_19_10/* /opt/rstudio-drivers/oracle/bin/lib/ && \
    rm instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip 

# install latest versions of important IDE packages
RUN /opt/R/${R_VERSION}/bin/R -e "install.packages(c(\"odbc\", \"rsconnect\", \"rstudioapi\"), repos=\"${R_REPO_LATEST}\")"

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales locales-all
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC
ENV R_BUILD_TAR /bin/tar
