// TESTS FOR MKtlDesc ///

/***************

TODO TODO TODO - cleanup pact items


m = MKtlDesc("korg-nanokontrol2");	// only single file

// * fully test support for new format of assocArrays in desc files

******************************************/

/******* typical user interface code: **********/

// check if already there by filename;
// if not there, make it from file.
MKtlDesc("korg-nanopad2"); 	// name can be string or symbol
MKtlDesc('korg-nanopad2') === MKtlDesc('korg-nanopad2'); // get same desc by name
MKtlDesc("korg-nanopad2") === MKtlDesc("korg-nanopad2") // name can also
MKtlDesc("korg-nano*");		// warns if multiple files match

m.fullDesc.postcs;"";



// this lists all files in readable form
MKtlDesc.postLoadable;
// check which ones are already loaded
MKtlDesc.postLoaded;

MKtlDesc('korg-nanopad2').openFile;		// open its descFile


// explicitly make the one you need by filename
// i.e. force a reload from file if it was loaded already
x = MKtlDesc.fromFileName("korg-nanokey2");


/******************************************/

// instvars and basic method tests:
x.dump;
x.fullDesc 		// the desc dict as from file
x.idInfo		// the name with which the system regoisters it
x.name			// its name == filename
x.protocol		// the protocol(s) it uses
x.elementsDesc	// the description of all the elements
				// in a hierarchical dict/array
x.elementsAssocArray // same descs in a flat Array of associations

// more information in the top level of the full description:
x.fullDesc.keys;
x.fullDesc.idInfo;			// the name by which the hardware device
							//// registers in the system
x.fullDesc.protocol;		// the protocol(s) the device uses
x.fullDesc.description;		// the hierarchical description of all elements

							// specific for midi devices:
x.fullDesc.msgTypesUsed;	// cc, noteOn etc, so we can make resps
x.fullDesc.elementsWithNoType; // should be empty
x.fullDesc.filename;		// the filename
x.fullDesc.path;			// and the full path it was loaded from.



/******************************************/

// some more ways to make MKtlDescs
// according to current definition,
// \idInfo, \protocol, \description are required in a desc dict, so
d = (idInfo: \yoho, description: [], filename: "yoho", protocol: \osc)
MKtlDesc.fromDict(d);
MKtlDesc.fromPath(MKtlDesc.findFile.choose);
MKtlDesc.fromFileName("korg-nanokey2");

MKtlDesc.fromFileName("*nano*");  // matches multiple, loads first
MKtlDesc.fromFileName("*nano*", multi: true); // loads multiple
MKtlDesc("sny*"); // single matching returns just that


/******************************************/
// CLASS METHOD TESTs:
MKtlDesc.folderName.cs		// how its folder should be named
MKtlDesc.defaultFolder.cs	// the one that comes with modality
MKtlDesc.fileExt.cs			// the file extension for desc files
MKtlDesc.allDescs;			// all currently loaded descs

MKtlDesc.addFolder("~/Desktop/").cs; // add your own
// if there is no folder there, it posts how to make it, e.g.:
-> File.mkdir("/Users/adc/Desktop/MKtlDescriptions");


MKtlDesc.loadDescs(folderIndex: 0);
MKtlDesc.openFolder
MKtlDesc.writeCache;
(MKtlDesc.defaultFolder +/+ MKtlDesc.cacheName).openDocument;

MKtlDesc.postLoadable;

MKtlDesc.findFile(postFound: true); ""; // this lists all files
MKtlDesc.findFile("*", postFound: true); ""; // all = matching "*"
MKtlDesc.findFile("n*", postFound: true); ""; // all beginning with "n"
MKtlDesc.findFile("*y*", postFound: true); ""; // all files with a "y"
MKtlDesc.findFile("*osc*", postFound: true); ""; // all files with a "y"

MKtlDesc.descFolders.cs;
MKtlDesc.openFolder(0);		// open them by index
MKtlDesc.openFolder(1);

MKtlDesc.loadDescs; // loads all descs from all folders
MKtlDesc.loadDescs("Steinberg*", 0); // match specific filename and folderIndex

/******************************************/
// internal method tests

// lookupDict for filename/idInfo:
MKtlDesc.fileToIDDict;
MKtlDesc.writeCache;
MKtlDesc.loadCache;
MKtlDesc.idInfoForFilename("ShermanFB2");
MKtlDesc.filenameForIDInfo("Steinberg CMC-FD");

// file filenames of desc files:
MKtlDesc.findFile("*nop*");		// single
MKtlDesc.findFile("korg*").cs.postln;"";			// matching
MKtlDesc.findFile("stein*").cs;"";
MKtlDesc.findFile(postFound: true); ""; // this lists all files

MKtlDesc.isValidDescDict((idInfo: \yoho, description: []));

// how we get \msgTypesUsed:
MKtlDesc('korg-nanokey2').getMidiMsgTypes;
MKtlDesc('korg-nanokey2').fullDesc[\msgTypesUsed];
MKtlDesc('korg-nanokey2').fullDesc[\elementsWithNoType];

