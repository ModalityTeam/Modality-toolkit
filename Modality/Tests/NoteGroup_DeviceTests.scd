// these devices are already adapted!
// - label just says pad_x, no on/off

MKtlDesc.loadDescs; l.free; l = MKtl(\apcmini, "*apcmini");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;


MKtlDesc.loadDescs; l.free; l = MKtl(\mpkmini, "*icontrols");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\mpkmini, "*mpkmini");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;


MKtlDesc.loadDescs; l.free; l = MKtl(\lpd8, "*uc4");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\lpd8, "*lpd8");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\mpd18, "*mpd18");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
g = l.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\btst, "*beatstep*16");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
g = l.trace.gui.showLabels;
