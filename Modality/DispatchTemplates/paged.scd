//needs to be fixed
(
func:{ |disp, source, previousSceneKey, nextSceneKey, n = 10, elementKeys, sourceKey|
	
	disp.map(source, elementKeys);	
	
	// initialize the scene
	disp.envir[\scene] = 0;
	disp.envir[\numOfScenes] = n;
	disp.envir[\values] = n.collect{ 
		Dictionary.new.putPairs(source.elementNames.collect{ |name| 
			[name, source.defaultValueFor(name) ? 0] 
		}) 
	};
	
	n.collect{ |i| source.elementNames.collect{ |name| disp.createOutput(("/page"++(i+1)++"/"++name).asSymbol) } };
	
	disp.addToProc( \processEvents, {  |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var val = in[\val];
		var scene = e[\scene];
	
		e[\values][scene][key] = val;
		dis.setOutput(("/page"++(scene+1)++"/"++key).asSymbol,val)
	
	});
	
	disp.addToProc( \changeScene, {  |dis,e|
		var in = dis.changedIn;

		if( (in[\key] == previousSceneKey) && ( in[\val] == 1.0 ) ) {
			e[\scene] = (e[\scene] - 1).max(0);
			postln("Scene is "++e[\scene])	
	
		};
		if( (in[\key] == nextSceneKey) && ( in[\val] == 1.0 )) {
			e[\scene] = (e[\scene] + 1).min(n);
			postln("Scene is "++e[\scene])
		};	
	});
	
	disp
},
desc: "makes a virtual scene system for the source",
name: "paged",
type: "creator"
)
