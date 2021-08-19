/*Granulation of Sampled Sounds*/


b = Buffer.read(s,"/Users/RHYTHMANIAC/Desktop/yara/SC/Arturia/arturia1.wav",); // load a mono soundfile into a buffer
// YOU WOULD NEED TO SUBSTITUTE THIS WITH YOUR OWN SOUNDFILE

b.play; // you may audition it

/*=============================================================*/
/*Replication*/

(
SynthDef("granule", {
	arg dur = 0.15, sndbuf, rate = 1, pos = 0 ;
	var trig, panner, grains;

	trig = Impulse.kr(10);	// triggers 10 grains per second
	panner = TRand.kr(-1, 1, trig); // randomly spatialises grains between left & right

	grains = GrainBuf.ar(2, trig, dur, sndbuf, rate, pos, pan: panner); // buffer granulator

	Out.ar(0, grains)
	}).add;
)

/* this guy produces ten 150ms-grains per second using the default envelope; it samples from the begining of harpChunk_m.wav.*/
~simple = Synth("granule", [\sndbuf, b])

~simple.set(\pos, 0.1); // change the position (0 is beginning, 1 is end of soundfile)

~simple.set(\rate, 2); // double the rate

~simple.set(\rate, 0.25); // half the rate

~simple.free;

/*=============================================================*/
/*Changing the envelope*/

(
SynthDef("granule0", {
	arg dur = 0.2, sndbuf, rate = 1, pos = 0.1, envbuf = -1 ;
	var trig, panner, grains;

	trig = Impulse.kr(10);
	panner = TRand.kr(-1, 1, trig);

	grains = GrainBuf.ar(2, trig, dur, sndbuf, rate, pos, pan: panner, envbufnum: envbuf);

	Out.ar(0, grains)
	}).add;
)

~env.plot; // look at it
~env =Env([1, 0], [1], \linear, 1); // build a new envelope

z = Buffer.sendCollection(s, ~env.discretize, 1); // load it into a buffer

~simple0 = Synth("granule0", [\sndbuf, b]);
~simple0.set(\envbuf, z); // replace the envelope

/*=============================================================*/
/*Reordering*/

(
SynthDef("granule2", {
	arg dur = 0.1, sndbuf, rate = 1, density = 10;
	var trig, panner,pos, grains;

	trig = Impulse.kr(density);
	panner = TRand.kr(-1, 1, trig);
	pos = TRand.kr(0, 1, trig); // randomly choose a grain from the soundfile

	grains = GrainBuf.ar(2, trig, dur, sndbuf, rate, pos, pan: panner);

	Out.ar(0, grains)
	}).add;
)

/* this guy produces ten 100ms-grains per second using the default envelope, it samples randomly from harpChunk_m.wav.*/
~simple2 = Synth("granule2", [\sndbuf, b])

~simple2.set(\dur, 0.2); // change the grain duration

~simple2.set(\dur, 0.01); // change the grain duration

~simple2.set(\density, 50); // change the density

~simple2.set(\rate, 50); // increase the rate

~simple2.free;

/*=============================================================*/
/*Merging & Reordering*/

/* reads all soundfiles from a folder and place them in an array*/
// ~bufs = "/Users/Shared/_sounds/*".pathMatch.collect {|file| Buffer.read(s, file);};

~bufs ="/Users/RHYTHMANIAC/Desktop/yara/SC/sc2/*" .pathMatch.collect {|file| Buffer.read(s, file);};
// YOU WOULD NEED TO SUBSTITUTE THIS WITH YOUR OWN PATH

(
SynthDef("granule3", {
	arg dur = 0.15, rate = 1, density = 10;
	var trig, panner, pos, sndbuf, grains;

	trig = Impulse.kr(density);	// triggers 10 grains per second
	panner = TRand.kr(-1, 1, trig); // randomly spatialises grains between left & right
	pos = TRand.kr(0, 1, trig); // randomly chooses a grain from the soundfile
	sndbuf = TChoose.kr( trig , ~bufs); // chooses between different buffers

	grains = GrainBuf.ar(2, trig, dur, sndbuf, rate, pos, pan: panner); // buffer granulator

	Out.ar(0, grains)
	}).add;
)

~simple3 = Synth("granule3");
~simple3.set(\dur, 0.8); // change the grain duration
~simple3.set(\density, 30); // change the density
~simple3.set(\rate, 25); // change the rate
~simple3.free;


/*Playing with the Fill Factor: DENSITY * DURATION*/

~simple3 = Synth("granule3");
~simple3.set(\density, 8, \dur, 0.08, ); // FF = 0.4 -> more than half of the cloud is silence
~simple3.set(\density, 10, \dur, 0.1, ); // FF = 1 -> the cloud is more-or-less filled with grains
~simple3.set(\density, 15, \dur, 0.1, ); // FF = 1.5 -> the cloud is filled with overlapping grains
~simple3.set(\density, 50, \dur, 0.05, ); // FF = 2.5 -> a dense cloud