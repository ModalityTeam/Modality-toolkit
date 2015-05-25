// TESTS FOR MKtlDesc ///

/***************

TODO TODO TODO - cleanup pact items

// * fully test support for new format of assocArrays in desc files

// * this osc controller creates a weird name:
MKtlDesc.at(\srcp3141731416127001).idInfo;

******************************************/

/******* typical user interface code: **********/

// check if already there by filename;
// if not there, make it from file.
MKtlDesc("nanoPAD2"); 	// name can be string or symbol
MKtlDesc('nanoPAD2') === MKtlDesc('nanoPAD2'); // get same desc by name
MKtlDesc("nanoKEY2") === MKtlDesc("nanoKEY2") // name can also
MKtlDesc("nano*");		// warns if multiple files match

// this lists all files in readable form
MKtlDesc.postLoadable;
// check which ones are already loaded
MKtlDesc.postLoaded;

MKtlDesc('nanoPAD2').openFile;		// open its descFile


// explicitly make the one you need by filename
// i.e. force a reload from file if it was loaded already
x = MKtlDesc.fromFileName("nanoKEY2");


/******************************************/

// instvars and basic method tests:
x.dump;
x.fullDesc 		// the desc dict as from file
x.idInfo		// the name with which the system regoisters it
x.name			// its name == filename
x.protocol		// the protocol(s) it uses
x.elementsDesc	// the description of all the elements
				// in a hierarchical dict/array

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
MKtlDesc.fromFileName("nanoKEY2");
MKtlDesc.fromFileName("nano*");


/******************************************/
// CLASS METHOD TESTs:
MKtlDesc.folderName.cs		// how its folder should be named
MKtlDesc.defaultFolder.cs	// the one that comes with modality
MKtlDesc.fileExt.cs			// the file extension for desc files
MKtlDesc.allDescs;			// all currently loaded descs

MKtlDesc.addFolder("~/Desktop/").cs; // add your own
// if there is no folder there, it posts how to make it:
File.mkdir("~/Desktop/".standardizePath);

MKtlDesc.loadDescs(folderIndex: 0);
MKtlDesc.openFolder
MKtlDesc.writeCache;
(MKtlDesc.defaultFolder +/+ MKtlDesc.cacheName).openDocument;

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
MKtlDesc.idInfoFor("ShermanFB2");
MKtlDesc.filenameFor("Steinberg CMC-FD");

// file filenames of desc files:
MKtlDesc.findFile("nanoKEY2");			// single
MKtlDesc.findFile("nano*").cs;			// matching
MKtlDesc.findFile("Stein*").cs;
MKtlDesc.findFile(postFound: true); ""; // this lists all files

MKtlDesc.isValidDescDict((idInfo: \yoho, description: []));

// how we get \msgTypesUsed:
MKtlDesc('nanoKEY2').getMidiMsgTypes;
MKtlDesc('nanoKEY2').fullDesc[\msgTypesUsed];
MKtlDesc('nanoKEY2').fullDesc[\elementsWithNoType];

