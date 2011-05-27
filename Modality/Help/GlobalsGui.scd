GlobalsGui		a gui that shows all global variables in the interpreter.

	// make one
g = GlobalsGui.new;

	// set some global variables - they should show up
a = 12;
z = 8768768;
q = (a: 123, b: 234);

// * try changing the window size - the textviews adjust. //

// * try writing into a textfield and evaluating 
// - this should set the global variables. To check, do:

this.dump

// todo: 
*	compare newState with prevState, only do gui update if needed
* 	make smaller version (use numItems), that only shows used vars, and scrolls
MKtlAllGui(8).moveTo(430, 5);

