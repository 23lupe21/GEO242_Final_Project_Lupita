#!/bin/bash

#First set up my variables 
#EQ Files
Northridge_1_year_cleaned='Data/Cleaned_Data/Northridge_1_year_cleaned.txt'
pre_1994='Data/Cleaned_Data/pre1994.txt'
Jan1994_April1994="Data/Cleaned_Data/Jan1994_April1994.txt"
April1994_July1994="Data/Cleaned_Data/April1994_July1994.txt"
July1994_Oct1994="Data/Cleaned_Data/July1994_Oct1994.txt"
Oct1994_Jan1995="Data/Cleaned_Data/Oct1994_Jan1995.txt"

#Focal Mechanism
mecafile='Data/focal_mec/Northridge_Focal.html'

#outfile
outfile='Figures/Northridge_seismicity_map.ps'
outfilepdf='Figures/Northridge_seismicity_map.pdf'
outfilepng='Figures/Northridge_seismicity_map.ps.png'

#Fault files
historic_faults='Data/Fault_Files/His_Fault.kml'
quat_faults='Data/Fault_Files/Latest_Quat.kml'
historic_faults_gmt='Data/Fault_Files/His_Fault.gmt'
quat_faults_gmt='Data/Fault_Files/Latest_Quat.gmt'

#bounding box (max and min coords)
xmin='-118.8'
xmax='-118.2'
ymin='34.1'
ymax='34.5'

#DEM File
demfile='Data/DEM/northridge_1994.i2.dem'

#gradient file
grad_demfile='Data/DEM/grad_northridge_1994.i2.dem'

#and Color Palette
colpal='Data/Color_palettes/elevation.cpt'

EQ_x='-118.53700'
EQ_y='34.21300'

#Get the DEM file, we only need this once so I'm running in uncommented then I'll comment it
#sardem --bbox $xmin $ymin $xmax $ymax --keep-egm --data-source COP -of ENVI -ot int16 -o $demfile

#Get the info we need for the color pallette
#gmt grdinfo $demfile
#v_min: 98 v_max: 1779 name: z --> I'm going to use this for the elevation next 

#make color palette
gmt makecpt -Cdem2 -T-100/1800/100 -D > $colpal

#make the dem gradient 
gmt grdgradient $demfile -G$grad_demfile -A225 -Ne0.6

#Making the plot

#First do the frame
gmt psbasemap -JM6.5i -R$xmin/$xmax/$ymin/$ymax -Ba0.1f0.01 -BWeSn+t"Seismicity between 1/10/1994 - 1/17/1995" -K > $outfile

#Now the 
gmt grdimage -J -R $demfile -I$grad_demfile -C$colpal -O -K >> $outfile

#gmt psscale -J -R -C$colpal -DJBC+w8c/0.5c+h -Bx500+l"Elevation (m)" -O -K >> $outfile

gmt psscale -J -R -C$colpal -Dg-118.175/34.2+jBL+w6c/2c+v -Bpa500+l"Elevation(m)" -W2p,black --FONT_ANNOT=10p,Helvetica-Bold --FONT_LABEL=12p,Helvetica-Bold -O -K >> $outfile

#Plotting the faults 
gmt kml2gmt $historic_faults > $historic_faults_gmt

gmt kml2gmt $quat_faults > $quat_faults_gmt

gmt psxy $historic_faults_gmt -J -R -W2p,black -O -K >> $outfile

gmt psxy $quat_faults_gmt -J -R -W2p,black -O -K >> $outfile

#Plotting seismicity

awk '{ print $5, $4, $3*0.05}' $pre_1994 | gmt psxy -J -R -Sc -Ggold -O -K >> $outfile 

awk '{ print $5, $4, $3*0.05}' $Jan1994_April1994 | gmt psxy -J -R -Sc -Gnavy -O -K >> $outfile 

awk '{ print $5, $4, $3*0.05}' $April1994_July1994 | gmt psxy -J -R -Sc -Gspringgreen4 -O -K >> $outfile 

awk '{ print $5, $4, $3*0.05}' $July1994_Oct1994 | gmt psxy -J -R -Sc -Gfirebrick4 -O -K >> $outfile 

awk '{ print $5, $4, $3*0.05}' $Oct1994_Jan1995 | gmt psxy -J -R -Sc -Gplum -O -K >> $outfile 

#Plotting the focal mechanism 
gmt psmeca $mecafile -J -R -Sm1c -O -K >> $outfile #This does the focal mechanisms 

#Plotting Star of Northridge EQ
#adding labels
#add a label and symbol for the weather station
echo $EQ_x  $EQ_y | gmt psxy -J -R -Sa1c -Gred -Wthin,red -O -K >> $outfile
echo $EQ_x  $EQ_y 1994 Mw 6.7 Northridge  | gmt pstext -J -R -F+f14p,Helvetica-Bold+jBL -Dj0.5c -Gwhite -Wthin,black -O -K >> $outfile

#Making a legend
gmt psxy -J -R -Wthin -Gwhite -L -O -K << EOF >> $outfile
-118.4 34.5
-118.4 34.41
-118.2 34.41
-118.2 34.5
EOF

echo -118.38 34.49 Dates | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 

echo -118.39 34.48 | gmt psxy -J -R -Sc0.2c -Ggold -O -K >> $outfile 
echo -118.38 34.48 pre-1994 Northridge EQ | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 


echo -118.39 34.465 | gmt psxy -J -R -Sc0.2c -Gnavy -O -K >> $outfile 
echo -118.38 34.465 Jan 1994 to Apr 1994 | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 


echo -118.39 34.45 | gmt psxy -J -R -Sc0.2c -Gspringgreen4 -O -K >> $outfile
echo -118.38 34.45 Apr 1994 to Jul 1994 | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 


echo -118.39 34.435 | gmt psxy -J -R -Sc0.2c -Gfirebrick4 -O -K >> $outfile 
echo -118.38 34.435 Jul 1994 to Oct 1994 | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 


echo -118.39 34.42 | gmt psxy -J -R -Sc0.2c -Gplum -O -K >> $outfile 
echo -118.38 34.42 Oct 1994 to Jan 1995 | gmt pstext -J -R -F+jML+f12p -O -K >> $outfile 


#This prints out the map

convert -rotate 90  -density 300 -trim $outfile $outfilepng

echo showpage >> $outfile 
echo end >> $outfile 

ps2pdf $outfile  $outfilepdf 


open $outfilepng



