
DefLib : Library { 
	classvar <ndefs, <pdefs, <tdefs;

	nodeType { ^Event } // shorter posting
		
	*initClass { 
		ndefs = ndefs ?? { this.new };
		pdefs = pdefs ?? { this.new };
		tdefs = tdefs ?? { this.new };
	}
	
	*addNdef { |name, ndef| ndefs.put(name, ndef); }
	*getNdef { |name| ^ndefs.at(name); }

	*findNdef { |cats, tags| 
		// later: locate all cat and tag haloes for ndefs; 
		// sort by weights, show list of n best matches 
	}

	*addTdef { |name, tdef| tdefs.put(name, tdef); }
	*getTdef { |name| ^tdefs.at(name); }
	*findTdef { |cats, tags, n = 10| 
		// later: locate all cat and tag haloes for defs; 
		// sort by weights, show list of n best matches 
	}

	*addPdef { |name, pdef| pdefs.put(name, pdef); }
	*getPdef { |name| ^pdefs.at(name); }
	*findPdef { |cats, tags| 
		// later: locate all cat and tag haloes for defs; 
		// sort by weights, show list of n best matches 
	}

}

+ Ndef { 
	
	hide { 
			// remember all settings
			// maybe try to freeBus later?
		this.end;
		Ndef.all[this.server.name].envir.removeAt(this.key);
		DefLib.addNdef(this.key, this);
	}
	
	*show { |name, play = false, vol = 0.1| 
		var def = DefLib.getNdef(name);
		if (def.notNil) { 
			Ndef.dictFor(Server.default).envir.put(name, def);
			if (play) { def.play(vol: vol) };
		};
	} 
	
	*findBy { |cats, tags|
		// later
	}
}

+ Tdef { 
	hide { 
		this.stop;
		Tdef.all.removeAt(this.key);
		DefLib.addTdef(this.key, this);
	}
	
	*show { |name, play = false| 
		var def = DefLib.getTdef(name);
		if (play) { def.play };
		Tdef.all.put(name, def);
		^def
	} 
	
	*findBy { |cats, tags|
		// later
	}
}

+ Pdef { 
	hide { 
		this.stop;
		Pdef.all.removeAt(this.key);
		DefLib.addPdef(this.key, this);
	}
	
	*show { |name, play = false| 
		var def = DefLib.getPdef(name);
		if (play) { def.play };
		Pdef.all.put(name, def);
		^def
	} 
	
	*findBy { |cats, tags|
		// later
	}
}

