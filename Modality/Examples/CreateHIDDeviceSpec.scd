// =====================================================================
// Creating a template for an HID device
// =====================================================================

// find all devices that are attached:
MKtl.find( \hid );

// take the HID device:

a = MKtl( 'sbcm0');

// this will print incoming messages:
a.explore( true )


-89999-
// turn on debugging on the source device
a.srcDevice.debug_( true );

// linux only to prevent keyboard/mouse typing/moving mouse too:
a.srcDevice.grab;

// ungrab it:
//a.srcDevice.ungrab;

// auto gui from GeneralHID (not so useful in case of numpad though)
a.srcDevice.makeGui;


// create a template with keys and properties:
// this device only has buttons
// basically you check the device and give the elements on the device appropriate names and specifications
(
~myDeviceDesc = 
( 
(0..9).collect{ |i| (\b_ ++ i).asSymbol } // button 0 to 9
++ 
[ \b_000, \b_dot, \b_enter, \b_plus, \b_minus, \b_BS, \b_times, \b_divide, \b_home, \b_up, \b_pgup, \b_left, \b_right, \b_end, \b_down, \b_pgdn, \b_ins, \b_del, \b_any ] // the other buttons (the device also prints a value for any key that is pressed)
).collect{ |it|
 [ it, ( type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1, "XXX"] ) ) ];
// OSX: [ it, ( type: \button, mode: \push, spec: \hidBut, osx: (cookie: 0 ) ) ];
}.flatten;
);

(
// post a template you can fill in:
"[".postln;
~myDeviceDesc.pairsDo{ |it1, it2|
	it1.asCompileString.post; ", ".post; it2.postcs;
};
"]";
);

// numlock on: buttons 0 - 9
// numlock off: buttons ins, home, etc

[
'b_0', ( 'linux': ( 'slot': [ 1, 82 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_1', ( 'linux': ( 'slot': [ 1, 79 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_2', ( 'linux': ( 'slot': [ 1, 80 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_3', ( 'linux': ( 'slot': [ 1, 81 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_4', ( 'linux': ( 'slot': [ 1, 75 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_5', ( 'linux': ( 'slot': [ 1, 76 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_6', ( 'linux': ( 'slot': [ 1, 77 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_7', ( 'linux': ( 'slot': [ 1, 71 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_8', ( 'linux': ( 'slot': [ 1, 72 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_9', ( 'linux': ( 'slot': [ 1, 73 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
	'b_000', ( 'linux': ( 'slot': [ 1, 82 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), // this one is double!!
  'type': 'button' )
'b_dot', ( 'linux': ( 'slot': [ 1, 83 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
	'b_enter', ( 'linux': ( 'slot': [ 1, 28 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), // when staying pressed, the button keeps firing
  'type': 'button' )
'b_plus', ( 'linux': ( 'slot': [ 1, 78 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_minus', ( 'linux': ( 'slot': [ 1, 74 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_BS', ( 'linux': ( 'slot': [ 1, 14 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_times', ( 'linux': ( 'slot': [ 1, 55 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_divide', ( 'linux': ( 'slot': [ 1, 98 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_home', ( 'linux': ( 'slot': [ 1, 102 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_up', ( 'linux': ( 'slot': [ 1, 103  ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_pgup', ( 'linux': ( 'slot': [ 1, 104 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_left', ( 'linux': ( 'slot': [ 1, 105 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_right', ( 'linux': ( 'slot': [ 1, 106 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_end', ( 'linux': ( 'slot': [ 1, 107 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_down', ( 'linux': ( 'slot': [ 1, 108 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_pgdn', ( 'linux': ( 'slot': [ 1, 109 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_ins', ( 'linux': ( 'slot': [ 1, 110 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_del', ( 'linux': ( 'slot': [ 1, 111 ] ), 'mode': 'pushRepeat', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
  'type': 'button' )
'b_any', ( 'linux': ( 'slot': [ 1, 69 ] ), 'mode': 'push', 'spec': 'hidBut', 'osx': ( 'cookie': 0 ), 
	'type': 'button' ) // only in numlock mode
];

// save the resulting array to a file in MKtlSpecs (NumPad.desc.scd)
// and add an entry in the index:

// get the device specifics from the HID device:
a.srcDevice.info
// prints out:
a GeneralHIDInfo(USB Compliant Keypad, 0x0003, 0x05A4, 0x9840, 0x0110, usb-0000:00:1a.1-1/input0, )

// add to the index.desc.scd:
	\NumPad -> (linux: (device: "USB Compliant Keypad"), protocol: \hid, file: "NumPad.desc.scd" )


// -------------  DanceMat --------------------

MKtl('wsgr88880')

// change mode by pressing SELECT, START and UP

// identify the controls on the device
(
~myDeviceDescription = 
[
	\joy_X, ( type: \joyAxis, mode: \center, linux: ( slot: [3,0], spec: \cent1 ) ),
	\joy_Y, ( type: \joyAxis, mode: \center, linux: ( slot: [3,1], spec: \cent1inv ) ),
	\bt_select, (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [ 1, 297] ) ),
	\bt_start,  (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [ 1, 296] ) ),
	\bt_x,  (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1, 294 ] ) ),
	\bt_up,  (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1,290  ] ) ),
	\bt_o,  (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1,295 ] ) ),
	\bt_left,  (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1,288 ] ) ),
	\bt_right, (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1,291 ] ) ),
	\bt_triangle, (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1, 292 ] ) ),
	\bt_down, (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1,289 ] ) ),
	\bt_square, (type: \button, mode: \push, spec: \hidBut, linux: ( slot: [1, 293] ) )
];
);

MKtl('wsgr88880').srcDevice.info

// add to the index.desc.scd:
	\DanceMat -> (linux: (device: "WiseGroup.,Ltd MP-8888 USB Joypad", protocol: \hid, file: "DanceMat.desc.scd" ))


MKtl('wsgr88880').verbose_( true );



/// NOTE: we will make a method to add the device description automagically and mail it to us to add to the repository