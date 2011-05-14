
( // defining the quarks path:
~myquark = Quarks(
	reposPath: "",
	localPath: Document.current.dir +/+ "quarks"
);
);

// install from GUI:
~myquark.gui;

// install from code:
~myquark.install( "Modality" )

