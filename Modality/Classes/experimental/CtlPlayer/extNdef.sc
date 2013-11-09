+ Ndef {

	*snapshot { |path, onlySettings=false, crossFade=false, server|
		var f;
		var fullpath = path ++ "_" ++ Date.localtime.stamp ++ ".scd";
		if ( server.isNil ){ server = Server.default; };

	//	var fullpath = "/home/nescivi/SuperCollider/test"  ++ Date.localtime.stamp ++ ".scd";
		f = File.new( fullpath, "w+" );
		f.isOpen;
		f.write( "(\n" );
		Ndef.dictFor(server).envir.do{ |it|
			if ( onlySettings ){
				if ( crossFade ){
					f.write( it.asCodeXSettings );
				}{
					f.write( it.asCodeSettings );
				};
			}{
				f.write( it.asCode );
			};
			f.write( "\n" );
		};
		f.write( ");\n" );
		f.close;

		fullpath.openDocument;
	}

	asCodeSettings { | envir |
		var nameStr, srcStr, str, docStr, indexStr, key;
		var space, spaceCS;

		var isAnon, isSingle, isInCurrent, isOnDefault, isMultiline;

		envir = envir ? currentEnvironment;

		nameStr = envir.use { this.asCompileString };
		indexStr = nameStr;

		isAnon = nameStr.beginsWith("a = ");
		isSingle = this.objects.isEmpty or: { this.objects.size == 1 and: { this.objects.indices.first == 0 } };
		isInCurrent = envir.includes(this);
		isOnDefault = server === Server.default;

	//	[\isAnon, isAnon, \isSingle, isSingle, \isInCurrent, isInCurrent, \isOnDefault, isOnDefault].postln;

		docStr = String.streamContents { arg stream;
				// add settings to compile string
			this.nodeMap.storeOn(stream, indexStr, true);

		};

		isMultiline = docStr.drop(-1).includes(Char.nl);
		if (isMultiline) { docStr = "(\n" ++ docStr ++ ");\n" };

		^docStr
	}

	asCodeXSettings { | envir |
		var nameStr, srcStr, str, docStr, indexStr, key;
		var space, spaceCS;

		var isAnon, isSingle, isInCurrent, isOnDefault, isMultiline;

		envir = envir ? currentEnvironment;

		nameStr = envir.use { this.asCompileString };
		indexStr = nameStr;

		isAnon = nameStr.beginsWith("a = ");
		isSingle = this.objects.isEmpty or: { this.objects.size == 1 and: { this.objects.indices.first == 0 } };
		isInCurrent = envir.includes(this);
		isOnDefault = server === Server.default;

	//	[\isAnon, isAnon, \isSingle, isSingle, \isInCurrent, isInCurrent, \isOnDefault, isOnDefault].postln;

		docStr = String.streamContents { arg stream;
				// add settings to compile string
			this.nodeMap.xstoreOn(stream, indexStr, true);

		};

		isMultiline = docStr.drop(-1).includes(Char.nl);
		if (isMultiline) { docStr = "(\n" ++ docStr ++ ");\n" };

		^docStr
	}
}


+ ProxyNodeMap {

	xstoreOn { | stream, namestring = "", dropOut = false |
		var strippedSetArgs, storedSetNArgs, rates, proxyMapKeys, proxyMapNKeys;
		this.updateBundle;
		if(dropOut) {
			forBy(0, setArgs.size - 1, 2, { arg i;
				var item;
				item = setArgs[i];
				if(item !== 'out' and: { item !== 'i_out' })
				{
					strippedSetArgs = strippedSetArgs.add(item);
					strippedSetArgs = strippedSetArgs.add(setArgs[i+1]);
				}
			})
		} { strippedSetArgs = setArgs };
		if(strippedSetArgs.notNil) {
			stream << namestring << ".xset(" <<<* strippedSetArgs << ");" << Char.nl;
		};

		if(mapArgs.notNil or: { mapnArgs.notNil }) {
			settings.keysValuesDo { arg key, setting;
				var proxy;
				if(setting.isMapped) {
					proxy = setting.value;
					if(proxy.notNil) {
						if(setting.isMultiChannel) {
							proxyMapNKeys = proxyMapNKeys.add(key);
							proxyMapNKeys = proxyMapNKeys.add(proxy);
						}{
							proxyMapKeys = proxyMapKeys.add(key);
							proxyMapKeys = proxyMapKeys.add(proxy);
						}
					};
				};
			};
			if(proxyMapKeys.notNil) {
				stream << namestring << ".xmap(" <<<* proxyMapKeys << ");" << Char.nl;
			};
			if(proxyMapNKeys.notNil) {
				stream << namestring << ".xmapn(" <<<* proxyMapNKeys << ");" << Char.nl;
			};
		};

		if(setnArgs.notNil) {
			storedSetNArgs = Array.new;
			settings.keysValuesDo { arg key, setting;
				if(setting.isMapped.not and: setting.isMultiChannel) {
					storedSetNArgs = storedSetNArgs.add(key);
					storedSetNArgs = storedSetNArgs.add(setting.value);
				}
			};
			stream << namestring << ".xsetn(" <<<* storedSetNArgs << ");" << Char.nl;
		};
		settings.keysValuesDo { arg key, setting;
			if(setting.rate.notNil) { rates = rates.add(key); rates = rates.add(setting.rate) };
		};
		if(rates.notNil) {
			stream << namestring << ".setRates(" <<<* rates << ");" << Char.nl;
		}

	}

}
