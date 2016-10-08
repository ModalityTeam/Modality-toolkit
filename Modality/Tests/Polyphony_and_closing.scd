// test controller polyphony when closing devices:

// connect gamepad, use twice
a = MKtl('a', "*drive").trace; a.gui;
b = MKtl('b', "*drive").trace; b.gui;

// close a - b should still work:
a.free;

// connect nanokontrol2, use twice
MKtl(\nk2, "*trol2").trace;
MKtl(\nk2B, "*trol2").trace;

MKtl(\nk2).free;
