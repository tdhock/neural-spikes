source("packages.R")

cell1 <- readMat("data_20120416_cell1_001.mat")
c1 <- cell1$obj
time.unit.vec <- unlist(c1["timeUnitNames",,])
ts.info <- c1[["timeSeriesArrayHash",1,1]]
data.list <- ts.info[["value",1,1]]
names(data.list) <- unlist(ts.info["keyNames",,])

tall.list <- list()
for(data.name in names(data.list)){
  L <- data.list[[data.name]]
  l <- L[[1]]
  names(l) <- dimnames(l)[[1]]
  l$data.name <- data.name
  tall.list[[data.name]] <- do.call(data.table, lapply(l, as.vector))
}
tall <- do.call(rbind, tall.list)

spikes <- tall[data.name=="detected_spikes" & valueMatrix!=0]

wide <- dcast(
  tall[data.name %in% c("fmean_roi", "fmean_neuropil")],
  time ~ data.name, value.var="valueMatrix")
wide[, fmean_comp := fmean_roi - 0.7 * fmean_neuropil]
## QUESTION: why 0.7?

comp.tall <- melt(wide, id.vars="time")
gg <- ggplot()+
  geom_vline(aes(
    xintercept=time),
    color="red",
    data=spikes)+
  geom_point(aes(
    time, value),
    shape=1,
    data=comp.tall)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "lines"))+
  facet_grid(variable ~ ., scales="free")
print(gg)

xmin <- 152
xmax <- 153
gg+
  coord_cartesian(xlim=c(xmin, xmax))

gg.zoom <- gg+
  coord_cartesian(xlim=c(150, 200))
print(gg.zoom)

png("figure-data_20120416_cell1_001-zoom.png")
print(gg.zoom)
dev.off()

some.tall <- tall[xmin<time & time<xmax]
gg <- ggplot()+
  geom_point(aes(
    time, valueMatrix),
    shape=1,
    data=some.tall)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "lines"))+
  facet_grid(data.name ~ ., scales="free")
print(gg)

png("figure-data_20120416_cell1_001.png")
print(gg)
dev.off()
