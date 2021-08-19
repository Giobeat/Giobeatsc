/* ******************************* // ******************************* */
// BITVOX, any even number of speakers up to 8
/* ******************************* // ******************************* */
// Construct a Cactus Composiitonal Framework
Cactus.new(Document.current.dir);

/*
// open config file to define ins/outs
Document.open(Document.current.dir ++ "/config.scd");
*/
/* ******************************* // ***************************** * */
// DEFINE CUES
/* ******************************* // ******************************* */
(
a.at[\cp].put(1,
	CueInfo(
		cueTitle: "drone that fades out",
		largeDisplayInfo: "20''",
		function: {
			a.at[\proxy_st][0].fadeTime = 8;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig, amp = 0.7;
				sig = PlayBuf.ar(2, bufnum: a.buf("drones/beLong_drone01"),
					rate: 1, trigger:1, loop: 0) * amp;
			};
			// shows approx. duration of cue
			a.at[\cpLine].create(duration: 20, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(2,
	CueInfo(
		cueTitle: "drone that filters out",
		largeDisplayInfo: "22''",
		function: {
			a.at[\proxy_st][0].fadeTime = 8;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig, amp = 1;
				sig = PlayBuf.ar(2, bufnum: a.buf("drones/beLong_drone02_FilterOut"),
					rate: 1, trigger:1, loop: 0) * amp;
			};
			a.at[\cpLine].create(duration: 22, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(3,
	CueInfo(
		cueTitle: "looping lower drone + sinetones",
		largeDisplayInfo: "12''",
		function: {
			a.at[\proxy_st][0].fadeTime = 8;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig, amp = 1.1;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLong_drone03_low_6sec"),
					rate: 1, lag: 0.1) * amp;
			};

			// sinetones
			Pdef(\sinHit).fadeTime = 0;
			Pdef(\sinHit, Pbind(\instrument, \fsin_Hit,
				\note, 69-12,
				\numTrigs, 40,
				\out, a.at[\sideBack][0],
				\pos, Prand([-1, 1], inf),
				\dec, 0.5,
				\amp, 0.5,
				\dur, Prand([0.33, 0.34], inf)
			)).play(a.at[\cp].clock, quant:[0]);

			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(4,
	CueInfo(
		cueTitle: "looping drone octave higher",
		largeDisplayInfo: "8''",
		function: {

			// replace lower drone with another but similar
			a.at[\proxy_st][0].fadeTime = 0;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig, amp = 0.9;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveDown_small"),
					rate: 1, lag: 0.1) * amp;
			};

			// add a drone one octave higher
			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\sideBack] );
			a.at[\proxy_st][1].source = { var sig,
				amp = 0.5;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveUp_small"),
					rate: 1, lag: 0.1,amp: amp);
			};

			Pdef(\sinHit).clear; // stop sinetones

			a.at[\cpLine].create(duration: 8, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(5,
	CueInfo(
		cueTitle: "transpose drone 1T upwards + add sines",
		largeDisplayInfo: "27''",
		function: {

			a.at[\proxy_st][0].fadeTime = 7;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig, amp = 1;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveDown_small"),
					rate:  1.12, lag: 0.5) * amp;
			};

			a.at[\proxy_st][1].fadeTime = 7;
			a.at[\proxy_st][1].playN( a.at[\sideBack] );
			a.at[\proxy_st][1].source = { var sig, amp = 0.5;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveUp_small"),
					rate: 1.12,
					lag: 0.5,amp: amp);
			};

			// sinetones
			Pdef(\sinHit).fadeTime = 12;

			Pdef(\sinHit, Pbind(\instrument, \fsin_Hit,
				\note, 69+12,
				\numTrigs, 40,
				\out, a.at[\sideBack][0],
				\pos, Prand([-1, 1], inf),
				\dec, 0.3,
				\amp, 0.15,
				\dur, Prand([0.33, 0.34], inf)
			)).play(a.at[\cp].clock, quant:[0]);

			// fade out sinetones
			{
				Pdef(\sinHit,
					Pbind(\instrument, \fsin_Hit, \amp, 0)).play(a.at[\cp].clock,quant:[0]);
			}.defer(8);

			a.at[\cpLine].create(duration: 27, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(6,
	CueInfo(
		cueTitle: "ringing physical model",
		largeDisplayInfo: "<1''",
		function: {

			Pdef(\sinHit).clear; // clear previous playing pattern

			a.at[\proxy_st][0].fadeTime = 0.1;
			a.at[\proxy_st][0].source = {  };

			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\side] );
			a.at[\proxy_st][1].source = { var sig, amp;
				amp = 4;
				sig = PlayBuf.ar(1, bufnum: a.buf("physical_models/beLongDrone_PhysMod"),
					rate: [1], trigger:1, loop: 0) * amp;
				sig = FreeVerb.ar(in: sig,mix: 0.5,room: 0.5,damp: 0.5);
				Pan2.ar(sig, pos: LFDNoise0.kr(5, 0.7))
			};
			a.at[\cpLine].create(duration: 0.8, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(7,
	CueInfo(
		cueTitle: "looping heavy drone",
		largeDisplayInfo: "8''",
		function: {

			// play sample
			{ var sig, pan;
				sig = PlayBuf.ar(numChannels: 1,bufnum: a.buf("chunks/BeLong-000"),
					doneAction:2) * Line.ar(1,0,9);
				pan = Pan2.ar(sig, LFDNoise1.kr(3, 0.5));
				Out.ar( a.at[\side][0], pan * 0.8)
			}.play;

			// add bass
			a.at[\proxy_st][0].fadeTime = 0;
			a.at[\proxy_st][0].playN( a.at[\sideBack] );
			a.at[\proxy_st][0].source = { var sig,
				amp = 0.5;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveDown_small"),
					rate: 1,lag: 0.1,amp: amp);
			};

			// simile to cue1
			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\front] );
			a.at[\proxy_st][1].source = { var sig,
				amp = 0.8;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/BeLong-000_DroneHiFreqs")
					,rate: 1, lag: 0.1,amp: amp);
			};
			a.at[\cpLine].create(duration: 9, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(8,
	CueInfo(
		cueTitle: "RT pitch-shifter/transition",
		largeDisplayInfo: "<1''",
		function: {

			a.at[\proxy_st][0].fadeTime = 0.1;
			a.at[\proxy_st][0].source = { };

			a.at[\proxy_st][2].fadeTime = 0;
			a.at[\proxy_st][2].playN( a.at[\front] );
			a.at[\proxy_st][2].source = { var sig, amp;
				amp = 1;
				sig = PlayBuf.ar(1, bufnum: a.buf("physical_models/beLongDrone_PhysMod"),
					rate: [1.19, 1.5], trigger:1, loop: 0) * amp;
				Pan2.ar(sig, pos: LFDNoise0.kr(5, 0.7))
			};

			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\rear] );
			a.at[\proxy_st][1].source =
			{ var sig;
				sig = TGrainSF02.ar(chans: 2,
					buf: a.buf("chunks/BeLong-000"),
					density: 30,
					rate: [ 1, 2 ],
					bufLo: 0.1, bufHi: 0.2,
					durLo: 0.15, durHi: 0.2,
					ampLo: 0.3, ampHi: 0.6,
					attack: 0, release: 2, gate: 1,
					posLo: -0.7,posHi: 0.7,
					gain: 0.3);
				sig = HPF.ar(sig, 80 )
			};

			// RealTime(RT) pitch-shifter
			a.at[\proxy_st][3].fadeTime = 1;
			a.at[\proxy_st][3].playN( a.at[\side] );
			a.at[\proxy_st][3].source = { var sig, amp;
				amp = 1.3;
				sig  = PitchShift.ar(in: SoundIn.ar( a.at[\in] ) ,
					windowSize: 0.1,
					pitchRatio: [0.5, 0.66],
					pitchDispersion: 0,
					timeDispersion: 0);
				sig = HPF.ar(sig * amp, 80);
			};
			a.at[\cpLine].create(duration: 0.8, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(9,
	CueInfo(
		cueTitle: "RT distortion",
		largeDisplayInfo: "11''",
		function: {

			{ var sig, pan;
				sig = PlayBuf.ar(numChannels: 1,bufnum: a.buf("chunks/BeLong-003"),
					rate: 1, doneAction:2) * Line.ar(1,0, 8);
				pan = Pan2.ar(sig, LFDNoise1.kr(3, 0.5));
				sig = HPF.ar(sig, 55);
				Out.ar( a.at[\sideBack][0], pan * 0.7)
			}.play;

			// RT distortion
			a.at[\proxy_st][4].fadeTime = 0;
			a.at[\proxy_st][4].playN( a.at[\front] );
			a.at[\proxy_st][4].source = { CrossoverDistortion.ar(
				SoundIn.ar( a.at[\in]), 0.05,  0.8).dup
			};

			{a.at[\proxy_st][4].release(5)}.defer(0.5); // clear distortion on vox

			a.at[\cpLine].create(duration: 11, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(10,
	CueInfo(
		cueTitle: "RT pitch-shifter",
		largeDisplayInfo: "8''",
		function: {

			// bass with clicks
			a.at[\proxy_st][0].fadeTime = 9;
			a.at[\proxy_st][0].playN( a.at[\rear] );
			a.at[\proxy_st][0].source = { var sig, trig, position, amp, buf;
				amp = 0.5;
				q = 8;
				buf = a.buf("drones/beLongDrone_OctaveDown_small");
				trig = Impulse.kr(q);
				position = TRand.kr(lo:0, hi:BufDur.kr(buf)*44100, trig:trig);
				sig = PlayBuf.ar(2, buf, 1, trig, position, 1 ) * amp;
				sig = HPF.ar(sig, 40)
			};

			// RT pitch-shifter
			a.at[\proxy_st][3].fadeTime = 1;
			a.at[\proxy_st][3].playN( a.at[\side] );
			a.at[\proxy_st][3].source = { var sig, amp;
				amp = 1.3;
				sig  = PitchShift.ar(in: SoundIn.ar( a.at[\in] ) ,
					windowSize: 0.1,
					pitchRatio: [0.5, 0.75],
					pitchDispersion: 0,
					timeDispersion: 0);
				sig = HPF.ar(sig * amp, 80);
			};
			a.at[\cpLine].create(duration: 8, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(11,
	CueInfo(
		cueTitle: "play sample",
		largeDisplayInfo: "9''",
		function: {

			a.at[\proxy_st][1].fadeTime = 5;
			a.at[\proxy_st][1].playN( a.at[\sideBack] );
			a.at[\proxy_st][1].source = { var sig,
				amp = 0.6;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/phys_mod_str_HiPitch")
					,rate: 1, lag: 0.1,amp: amp);
			};

			// silence RT pitch-shifter
			a.at[\proxy_st][3].fadeTime = 1;
			a.at[\proxy_st][3].playN( a.at[\side] );
			a.at[\proxy_st][3].source = { };

			// play sample
			{ var sig, pan;
				sig = PlayBuf.ar(numChannels: 1,bufnum: a.buf("chunks/BeLong-001"), rate: 0.5,
					doneAction:2) * Line.ar(1,0, 3);
				pan = Pan2.ar(sig, LFDNoise1.kr(3, 0.5));
				sig = HPF.ar(sig, 55);
				Out.ar( a.at[\front][0], pan * 0.7)
			}.play;
			a.at[\cpLine].create(duration: 9, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(12,
	CueInfo(
		cueTitle: "RT pitch-shifter + drone",
		largeDisplayInfo: "9''",
		function: {

			// RT pitch-shifter
			a.at[\proxy_st][3].fadeTime = 1;
			a.at[\proxy_st][3].playN( a.at[\side] );
			a.at[\proxy_st][3].source = { var sig, amp;
				amp = 3;
				sig  = PitchShift.ar(in: SoundIn.ar( a.at[\in] ) ,
					windowSize: 0.1,
					pitchRatio: [0.5, 0.75],
					pitchDispersion: 0,
					timeDispersion: 0);
				sig = HPF.ar(sig * amp, 60);
			};

			// drone with delay
			a.at[\proxy_st][0].fadeTime = 4;
			a.at[\proxy_st][0].playN( a.at[\front] );
			a.at[\proxy_st][0].source = { var sig,
				amp = 0.6;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLong_drone03_normal") ,
					rate: 1,lag: 0.1,amp: amp);
				sig = AllpassC.ar(in: sig,
					maxdelaytime: 0.4,
					delaytime: TExpRand.ar(2e-4, 0.4, Dust.ar( 0.5 )).round([2e-3, 4e-3]),
					decaytime: 1);
				sig = HPF.ar(sig, 20)
			};

			// clicky grains
			a.at[\proxy_st][1].fadeTime = 4;
			a.at[\proxy_st][1].playN( a.at[\rear] );
			a.at[\proxy_st][1].source = {
				TGrainSFRandImpulse.ar(chans: 2,
					buf: a.buf("chunks/kr-002"),
					density: 10,
					durLo: 0.1,
					durHi: 0.1,
					rateLo: 1,
					rateHi: 1,
					posLo: -1,
					posHi: 1,
					posFreq: 1,
					gain: 0.5,
					attack: 2 )[0]};

			a.at[\cpLine].create(duration: 9, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(13,
	CueInfo(
		cueTitle: "release pitch-shifter",
		largeDisplayInfo: "16''",
		function: {
			// RT pitch-shifter
			a.at[\proxy_st][3].fadeTime = 1;
			a.at[\proxy_st][3].playN( a.at[\side] );
			a.at[\proxy_st][3].source = { var sig, amp;
				amp = 1;
				sig  = PitchShift.ar(in: SoundIn.ar( a.at[\in] ) ,
					windowSize: 0.1,
					pitchRatio: [0.5, 0.75],
					pitchDispersion: 0,
					timeDispersion: 0);
				sig = HPF.ar(sig * amp, 60);
			};

			{ a.at[\proxy_st][3].release(5)}.defer(1); // release pitch-shifter

			a.at[\cpLine].create(duration: 16, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(14,
	CueInfo(
		cueTitle: "granulated breaths with delay",
		largeDisplayInfo: "10''",
		function: {

			a.at[\proxy_st][2].fadeTime = 9;
			a.at[\proxy_st][2].playN( a.at[\sideBack] );
			a.at[\proxy_st][2].source = { var sig;
				sig = TGrainSFRandImpulse.ar(chans: 2,
					buf: a.buf("chunks/breaths-006"),
					density: TRand.kr(1,8, Dust.kr(1)),
					durLo: 0.01,
					durHi: 0.15,
					rateLo: 1,
					rateHi: 1.2,
					posLo: -1,
					posHi: 1,
					posFreq: 1,
					gain: 0.7,
					attack: 2 )[0];
				sig = AllpassC.ar(in: sig,
					maxdelaytime: 0.4,
					delaytime: TExpRand.ar(2e-4, 0.4, Dust.ar( 1 )).round([2e-3, 4e-3]),
					decaytime: 1.5);
				sig = HPF.ar(sig, 500)
			};

			a.at[\cpLine].create(duration: 10, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(15,
	CueInfo(
		cueTitle: "RT grains w/ var.delay",
		largeDisplayInfo: "17''",
		function: {

			a.at[\proxy_st][2].fadeTime = 1;
			a.at[\proxy_st][2].playN( a.at[\front] );
			a.at[\proxy_st][2].source = {
				var grains, trig, timer, rBufDur, pos, amp, pan,
				rate, dur, gain, density, alwaysProcess, sig;

				alwaysProcess = 1;
				rate = LFDNoise1.kr(3, 3, 4);
				gain = 1;
				dur = LFDNoise1.kr(4, 0.1, 0.15); // 0.2
				density = LFDNoise1.kr(4, 4, 5); // 9

				RecordBuf.ar(HPF.ar(SoundIn.ar( a.at[\in] ), 30),
					bufnum: a.at[\bufForRTGrains], loop: alwaysProcess);

				rBufDur = BufDur.kr(a.at[\bufForRTGrains]).reciprocal;
				timer = Sweep.ar(Impulse.ar(rBufDur), rBufDur);

				trig = Impulse.kr(density);
				pos = TRand.kr(timer -0.1, timer, trig);
				amp = TRand.kr(0.7, 0.9, trig);
				pan = TRand.kr(-0.7, 0.7, trig);

				grains = TGrains.ar(2, trig,
					a.at[\bufForRTGrains], rate, pos, dur, pan, amp) * gain;

				sig = AllpassC.ar(in: grains,
					maxdelaytime: 0.4,
					delaytime: TExpRand.ar(2e-4, 0.4, Dust.ar( 1 )).round([2e-3, 4e-3]),
					decaytime: 1.5);
				sig = HPF.ar(sig, 50)
			};
			a.at[\cpLine].create(duration: 17, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(16,
	CueInfo(
		cueTitle: "RT granular gesture",
		largeDisplayInfo: "8''",
		function: {

			a.at[\proxy_st][2].fadeTime = 1;
			a.at[\proxy_st][2].playN( a.at[\front] );
			a.at[\proxy_st][2].source = {
				var grains, trig, timer, rBufDur, pos, amp, pan,
				rate, dur, gain, density, alwaysProcess, sig;

				alwaysProcess = 1;
				rate = Line.kr(1, 7, 8);
				gain = Line.kr(1, 1.3, 8);
				dur = Line.kr(0.5, 0.01, 8);
				density = Line.kr(5, 50, 8);

				RecordBuf.ar(HPF.ar(SoundIn.ar( a.at[\in] ), 30),
					bufnum: a.at[\bufForRTGrains], loop: alwaysProcess);

				rBufDur = BufDur.kr(a.at[\bufForRTGrains]).reciprocal;
				timer = Sweep.ar(Impulse.ar(rBufDur), rBufDur);

				trig = Impulse.kr(density);
				pos = TRand.kr(timer -0.1, timer, trig);
				amp = TRand.kr(0.7, 0.9, trig);
				pan = TRand.kr(-0.7, 0.7, trig);

				grains = TGrains.ar(2, trig,
					a.at[\bufForRTGrains], rate, pos, dur, pan, amp) * gain;

				sig = AllpassC.ar(in: grains,
					maxdelaytime: 0.4,
					delaytime: TExpRand.ar(2e-4, 0.4,
						Dust.ar( Line.kr(1, 30, 8)  )).round([2e-3, 4e-3]),
					decaytime: 1.5);
				sig = HPF.ar(sig, 50);
			};

			// play sample
			{ var sig, pan;
				sig = PlayBuf.ar(numChannels: 1,bufnum: a.buf("chunks/BeLong-001"), rate: 0.5,
					doneAction:2) * Line.ar(1,0, 3);
				pan = Pan2.ar(sig, LFDNoise1.kr(3, 0.5));
				sig = HPF.ar(sig, 55);
				Out.ar( a.at[\sideBack][0], pan * 0.7)
			}.play;

			a.at[\cpLine].create(duration: 8, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(17,
	CueInfo(
		cueTitle: "16 RT granulators",
		largeDisplayInfo: "29''",
		function: {

			a.at[\proxy_st][2].source = { };
			for(10, 25, {arg i;
				if(i == 10 || i == 11, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 12 || i == 13, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 14 || i == 15, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 16 || i == 17, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				if(i == 18 || i == 19, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 20 || i == 21, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 22 || i == 23, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 24 || i == 25, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				a.at[\proxy_st][i].source = {
					var grains, trig, timer, rBufDur, pos, amp, pan, rate,
					dur, gain, density, alwaysProcess, sig;
					gain = 0.4;
					alwaysProcess = 1;
					rate = 0.25 + 2.75.rand;
					dur = 0.1 + 0.8.rand;
					density = 5 + 15.rand;

					RecordBuf.ar(SoundIn.ar( a.at[\in] ),
						bufnum: a.at[\bufForRTGrains], loop: alwaysProcess);

					rBufDur = BufDur.kr(a.at[\bufForRTGrains]).reciprocal;
					timer = Sweep.ar(Impulse.ar(rBufDur), rBufDur);
					trig = Impulse.kr(density);
					pos = TRand.kr(timer -0.1, timer, trig);
					amp = TRand.kr(0.7, 0.9, trig);
					pan = TRand.kr(-0.7, 0.7, trig);
					grains = TGrains.ar(2, trig, a.at[\bufForRTGrains],
						rate, pos, dur, pan, amp) * gain;
					grains = HPF.ar(grains, 30);
				};
			});
			a.at[\cpLine].create(duration: 29, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(18,
	CueInfo(
		cueTitle: "physical models",
		largeDisplayInfo: "5''",
		function: {
			{ var sig1, sig2, sig3, sig4, amp = 1.3, decay = 6;
				sig1 = PlayBuf.ar(1, bufnum: a.buf("physical_models/bvr_phys_mod_002"),
					rate: 1, loop: 0);
				sig1 = CombL.ar(in: sig1 ,maxdelaytime: 0.3, delaytime: 0.3, decaytime: decay);

				sig2 = PlayBuf.ar(1, bufnum: a.buf("physical_models/bvr_phys_mod_003"),
					rate: 1, loop: 0);
				sig2 = CombL.ar(in: sig2 ,maxdelaytime: 0.4, delaytime: 0.4, decaytime: decay);

				sig3 = PlayBuf.ar(1, bufnum: a.buf("physical_models/bvr_phys_mod_005"),
					rate: 1, loop: 0);
				sig3 = CombL.ar(in: sig3 ,maxdelaytime: 0.2, delaytime: 0.2, decaytime: decay);

				sig4 = PlayBuf.ar(1, bufnum: a.buf("physical_models/bvr_phys_mod_004"),
					rate: 1, loop: 0);
				sig4 = CombL.ar(in: sig4 ,maxdelaytime: 0.5, delaytime: 0.5, decaytime: decay);

				Line.kr(1,0, 6, doneAction:2);
				Out.ar(a.at[\front][0], LeakDC.ar([sig1, sig2] * amp));
				Out.ar(a.at[\sideBack][0], LeakDC.ar([sig3, sig4] * amp));
			}.play;

			a.at[\proxy_st][0].release(1); // release drone

			a.at[\proxy_st][1].release(0); // release clicky grains

			a.at[\cpLine].create(duration: 5, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(19,
	CueInfo(
		cueTitle: "RT concatenative",
		largeDisplayInfo: "20''",
		function: {

			// release RT granulators
			for(10, 25, {arg i; a.at[\proxy_st][i].release(1)});

			a.at[\proxy_multi][0].fadeTime = 1;
			a.at[\proxy_multi][0].playN( (0..a.at[\numOfChans]-1) );
			a.at[\proxy_multi][0].source = {
				var matchlength, freeze, concat, control, input;
				var chain1, onset1, chooseSpeaker, verb;

				matchlength = 0.15;
				freeze=0;

				control= SoundIn.ar( a.at[\in] );
				input = PlayBuf.ar(1,
					a.buf("gestures/EA_gestures"),
					BufRateScale.kr( a.buf("gestures/EA_gestures") ),
					rate: 1,loop:1);

				chain1 = FFT(LocalBuf(512, 2), control);
				onset1 = Onsets.kr(chain1, 0.3, \rcomplex);
				chooseSpeaker = TRand.kr(lo: 0, hi: a.at[\numOfChans],trig: onset1 );

				concat= Concat2.ar(
					control: control,
					source: input,
					storesize: 8,
					seektime: 8,
					seekdur: 2,
					matchlength: matchlength,
					freezestore: freeze,
					zcr: 1,
					lms: 0.5,
					sc: 0.5,
					st: 0.5);

				verb = FreeVerb.ar(in:concat ,mix: 0.2 ,room: 0.7,damp: 0.9);
				Out.ar(0, PanAzEasy.ar(numChans: a.at[\numOfChans] ,in: verb,
					out: chooseSpeaker))
			};
			a.at[\cpLine].create(duration: 20, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(20,
	CueInfo(
		cueTitle: "RT concat. + 16 granulators",
		largeDisplayInfo: "6''",
		function: {
			for(10, 25, {arg i;
				if(i == 10 || i == 11, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 12 || i == 13, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 14 || i == 15, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 16 || i == 17, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				if(i == 18 || i == 19, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 20 || i == 21, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 22 || i == 23, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 24 || i == 25, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				a.at[\proxy_st][i].source = {
					var grains, trig, timer, rBufDur, pos, amp, pan, rate,
					dur, gain, density, alwaysProcess, sig;
					gain = 0.4;
					alwaysProcess = 1;
					rate = 0.25 + 2.75.rand;
					dur = 0.1 + 0.8.rand;
					density = 5 + 15.rand;

					RecordBuf.ar(SoundIn.ar( a.at[\in] ),
						bufnum: a.at[\bufForRTGrains], loop: alwaysProcess);

					rBufDur = BufDur.kr(a.at[\bufForRTGrains]).reciprocal;
					timer = Sweep.ar(Impulse.ar(rBufDur), rBufDur);
					trig = Impulse.kr(density);
					pos = TRand.kr(timer -0.1, timer, trig);
					amp = TRand.kr(0.7, 0.9, trig);
					pan = TRand.kr(-0.7, 0.7, trig);
					grains = TGrains.ar(2, trig, a.at[\bufForRTGrains], rate,
						pos, dur, pan, amp) * gain;
					grains = HPF.ar(grains, 30);
				};
			});

			// delay w/ reverb
			a.at[\proxy_st][5].fadeTime = 4;
			a.at[\proxy_st][5].playN( a.at[\sideBack] );
			a.at[\proxy_st][5].source = { var in, sig;
				in = HPF.ar(SoundIn.ar( a.at[\in]), 50) ;
				sig = AllpassC.ar(in: in,
					maxdelaytime: 0.4,
					delaytime: LFDNoise1.kr(10, 0.1, 0.15),
					decaytime: 10);
				sig = FreeVerb.ar(sig,mix: 0.5 ,room: 0.8);
				Pan2.ar(sig, LFDNoise1.kr(5));
			};
			a.at[\cpLine].create(duration: 6, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(21,
	CueInfo(
		cueTitle: "sinetones X:concat/granul.",
		largeDisplayInfo: "12''",
		function: {

			// stop concat
			a.at[\proxy_multi][0].release(3);

			// release RT granulators
			for(10, 25, {arg i; a.at[\proxy_st][i].release(4)});

			// rhythmic tones
			Pdef(\sinHit).fadeTime = 0;
			Pdef(\sinHit, Pbind(\instrument, \fsin_Hit,
				\note, 57,
				\numTrigs, 16,
				\out, a.at[\side][0],
				\pos, Prand([-1, 1], inf),
				\dec, 0.3,
				\amp, 0.3,
				\dur, Prand([0.33, 0.34], inf)
			)).play(a.at[\cp].clock, quant:[0]);

			// sustained tones
			a.at[\proxy_st][3].fadeTime = 0;
			a.at[\proxy_st][3].playN( a.at[\rear] );
			a.at[\proxy_st][3].source = { var sin1, sig1, sin2, sig2,  amp = 0.1;
				sin1 =  FSinOsc.ar(freq: 57.midicps,  mul: 0.05).tanh;
				sig1 = sin1 + (LPF.ar(Impulse.ar(0, mul: 1), 1000) * 0.4);
				sig1 = HPF.ar(in: sig1, freq: 20)  * amp;
				sig1 = Clip.ar(in:sig1, lo:-1,hi:1);
				sin2 =  FSinOsc.ar(freq: 45.midicps,  mul: 0.05).tanh;
				sig2 = sin2 + (LPF.ar(Impulse.ar(0, mul: 1), 1000) * 0.4);
				sig2 = HPF.ar(in: sig2, freq: 20)  * amp;
				sig2 = Clip.ar(in:sig2, lo:-1,hi:1);
				[sig1, sig2];
			};
			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(22,
	CueInfo(
		cueTitle: "looping drone ",
		largeDisplayInfo: "7''", // simile to cue4
		function: {
			a.at[\proxy_st][5].release(6); // slowly release delay with reverb

			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\sideBack] );
			a.at[\proxy_st][1].source = { var sig, amp = 0.35;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveUp_small"),
					rate: 1, lag: 0.1,amp: amp);
			};
			a.at[\cpLine].create(duration: 7, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(23,
	CueInfo(
		cueTitle: "BBCutting + sinetones",
		largeDisplayInfo: "13''",
		function: {
			// sinetones
			Pdef(\sinHit, Pbind(\instrument, \fsin_Hit,
				\note, 69+12,
				\numTrigs, 40,
				\out, a.at[\side][0],
				\pos, Prand([-1, 1], inf),
				\dec, 0.3,
				\amp, 0.115,
				\dur, Prand([0.33, 0.34], inf)
			)).play(a.at[\cp].clock, quant:[0]);

			// drone
			a.at[\proxy_st][0].fadeTime = 0;
			a.at[\proxy_st][0].playN( a.at[\rear] );
			a.at[\proxy_st][0].source = { var sig,
				amp = 0.25;
				sig = PlayCFnaive.ar(chans: 2 ,buf: a.buf("drones/beLongDrone_OctaveDown_small"),
					rate: 1, lag: 0.1) * amp;
			};

			a.at[\bbcut] = BBCut2(
				cutgroups: CutGroup(
					[CutStream1(
						inbus: s.options.numOutputBusChannels + a.at[\in], // input-bus to be cut-up
						bbcutbuf: a.at[\bufForBBCut], // an empty buffer
						dutycycle: 0.5,
						atkprop: 0.001, // attack proportion
						relprop: 0.5, // release proportion
						curve: -4), // env curve
					CutMod1( // ring modulation
						modamount: {[0,0.5,0.8].wchoose([0.25,0.5,0.25])},
						modfreq: {200+800.rand},
						mamult: 1,
						mfmult: {[1.06, 2, 4, 8].wchoose([0.6,0.1,0.1,0.1])}),
					// CutComb1({0.05 + 0.01.rand}, {0.1 + 0.4.rand}), // comb filter
					// CutRev1({ 0.5.rand }, 0.2), // reverb
					CutMixer(a.at[\front][0], 1, 1, CutPan1(nil, 0.2)) // rand panning
					]
				),
				proc: MultiProc.new(
					[ WarpCutProc1.new(
						blocksizefunc: {[1,2,4].wchoose([0.6,0.3,0.1])},
						//returns next block size
						rollfunc: {[8,16,32].choose},
						// returns num of cuts to subdivide a block in a roll
						probs: [0.2,0.4,0.4],
						// array of 3 probabilities (simple, roll, accelerandoVSdecelerando)
						phraselength: a.at[\cp].tempo,
						// next length of phrase in beats
						accel: {0.5+(0.4.rand)},
						// acceleration rate
						bpsd: {[0.5,1,2,4].choose}
						// beats per sub-division
					),
					BBCutProc11.new ], {[0,1].wchoose([0.7,0.3])});
			).play(a.at[\cp].clock);

			a.at[\bbcut].amp = 1.3; // amplitude

			a.at[\cpLine].create(duration: 13, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(24,
	CueInfo(
		cueTitle: "RT distortion+concat X:BBC",
		largeDisplayInfo: "7''",
		function: {
			a.at[\bbcut].stop; // stop BreakBeatCutting

			{ var sig, pan;
				sig = PlayBuf.ar(numChannels: 1,bufnum: a.buf("chunks/BeLong-001"), rate: 0.5,
					doneAction:2) * Line.ar(1,0, 6);
				pan = Pan2.ar(sig, LFDNoise1.kr(3, 0.5));
				sig = HPF.ar(sig, 55);
				Out.ar( a.at[\side][0], pan * 0.7)
			}.play;

			// RT distortion
			a.at[\proxy_st][4].fadeTime = 0;
			a.at[\proxy_st][4].playN( a.at[\front] );
			a.at[\proxy_st][4].source = { CrossoverDistortion.ar(
				SoundIn.ar( a.at[\in]), 0.05,  0.8).dup  };

			{a.at[\proxy_st][4].release(8)}.defer(0.5); // clear distortion on vox

			// RT Concatenative
			{a.at[\proxy_multi][0].playN( (0..a.at[\numOfChans]-1) );
				a.at[\proxy_multi][0].source = {
					var matchlength, freeze, concat, control, input;
					var chain1, onset1, chooseSpeaker, verb;

					matchlength = 0.15;
					freeze=0;

					control= SoundIn.ar( a.at[\in] );

					chain1 = FFT(LocalBuf(512, 2), control);
					onset1 = Onsets.kr(chain1, 0.3, \rcomplex);
					chooseSpeaker = TRand.kr(lo: 0, hi: a.at[\numOfChans]-1,trig: onset1 );

					input = PlayBuf.ar(1,
						a.buf("gestures/EA_gestures"),
						BufRateScale.kr( a.buf("gestures/EA_gestures") ),
						rate: TRand.kr(lo: 1.0, hi: 3.0,trig: onset1 ),
						loop:1);

					concat= Concat2.ar(
						control: control,
						source: input,
						storesize: 8,
						seektime: 8,
						seekdur: 2,
						matchlength: matchlength,
						freezestore: freeze,
						zcr: 1,
						lms: 0.5,
						sc: 0.5,
						st: 0.5);

					verb = FreeVerb.ar(in:concat ,mix: 0.2 ,room: 0.7,damp: 0.9);
					Out.ar(0, PanAzEasy.ar(numChans: a.at[\numOfChans] ,in: verb,
						out: chooseSpeaker))
			};}.defer(1);

			a.at[\cpLine].create(duration: 7, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(25,
	CueInfo(
		cueTitle: "clicks X:concat.",
		largeDisplayInfo: "7''",
		function: {
			a.at[\proxy_multi][0].source = { }; // silence RT Concatenative

			// clicks
			a.at[\proxy_st][1].fadeTime = 0;
			a.at[\proxy_st][1].playN( a.at[\sideBack] );
			a.at[\proxy_st][1].source =
			{ var sig;
				sig = TGrainSF02.ar(chans: 2,
					buf: a.buf("chunks/kr-002"),
					density: 10,
					rate: [ 1 ],
					bufLo: 0.1, bufHi: 0.2,
					durLo: 0.15, durHi: 0.2,
					ampLo: 0.3, ampHi: 0.6,
					attack: 0, release: 2, gate: 1,
					posLo: -0.7,posHi: 0.7,
					gain: 0.2);
				sig = HPF.ar(sig, 80 )
			};

			a.at[\cpLine].create(duration: 7, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(26,
	CueInfo(
		cueTitle: "BreakBeatCutting w/ CombFilter",
		largeDisplayInfo: "12''",
		function: {
			a.at[\proxy_st][1].release(0.1); // release clicks

			a.at[\bbcut] = BBCut2(
				cutgroups: CutGroup(
					[CutStream1(
						inbus: s.options.numOutputBusChannels + a.at[\in],
						bbcutbuf: a.at[\bufForBBCut],
						dutycycle: 0.5,
						atkprop: 0.001,
						relprop: 0.5,
						curve: -4),
					CutMod1(
						modamount: {[0,0.5,0.8].wchoose([0.25,0.5,0.25])},
						modfreq: {200+800.rand},
						mamult: 1,
						mfmult: {[1.06, 2, 4, 8].wchoose([0.6,0.1,0.1,0.1])}),
					CutComb1({0.05 + 0.01.rand}, {0.1 + 0.4.rand}),
					// CutRev1({ 0.5.rand }, 0.2),
					CutMixer(a.at[\front][0], 1, 1, CutPan1(nil, 0.2))
					]
				),
				proc: MultiProc.new(
					[ WarpCutProc1.new(
						blocksizefunc: {[1,2,4].wchoose([0.6,0.3,0.1])},
						rollfunc: {[8,16,32].choose},
						probs: [0.2,0.4,0.4],
						phraselength: a.at[\cp].tempo,
						accel: {0.5+(0.4.rand)},
						bpsd: {[0.5,1,2,4].choose}
					),
					BBCutProc11.new ], {[0,1].wchoose([0.7,0.3])});
			).play(a.at[\cp].clock);

			a.at[\bbcut].amp = 1.3; // amplitude

			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(27,
	CueInfo(
		cueTitle: "BreakBeatCutting w/ Reverb",
		largeDisplayInfo: "12''",
		function: {
			a.at[\bbcut].stop;

			a.at[\bbcut] = BBCut2(
				cutgroups: CutGroup(
					[CutStream1(
						inbus: s.options.numOutputBusChannels + a.at[\in],
						bbcutbuf: a.at[\bufForBBCut],
						dutycycle: 0.5,
						atkprop: 0.001,
						relprop: 0.5,
						curve: -4),
					CutMod1(
						modamount: {[0,0.5,0.8].wchoose([0.25,0.5,0.25])},
						modfreq: {200+800.rand},
						mamult: 1,
						mfmult: {[1.06, 2, 4, 8].wchoose([0.6,0.1,0.1,0.1])}),
					CutComb1({0.05 + 0.01.rand}, {0.1 + 0.4.rand}),
					CutRev1({ 0.6.rand }, 0.2),
					CutMixer(a.at[\front][0], 1, 1, CutPan1(nil, 0.2))
					]
				),
				proc: MultiProc.new(
					[ WarpCutProc1.new(
						blocksizefunc: {[1,2,4].wchoose([0.6,0.3,0.1])},
						rollfunc: {[8,16,32].choose},
						probs: [0.2,0.4,0.4],
						phraselength: a.at[\cp].tempo,
						accel: {0.5+(0.4.rand)},
						bpsd: {[0.5,1,2,4].choose}
					),
					BBCutProc11.new ], {[0,1].wchoose([0.7,0.3])});
			).play(a.at[\cp].clock);

			a.at[\bbcut].amp = 1.3;

			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(28,
	CueInfo(
		cueTitle: "+ RT concatenative",
		largeDisplayInfo: "12''",
		function: {
			// RT Concatenative
			a.at[\proxy_multi][0].fadeTime = 12;
			a.at[\proxy_multi][0].playN( (0..a.at[\numOfChans]-1) );
			a.at[\proxy_multi][0].source = {
				var matchlength, freeze, concat, control, input;
				var chain1, onset1, chooseSpeaker, verb;

				matchlength = 0.15;
				freeze=0;

				control= SoundIn.ar( a.at[\in] );

				chain1 = FFT(LocalBuf(512, 2), control);
				onset1 = Onsets.kr(chain1, 0.3, \rcomplex);
				chooseSpeaker = TRand.kr(lo: 0, hi: a.at[\numOfChans]-1,trig: onset1 );

				input = PlayBuf.ar(1,
					a.buf("gestures/EA_gestures"),
					BufRateScale.kr( a.buf("gestures/EA_gestures") ),
					rate: TRand.kr(lo: 0.75, hi: 1.5,trig: onset1 ),
					loop:1);

				concat= Concat2.ar(
					control: control,
					source: input,
					storesize: 8,
					seektime: 8,
					seekdur: 2,
					matchlength: matchlength,
					freezestore: freeze,
					zcr: 1,
					lms: 0.5,
					sc: 0.5,
					st: 0.5);

				verb = FreeVerb.ar(in:concat ,mix: 0.2 ,room: 0.7,damp: 0.9);
				Out.ar(0, PanAzEasy.ar(numChans: a.at[\numOfChans] ,in: verb,
					out: chooseSpeaker))
			};
			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(29,
	CueInfo(
		cueTitle: "+ RT distortion",
		largeDisplayInfo: "12''",
		function: {
			a.at[\proxy_st][4].fadeTime = 12;
			a.at[\proxy_st][4].playN( a.at[\side] );
			a.at[\proxy_st][4].source = { CrossoverDistortion.ar(
				SoundIn.ar( a.at[\in]), 0.05,  0.8).dup };

			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(30,
	CueInfo(
		cueTitle: "+ RT granulators",
		largeDisplayInfo: "10''",
		function: {
			for(10, 25, {arg i; a.at[\proxy_st][i].fadeTime = 12});
			for(10, 25, {arg i;

				if(i == 10 || i == 11, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 12 || i == 13, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 14 || i == 15, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 16 || i == 17, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				if(i == 18 || i == 19, { a.at[\proxy_st][i].playN( a.at[\front] ); } );
				if(i == 20 || i == 21, { a.at[\proxy_st][i].playN( a.at[\side] ); } );
				if(i == 22 || i == 23, { a.at[\proxy_st][i].playN( a.at[\sideBack] ); } );
				if(i == 24 || i == 25, { a.at[\proxy_st][i].playN( a.at[\rear] ); } );

				a.at[\proxy_st][i].source = {
					var grains, trig, timer, rBufDur, pos, amp, pan, rate, dur, gain,
					density, alwaysProcess, sig;
					gain = 0.4;
					alwaysProcess = 1;

					rate = 0.25 + 2.75.rand;
					dur = 0.1 + 0.8.rand;
					density = 5 + 15.rand;

					RecordBuf.ar(SoundIn.ar( a.at[\in] ),
						bufnum: a.at[\bufForRTGrains], loop: alwaysProcess);

					rBufDur = BufDur.kr(a.at[\bufForRTGrains]).reciprocal;
					timer = Sweep.ar(Impulse.ar(rBufDur), rBufDur);
					trig = Impulse.kr(density);
					pos = TRand.kr(timer -0.1, timer, trig);
					amp = TRand.kr(0.7, 0.9, trig);
					pan = TRand.kr(-0.7, 0.7, trig);
					grains = TGrains.ar(2, trig, a.at[\bufForRTGrains], rate, pos, dur, pan, amp) * gain;
					grains = HPF.ar(grains, 30);
				};
			});
			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);

			a.at[\cpLine].create(duration: 10, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(31,
	CueInfo(
		cueTitle: "release",
		largeDisplayInfo: "12''",
		function: {
			a.at[\proxy_st][4].release(0.1); // stop distortion on vox

			a.at[\proxy_multi][0].release(1); // stop concatenative on vox

			a.at[\bbcut].stop; // stop bbcut on vox

			a.at[\proxy_st][0].release(0.1); // release drone

			Pdef(\sinHit).stop; //  stop sinetones

			// delay w/ reverb
			a.at[\proxy_st][5].fadeTime = 0.5;
			a.at[\proxy_st][5].playN( a.at[\sideBack] );
			a.at[\proxy_st][5].source = {
				var in, sig;
				in = HPF.ar(SoundIn.ar( a.at[\in]), 50) ;
				sig = AllpassC.ar(in: in,
					maxdelaytime: 0.4,
					delaytime: LFDNoise1.kr(5, 0.1, 0.11),
					decaytime: 10);
				sig = FreeVerb.ar(sig,mix: 0.5 ,room: 0.8);
				Pan2.ar(sig, LFDNoise1.kr(2),0.5);
			};

			{a.at[\proxy_st][5].release(5);}.defer(8);

			a.at[\cpLine].create(duration: 12, color: Color.red, width: 20);
}));
/* ******************************* // ******************************* */
a.at[\cp].put(32,
	CueInfo(
		largeDisplayInfo: "silence",
		function: {
			for(10, 25, {arg i; a.at[\proxy_st][i].release(0.1)}); // release RT granulators

			a.at[\proxy_st][3].release(0.1); // release tones
}));
/* ******************************* // ******************************* */
/* ****************************** * // ******************************* */
)
/*
Speakers: Left,Right,SideL,SideR,SideBackL,SideBackR,RearL,RearR
RT: processing takes place in Real-Time
X: denotes that the process stops

BitVox uses the following externals:

Cactus: compositional framework
CuePlayer: organises and executes cues

PlayCFnaive: plays a soundfile in loop with crossfade
TGrainSF02: granulation of sampled sound with randomised parameters
TGrainsSFRandImpulse: granulation of sampled sound

BBCut: break beat cutting
CrossoverDistortion: b/ab power amp distortion simulation
Concat2: Concatenative cross-synthesis on live streams

Note: The BeatBoxer may prepare & record a 45sec dense electroacoustic improvisation
prior to the performance. The prepared soundfile should be labeled "EA_gestures"
and placed inside the folder "buffers/gestures/" by replacing the file which is
already  there. Concatenative synthesis uses the audiofile "EA_gestures"
as the source for cross-synthesis in real-time with the microphone input.
*/      