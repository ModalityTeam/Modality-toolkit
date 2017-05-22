// contributed by gil fuser
/*
* todo:
* test on osx

m = MKtl(\mpk2, "akai-mpkmini2");
m.gui;
m.trace;
m.trace(false);
*/

(
deviceName: "MPKmini2",
protocol: 'midi',
deviceType: 'midiKeyboard',
elementTypes: [\knob, \key, \pad, \bend],
status: (
    linux: "tested and working",
    osx: "unknown",
    win: "tested and working"),

idInfo: "MPKmini2",

// hardwarePages: [1, 2, 3, 4],

deviceInfo: (
    vendorURI: 'http://www.akaipro.com/product/mpk-mini-mkii',
    manualURI: 'http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/988/documents/MPK%20mini%20-%20User%20Guide%20-%20v1.0.pdf',
    features: [\pianoKey, \pad, \knob, \bender],
    notes:
    "Uses only ```Program 1```.\n"
    "To use the other programs use first: [MPK MiniMKII editor](http://www.akaipro.com/product/mpk-mini-mkii#downloads)\n"
	"avoiding more mapping overlaping as occours in the defaults.\n"
    "Accidental ```Prog-Change``` activation on the device needs to be reverted by ```Bank A/B```.\n",
	longName: "AKAI MPKmini mk2"
),

elementsDesc: (
	
	elements:
	[
		
		// ------ pad BANK A note on-off-------------
		(
			key: \pnA,
			shared: ( elementType: \pad, midiChan: 0, spec: \midiVel, midiMsgType: \noteOn, groupType: \noteOnOffBut ),
			elements: ( 44..51 ).collect{ |num, i|
				(
					key: i.asSymbol,
					shared: ( midiNum: num, style:( row: 1 - (i div:4), column: 2 + (i % 4)) )
				)
			}
		),
		
		// ------ pad BANK B note on-off -------------
		(
			key: \pnB,
			shared: ( elementType: \pad, midiChan: 0, spec: \midiVel, midiMsgType: \noteOn, groupType: \noteOnOffBut ),
			elements: ( 32..39 ).collect{ |num, i|
				(
					key: i.asSymbol,
					shared: ( midiNum: num, style:( row: 2.25 + (1 - (i div:4)), column: 2 + (i % 4)) )
				)
			}
		),
		
		// ------ pad BANK A cc -------------
		(
			key: \pcA,
			shared: ( midiChan: 0, midiMsgType: \cc, elementType: \pad, spec: \midiCC ),
			elements: ( 20..27 ).collect{ |num, i|
				(
					key: i.asSymbol,
					midiNum: num,
					style:( row: 4.5 + (1 - (i div:4)), column: 2 + (i % 4))
				)
			}
		),
		
		// ------ pad BANK B cc -------------
		(
			key: \pcB,
			shared: ( elementType: \pad, midiChan: 0, spec: \midiCC, \ioType: \inout, midiMsgType: \cc ),
			elements: ( 28..35 ).collect{ |num, i|
				(
					key: i.asSymbol,
					midiNum: num,
					style:( row: 6.75 + (1 - (i div:4)), column: 2 + (i % 4))
				)
			}
		),
		
		
		// ------ knob -------------
		(
			key: \k,
			shared: ( elementType: \knob, midiChan: 0, spec: \midiCC, midiMsgType: \cc ),
			elements: ( 1..8 ).collect{ |num, i|
				(
					key: i.asSymbol,
					midiNum: num, style:( row: i div:4, column: 6 + (i % 4) ),
				)
			}
		),
		
		//////// piano key //////////
		(
			key: \pkey,
			shared: ( midiChan: 0, elementType: \pianoKey, groupType: \noteOnOff, spec: \midiVel ),
			elements:
			(0..120).collect { |i|
				var pos = Piano.pos( i % 25, 0);
				(
					key: i.asSymbol,
					shared: (
						midiNum: i, groupType: \noteOnOff,
						style: (
							row: ( i div: 25 * 1.5 ) + (pos.y * 0.6),
							column: 10 + (pos.x * 0.65 % 25),
							color: pos.color,
							width: 0.9,
							height: 0.75,
						)
					)
				)
			}
		),
		// ------- bend ------------
		( key: \bY,
			midiChan: 0, \midiNum: 2, midiMsgType: \cc, elementType: \slider, spec: \midiCC, style: (row: 0, column:0.5, width: 0.84, height: 1.75 ) ),
		( key: \bX,
			midiChan: 0, midiMsgType: \bend, elementType: \xfader, spec: \midiBend, style: (row: 1.66, column:0, width: 1.9 ) ),
	]
)
);
