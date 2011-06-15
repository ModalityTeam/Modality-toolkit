// =====================================================================
// Sketch for I/O specs
// =====================================================================


\io: \inout
\io: \in
\io: \out

// case where it is both input and output
(\inout: (\chan: 0, \ccNum: 89))
// just in
(\in: (\chan: 0, \ccNum: 89))
// just out
(\out: (\chan: 0, \ccNum: 89))
// input and output, with same CC but different channel
(\in: (\chan: 0), \out: (\chan: 1), \ccNum: 89 )
// input and output, with different CC but same channel
(\in: (\ccNum:1), \out: (\ccNum: 21), \chan: 0 )
// input and output: with different CC and different channel
(\in: (\chan: 0, \ccNum:1), \out: (\chan: 1, \ccNum: 21) )


//( msg: (in: "/data/in/1", out: "/data/out/1" ) )
//( cc: (in: 1, out: 1) )
//( cc: (in: 1), note: (out: 1) )

//\cc1_ ( cc: 1,  io: \inout )
MKtlElement( )
