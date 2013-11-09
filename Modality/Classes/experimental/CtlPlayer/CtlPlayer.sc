CtlPlayer {
    classvar <all;

    var <key;
    var <synthproxy;
    var <>parameters;
    var <>defaultMap;

    // var <currentSynthArgs;
    var <synthArgs;

    // var <bufferBank;

    var <ctLoop;
    // var <ctlFuncs;

    *initClass{
        all = IdentityDictionary.new;
    }

    *new { | key, source |
		// key may be simply a symbol
		var res, server, dict;

        res = all.at(key);
		if(res.isNil) {
            res = super.new.init(key);
			all.put(key, res);
		};

		source !? { res.synthproxy.source = source };
		^res;
	}

    defaultInit{
        synthproxy = NodeProxy.new;
        // ctlFuncs = IdentityDictionary.new;
        // defaultMap.put( \default, [] );
    }

    init{ |name|
        this.defaultInit;
        key = name;
        ctLoop = CtLoop( key );
        parameters = IdentityDictionary.new;
        defaultMap = IdentityDictionary.new;
        synthArgs = IdentityDictionary.new;
    }

    // bufferBank_{ |bank|
    // bufferBank = bank;
// }

    // functions take as argument the input parameters, and the calculated parameters (so parameters can depend on each other).
    addParameter{ |name,func|
        parameters.put( name, func );
    }

    addDefault{ |name,func|
        parameters.put( name, func );
        defaultMap.put( \default, defaultMap.at( \default ) ++ name );
    }

    addMap{ |inname,parnames|
        defaultMap.put( inname, parnames );
    }

    getSynthArgs{ |inpars, parmap|
        // var synthArgs = IdentityDictionary.new;
        if ( parmap.isNil ){ parmap = () };
        if ( inpars.notNil ){
            inpars.do{ |it| // inpars should be array of [\name,val] arrays
                if ( parmap[ it[0] ].notNil ){
                    parmap[ it[0] ].do{ |jt| // parmap is a dictionary of input parameter -> [ output parameters ]
                        synthArgs.put(
                            jt,
                            parameters.at( jt ).value( it[1], synthArgs )
                        );
                    };
                }{ // use default map
                    defaultMap[ it[0] ].do{ |jt| // parmap is a dictionary of input parameter -> [ output parameters ]
                        synthArgs.put(
                            jt,
                            parameters.at( jt ).value( it[1], synthArgs )
                        );
                    };
                };
            };
        };
        defaultMap[ \default ].do{ |jt| synthArgs.put( jt, parameters.at( jt ).value( 0, synthArgs ) ) };
        // currentSynthArgs = synthArgs;
        ^synthArgs.asKeyValuePairs.clump(2);
    }

    /*
    getSingleSynthArg{ |inpar, parmap|
        // var synthArgs = IdentityDictionary.new;
        if ( parmap[ inpar[0] ].notNil ){
            parmap[ inpar[0] ].do{ |jt| // parmap is a dictionary of input parameter -> [ output parameters ]
                synthArgs.put(
                    jt,
                    parameters.at( jt ).value( inpar[1], synthArgs )
                );
            };
        }{ // use default map
            defaultMap[ inpar[0] ].do{ |jt| // parmap is a dictionary of input parameter -> [ output parameters ]
                synthArgs.put(
                    jt,
                    parameters.at( jt ).value( inpar[1], synthArgs )
                );
            };
        };
        defaultMap[ \default ].do{ |jt| synthArgs.put( jt, parameters.at( jt ).value( 0, synthArgs ) ) };
        // currentSynthArgs = synthArgs;
        ^synthArgs.asKeyValuePairs.clump(2);
    }
    */

    addCtl{ |key|
        ctLoop.ctlMap.put( key, { |value|
            this.set( *(this.getSynthArgs( [ [key,value] ] ).flatten;) )
            // this.set( *(this.getSingleSynthArg( [key,value], () ).flatten.postln;) )
        } );
        /*
        ctlFuncs.add( key -> { |value|
            var synthArg;
            ctLoop.recordEvent( key, value );
            // this.set( *(this.getSingleSynthArg( [key,value], () ) ).unbubble );
            this.getSingleSynthArg( [key,value], () );
            };
        );
        */
    }

    setCtl{ |key,value|
        var synthArgs;
        ctLoop.recordEvent( key, value );
        if ( ctLoop.isRecording ){
            synthArgs = this.getSynthArgs( [ [ key, value] ] );
            this.set( *(synthArgs.flatten) );
        };
        // ctlFuncs.at( key ).value( value ).postln;
    }

    setCtls{ |...args|
        var synthArgs;
        args.clump(2).do{ |it|
            ctLoop.recordEvent( it[0], it[1] );
        };
        if ( ctLoop.isRecording ){
            synthArgs = this.getSynthArgs( args.clump(2) );
            this.set( *(synthArgs.flatten) );
        };
    }

    ctlRec{
        ctLoop.stop;
        fork{
            0.01.wait;
            ctLoop.startRec;
        }
    }

    toggleRec{
        if ( ctLoop.isRecording ){
            this.ctlStopRec;
        }{
            this.ctlRec;
        }
    }

    ctlStopRec{
        ctLoop.stopRec;
        fork{
            0.01.wait;
            ctLoop.play;
        }
    }

    play{ |chan=0|
        var synthArgs = this.getSynthArgs().flatten;
        // if ( bufferBank.notNil ){
        // synthArgs = synthArgs.add( [\bufnum, bufferBank.getBuffer( bufselect ) ] );
    // };
        this.set( *synthArgs );
        synthproxy.play(chan);
        if ( ctLoop.isRecording.not ){ ctLoop.play; };
    }

    stop{
        synthproxy.stop;
    }

    set{ |...args|
        synthproxy.set( *args );
    }

    release{ |time=1|
        synthproxy.stop( time );
    }

    *newFrom{ |newkey, key|
        var ctlPlayer, ctlPlayerModel;
        if ( key.isKindOf( CtlPlayer ) ){
            ctlPlayerModel = key;
        }{
            ctlPlayerModel = all.at( key );
        };
        ^CtlPlayer.new( newkey ).copyFrom( ctlPlayerModel );
    }

    copyFrom{ |otherPlayer|
        synthproxy.source = otherPlayer.synthproxy.source.copy;
        ctLoop.list_( otherPlayer.ctLoop.list.copy );
        otherPlayer.ctLoop.ctlMap.keys.do{ |k|
            this.addCtl( k );
        };
        // ctLoop.ctlMap_( otherPlayer.ctLoop.ctlMap.copy );
        parameters = otherPlayer.parameters.copy;
        defaultMap = otherPlayer.defaultMap.copy;
        synthArgs = otherPlayer.synthArgs.copy;
    }

    save{ |newkey, filename, openDoc=true, saveCtl=false|
        var file, fullPath, ctlString;
        if ( newkey.isNil ){ newkey = key };
        if ( filename.isNil ){ filename = (newkey ++ "_" ++ Date.localtime.stamp ++ "_ctlplayer.scd" ) };
        file = File.open( filename, "w" );
        if ( file.isOpen ){
            newkey = newkey.asSymbol;
            ctlString = "CtlPlayer.new(" ++ newkey.asCompileString ++ ")";
            file.write( "CtlPlayer.new(" ++ newkey.asCompileString ++ ", " ++ synthproxy.source.asCompileString ++ " );\n" );
            file.write( ctlString ++ ".defaultMap = " ++ defaultMap.asCompileString  ++ ";\n");
            file.write( ctlString ++ ".parameters = " ++ parameters.asCompileString  ++ ";\n");
            file.write( ctlString );
            ctLoop.ctlMap.keys.do{ |k|
                file.write( ".addCtl( " ++ k.asCompileString ++ ")" );
            };
            file.write( ";\n" );
            // file.write( ctlString ++ ".ctLoop.ctlMap_( " ++ ctLoop.ctlMap.asCompileString  ++ " );\n");
            if ( saveCtl ){
                file.write( ctlString ++ ".ctLoop.list_( " ++ ctLoop.list.asCompileString  ++ " );\n");
            };
            file.write( ctlString ++ ";\n" );
            file.close;
            "saved to file %\n".postf( filename );
            if ( openDoc ){
                fullPath = File.realpath( filename );
                fullPath.openDocument;
            };
        }{
            "could not open file % for writing\n".postf( filename );
        };
    }

    *load{ |filename|
        var file,ctlPlayer;
        ^ctlPlayer = filename.load;
    }

    /*
    initFromFile{ |file|
        this.defaultInit;
        key = file.getLine();
        synthproxy.source = file.getLine().interpret;
        defaultMap = file.getLine().interpret;
        parameters = file.getLine( 2048 ).interpret;
        ctLoop = CtLoop( key );
        ctLoop.list_( file.getLine( 1048 * 64 ).interpret );
        synthArgs = IdentityDictionary.new;
        all.put( key, this );
    }
    */

    storeOn { | stream |
		this.printOn(stream);
	}
	printOn { | stream |
		stream << this.class.name << "(" <<< this.key << ")"
	}
}