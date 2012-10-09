darkgreen <- rgb(0, 88, 36, max=255)
green <- rgb(0.90, 50, max=255)
goodpurple <- rgb(74, 20, 134, max=255)
lightb <- rgb(8, 69, 148, max=255)
library(plyr); library(maptools); library(googleVis)
load("keyobject.Rdata")
################################ missings pattern visualization ################
# count number of missing values

hqmr.date<-seq(as.Date("1911/01/01")by="month"length.out=1200)
hqmr.data$date<-hqmr.date
hqmr_date<-hqmr.data[, -1]# hqmr dateset with date variable at the last column
hqmr.data<-hqmr.data[, -c(1,80)]
nmissing<-function(x) sum(is.na(x)) # function to count the number of missings 
f.missing<-colwise(nmissing) # colwise counting
# apply to every column in the data(stations are at columns)
n_missing<-as.data.frame(t(as.matrix(f(as.data.frame(hqmr.data)))))
colnames(n_missing)<-"nmissings"
##read stations and merge nmissings into stations
stations<-read.csv("stations.csv", head=TRUE)
nmissing_stations<-transform(stations, nmissings=n_missing$nmissings)
# adding proportions of missing for
nmissing_stations<-transform(nmissing_stations, prop_nmissings=nmissings/sum(nmissings))
# order the dataframe by nmissing 
nmissing_ordered<-nmissing_station[rev(order(nmissing_station$nmissings)), ]
# save data
write.csv(nmissing_station, "nmissing_stations.csv")
write.csv(nmissing_ordered, "nmissing_ordered.csv")

## Reading in the ShapeFile data.
setwd("D:/Analysis/SPImputation/data/hqmr station info")
load("station_info.Rdata")

# rbasin.pol <- readShapeSpatial("42343_shp/rbasin_polygon")
# rbasin.chain <- readShapeSpatial("42343_shp/rbasin_chain")
# state.bdrs <- c("state_border","divn_state","region_state")
# coast.bdrs <- c("coast_vic","coast_sa","coast_nsw","coast_qld")
# ## Merging polygons.
# mdb.pol.ind <- rbasin.pol$DNAME=="MURRAY-DARLING"
# mdb.pol <- unionSpatialPolygons(rbasin.pol[mdb.pol.ind,],
#                                 rbasin.pol$DNAME[mdb.pol.ind])
# ## Vector of borders.
# state.bdrs <- c("state_border","divn_state","region_state")
# coast.bdrs <- c("coast_vic","coast_sa","coast_nsw","coast_qld")


## Plotting MDB region and apply sunflowerplot to visualize the missing counts
plot(mdb.pol,border="grey",lty=3, axes=T, xlim=c(139,150), ylim=c(-39,-24))
plot(rbasin.chain[rbasin.chain$F_CODE%in%coast.bdrs,], add=T)
plot(rbasin.chain[rbasin.chain$F_CODE%in%state.bdrs,], lty=2, add=T)
sunflowerplot(nmissing_stations$Lon, nmissing_stations$Lat, number=nmissing_stations$nmissings, pch=20,
              col="red", size=0.2, seg.col="darkgreen", add=TRUE)
# text(nmissing_stations$Lon,nmissing_stations$Lat,nmissing_stations$id,cex=0.5)
title(xlab="Longitude", ylab="Latitude", main="Missing Counts_Sunflowerplot")
# plot1<-ggplot(nmissing_stations,aes(x=Long,y=Lat))
# plot1_plon<-c(geom_polygon(data=mdb_pol, aes(x=long, y=lat), colour= "red", lwd=0.2))
# plot1_points<-geom_point(data=nmissing_stations,aes(nmissings),size="nmissings")
# plot<-plot1+plot1_plon+plot1_points

#### Utilizing Google Visualization API supported by googleVis package in R to visuliaze########
library("googleVis")
lat <- as.character(nmissing_stations$Lat)
long <- as.character(nmissing_stations$Lon)
locationvar <- paste(lat, long, sep=":")
nmissing_station <- transform(nmissing_stations, id = as.character(as.numeric(id)), locationvar = locationvar)
rownames(nmissing_station) <- nmissing_stations$id

## use bubble plot on google maps to illustrate the missing proportions of each station
missing_bubble<-gvisBubbleChart(nmissing_station,idvar="id",xvar="Lat",yvar="Lon",sizevar="nmissings")
plot(missing_bubble)## seems of no use at all!

## missing on the map(should be better than the bubble plot)
missing_map<-gvisGeoMap(data=nmissing_station,locationvar="locationvar", numvar="nmissings", hovervar="id",
                        options=list(region="AU", width=1100, height=1100, dataMode="markers", showZoomOut=TRUE), chartid="Missing_Counts")
plot(missing_map)
# below is for merging
missing_map2<-gvisGeoMap(data=nmissing_station, locationvar="locationvar",numvar="nmissings",hovervar="id",
                         options=list(region="AU",width=500,height=500,dataMode="markers",showZoomOut=TRUE),chartid="Missing_Counts")

