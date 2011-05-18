/*
g = GlobalsGui.new;
a = 12;
z = 8768768;
q = (a: 123, b: 234);
*/

GlobalsGui : JITGui { 
	var <texts; 
	classvar <names = #[
		\a, \b, \c, \d, \e, \f, \g, 
		\h, \n, \j, \k, \l, \m, \n,
		\o, \p, \q, \r, \s, \t, \u, 
		\v, \w, \x, \y, \z, \cmdLine ]; 
	
	*new { |parent, bounds| 
		^super.new(thisProcess.interpreter, 0, parent, bounds);
	}
	
		// these methods should be overridden in subclasses:
	setDefaults { |options|
		if (parent.isNil) {
			defPos = 10@260
		} {
			defPos = skin.margin;
		};
		minSize = 250 @ (names.size * skin.buttonHeight + 10);
	}
	
	makeViews { 
		
		texts = names.collect { |name| 
			var text = EZText(zone, 240@ skin.buttonHeight, name);
			text.view.resize_(2);
			text;
		};
		this.name_("Global Vars");
	}
	
	getState { 
		var state = ();
		names.do { |globvar| 
			state.put(globvar, object.instVarAt(globvar))
		};
		^state;
	}
	
	getName { ^"GlobalVars" }
	
	checkUpdate { 
		var newState = this.getState;
		names.do { |globvar, i|
			var obj = newState[globvar];
			if (obj != prevState[globvar]) { 
				texts[i].value_(obj);
			};
		};
		prevState = newState;
	}
}
