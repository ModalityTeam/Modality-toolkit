
( // defining the quarks path:
~myquark = Quarks(
	reposPath: "",
	localPath: Document.current.dir
);
);

// install from GUI:
~myquark.gui;

// install from code:
~myquark.install( "Modality" )

// dependencies:

Quarks.updateDirectory;
Quarks.install("FP");
