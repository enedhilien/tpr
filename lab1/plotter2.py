__author__ = 'Blazej'

import matplotlib.pyplot as plt
import time
import os

save = True
dirName = time.strftime("%Y.%m.%d %H.%M.%S")
plotNumber = 1


class Texts(object):
    def __init__(self, x, y, txt):
        self.x = x
        self.y = y
        self.txt = txt

def createDir():
    if save:
        os.mkdir(dirName)

def savePlot():
    if save:
        global  plotNumber
        plt.savefig(dirName + '/plot' + str(plotNumber) + '.png')
        plotNumber = plotNumber + 1
    else:
        plt.show()

def drawPlot(x, y, lineLegend, *texts ):
    plt.plot(x, y, label=lineLegend)
    for text in texts:
        plt.text(text.x, text.y, text.txt)
    plt.grid(True)


def setTitles(xTitle, yTitle, title):
    plt.title(title)
    plt.ylabel(yTitle)
    plt.xlabel(xTitle)
    plt.legend(loc=2)

def readData(file):
    x = []
    y = []
    file.readline()
    for line in file:
        splited = line.split(';')
        x.append(int(splited[0]))
        y.append( (float(splited[1]) + float(splited[2]))/2000)
    return x,y

dataDir = "data2/"
sync = open(dataDir + "sync.out",'r')
async  = open(dataDir + "async.out",'r')

x1,y1 = readData(sync)
x2,y2 = readData(async)

createDir()
yTitle = 'Msg send time [ms]'
plt.figure()
drawPlot(x1, y1,  'Ssync')
drawPlot(x2, y2,  'Isync')
setTitles('Message size [B]', yTitle,'Send time')
savePlot()

plt.figure()
sliceTo = 50
drawPlot(x1[:sliceTo], y1[:sliceTo],  'Ssync')
drawPlot(x2[:sliceTo], y2[:sliceTo],  'Isync')
setTitles('Message size [B]', yTitle,'Send time')
savePlot()

plt.figure()
sliceTo = 30
drawPlot(x1[:sliceTo], y1[:sliceTo],  'Ssync')
drawPlot(x2[:sliceTo], y2[:sliceTo],  'Isync')
setTitles('Message size [B]', yTitle,'Send time')
savePlot()

y11 = [None] * len(y1)
y22 = [None] * len(y2)

for i in xrange(len(y1)):
    y11[i] = x1[i] * 8.0 * (1e-3 / y1[i]) # * 1e6 * 1e-6
    y22[i] = x2[i] * 8.0 * (1e-3 / y2[i])

yTitle = 'Bandwidth [Mbit/s]'
plt.figure()
drawPlot(x1, y11,  'Ssync')
drawPlot(x2, y22,  'Isync')
setTitles('Message size [B]', yTitle,'Bandwidth')
savePlot()

plt.figure()
sliceTo = 50
drawPlot(x1[:sliceTo], y11[:sliceTo],  'Ssync')
drawPlot(x2[:sliceTo], y22[:sliceTo],  'Isync')
setTitles('Message size [B]', yTitle,'Bandwidth')
savePlot()

plt.figure()
sliceTo = 30
drawPlot(x1[:sliceTo], y11[:sliceTo],  'Ssync')
drawPlot(x2[:sliceTo], y22[:sliceTo],  'Isync')
setTitles('Message size [B]', yTitle,'Bandwidth')
savePlot()