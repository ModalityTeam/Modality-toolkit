+ NodeProxy { 
	generateUniqueName {
			// if named, give us the name so we see it 
			// in synthdef names of the server's nodes. 
		var key = this.key ?? this.identityHash.abs;
		^server.clientID.asString ++ key ++ "_";
	}
}

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

+ ProxySpace {
	size { ^envir.size }
}
	// support option \small for small displays:
	// less than 800@600, arZone only 390 wide, 
	// rotate between nothing, krZone, editZone
+ ProxyMixer { 

}