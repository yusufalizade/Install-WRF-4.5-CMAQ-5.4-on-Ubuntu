#!/bin/sh

: '

This shell script assists WRF/CMAQ users in installing the Weather Research and Forecasting (WRF) model version 4.5 / US EPA Community Multiscale Air Quality Model (CMAQ) version 5.4 on Ubuntu 22.04.2 LTS in 64-bit system.

Author: Yusuf Aydin (Yusuf Alizade Govarchin Ghale)
***************************************************
PhD
Department of Climate and Marine Sciences
Eurasia Institute of Earth Sciences
Istanbul Technical University
Maslak 34469, Istanbul, Turkey
Email: yusufalizade2000@gmail.com
Email: yusufaydin@itu.edu.tr
Email: alizade@itu.edu.tr
Tel:   +90 537 919 7953

'
#***********************************************************************************************************************************************

# Install required libraries including NetCDF-C, NetCDF-Fortran, Zlib, MPICH and IOAPI

echo "******************************************************************************************************************************************"
echo 								"Install basic libraries"
echo "******************************************************************************************************************************************"

sudo apt update
sudo apt upgrade
sudo apt install -y tcsh git libcurl4-openssl-dev
sudo apt install -y make gcc cpp gfortran openmpi-bin libopenmpi-dev
sudo apt install libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg build-essential unzip mlocate byacc flex

#************************************************************************************************************************************************

# Make required directories

# Change current directory to home directory and export environmental variables as child processes without affecting the existing environmental variable

echo "*******************************************************************************************************************************************"
echo 					"Make required directories and set environment variables and compilers"
echo "*******************************************************************************************************************************************"

export HOME=`cd;pwd`
mkdir $HOME/Models
mkdir $HOME/Models/WRF-CMAQ
export WRFCMAQ_HOME=$HOME/Models/WRF-CMAQ
cd $WRFCMAQ_HOME
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH
mkdir Libs/IOAPI
export DIR=$WRFCMAQ_HOME/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#***********************************************************************************************************************************************

# Download and install Zlib library

echo "******************************************************************************************************************************************"
echo					 "Download and install Zlib library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://www.zlib.net/fossils/zlib-1.2.13.tar.gz
tar -xzvf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure --prefix=$DIR/grib2
make 
make install

#***********************************************************************************************************************************************

# Download and install hdf5 library 

echo "******************************************************************************************************************************************"
echo 					"Download and install hdf5 library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.13/hdf5-1.13.2/src/hdf5-1.13.2.tar.gz
tar -xvzf hdf5-1.13.2.tar.gz
cd hdf5-1.13.2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

#***********************************************************************************************************************************************

# Download and install Netcdf C library

echo "******************************************************************************************************************************************"
echo 					"Download and install Netcdf C library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.0.tar.gz -O netcdf-c-4.8.0.tar.gz
tar -xzvf netcdf-c-4.8.0.tar.gz 
cd netcdf-c-4.8.0
export CPPFLAGS=-I$DIR/grib2/include
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-netcdf-4 --disable-dap
make
make install
export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF

#***********************************************************************************************************************************************

# Download and install Netcdf fortran library

echo "******************************************************************************************************************************************"
echo 					"Download and install Netcdf fortran library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz -O netcdf-fortran-4.5.3.tar.gz
tar -xzvf netcdf-fortran-4.5.3.tar.gz 
cd netcdf-fortran-4.5.3
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF 
make
make install

#***********************************************************************************************************************************************

# Download and install Jasper library

echo "******************************************************************************************************************************************"
echo 					"Download and install Jasper library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c  http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
unzip jasper-1.900.1.zip
cd jasper-1.900.1
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

#***********************************************************************************************************************************************

# Download and install Libpng library

echo "******************************************************************************************************************************************"
echo					 "Download and install Libpng library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
tar -xzvf libpng-1.6.39.tar.gz
cd libpng-1.6.39/
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
./configure --prefix=$DIR/grib2
make
make install

#***********************************************************************************************************************************************

# Download and install Mpich library

echo "******************************************************************************************************************************************"
echo 					"Download and install Mpich library and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://www.mpich.org/static/downloads/4.1.2/mpich-4.1.2.tar.gz
tar -xzvf mpich-4.1.2.tar.gz
cd mpich-4.1.2
./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch
make
make install
export PATH=$DIR/MPICH/bin:$PATH

