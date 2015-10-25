/*
The RME Fireface 400 has two external MIDI ins and outs.
On OSX, it registers these as (for example):
"Fireface 400 (297)", "Port 1",
"Fireface 400 (297)", "Port 2",
where the "(297)" is an individual ID/serial number for each Fireface.


// example for finding the device for this individual ID:

MKtlDesc('rme-audio-fireface-400_midi_port1')
.idInfo.put(\deviceName, "Fireface 400 (297)");
MKtlDesc('rme-audio-fireface-400_midi_port2')
.idInfo.put(\deviceName, "Fireface 400 (297)");

MKtl.find(\midi);

// now you can make them:
MKtl(\ff_m1, "*fireface-400*port1");
MKtl(\ff_m2, "*fireface-400*port2");


*/

(
deviceName: "Fireface 400*",
deviceType: \externalMidiPort,

deviceInfo: (

	vendorURI: "http://www.rme-audio.de/en/products/fireface_400.php",
	manualURI: "http://www.rme-audio.de/download/fface400_e.pdf",
	description: "audio interface with 2 MIDI IO ports",
	features: [
		"audio interface with 18 chans IO",
		"2 MIDI I/O ports for external midi hardware"
	],
	notes: "",
	hasScribble: false
),

status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown")
);
