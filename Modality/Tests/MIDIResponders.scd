// tests for all kinds of responders

m = MKtl(\mpd18, "akai-mpd18");
m.device.msgTypes;
// -> Set[ cc, noteOn, noteOff, touch ]

m.elements.action = { |el|
	"yo, mpd18: %\n".postf([el.name, el.value]);
};

m.elementAt(\padOn, 0, 15)
//
MIDISim.value((midiMsgType: \noteOn, numbers: [0, 64, 1.0.rand.round(0.01)]));


// \touch test - mpd18 has touch - not working yet
m.elements.at(\touch_0).action = { |el|
	"you can't touch this: %\n".postf(el.value);
};

m.device.class.allMsgTypes
m.elements.at(\touch_0).valueAction_(1.0.rand);
m.device.responders.touch.enabled;

// noteOn, cc
// bend test - steinberg CMC-FD has 4 chans of bend
...
 [ noteOn, noteOff, noteOnOff, cc, polyTouch, touch, bend, program ]


// not working, why?
MIDISim((midiMsgType: \touch, numbers: [0, 1.0.rand.round(0.01)]));

// no MktlDesc so far has \program

// ableton push has polytouch: todo

