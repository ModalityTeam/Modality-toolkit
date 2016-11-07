// these devices are already adapted!
// - label just says pad_x, no on/off

m.free; m = MKtl(\qnx, "*1_AB"); m.trace.gui.showLabels;

m.free; m = MKtl(\ax, "*axis49"); m.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\apc, "*apcmini");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;


MKtlDesc.loadDescs; l.free; l = MKtl(\ic, "*icontrols");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;

MKtlDesc.loadDescs; l.free; l = MKtl(\mpk, "*mpkmini");
l.elementsDict.size;
l.elementsDict.choose.elemDesc;
l.trace.gui.showLabels;


MKtlDesc.loadDescs; l.free; l = MKtl(\uc4, "*uc4");
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
