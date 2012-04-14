IdentityDictionary[

	\nanoKONTROL -> (osx: ( device: "nanoKONTROL"), linux: ( device: "nanoKONTROL-nanoKONTROL MIDI 1"), protocol: \midi, file: "nanoKONTROL.desc.scd" ),
	\nanoKONTROL2 -> (osx: ( device: "nanoKONTROL2"), linux: ( device: "nanoKONTROL2-nanoKONTROL2 MIDI 1" ), protocol: \midi, file: "nanoKONTROL2.desc.scd" ),
	\BCR2000 -> (osx: ( device: "BCR2000"), linux: ( device: "BCR2000-BCR2000 MIDI 1" ), protocol: \midi, file: "BCR2000.desc.scd" ),
	\BCF2000 -> (osx: ( device: "BCF2000"), linux: ( device: "BCF2000-BCF2000 MIDI 1" ), protocol: \midi, file: "BCF2000.desc.scd" ),
	\Launchpad -> (osx: ( device: "Launchpad"), linux: (device: "Launchpad"), protocol: \midi, file: "Launchpad.desc.scd" ),
	\istage -> (osx: ( device: "iCON iStage V1.00"), file: "ICONIStage.desc.scd"),
    \lpd80 -> (osx: ( device: "LPD8"), file: "LPD8.desc.scd"),

	\DanceMat -> (osx: (), linux: (device: "WiseGroup.,Ltd MP-8888 USB Joypad"), protocol: \hid, file: "DanceMat.desc.scd" ),
	
	\GamePad -> ( type: \template, protocol: \hid, file: "GamePad.desc.scd" ), // gamepad template
	\Run_N_Drive -> (osx: ( device: "Run'N' Drive"), linux: (device: "Thrustmaster Run\'N\' Drive"), protocol: \hid, file: "Run_N_Drive.desc.scd" ),
	\ImpactGamePad -> ( osx: ( ), linux: ( device: "Mega World USB Game Controllers"), protocol: \hid, file: "ImpactGamePad.desc.scd" ),
	\PuzzleSphere -> ( osx: (), linux: (device: "In2Games Real Play"), protocol: \hid, file: "PuzzleSphere.desc.scd"),

	\manta -> (inport: 1234, outport: 5678, protocol: \osc, file: "Manta.desc.scd" ),

	
	//	\Arduino -> (protocol: \serial),
	//	\JeeLink -> (protocol: \serial),
	//	\JeeNode -> (protocol: \serial)
]