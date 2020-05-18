(
	idInfo: (
		deviceName: "MOTÖR49 Keyboard",
		srcPortIndex: 0,
		destPortIndex: 0
	),
	deviceType: 'midiKeyboard',
	elementTypes: #[painoKey, bender, wheel, button, fader, encoder, pad],
	protocol: 'midi',
	deviceInfo: (
		features: [
			"9 motor-faders (4 banks of 8 + 1)",
			"4 banks of 8 rotary-encoders",
			"4 banks of 8 drum pads",
			"6 transport control buttons",
			"49 piano keys",
			"pitch bend and modulation wheel"
		],
		notes: "This description covers the regular MIDI mode",
		longName: "Behringer MOTÖR49 Keyboard"
	),
	elementsDesc: (
		elements: [
			(
				key: 'key',
				shared: (
					groupType: 'noteOnOff',
					elementType: 'pianoKey',
					midiChan: 0,
					spec: 'midiVel',
					ioType: 'in'
				),
				elements: (0..120).collect {| n |
					(
						midiNum: n
					)
				}
			),
			(
				key: 'bend',
				elementType: 'bender',
				midiMsgType: 'bend',
				midiChan: 0,
				spec: 'midiBend',
				ioType: 'in'
			),
			(
				key: 'mod',
				elementType: 'wheel',
				midiMsgType: 'cc',
				midiChan: 0,
				midiNum: 1,
				spec: 'midiCC',
				ioType: 'in'
			),
			(
				key: 'tr',
				shared: (
					elementType: 'button',
					midiMsgType: 'cc',
					midiChan: 1,
					spec: 'midiBut',
					ioType: 'in'
				),
				elements: [
					(key: 'rew', midiNum: 115),
					(key: 'fwd', midiNum: 116),
					(key: 'stop', midiNum: 117),
					(key: 'play', midiNum: 118),
					(key: 'loop', midiNum: 120),
					(key: 'rec', midiNum: 119)
				]
			),
			(
				key: 'sl',
				shared: (
					midiMsgType: 'cc',
					midiChan: 1,
					spec: 'midiCC',
					ioType: 'inout'
				),
				elements: [
					(
						key: 'master', midiNum: 53
					)
				] ++ 4.collect {| page |
					(
						key: (page + 1).asSymbol,
						elements: 8.collect {| fader |
							(
								midiNum: 21 + (page * 8) + fader
							)
						}
					)
				}
			),
			(
				key: 'kn',
				shared: (
					midiMsgType: 'cc',
					midiChan: 1,
					spec: 'midiCC',
					ioType: 'inout'
				),
				elements: 4.collect {| page |
					(
						elements: 8.collect {| knob |
							(midiNum: 71 + (page * 8) + knob)
						}
					)
				}
			),
			(
				key: 'pad',
				shared: (
					midiChan: 1,
					ioType: 'in'
				),
				elements: 4.collect {| page |
					(
						shared: (
							elementType: 'pad',
							groupType: 'noteOnOff'
						),
						elements: 8.collect {| pad |
							(
								midiNum: 66 + (page * 8) + pad
							)
						}
					)
				}
			)
		]
	)
)
