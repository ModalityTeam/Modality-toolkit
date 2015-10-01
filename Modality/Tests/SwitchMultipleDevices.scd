/* Test cases for multiple instances of the same device:
	works after commit [e2eceb8]:

* connect two Saitek Impact gamepads
* connect two nanoKontrol2s

There are two ways to address both of each kind:
- by lookupName given by MKtlLookup, and
- by desc filename and multiIndex - recommended!

If the USB plugs are connected to the same plugs again,
the order will be the same, so for the exact same setup,
both ways work.
For a changing setup with two controllers, it is more
reliable to use desc filename and multiIndex;
and still make sure the identical devices are connected to the same USB plugs.
*/
postPossible
MKtl.find(\midi);
MKtl.find(\hid);
MKtlLookup.all.midi_1_nanokontrol2_nr_1;
MKtlLookup.all.midi_2_nanokontrol2_nr_2;
MIDIClient.sources;



// by desc filename and multiIndex:
l = MKtl('nk2b', "korg-nanokontrol2", multiIndex: 0).trace;
m = MKtl('nk2w', "korg-nanokontrol2", multiIndex: 1).trace;
l.mktlDevice.srcID;
m.mktlDevice.srcID;

// free them, then try by lookupName
MKtl('nk2b').free; MKtl('nk2w').free;
l = MKtl('nk2b', 'midi_1_nanokontrol2_nr_1').trace;
m = MKtl('nk2w', 'midi_2_nanokontrol2_nr_2').trace;

// works, but not with two gamepads on the same USB expander - ?
// by desc filename and multiIndex:
MKtl('gp1', "saitek-impact-gamepad", multiIndex: 0).trace;
MKtl('gp2', "saitek-impact-gamepad", multiIndex: 1).trace;

// free them, then try by lookupName
MKtl('gp1').free; MKtl('gp2').free;
MKtl('gp1', 'hid_5_usb_game_controllers').trace;
MKtl('gp2', 'hid_6_usb_game_controllers').trace;
