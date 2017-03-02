#!/bin/csh -f

# Wrapper script for running WRFDA verification package

# Set some initial variables, then source the main "parameters" script

setenv QUEUE   regular
setenv use_standby   false 
setenv EXPT   hvc10_sfc
setenv NOTIFY   false
setenv MAIL_TO   kavulich@ucar.edu
setenv MKBASEDIR   /glade/p/wrf/WORKDIR/wrfda_realtime

if ( ${#argv} > 0 ) then
   setenv END_DATE $1
   set cc = `echo $END_DATE | cut -c1-2`
   set yy = `echo $END_DATE | cut -c3-4`
   set mm = `echo $END_DATE | cut -c5-6`
   set dd = `echo $END_DATE | cut -c7-8`
   set hh = `echo $END_DATE | cut -c9-10`
else
   set cc = `date -u '+%C'`
   set yy = `date -u '+%y'`
   set mm = `date -u '+%m'`
   set dd = `date -u '+%d'`
   set hh = `date -u +%H`  ;  set hh = `expr $hh \+ 0`
   if      ( $hh >    0  && $hh < 6  ) then
      set hh = '00'
   else if ( $hh >    6  && $hh < 12 ) then
      set hh = '06'
   else if ( $hh >    12 && $hh < 18 ) then
      set hh = '12'
   else if ( $hh >    18 && $hh < 24 ) then
      set hh = '18'
   endif
   setenv END_DATE ${cc}${yy}${mm}${dd}${hh}
endif

source params.csh

# Settings for ./da_verif_grid.ksh
setenv WRFVAR_DIR   ${WRFDA_SRC_DIR}
setenv TOOLS_DIR   /glade/p/wrf/WORKDIR/wrfda_realtime/TOOLS
setenv SCRIPTS_DIR   ${TOOLS_DIR}/scripts
setenv GRAPHICS_DIR   ${TOOLS_DIR}/graphics/ncl
setenv NUM_EXPT   1
setenv EXP_DIRS   /glade/scratch/hclin/CONUS/wrfda/expdir/rt/fcst_15km/
setenv EXP_NAMES   'REALTIME'
setenv VERIFICATION_FILE_STRING   'wrfout'
setenv EXP_LEGENDS   '(/"WRFDA Realtime System"/)'
setenv START_DATE   `${WRFDA_SRC_DIR}/var/build/da_advance_time.exe ${END_DATE} -7d`
setenv INTERVAL   24
setenv VERIFY_HOUR   48
setenv CONTROL_EXP_DIR   ${MKBASEDIR}/verification/gfs_forecast/Output
setenv RUN_DIR /glade/p/wrf/WORKDIR/wrfda_realtime/verification/GFS_verify
setenv VERIFY_ITS_OWN_ANALYSIS false

#echo "Start date parent:"
#echo $END_DATE
#
#./da_verif_grid.ksh



# Settings for ./da_run_suite_verif_obs.ksh

setenv CLEAN false
setenv INITIAL_DATE ${START_DATE}
setenv FINAL_DATE ${END_DATE}
setenv EXP_DIR `pwd`/REALTIME/${EXPT}
setenv OB_DIR /glade/scratch/hclin/CONUS/wrfda/obsproc
setenv FILTERED_OBS_DIR /glade/scratch/hclin/CONUS/wrfda/expdir/start2016102512/hyb_ens75/${END_DATE}
setenv BE_DIR ${FILTERED_OBS_DIR}
setenv FC_DIR /glade/scratch/hclin/CONUS/wrfda/expdir/rt/fcst_15km/
setenv WINDOW_START ${TIMEWINDOW1}
setenv WINDOW_END ${TIMEWINDOW2}
#setenv NUM_PROCS 4
#setenv RUN_CMD "mpirun -np $NUM_PROCS"
#setenv VERIFICATION_FILE_STRING wrfout

# Here is where you set the appropriate namelist variables that the script will use to run WRFDA
setenv NL_ANALYSIS_TYPE verify
setenv NL_E_WE ${E_WE_d01}
setenv NL_E_SN ${E_SN_d01}
setenv NL_E_VERT ${N_VERT}
setenv NL_DX ${DX_d01}
setenv NL_DY ${DX_d01}
setenv NL_SF_SURFACE_PHYSICS 2
setenv NL_NUM_LAND_CAT 24

./da_run_suite_verif_obs.ksh

# Settings for da_verif_obs_plot.ksh

#setenv RUN_DIR "`pwd`/conv_only/plots"
#setenv NUM_EXPT 1
#setenv EXP_NAMES 'conv_only'
#setenv EXP_LEGENDS '(/"conv_only"/)'
#setenv EXP_DIRS "$EXP_DIR"
#setenv NUM_PROCS 4
#setenv VERIFY_HOUR 00
#setenv GRAPHICS_DIR /kumquat/wrfhelp/DATA/WRFDA/TOOLS/graphics/ncl
#setenv WRF_FILE "/kumquat/wrfhelp/DATA/WRFDA/cycling/run/2013122300/wrfout_d01_2013-12-23_00:00:00"
#setenv Verify_Date_Range "12z 23 Dec - 12z 25 Dec, 2015 (${INTERVAL} hour Cycle)"
#setenv OBS_TYPES 'synop sound'
#setenv NUM_OBS_TYPES 2
#setenv PLOT_WKS pdf #"pdf" will save plots in pdf format; "x11" will display the plots and not save them

#./da_verif_obs_plot.ksh

