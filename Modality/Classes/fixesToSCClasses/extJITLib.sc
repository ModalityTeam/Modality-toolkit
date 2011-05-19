+ NodeProxy { 
	generateUniqueName {
			// if named, give us the name so we see it 
			// in synthdef names of the server's nodes. 
		var key = this.key ?? this.identityHash.abs;
		^server.clientID.asString ++ key ++ "_";
	}
}
	// support option \small for small displays:
	// less than 800@600, arZone only 390 wide, 
	// rotate between nothing, krZone, editZone
+ ProxyMixer { 

}