## however, there is overlap among stations. One idea is to use heatmap-wise plot on map in which the size are identical
## but with colors varying among stations. Here we go by applying gvisGeoChar
# add a variable: size, which are identical for all stations
nmissing_station$size<-rep(1,78)
missing_geochart<-gvisGeoChart(nmissing_station,locationvar="locationvar",colorvar="nmissings",sizevar="size",
                               options=list(region="AU",displayMode="Markers",backgroundColor="lightblue",markerOpacity=0.5,
                                            keepAspectRatio=FALSE,width=800,height=600),
                               chartid="Missing_Counts")
plot(missing_geochart)
# below is for merging
# missing_geochart2<-gvisGeoChart(nmissing_station,locationvar="locationvar",colorvar="nmissings",sizevar="size",
#                                options=list(region="AU",displayMode="Markers",backgroundColor="lightblue",markerOpacity=0.5,
#                                             keepAspectRatio=FALSE,width=500,height=300),
#                                chartid="Missing_Counts")
## utilize google map to locate 78 stations. srollwheel and hybrid map and map control could be used
stationmap <- gvisMap(data = nmissing_station, locationvar="locationvar", tipvar="id",
                      options=list(showTip=TRUE, enableScrollWheel=TRUE, mapType='hybrid',
                                   useMapTypeControl=TRUE, width=1200,height=800), chartid="Missing_Counts")
plot(stationmap)
# below is for merging
# missing_map3<-gvisMap(data=nmissing_station,locationvar="locationvar",tipvar="id",
#                       options=list(showTip=TRUE,enableScrollWheel=TRUE,
#                                    mapType='hybrid', useMapTypeControl=TRUE,
#                                    width=600,height=400),chartid="Missing_Counts")
# Merge them together(not working, don't know why)
# merge1<-gvisMerge(missing_geochart2,missing_map3,horizontal=FALSE)
# plot(merge1)

### Google Motion Chart
# melt the data set into long format, rep the date and get the "long" dataset with just 3 columns
library(reshape2)
meltdata<-melt(hqmr.data,idvars=rownames(hqmr.data))
meltdate<-rep(seq(as.Date("1911/1/1"),as.Date("2010/12/1"),by="1 month"),times=78)
longdata<-transform(meltdata,date=meltdate)
names(longdata)<-c("id","rainfall","month")
write.csv(longdata,"longdata.csv")
## using gvisMotionChart in {googleVis}
# caution: could be very slow in your laptop
# (it takes 105.75s in a workstation with Xeon 3.2GHz CPU and 12G RAM))
# longdata2<-as.data.frame(cbind(longdata$id,longdata$month,longdata$month2,longdata$rainfall))
# View(longdata2)
# longdata2<-longdata[,c(1,3)]
# longdata2$rainfall<-longdata$rainfall
# longdata2$month2<-longdata$month2
#longdata$month2<-as.Date(as.character(longdata$month),date.format = "%Y/%m/%d")
motionplot<-gvisMotionChart(data=longdata2,idvar="id",timevar="month",date.format="%Y%m%d",
                            options=list(height=1000,width=1000),
                            chartid="Motion_Chart_Rainfall")
plot(motionplot)


##stem-leaf plot 
library(BHH2)
dotPlot(nmissing_stations$nmissings,xlim=c(1,145),axes=FALSE,base=FALSE,pch=20,col=3,main="Dots plot of Nmissing ",xlab="Number of Missing Values")
axis(1,at=c(0,13,25,32,43,55,70,88,120,144),col.ticks=2)

#############################################################################
#                                 Jenks's Method                            #
#############################################################################
########## finding proper intervals for plotting the missing heatmap
pal1 <- c("wheat1", "red3")
opar <- par(mfrow=c(2,3))

