
AllGui : JITGui { 
	var <labels, <texts; 
	var <globalNames = #[ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 
					    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' ];
					    
	*new { |numItems = 12, parent, bounds|
		^super.new(nil, numItems, parent, bounds);
	}

		// these methods should be overridden in subclasses: 
	setDefaults { |options|
		defPos = if (parent.isNil) { 10@10 } { skin.margin };
		minSize = 175 @ 170;
	}
	
	winName { ^"AllGui" }
	
	makeViews {
		zone.resize_(2);
		texts = ();
		labels = [ 
			\global, 		{ |num| GlobalsGui.new },
			\currEnvir, 	{ |num| EnvirGui(currentEnvironment, num)
								.parent.name_("currentEnvironment") }, 
			
			\Tdef,		{ |num| TdefAllGui.new(num) }, 
			\Pdef, 		{ |num|  PdefAllGui.new(num) }, 
			\Pdefn,		{ |num| PdefnAllGui.new(num) }, 
			\Ndef, 		{ |num| NdefMixer.new(Ndef.all.choose, num) }, 
			\proxyspace, 	{ |num| 
				var pxs = if (currentEnvironment.isKindOf(ProxySpace), 
					currentEnvironment, 
					ProxySpace.all.choose);
					ProxyMixer.new(pxs, num) 
				}
		]; 
		
		if (\MKtl.asClass.notNil) { 
			labels = labels ++ [ \MKtl, { |num| MKtlAllGui.new(num) } ];
		};
		
		labels.pairsDo { |label, action|
			var numbox;
			var text = EZText(zone, 100@20, label.asString, labelWidth: 75)
				.value_(0)
				.enabled_(false);
		
		// resizing not working properly yet 
		// in EZNumber seems to be the problem.
			text.labelView.align_(\center);
			text.textField.align_(\center);
//			text.labelView.resize_(2);
//			text.textField.resize_(3);
			
			texts.put(label, text);
			Button(zone, Rect(0,0, 50, 20))
				.states_([["open"]])
				.action_({ action.value(numbox.value.asInteger) })
			//	.resize_(3)
				;
			numbox = EZNumber(zone, 
				Rect(0,0, 20, 20), nil, 
				[0, 32, \lin, 1], 
				initVal: numItems);
			//	numbox.view.resize_(3);
		};
	}
	
	getState { 
		var interp = thisProcess.interpreter;
		var numGlobs = globalNames.count { |glob| interp.perform(glob).notNil };

		^(global: numGlobs, 
		currEnvir: currentEnvironment.size, 
		MKtl: MKtl.all.size,
		Tdef: Tdef.all.size,
		Pdef: Pdef.all.size,
		Pdefn: Pdefn.all.size,
		Ndef: Ndef.all.collect { |ps| ps.envir.size }.sum, 
		proxyspace: ProxySpace.all.collect { |ps| ps.envir.size }.sum;
		);
	}
	
	checkUpdate { 
		var newState = this.getState;
		newState.keysValuesDo { |key, val| 
			try { texts[key].value_(val) };
		};
	}
}