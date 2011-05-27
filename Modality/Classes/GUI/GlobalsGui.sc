GlobalsGui : JITGui { 
	var <textViews, <cmdLineView; 
	classvar <names = #[
		\a, \b, \c, \d, \e, \f, \g, 
		\h, \i, \j, \k, \l, \m, \n,
		\o, \p, \q, \r, \s, \t, \u, 
		\v, \w, \x, \y, \z, \cmdLine ]; 
	
	*new { |numItems, parent, bounds| 
			// numItems not supported yet, should do scrolling
			// ... for small screens ...
		^super.new(thisProcess.interpreter, numItems, parent, bounds);
	}
	
		// these methods should be overridden in subclasses:
	setDefaults { |options|
		if (parent.isNil) {
			defPos = 10@260
		} {
			defPos = skin.margin;
		};
		minSize = 200 @ (names.size * skin.buttonHeight + 4);
	}
	
	makeViews { 
		var textwidth = zone.bounds.width - 20;
		var textheight = skin.buttonHeight;
		
		cmdLineView = EZText(zone, textwidth @ textheight, 'cmdLine', labelWidth: 60)
			.enabled_(false);
			
		cmdLineView.labelView.align_(\center);
		
		textViews = names.drop(-1).collect { |name, i| 
			var text, labelWidth = 15, canEval = true; 
			
			text = EZText(zone, 188@ skin.buttonHeight, name, 
				{ |tx| object.perform(name.asSetter, tx.textField.string.interpret); }, 
			labelWidth: labelWidth);
			text.view.resize_(2);
			text.labelView.align_(\center); 
			text; 
		};
		textViews = textViews ++ cmdLineView;
		
		this.name_(this.getName);
	}
	
	getState { 
		var state = ();
		names.do { |globvar| 
			state.put(globvar, object.instVarAt(globvar))
		};
		^state;
	}
	
	getName { ^"Global_Vars" }
	winName { ^this.getName }
				
	checkUpdate { 
		var newState = this.getState; 
		names.do { |globvar, i|
			var obj = newState[globvar];
			if (obj != prevState[globvar]) { 
				textViews[i].value_(obj);
			};
		};
		prevState = newState;
	}
}
