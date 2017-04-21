source("packages.R")

cell1 <- readMat("crcns-mt1-data/Cell1.mat")
names(cell1$mtdata) <- c(
  "cellid",
  "dt",#temporal resolution of the stimulus, matching the monitor refresh interval
  "spkt",#list of spike times (at 1 ms resolution)
  "spkbinned",#spike responses binned at 25 ms resolution
  "opticflows",#the magnitude of the six optic flow components over time
  "aperturecenter",#center of the aperture over time
  "aperturediameter",#diameter of the aperture
  "eyeloc")#eye location over time (at 25ms resolution)
