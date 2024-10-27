(
idInfo: "SHNTH_SHBOBO",
protocol: 'hid',
deviceName: "SHNTH_SHBOBO",
deviceType: '\shbobo',
elementTypes: [\fader, \button],
status: (
	linux: "tested and working (bgola)",
	osx: "unknown",
	win: "unknown"
),

deviceInfo: (
        vendorURI: "https://www.ciat-lonbarde.net/shbobo/index.html",
        description: "The SHNTH, a computer music device by SHBOBO, features the ARM Cortex 32 bit processor. It connects via USB to host computer (windows, linux, or macintosh) which may read its squish data, or program the standalone synthesizer in the computer music language, SHLISP. A switch enables internal batteries; electronic sounds out a stereo-mini jack. It is handtop: four bars on top feel your fingers and two woven antennae below sense palm flesh, complimented by a battery of buttons. There are red lights.",
),

elementsDesc: (
	elements: [
		(
			key: \pz,
			shared: (hidUsagePage: 1, elementType: \joyAxis, ioType: \in, spec: \cent1inv, mode: \center),
			elements: 4.collect {|idx|
				(key: idx, hidUsage: 48 + idx, style: (row: 2, column: 2+idx, height: 2))
			}
		),
		(
			key: \an,
			shared: (hidUsagePage: 1, elementType: \joyAxis, ioType: \in, spec: [1,0]),
			elements: 2.collect {|idx|
				(key: idx, hidUsage: 52+idx,  style: (row:4, column: 3+idx, height: 2))
			}
		),
		(
			key: \bt,
			shared:  (hidUsagePage: 9, elementType: \button, ioType: \in, spec: \hidBut, mode: \push),
			elements: 8.collect {|idx|
				(key: idx, hidUsage: idx+1, style: (row: if (idx % 2 == 0) { 1 } { 0 }, column:[0,1,2,3,5,4,7,6][idx]))
			}
		)
	]
)
);


