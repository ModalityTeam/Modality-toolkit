///////// Example for an external MIDI device ///////
/*
	Doepfer Pocket fader box has 16 sliders.

// usage example:
// make an Mktl for it - will say that this is virtual only
MKtl(\pf, "*pocketfader"); MKtl(\pf).gui;

// MKtl has as idInfo : "EXTERNAL", which is not an existing port name.
MKtl(\pf).desc.fullDesc.at(\idInfo);

// So we need to tell it which midi hardware interface we connect it to.

// See which MIDI sources are available:
MIDIClient.sources;

// figure out which one you want to use,
// and open it via the port name as idInfo:
MKtl(\pf).openDeviceVia("IAC Driver");

// or via another MKtl that is just a MIDI interface plug:
MKtl(\qnx_pt2, "*qunexus_port2");
MKtl(\qnx_pt2).desc.idInfo.postcs;

// -> ( 'destPortIndex': 1, 'sourcePortIndex': 1, 'deviceName': QuNexus )

// open with that idInfo:
MKtl(\pf).openDeviceVia(MKtl(\qnx_pt2).desc.idInfo);


*/

(

deviceName: "pocketfader",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

// replace with uid of a midi interface port,
// then redo openDevice to create this.
idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://www.doepfer.de/pe.htm",
	manualURI: "http://www.doepfer.de/pdf/PE_manual.pdf",
	description: "Originally a 16 chan MIDI faderbox (now discontinued);"
	"\nnow a kit for making 16 chan midi controllers.",
	features: [
		"hardware midi plugs (no USB)",
		"MIDI configurable by DIP switches."],
	notes: "",

),

elementsDesc: (
	key: \sl,
	shared: (elementType: \slider, midiMsgType: \control,
		midiChan: 0, spec: \midiCC, \ioType: \inout),
	elements: (
		(1..16).collect { |num, i| (key: num.asSymbol, midiNum: i) }
	)
)
);
