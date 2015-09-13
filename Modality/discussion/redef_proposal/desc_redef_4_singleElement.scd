/*********

4 steps towards redefining .desc.scd files:

1. An example for a simple desc file (LPD8) with comments

2. general info section in full detail

3. the entire elementsDesc in full detail

4. the single elementDesc in full detail

*********/

// 4. the single elementDesc in full detail

/* single elements and their descriptions have some things in common,
	and vary quite a lot based on protocol.
*/

// A single element desc is a dict or event,
// and it (or its group shared properties) should contain these keys:

(
/* elementType: user-readable name for the physical type of thing */
// Typically one of MKtl.elementTypes;
elementType: \slider,

// ioType: whether and how it gets input/output.
// one of MKtl.ioTypes;
// [\in, \out, \inout, \sharedIn, \sharedOut, \sharedInOut];
ioType: \inout,

// spec: a spec for the internal number range of the device;
// e.g. for midi controls, this is \midiCC,
// which is [0, 127, \lin, 1, 0].asSpec;
spec: \midiCC,
// for hid buttons:
spec: \hidBut,
// or just
spec: \but,


// valueType: \absolute (default) or \relative
	// element sends absolute value, such as fader position
	// default, so this is assumed if not given.
valueType: \absolute,
	// relative: elements send delta value, i.e.
	// by how much to change whatever it is currently setting.
	// HID mouse devices send deltaX and deltY values,
	// MIDI encoder knobs send how many clicks one has turned,
	// or custon increment/decrement buttons ...
valueType: \relative,
	// in this case, one can use a RelSet in the element.action,
	// so the current value of the destination object is changed.


// how buttons act:
// trigger action on release only for toggle buttons (default):
buttonMode: \toggle,
// trigger action on push and release,
// so active value only while holding down
buttonMode: \momentary,


// all other elements, e.g. faders and joystick axes:
	// releaseMode: what to do on release,
	// default: value is held where it is
releaseMode: \hold,
	// specify these two for joy axes which have springs
	// that return them to center:
releaseMode: \snapback,
snapbackValue: 0.5,


/**** protocol specific keys: ***/

// MIDI specifics:
	// one of MIDIMKtlDevice.allMsgTypes;
midiMsgType: \control,

	// on which chan to listen/send
midiChan: 0,
	 // if noteOn, noteOff, cc, or polyTouch:
	// which noteNum, ccNum to use
midiNum: 60,

// HID specifics:
// which 'hidUsage' (element cookie) and page to listen to
'hidUsage': 5,
'hidUsagePage': 9,

// is this currently used? how?
'hidElementID': 0,

// OSC specifics:
	// the osc message the element listens to:
oscPath: "/minibee/imu",
	// if multiple elements use the same message name,
	// specify addressing keys for this element in argTemplate:
// "How to create a description file for an OSC device".openHelpFile;
argTemplate: [ 1, 2 ],

