MKtlDesc.loadDescs.size;
MKtlDesc.allDescs.size;
MKtlDesc.openFolder;

~vm = MKtlDesc("*vmeter");
~vm.elementsDesc.elements[0];
~vm.elAt;
~vm.dictAt(\0); // should be \slider?

~pf = MKtlDesc("*tfader");
~pf.elementsDesc.elements[0].midiMsgType;
~pf.elAt(\3);
~pf.elAt(0);

~dj = MKtlDesc("decampo-joybox");
~dj.elAt(0, \x).ioType;

~mb = MKtlDesc("sensestage-minibee1");
~mb.elAt(\x).elementType;
~mb.elAt(\x);
~mb.elementsDesc.keys;
~mb.fullDesc.deviceIOGroups;

~trig = MKtlDesc("*finger");
~trig.elAt(0, 0);
~trig.elAt(\pad, 12);
~trig.elAt(\kn, 7).spec;

~lpd = MKtlDesc("*lpd8");
~lpd.elAt(\kn, 0);
~lpd.elAt(\pad, 0).midiMsgType;

~nk2 = MKtlDesc("*trol2");
~nk2.elAt(\kn, 0);
~nk2.elAt(\bt, \S, 1);
~nk2.elAt(\knixi, 0);

~gp = MKtlDesc("*drive");
~gp.elAt(\bt, \1);
~gp.elAt(\compass);
~gp.elAt(\wheel);
~gp.elAt(\throt);


// done already - sharing properties down
MKtlDesc.sharePropsToElements(~pf.elementsDesc);

MKtlDesc.postLoadable;
MKtlDesc.postLoaded;
MKtlDesc.postStatus;

MKtlDesc.elementTypesUsed;
MKtlDesc.deviceTypesUsed;