with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="equal"), pal=pal1, xlab="missing counts",main="Equal Intervals"))
with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="quantile"), pal=pal1, xlab="missing counts",main="Quantile"))
with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="kmeans"), pal=pal1, xlab="missing counts",main="K-Means"))
with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="hclust"), pal=pal1, xlab="missing counts",main="Complete Cluster"))
with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="fisher"), pal=pal1, xlab="missing counts",main="Fisher's Method"))
with(nmissing_stations,plot(classIntervals(nmissings, n=6, style="jenks"), pal=pal1, xlab="missing counts",main="Jenk's Method"))
par(mfrow=c(1,1))
# Jenk's method seems to work well.
cla<-with(nmissing_stations,classIntervals(nmissings, n=6, style="jenks"))
mypal<- c("wheat1", "red3")
cols<-findColours(cla,mypal)
nmissing_stations<-transform(nmissing_stations,colours=cols)
size_stations<-transform(nmissing_stations,size=rep(0.001,78))
#####
######heatmap function which is a refined version of ggstructure() in ggplot2
gstruct<-function (data, scale = "I") 
{
  ggpcp(data, scale = scale) + aes_string(y = "ROWID", fill = "value", 
                                          x = "variable") + geom_tile() + scale_y_continuous("Months",expand=c(0,1)) + scale_fill_continuous(low = "white", 
                                                                                                                                             high = "darkgreen",guide="colorbar" )
}
gstruct(hqmr.data)+xlab("Stations")
hqmr.cube=as.data.frame(hqmr.data^(1/3))
gstruct(hqmr.cube)+xlab("Stations")
# reorder the hqmr data by number of missings
hqmr.reorder<-hqmr.data[,as.numeric(rownames(nmissing_ordered))]
hqmr.cube.reorder<-hqmr.cube[,as.numeric(rownames(nmissing_ordered))]
##write.csv(hqmr.reorder,"hqmr.reorder.csv")
gstruct(hqmr.reorder)+xlab("Stations")
gstruct(hqmr.cube.reorder)+xlab("Stations")
################## correlation plot of the correlation matrix ####################
library(corrplot)
cormat<-cor(hqmr.data,use="complete.obs")
cormat_order<-cor(hqmr.reorder,use="complete.obs")
# using hierarchical clustering 
corplot1<-corrplot(cormat,diag=FALSE,order="hclust",addrect=8,rect.col="red",
                   hclust.method="ward",method="ellipse",tl.cex=0.5,tl.col="darkgreen")
corplot2<-corrplot(cormat,diag=FALSE,tl.cex=0.5,tl.col="darkgreen")
corplot3<-corrplot(cormat_order,diag=FALSE,tl.cex=0.5,tl.col="darkgreen")
#################### Overplotting on the Google Static Map #######################

lat<-nmissing_station$Lat
lon <-nmissing_station$Lon
center = c(mean(lat), mean(lon)) #lat/lon center of map

#determine the max zoom, so that all points fit on the plot
# (might not be necessary in this case):
# zoom <- min(MaxZoom(latrange=bb$latR,lonrange=bb$lonR))

# define the markers
gmark=cbind.data.frame(lat,lon,size=rep("tiny",78),color=rep("blue",78),char=rep("",78))
#get the bounding box
bb <- qbbox(lat = gmark[,"lat"], lon = gmark[,"lon"])

MyMap <- GetMap(center=center,zoom=5,destfile="mymap.png")
##  or  the same function (in my opinio at least)
## MyMap2 <- GetMap.bbox(bb$lonR, bb$latR, destfile = "gmap2.png", GRAYSCALE =T)
#  MyMap3<- GetMap.OSM(lonR=bb$lonR,latR=bb$latR,destfile="openmap.png")  
# put text on MyMap (not working for the time being)
# TextOnStaticMap(MyMap, lat=mean(lat),lon=mean(lon), "78 Stations in Murray-Darling Basin", cex=2, col = 'red')
#plot:
png("tmp.png",640,640)
tmp <- PlotOnStaticMap(MyMap,lon=nmissing_station$Lon,lat=nmissing_station$Lat,
                       FUN=sunflowerplot,number=nmissing_station$nmissings)
dev.off()

##### pick a chunk without missing values and experiment#####################
hqmr.chunk <- hqmr[300:900,]
# check missing values
f.missing(as.data.frame(hqmr.chunk))
# draw corrplot
library(corrplot)
cormat.chunk<-cor(hqmr.chunk)
cormat_chunk_order<-cor(hqmr.reorder)
# using hierarchical clustering 
corplot.chunk<-corrplot(cormat.chunk,diag=FALSE,tl.cex=0.5,tl.col="darkgreen")
corplot.chunk1<-corrplot(cormat.chunk,diag=FALSE,order="hclust",addrect=8,rect.col="red",
                         hclust.method="ward",method="circle",tl.cex=0.5,tl.col="darkgreen")
corplot.chunk2<-corrplot(cormat.chunk,diag=FALSE,tl.cex=0.5,tl.col="darkgreen")

# 
library(sp); library(spacetime); library("rgdal"); library(reshape2)
sp0 <- SpatialPoints(cbind(stations$Lon, stations$Lat), CRS("+proj=longlat +datum=WGS84"))
utm54_6 <- CRS("+proj=utm +zone=54:56 +datum=WGS84")
sp1 <- spTransform(sp0, utm54_6)
data.sp <- melt(t(hqmr.cube))[, c(1, 3)]
names(data.sp) <- c("ID", "value")
spst <- STFDF(sp1, date.month, data.sp)

# for plotting purposes, we can obtain countey boundaries from pkg maps
library(maps)
m <- map2SpatialLines(map("worldHires", xlim = c(130, 160), ylim = c(-45, -20), plot=F))
proj4string(m) = "+proj=longlat +datum=WGS84"
m = spTransform(m, utm54_6)

# For interpolation, we can dene a grid over the area:
grd = SpatialPixels(SpatialPoints(makegrid(m, n = 300)), proj4string = proj4string(m))
layout = list(list("sp.lines", m, col='grey'), list("sp.points", m, first=F, cex=.5))
stplot(spst, sp.layout = layout)