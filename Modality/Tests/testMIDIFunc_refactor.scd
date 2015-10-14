MIDIMKtlDevice.postMsgNotFound("MKtl(\\asd)", \cc, 64, 10, 0, -123456);
MIDIMKtlDevice.postMsgNotFound("MKtl(\\asd)", \cc, 64, nil, 0, -123456);

MIDIMKtlDevice.postMsgTrace("MKtl(\\asd)", \bt_0, 0.5, \cc, 64, 10, 0, -123456);
MIDIMKtlDevice.postMsgTrace("MKtl(\\asd)", \bt_0, 0.25, \bend, 64, nil, 0, -123456);

MIDIMKtlDevice.makeMsgKey(\cc, 0, 14);
MIDIMKtlDevice.makeMsgKey(\control, 0, 14);
MIDIMKtlDevice.makeMsgKey(\bend, 0);

MIDIFunc.trace(true);
MIDIFunc.trace(false);

MKtl.find(\midi);

// noteOn, noteOff works
MKtl('lpd80', "akai-lpd8");
MKtl('lpd80').device.responders;
MKtl('lpd80').trace(true);
MKtl('lpd80').trace(false);

// cc does not - why? maybe cc / control confusion?
MKtl('nnkn0', "korg-nanokontrol");
MKtl('nnkn0').trace(true);
MKtl('nnkn0').elementsDict.keys;

// does it when called directly, but not from MIDIIn
MKtl('nnkn0').device.responders.cc.func.value(127, 7, 0, -130);
//  but not from MIDIIn - why???
MIDIIn.doControlAction(-123, 0, 7, 64);
MIDIIn.control.dump


// bend works:
MKtl('qnxs0', "keith-mcmillen-qunexus");

MKtl('qnxs0').device.responders;

