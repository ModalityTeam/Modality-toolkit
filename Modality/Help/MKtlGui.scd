MKtlGui		- a gui that can draw views 
			for all the elements  of an MKtl.

(	// make two
MKtl.make(\ferr1, 'Run_N_Drive');
MKtl.make(\nk1, 'nanoKONTROL');
MKtlGui.init;

MKtlAllGui(12);

m = MKtlGui(MKtl(\ferr1));
)
(	// the zones for each element 
var zoneDict = (
	'bt1r': Rect(250 + 40, 200 - 12, 40, 24),
	'bt2r': Rect(275 + 40, 225 - 12, 40, 24),
	'bt3r': Rect(300 + 40, 200 - 12, 40, 24),
	'bt4r': Rect(275 + 40, 175 - 12,  40, 24),

	'lfBot7': 	Rect(110, 25,  40, 20),
	'lfTop5': 	Rect(40, 100,  80, 20),
	
	'midL9': 		Rect(150, 190, 48, 20),
	'midR10': 	Rect(202, 190, 48, 20),
	
	'rfBot8':		Rect(250, 25,  40, 20),
	'rfTop6': 	Rect(280, 100,  80, 20),
	
	\joyL: 		Rect(60, 260, 100, 100),
	\joyR: 		Rect(220, 260, 100, 100),
	
	\compass: 	Rect.aboutPoint(100@200, 45, 45),

	'wheel': 		Rect(5, 125, 40, 150 ),
	'throtL': Rect(30, 55, 120, 40),
	'throtR': Rect(250, 55, 120, 40)
);
	// temp fix for composite elements:
m.object.elements.put(\joyL, (type: \joyStick));
m.object.elements.put(\joyR, (type: \joyStick));

m.makeElemViews(zoneDict);
)


MKtlGui.postZoneTemplate(MKtl(\ferr1));

