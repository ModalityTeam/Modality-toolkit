# Elements of MKtl description files (<>.desc.scd)

As agreed on by the modalityTeam(tm) on 9.Nov.2013

A controller is always bound to one protocol. If there is a device that communicates on multiple protocols (e.g. *ICON i-controls*), this has to be merged later in the processing chain.
A control element is a part of a controller that does one or more of the following things

+ spits out a one-dimensional stream of events, 
+ accepts a one-dimensional stream of events.


A description file gathers information for each element.
One description file line is a combination of 
*(a)* semantic information (e.g. for searching or automated grouping) and 
*(b)* technical information (e.g. for MKtl-internal usage).

It is of this form:

`\key: (\infoKey1: infoVal1, \infoKey2: infoVal2, ...),`


### Semantic information

#### type
tells about the type of an element. Popular are

+ fader
+ button
+ knob
+ joyAxis
+ hatSwitch
+ pianoKey
+ pad
+ slider



#### mode

optional extension to type, e.g. 

+ one-shot
+ push
+ etc.

### Technical information

#### <midi|hid|osc>Type 

One of `[ \midiType, \hidType, oscType ]` has to be present. This also tells about the type of device on which it is implemented (MIDI/HID/OSC). 

+ `\midiMsgType` -- `\noteOnOff | \noteOn | \noteOff | \bend | \cc | \touch | \polytouch | \program`
+ `\hidElementID`  -- key usage. *We have to agree on this. possibly taking from the HID whitepaper?*
+ `\oscType`  -- *tbd. We have to agree on this.*

#### spec

The element `\spec` has to be present and is a symbol that, if called `.asSpec` upon, returns the (global) ControlSpec suitable for this element.

### midiChan, midiNum

Needed, if `\midiType` is part of the config string.
`bend, touch, program` only need `midiChan` is specified.



## all elements
<code>
[
	// noteKeys				(OP-1)
	\noteOn: 	(\midiType: \noteOnOff, \type: \keys,   \midiChan: 0, \midiNum: (29..64), \spec: \midiVel, \mode: \key),
	
	// bend position		(EOWave Ribbon)
	\ribbonPos: (\midiType: \bend,      \type: \fader, \midiChan: 0, \midiNum: 0, \spec: \midiBend, 			\mode: \push	),
	
	// button 				(NanoKtl)
	\play:  (\midiType: \cc, \type: \button,  \midiChan: 0, \midiNum: 45, \spec: \midiBut,					\mode: \push	),

	// hat button of a knob	(BCF2000)
	\tr_1:  (\midiType: \cc, \type: \hatSwitch, \midiChan: 0, \midiNum: 33, \spec: \midiCC,  \ioType: \in						),

	// endless knob 		(BCF2000)
	\kn_1:  (\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum:  8, \spec: \midiCC,  \ioType: \inout					),

	// fader 				(BCF2000)
	\sl_1:  (\midiType: \cc, \type: \fader, \midiChan: 0, \midiNum: 81, \spec: \midiCC,  \ioType: \inout					),
	
	// joystick axis		(DanceMat)
	\joy_X: (\type: \joyAxis, osx: ( cookie: 16, spec: \cent255),linux: ( slot: [3,0], spec: \cent1 ),	\mode: \center	),
	// does not tell anything about being a HID thingie...
	// has a linux-specific area... still needed?
	
	// HID button			(DanceMat)
	\bt_select, (type: \button, spec: \hidBut, osx: ( cookie: 12), linux: ( slot: [ 1, 297] ),			\mode: \push	),
	// spec tells about being HID...
	
	// Pad global aftertouch	(MPD18)
	\padTouch: ('midiType': 'touch', 'type': 'padTouch', 'chan': 0, 'midiNote':  0,'spec': 'midiTouch'), 
	
]
</code>

