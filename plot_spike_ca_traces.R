# Ported to R from plot_spike_ca_traces.m

# %% Example code to read cell-attached recording file format
# %
# %  this .m file contains example code to read .mat file containing
# %  GCaMP5,6s,6f in vivo imaging/ephys data published in 
# %  (Chen et. al. 2013 Nature; Akerboom, Chen 2012 J. Neurosci)
# %
# % Ephys data were recorded at 10KHz
# % Imaging data were recorded at 60Hz
# %
# % Each .mat data file contains a variable named 'obj'
# % key recording traces and time base can be accessed by the following:
#   %
# % traces=obj.timeSeriesArrayHash.value{id}.valueMatrix
# % time=obj.timeSeriesArrayHash.value{id}.time
# %
# % id=
#   % 
# % 1: fmean_roi
# % 2: fmean_neuropil
# % 3: raw_ephys
# % 4: filtered_ephys
# % 5: detected_spikes
# %
# %
# %  Tsai-Wen Chen, 2015/01/27
# 
                                        # %%
source("packages.R")
matFile <- 'data_20120416_cell1_001.mat'
mat <- R.matlab::readMat(matFile)
obj <- mat$obj

fmean_roi <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[1]][[1]][ , , 1]$valueMatrix
fmean_neuropil <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[2]][[1]][ , , 1]$valueMatrix
fmean_comp <- fmean_roi - 0.7 * fmean_neuropil
t_frame <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[1]][[1]][ , , 1]$time

filt <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[4]][[1]][ , , 1]$valueMatrix
t_ephys <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[4]][[1]][ , , 1]$time

detected_spikes <- obj[ , , 1]$timeSeriesArrayHash[ , , 1]$value[[5]][[1]][ , , 1]$valueMatrix
spike_time <- t_ephys[detected_spikes != 0]

plot.chen <- function(timeFrame, chenySmall, spikeTimes, fitSpikes = NULL, fitCol = NULL, xlim, cex = 0.2, xlab = "") {
  plot(timeFrame, chenySmall, cex = cex, pch = 20, cex.lab = 1.5, col = "darkgrey", cex.main = 1.5, ylab = "", xlab = xlab,  xlim = xlim)
  
  if (!is.null(fitSpikes)) {
    for (spikey in fitSpikes) {
      abline(v = timeFrame[spikey], col = fitCol, lwd = 2)
    }
  }
  
  for (spikey in spikeTimes) {
    segments(x0 = spikey, y0 = min(chenySmall), x1 = spikey, y1 = 0.05 * max(chenySmall) , col = "black", lwd = 2)
  }
}

plot.chen(t_frame, fmean_comp, spikeTimes = spike_time, xlim = c(1, max(t_frame)))
plot.chen(t_frame, fmean_comp, spikeTimes = spike_time, xlim = c(30, 50))



