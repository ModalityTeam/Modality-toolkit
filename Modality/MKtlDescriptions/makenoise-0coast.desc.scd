/* 0-coast

// basic example:
// make an Mktl for it - will say that this is virtual only
MKtl(\nocoast, "makenoise-0coast"); MKtl(\nocoast).gui;

// MKtl has as idInfo : "EXTERNAL", which is not an existing port name.
MKtl(\nocoast).desc.fullDesc.at(\idInfo);

// So we need to tell it which midi hardware interface we connect it to.

// See which MIDI sources are available:
MIDIClient.sources;

// figure out which one you want to use,
// and open it via the port name as idInfo:
MKtl(\nocoast).openDeviceVia("IAC Driver");

*/

(

deviceName: "0-Coast",
protocol: \midi,
deviceType: \synth,
elementTypes: [\knobs],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://makenoisemusic.com/synthesizers/ohcoast",
	manualURI: "http://makenoisemusic.com/manuals/0-coast_manual.pdf",
	description: "The 0-COAST is a single voice patchable synthesizer. It’s name reflects the fact that it utilizes techniques from both the Moog and Buchla paradigms (aka East Coast, and West Coast, due to their locations), but is loyal to neither and thus implements no coast synthesis.",
	features: ["synth stuff"],
	longName: "Make Noise 0-coast"
),

elementsDesc: (
	elements: [
		(
			key: \key,
			shared:  (\elementType: \pad,
				\midiChan: 0, \spec: \midiVel, \ioType: \out),
			elements: (0..124).collect { |num, i| (
				shared: (midiNum: num),
				elements: [
					(key: \on,  midiMsgType: \noteOn ),
					(key: \off, midiMsgType: \noteOff)
				]
			)}
		),
		(
			key: \ctl,
			shared:  (\elementType: \pad,
				\midiChan: 0, \midiMsgType: \cc, \spec: \midiCC, \ioType: \out),
			elements: [
				(key: \tempoInDiv,  midiNum: 116),
				(key: \portamento,  midiNum: 5),
				(key: \arpeggiator, midiNum: 117), // on/off: 0/1
				(key: \latch,       midiNum: 119), // on/off: 0/1
				(key: \midiClock,   midiNum: 114), // on/off: 0/1
				(key: \chanA,       midiNum: 102), // val determines channel (0..15, 16>all)
				(key: \chanB,       midiNum: 103), // val determines channel (0..15, 16>all)
				(key: \cvA,         midiNum: 104), // 0: note, 1: vel, 2: mod, 3:LFO
				(key: \cvB,         midiNum: 105), // 0: note, 1: vel, 2: mod, 3:LFO
				(key: \gateA,       midiNum: 106), // 0: note, 1: vel, 2: mod, 3:LFO
				(key: \gateB,       midiNum: 107), // 0: note, 1: vel, 2: mod, 3:LFO
				(key: \pBendMin,    midiNum: 108),
				(key: \pBendMax,    midiNum: 109),
				(key: \aTouchMin,    midiNum: 110),
				(key: \aTouchMax,    midiNum: 111),
				(key: \velMin,    midiNum: 112),
				(key: \velMax,    midiNum: 113),

			]

		)
	]
)
);
