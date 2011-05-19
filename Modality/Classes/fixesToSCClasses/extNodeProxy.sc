+ NodeProxy { 
		// renames synthdef so one can use it in patterns
	nameDef { |name, index = 0| 
		var func = objects[index].synthDef.func; 
		name = name ?? { 
			"New SynthDef name: ".post; 
			(this.key ++ "_" ++ index).asSymbol.postcs;
		};
		^SynthDef(name, func); 
	}
}
