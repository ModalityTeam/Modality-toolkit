//VMeter desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('vmtr1300');
k.verbose_(true);
*/

(
idInfo: "VMeter 1.30 A",
protocol: \midi,
deviceInfo: (
	vendorURI: "http://www.vmeter.net/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	type: [\fader],
	// hasScribble: false
),
description: (

	\slider: ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  20,'spec': 'midiCC')
)
)