#***********************************************************************************************************************************************

# Download and install IOAPI library

echo "******************************************************************************************************************************************"
echo 					"Download and install IOAPI library and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads

#Download IOAPI using one of the following commands;
#wget https://www.cmascenter.org/ioapi/download/ioapi-3.2.tar.gz
#or 
git clone https://github.com/cjcoats/ioapi-3.2
cd ioapi-3.2
git checkout -b 20200828
export BIN=Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0
mkdir Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0
ln -sf $DIR/NETCDF/lib/* Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0
cp ioapi/Makefile.nocpl ioapi/Makefile
cp m3tools/Makefile.nocpl m3tools/Makefile
cp Makefile.template Makefile

sed -i '190i DIR     = $(WRFCMAQ_HOME)/Libs\
LIBINST = $(DIR)/IOAPI/lib\
BININST = $(DIR)/IOAPI/bin\
CPLMODE = nocpl' Makefile

sed -i -s 's+NCFLIBS    = -lnetcdff -lnetcdf+NCFLIBS    = -L$(NETCDF)/lib -lnetcdf -lnetcdff+g' Makefile

cd ioapi
cp Makeinclude.Linux2_x86_64gfort Makeinclude.Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0
cd ..
find $WRFCMAQ_HOME/Downloads/ioapi-3.2/ioapi -type f -name Makeinclude.Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0 -exec sed -i 's/OMPFLAGS  = #-fopenmp/OMPFLAGS  = -fopenmp/g' {} +
find $WRFCMAQ_HOME/Downloads/ioapi-3.2/ioapi -type f -name Makeinclude.Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0 -exec sed -i 's/OMPLIBS   = #-fopenmp/OMPLIBS   = -fopenmp/g' {} +
find $WRFCMAQ_HOME/Downloads/ioapi-3.2/ioapi -type f -name Makeinclude.Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0 -exec sed -i 's/FOPTFLAGS = -O3 ${MFLAGS}/FOPTFLAGS = -O3 -std=legacy ${MFLAGS}/g' {} +

make configure
make | tee make.ioapi.log
make install

: '

Check the existance of libioapi.a, libnetcdf.a and libnetcdff.a in the $BIN directory to be sure that libioapi.a was successfully built

ls $BIN/*.a

Also, check the existance of m3xtract to be sure about the successfull installation of m3tools

ls $BIN/m3xtract


# Test ioapi 

$WRFCMAQ_HOME/Downloads/ioapi-3.2/Linux2_x86_64gfort_openmpi_4.1.2_gcc_11.4.0/juldate

'

# Download and install WRF library

echo "******************************************************************************************************************************************"
echo 					"Download and install WRF and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.5/v4.5.tar.gz -O wrf-4.5.tar.gz
tar -xzvf wrf-4.5.tar.gz -C $WRFCMAQ_HOME
cd $WRFCMAQ_HOME/WRFV4.5

./configure | tee configure.log
# Select option 34 (dmpar GNU) for gfortran/gcc and option 1 (basic) for compiler nesting

./compile em_real 2>&1 | tee wrf_compile.log

export WRF_DIR=$WRFCMAQ_HOME/WRFV4.5

: '

Check the existence of executable files in the following links using;

ls -lah main/*.exe
ls -lah run/*.exe
ls -lah test/em_real/*.exe

If you see all of the executable files including;

ndown.exe
real.exe 
tc.exe 
wrf.exe 

the installation is successfully completed. 

Check the wrfchem_compile.log file if there is any error.
'

#***********************************************************************************************************************************************

# Download and install WPS library

echo "******************************************************************************************************************************************"
echo 					"Download and install WPS and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz -O wps-4.5.tar.gz
tar -xzvf wps-4.5.tar.gz -C $WRFCMAQ_HOME
cd $WRFCMAQ_HOME/WPS-4.5

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./configure
# Select option 3 (Linux x86-64) gfortran (dmpar) for gfortran and distributed memory

./compile

export PATH=$DIR/bin:$PATH
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH

: '

Check the existence of executable files;

ls *.exe

If  you see all of the executable files including

geogrid.exe
metgrid.exe
ungrib.exe 

the installation is successfully compeleted.

'

#***********************************************************************************************************************************************

# Download and install CMAQ library

echo "******************************************************************************************************************************************"
echo 					"Download and install CMAQ and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCMAQ_HOME/Downloads
git clone https://github.com/USEPA/CMAQ.git CMAQ_REPO
cd CMAQ_REPO
git checkout -b my_branch
cp bldit_project.csh bldit_project.csh.old

sed -i -s 's+set WRFCMAQ_HOME = /home/username/path+set WRFCMAQ_HOME = $WRFCMAQ_HOME/CMAQV54+g' bldit_project.csh

./bldit_project.csh

cd $WRFCMAQ_HOME/CMAQV54

cp config_cmaq.csh config_cmaq.csh.old

sed -i -s 's+setenv WRFCMAQ_HOME $cwd+setenv WRFCMAQ_HOME $WRFCMAQ_HOME/CMAQV54+g' config_cmaq.csh

sed -i '159i\        setenv IOAPI_INCL_DIR	$WRFCMAQ_HOME/Downloads/ioapi-3.2/ioapi/fixed_src\
        setenv IOAPI_LIB_DIR	$WRFCMAQ_HOME/Libs/IOAPI/lib\
	setenv NETCDF_LIB_DIR	$WRFCMAQ_HOME/Libs/NETCDF/lib\
	setenv NETCDF_INCL_DIR	$WRFCMAQ_HOME/Libs/NETCDF/include\
	setenv NETCDFF_LIB_DIR	$WRFCMAQ_HOME/Libs/NETCDF/lib\
	setenv NETCDFF_INCL_DIR	$WRFCMAQ_HOME/Libs/NETCDF/include\
	setenv MPI_INCL_DIR	$WRFCMAQ_HOME/Libs/MPICH/include\
	setenv MPI_LIB_DIR	$WRFCMAQ_HOME/Libs/MPICH/lib' config_cmaq.csh

sed -i -s 's+setenv myLINK_FLAG # "-fopenmp" openMP not supported w/ CMAQ+setenv myLINK_FLAG "-fopenmp" #openMP not supported w/ CMAQ+g' config_cmaq.csh

./config_cmaq.csh gcc

cd $WRFCMAQ_HOME/CMAQV54/CCTM/scripts 

cp bldit_cctm.csh bldit_cctm.csh.old

sed -i -s 's+set shaID   = `git --git-dir=${CMAQ_REPO}/.git rev-parse --short=10 HEAD`+set shaID   = fb7856ef5c #`git --git-dir=${CMAQ_REPO}/.git rev-parse --short=10 HEAD`+g' bldit_cctm.csh



sed -i '446s/^/#&/' bldit_cctm.csh
sed -i '447s/^/#&/' bldit_cctm.csh
sed -i '448s/^/#&/' bldit_cctm.csh

sed -i -s 's+set ICL_MPI   = .  #$xLib_Base/$xLib_3+set ICL_MPI   = $WRFCMAQ_HOME/Libs/MPICH/include  #$xLib_Base/$xLib_3+g' bldit_cctm.csh

./bldit_cctm.csh gcc | tee bldit.cctm.log

: '

Check the existence of executable file in the following links using;

ls -lah BLD_CCTM_v54_gcc/*.exe

If  you see cctm.exe the installation is successfully completed.

'

#***********************************************************************************************************************************************
#The end of shell script

# Set the color variable
green='\033[0;32m'
# Clear the color after that
clear='\033[0m'
echo "${green}***Congratulations! You have successfully installed the WRF(4.5)/CMAQ version 5.4 on your system***${clear}"

: '
After the installation set all environment variables in bashrc and activate it using the following commands;

vi ~/.bashrc

source ~/.bashrc
'

: '

References:

https://www.epa.gov/cmaq

https://github.com/USEPA/CMAQ/tree/main

https://esrl.noaa.gov/gsd/wrfportal/

https://github.com/yusufalizade

https://github.com/HathewayWill

https://undhpc.gitlab.io/Tutorials/SpecificPrograms/WRF/README_INSTALL_3_8_1.html

https://wiki.harvard.edu/confluence/pages/viewpage.action?pageId=228526205

https://www.youtube.com/watch?v=YGTdy-xH4Ik

https://github.com/USEPA/CMAQ/blob/main/DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_benchmark.md

'
