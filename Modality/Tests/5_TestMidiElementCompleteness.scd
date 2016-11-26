// test element completeness for midi:

// use an existing source device, e.g. on mac, "IAC Driver"
~midisrc = MIDIClient.sources[0].device;

// make all midi descs and mktls for them
~descs = MKtlDesc.loadDescs.select  { |d| d.protocol == \midi };
~mktls = ~descs.collect { |d|
	MKtl(d.name.asSymbol, d).openDeviceVia(~midisrc);
};

~descs.do { |d, i|
	var ddsize = d.elementsDict.size;
	var mktl = ~mktls[i];
	var mksize = mktl.elementsDict.size;
	var res = if (ddsize == mksize) { "OK." } { "wrong!!" };
	"% desc: % dict/mktl: % == % \n".postf(res, d.name, ddsize, mksize);
	mktl.free;
};"";


// tests with an individual desc
m = MKtl(\x, "*oxy*");
// use an existing source device, e.g. on mac, "IAC Driver"
x = MIDIClient.sources[0].device;
m.openDeviceVia(x);
m.device.midiKeyToElemDict.size;
m.desc.elementsDict.size;
m.device.midiKeyToElemDict.keys(SortedList).printAll;"";
m.desc.elementsDict.keys(SortedList).printAll;"";
m.desc.openFile;


