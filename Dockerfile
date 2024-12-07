# get tidyverse docker from rocker
FROM rocker/r-ver:4.4.2

# system libraries
# Try to only install system libraries you actually need
# Package Manager is a good resource to help discover system deps
RUN apt-get update --yes \
 && apt-get upgrade --yes 

# install R packages required 
RUN R -e 'install.packages("https://packagemanager.posit.co/cran/latest/src/contrib/Archive/renv/renv_1.0.10.tar.gz")'
RUN echo "options(Ncpus = 6, renv.config.pak.enabled = TRUE)" | tee /usr/local/lib/R/etc/Rprofile.site

# Copy renv files 
WORKDIR /testproject
COPY renv.lock renv.lock

# Restore the R environment
RUN R -s -e 'renv::diagnostics()'
RUN R -e "renv::restore(lockfile = 'renv.lock')"