MPush2 : MPush {
	*new {|name, multiIndex = 0 |
		^this.fromMKtl(MKtl(name, "ableton-push-2", multiIndex: multiIndex))
	}
}

MPush : MKtl{
	classvar <lights;

	*new {|name, multiIndex = 1 |
		^this.fromMKtl(MKtl(name, "ableton-push", multiIndex: multiIndex))
		// ^super.new(name, "ableton-push", multiIndex: multiIndex)
	}

	*fromMKtl {|mktl|
		^super.new(mktl.name);
	}

	*initClass {
		lights = ();


		lights.ctlIntensity = IdentityDictionary[
			\off    -> 0,
			\dim    -> 1,
			\full   -> 7,
		];


		lights.topRowIntensity = IdentityDictionary[
			\dim -> 0,
			\full-> 1
		];

		lights.topRowBlink = IdentityDictionary[
			\steady -> 0,
			\slow   -> 1,
			\fast   -> 2
		];


		lights.topRowColor = IdentityDictionary[
			\red    -> 0,
			\orange -> 1,
			\yellow  -> 2,
			\green  -> 3,
		];

		lights.padIntensity = IdentityDictionary[
			\dim  -> 2,
			\half -> 1,
			\full -> 0
		];

		// lights.padBlink = IdentityDictionary[
		// 	\steady -> 0,
		// 	\slow   -> 1,
		// 	\fast   -> 2
		// ];


		lights.padColor = IdentityDictionary[
			\red     ->  0,
			\amber   ->  1,
			\yellow  ->  2,
			\lime    ->  3,
			\green   ->  4,
			\spring  ->  5,
			\turquoise -> 6,
			\cyan    ->  7,
			\sky     ->  8,
			\ocean   ->  9,
			\blue    -> 10,
			\orchid  -> 11,
			\magenta -> 12,
			\pink    -> 13,
			\brightOrange -> 60
		];

	}

	*buttonLight {|color = \red, intensity = \full, blink = \steady, row = 0|
		(row > 0).if({
			^this.padLight(color, intensity, blink)
		});

		intensity = lights.topRowIntensity  [intensity] ? intensity;
		blink     = lights.topRowBlink      [blink] ? blink;
		color     = lights.topRowColor[color] ? color;

		^intensity.notNil.if({
			(color * 6) + (intensity  * 3) + blink + 1
		}, { // off
			0
		});
	}

	*padLight {|color = \red, intensity = \full, blink = \steady|
		intensity = lights.padIntensity  [intensity] ? intensity;
		color     = lights.padColor[color] ? color;

		^(color == 60).if({
			60
		}, {
			(5 + ((color * 4) + intensity))
		})
	}

	lightsOff {
		this.setCtlLight(\btCtl, intensity: \off);
		this.setCtlLight(\btLen, intensity: \off);
		this.setBtLight(this.elementAt(\bt, 0), intensity: \off);
		this.setBtLight(this.elementAt(\bt, 1), intensity: \off);
		this.setPadLight(this.elAt(\pad), intensity: \off);
	}


	setPadLight {|elem, color = \red, intensity = \full, blink = \steady|
		elem.isKindOf(Symbol).if{
			elem = this.elAt(elem, \on);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.padLight(color, intensity, blink))};
	}

	setCtlLight {|elem, color = \red, intensity = \full, blink = \steady|
		elem.isKindOf(Symbol).if{
			elem = this.elAt(elem);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.buttonLight(color, intensity, blink))};
	}

	setBtLight {|elem, color = \red, intensity = \full, blink = \steady|
		elem.isKindOf(Symbol).if{
			elem = this.elAt(elem);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.buttonLight(color, intensity, blink, elem.parent.index))}
	}
}