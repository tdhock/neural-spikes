source("packages.R")

if(!file.exists("spikefinder.train.zip")){
  download.file("https://s3.amazonaws.com/neuro.datasets/challenges/spikefinder/spikefinder.train.zip", "spikefinder.train.zip")
  system("unzip spikefinder.train.zip")
}

calcium <- fread("spikefinder.train/3.train.calcium.csv", header=TRUE)
spikes <- fread("spikefinder.train/3.train.spikes.csv", header=TRUE)
calcium[, time := 1:.N]
spikes[, time := 1:.N]
stopifnot(nrow(calcium)==nrow(spikes))
cal.tall <- melt(
  calcium,
  id.vars="time",
  variable.name="neuron",
  value.name="calcium"
)
spikes.tall <- melt(
  spikes,
  id.vars="time",
  variable.name="neuron",
  value.name="spike"
)[spike==1][cal.tall, on=list(time, neuron), nomatch=0L]

gg <- ggplot()+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "lines"))+
  facet_grid(neuron ~ ., scales="free")+
  geom_line(aes(
    time, calcium),
    data=cal.tall)+
  geom_point(aes(
    time, calcium),
    data=spikes.tall,
    color="red",
    shape=1)

gg.zoom <- gg+
  scale_x_continuous(limits=c(35000, 4e4))

png("figure-spikefinder.png")
print(gg.zoom)
dev.off()
