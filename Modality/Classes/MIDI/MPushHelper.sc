MPushHelper {
	classvar <lightDict;

	*initClass {
		lightDict = ();

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

}