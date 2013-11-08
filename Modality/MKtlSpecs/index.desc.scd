IdentityDictionary[

	\nanoKONTROL -> ( device: "nanoKONTROL", protocol: \midi, file: "nanoKONTROL.desc.scd" ),
	\nanoKONTROL2 -> ( device: "nanoKONTROL2", protocol: \midi, file: "nanoKONTROL2.desc.scd" ),

	\BCR2000 -> ( device: "BCR2000", protocol: \midi, file: "BCR2000.desc.scd" ),
	\BCF2000 -> ( device: "BCF2000", protocol: \midi, file: "BCF2000.desc.scd" ),

	\Launchpad -> ( device: "Launchpad", protocol: \midi, file: "Launchpad.desc.scd" ),
	\istage -> ( device: "iCON iStage V1.00", protocol: \midi, file: "ICONIStage.desc.scd"),
	\icontrols -> ( device: "iCON iControls V2.00", file: "ICONIControls.desc.scd" ),
    \lpd8 -> ( device: "LPD8", protocol: \midi, file: "LPD8.desc.scd"),

	'UC-33' -> ( device: "UC-33 USB MIDI Controller", protocol: \midi, file: "UC-33.desc.scd" ),
	\triggerfinger -> ( device: "USB Trigger Finger", protocol: \midi, file: "triggerfinger.desc.scd"),

	\DanceMat -> (osx: ( device: "MP-8888 USB Joypad"), linux: (device: "WiseGroup.,Ltd MP-8888 USB Joypad"), protocol: \hid, file: "DanceMat.desc.scd" ), // device identifier might be specific to PS/2 to USB adapter...

	\GamePad -> ( type: \template, protocol: \hid, file: "GamePad.desc.scd" ), // gamepad template
	\Run_N_Drive -> (osx: ( device: "Run'N' Drive"), linux: (device: "Thrustmaster Run\'N\' Drive"), protocol: \hid, file: "Run_N_Drive.desc.scd" ),
	\ImpactGamePad -> ( osx: ( device: "USB Game Controllers"), linux: ( device: "Mega World USB Game Controllers"), protocol: \hid, file: "ImpactGamePad.desc.scd" ),
	\DragonRiseGamePad -> ( linux: ( device: "DragonRise Inc.   Generic   USB  Joystick  "), protocol: \hid, file: "DragonRiseGamePad.desc.scd" ),
	\ZeroplusXbox -> ( linux: ( device: "Zeroplus Xbox Controller" ), protocol: \hid, file: "ZeroplusXbox.desc.scd" ),
	\PuzzleSphere -> ( osx: ( device: "Real Play"), linux: (device: "In2Games Real Play"), protocol: \hid, file: "PuzzleSphere.desc.scd"),

	'The Ribbon' -> ( device: "The Ribbon", protocol: \midi, file: "EOWave_Ribbon.desc.scd" ),

	//	\manta -> (inport: 1234, outport: 5678, protocol: \osc, file: "Manta.desc.scd" ),


	//	\Arduino -> (protocol: \serial),
	//	\JeeLink -> (protocol: \serial),
	//	\JeeNode -> (protocol: \serial)
]