# Install R version 3.5
FROM r-base:3.5.1

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev

# Download and install ShinyServer (latest version)
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# Install public R packages from CRAN
RUN R -e "install.packages(c('shiny', 'testthat', 'shinytest'), repos='http://cran.rstudio.com/')"

# Copy local R package to tmp folder, install, and create link for ShinyApp
COPY /RPackageTestDemo /tmp/RPackageTestDemo
RUN R -e "install.packages('/tmp/RPackageTestDemo', repos=NULL, type='source')"
RUN ln -s /usr/local/lib/R/site-library/RPackageTestDemo/shinyApp/app.R /srv/shiny-server/

# Clean up unneccessary resources
RUN sudo rm /srv/shiny-server/index.html
RUN sudo rm -r /srv/shiny-server/sample-apps
RUN sudo rm -r /tmp/RPackageTestDemo

# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh

# Make the ShinyApp available at port 80
EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]