//VMeter desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('vmtr1300');
k.verbose_(true);
*/

(
device: "VMeter 1.30 A",
protocol: \midi,
description: (

	\slider: ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  20,'spec': 'midiCC')
)
)