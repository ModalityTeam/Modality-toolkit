/*
Window.closeAll;
MKtlDesc("*motor_49"); MKtl(\m49).free; MKtl(\m49, "*motor*").gui;
*/

(
	idInfo: (
		deviceName: "MOTÖR49 Keyboard",
		srcPortIndex: 0,
		destPortIndex: 0
	),
	deviceType: 'midiKeyboard',
	elementTypes: #[pianoKey, bender, wheel, button, fader, encoder, pad],
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
				elements: (0..120).collect {| num |
					var pos = Piano.pos(num, 0);
					(
						key: num.asSymbol, midiNum: num,
						style: (
							row: pos.y * 1.2 + 3,
							column: pos.x * 0.55,
							width: 0.7,
							height: 1.5,
							color: pos.color
						)
					)
				}
			),
			(
				key: 'bend',
				elementType: \slider, // 'bender',
				midiMsgType: 'bend',
				midiChan: 0,
				spec: 'midiBend',
				ioType: 'in',
				style: (row: 1, column: 0, height: 2)
			),
			(
				key: 'mod',
				elementType: \slider, // 'wheel',
				midiMsgType: 'cc',
				midiChan: 0,
				midiNum: 1,
				spec: 'midiCC',
				ioType: 'in',
				style: (row: 1, column: 1, height: 2)
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
					(key: 'rew', midiNum: 115, style: (row: 2, column: 11, width: 0.8)),
					(key: 'fwd', midiNum: 116, style: (row: 2, column: 11.6, width: 0.8)),
					(key: 'stop', midiNum: 117, style: (row: 2, column: 12.2, width: 0.8)),
					(key: 'play', midiNum: 118, style: (row: 2, column: 12.8, width: 0.8)),
					(key: 'loop', midiNum: 120, style: (row: 2, column: 13.4, width: 0.8)),
					(key: 'rec', midiNum: 119, style: (row: 2, column: 14.0, width: 0.8))
				]
			),
			(
				key: 'sl',
				shared: (
					elementType: 'slider',
					midiMsgType: 'cc',
					midiChan: 1,
					spec: 'midiCC',
					ioType: 'inout'
				),
				elements: 4.collect {| page |
					(
						key: (page + 1).asSymbol,
						page: page,
						elements: 8.collect {| fader |
							(
								midiNum: 21 + (page * 8) + fader,
								style: (row: 0, column: 2 + fader),
							)
						}
					)
				} ++ [
					(
						key: 'main', midiNum: 53,
						style: (row: 0, column: 2 + 8)
					)
				]
			),
			(
				key: 'kn',
				shared: (
					elementType: 'knob',
					midiMsgType: 'cc',
					midiChan: 1,
					spec: 'midiCC',
					ioType: 'inout'
				),
				elements: 4.collect {| page |
					(
						page: page,
						elements: 8.collect {| knob |
							(
								midiNum: 71 + (page * 8) + knob,
								style: (row: knob div: 4, column: knob % 4 + 11),
							)
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
						page: page,
						shared: (
							elementType: 'pad',
							groupType: 'noteOnOff'
						),
						elements: 8.collect {| pad |
							(
								midiNum: 66 + (page * 8) + pad,
								style: (
									row: 1 - (pad div: 4) * 1.5,
									column: pad % 4 * 1.5 + 15,
									width: 1.5, height: 1.5
								),
							)
						}
					)
				}
			)
		]
	)
);

