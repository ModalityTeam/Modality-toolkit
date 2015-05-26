///// State of connecting some controllers with adc refactor branch:

MKtlDesc.postLoadable;
MKtlDesc.openFolder;

///////// HID \\\\\\\\\\
MKtl.find(\hid);
MKtlDevice.allAvailable[\hid]
HID.available
HID.available.do { |hid| MKtlDesc.filenameFor(hid.productName) };

// Ferrari gamepad, works
~ferr = MKtl('rnnd0', "RunNDrive").trace(true);

// Saitek impact gamepad (silver) - works
~imp = MKtl('sbgm0', "impact_gamepad"); ~imp.trace(true);

// Saitek gamepad black - does not find device - why?
~stk = MKtl('dlnl0', "JessTechDualAnalogRumble"); ~stk.trace(true);
~stk.desc.fullDesc;

// Saitek Cyborg X joystick
// - has no description; auto-desc from HID not yet working again.
~cyb = MKtl('cybr0', ).trace(true);

d = HIDMKtlDevice.sourceDeviceDict[\cybr0];
d.dump;


/////// MIDI \\\\\\\\\

// works, but desc only has scene 1, and PAD mode.
MKtl.find(\midi);
m = MKtl(\lpd80, "LPD8").trace(true);

// works, all 4 scenes
// ? what about the overlapping ccs in scene 4?
MKtl('nnkn0', "nanoKONTROL").trace(true);

MKtl('nnkn20', "nanoKONTROL2").trace(true); // OK!

MKtl('nnkn20', "nanoKONTROL2"); // OK!

MKtl('nnkn20').mktlDevice.checkAllCtls;
MKtl('nnkn20').trace(false).checkAllCtls;



//////// OSC \\\\\ not working yet.

MKtl(\manta, "manta*");


///// next = get lookups to work in all directions!


MKtlDesc.fileToIDDict["LPD8"];

MKtlDevice.idInfoForLookupName('dlnl0');
MKtlDevice.lookupNameForIDInfo('dlnl0');
MKtlDevice.lookupNameForIDInfo('dlnl0');

MKtlDesc.idInfoForFilename(MKtlDevice.idInfoForLookupName('dlnl0'));
MKtlDesc.filenameForLookupName('dlnl0');
