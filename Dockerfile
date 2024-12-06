# get tidyverse docker from rocker
FROM rocker/r-ver:4.4.2

# system libraries
# Try to only install system libraries you actually need
# Package Manager is a good resource to help discover system deps
RUN apt-get update --yes \
 && apt-get upgrade --yes 

# install R packages required 
# Change the packages list to suit your needs
RUN R -e 'install.packages("https://packagemanager.posit.co/cran/latest/src/contrib/Archive/renv/renv_1.0.10.tar.gz")'
RUN echo "options(Ncpus = 6, renv.config.pak.enabled = TRUE)" | tee /usr/local/lib/R/etc/Rprofile.site

# Copy renv files 
WORKDIR /testproject
COPY renv.lock renv.lock

RUN mkdir -p renv
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

# Restore the R environment
RUN R -e "renv::restore()"
