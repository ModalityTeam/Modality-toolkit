MPush : MKtl{
	classvar <lightDict;

	*new {|name, multiIndex = 1 |
		^super.new(name, "ableton-push", multiIndex: multiIndex)
	}

	*initClass {
		lightDict = ();


		lightDict.ctlIntensity = IdentityDictionary[
			\off    -> 0,
			\dim    -> 1,
			\full   -> 7,
		];


		lightDict.topRowIntensity = IdentityDictionary[
			\dim -> 0,
			\full-> 1
		];

		lightDict.topRowBlink = IdentityDictionary[
			\steady -> 0,
			\slow   -> 1,
			\fast   -> 2
		];


		lightDict.topRowColor = IdentityDictionary[
			\red    -> 0,
			\orange -> 1,
			\yellow  -> 2,
			\green  -> 3,
		];

		lightDict.padIntensity = IdentityDictionary[
			\dim  -> 2,
			\half -> 1,
			\full -> 0
		];

		// lightDict.padBlink = IdentityDictionary[
		// 	\steady -> 0,
		// 	\slow   -> 1,
		// 	\fast   -> 2
		// ];


		lightDict.padColor = IdentityDictionary[
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

	*buttonLightCode {|intensity = \full, blink = \steady, color = \red, row = 0|
		(row > 0).if({
			^this.padLightCode(intensity, blink, color)
		});

		intensity = lightDict.topRowIntensity  [intensity] ? intensity;
		blink     = lightDict.topRowBlink      [blink] ? blink;
		color     = lightDict.topRowColor[color] ? color;

		^intensity.notNil.if({
			(color * 6) + (intensity  * 3) + blink + 1
		}, { // off
			0
		});
	}

	*padLightCode {|intensity = \full, blink = \steady, color = \red|
		intensity = lightDict.padIntensity  [intensity] ? intensity;
		color     = lightDict.padColor[color] ? color;

		^(color == 60).if({
			60
		}, {
			(5 + ((color * 4) + intensity))
		})
	}

	lightsOff {
		this.setCtlLight(\btCtl, \off);
		this.setCtlLight(\btLen, \off);
		this.setBtLight(this.elementAt(\bt, 0), \off);
		this.setBtLight(this.elementAt(\bt, 1), \off);
		this.setPadLight(\pad, \off);
	}


	setPadLight {|elem, intensity = \full, blink = \steady, color = \red|
		elem.isKindOf(Symbol).if{
			elem = this.elementAt(elem, \on);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.padLightCode(intensity, blink, color))};
	}

	setCtlLight {|elem, intensity = \full, blink = \steady, color = \red|
		elem.isKindOf(Symbol).if{
			elem = this.elementAt(elem);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.buttonLightCode(intensity, blink, color))};
	}

	setBtLight {|elem, intensity = \full, blink = \steady, color = \red|
		elem.isKindOf(Symbol).if{
			elem = this.elementAt(elem);
		};
		elem.bubble.flat.do{|e| e.deviceValue_(this.class.buttonLightCode(intensity, blink, color, elem.parent.index))}
	}
}