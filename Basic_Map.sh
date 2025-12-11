#!/bin/bash

#First set up my variables 

#outfile
outfile='Figures/Basic_map.ps'
outfilepdf='Figures/Basic_map.pdf'
outfilepng='Figures/Basic_map.ps.png'

#Fault files
historic_faults='Data/Fault_Files/His_Fault.kml'
quat_faults='Data/Fault_Files/Latest_Quat.kml'
historic_faults_gmt='Data/Fault_Files/His_Fault.gmt'
quat_faults_gmt='Data/Fault_Files/Latest_Quat.gmt'

#bounding box (max and min coords)
xmin='-124.4'
xmax='-114.1'
ymin='32.5'
ymax='42'


EQ_x='-118.53700'
EQ_y='34.21300'


#Making the plot

#First do the frame
gmt psbasemap -JM6.5i -R$xmin/$xmax/$ymin/$ymax -Ba1f0.1 -BWeSn+t"California's faults and 1994 Northridge EQ" -P -K > $outfile

gmt pscoast -J -R -Glightgreen -Slightblue -Wthin -N1/thinner -N2 -Dh -O -K >> $outfile

#Plotting the faults 
gmt kml2gmt $historic_faults > $historic_faults_gmt

gmt kml2gmt $quat_faults > $quat_faults_gmt

gmt psxy $historic_faults_gmt -J -R -W1p,black -O -K >> $outfile

gmt psxy $quat_faults_gmt -J -R -W1p,black -O -K >> $outfile


#Plotting Star of Northridge EQ
#adding labels
#add a label and symbol for the weather station
echo $EQ_x  $EQ_y | gmt psxy -J -R -Sa0.5c -Gred -Wthin,red -O -K >> $outfile
echo $EQ_x  $EQ_y 1994 Mw 6.7 Northridge  | gmt pstext -J -R -F+f14p,Helvetica-Bold+jBL -Dj0.5c -Gwhite -Wthin,black -O -K >> $outfile

#This prints out the map

convert -density 300 -trim $outfile $outfilepng

echo showpage >> $outfile 
echo end >> $outfile 

ps2pdf $outfile  $outfilepdf 


open $outfilepng



