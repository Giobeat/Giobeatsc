// Granulation with Visual Feedback by Orestis guys, for SC 3.6
// Use your mouse to scrub through the soundfile


(
~inGroup= Group.head(s); // create a group and put it in the head
~tailGroup= Group.tail(s); // create a group for the FX and add it in the end

b = Buffer.alloc(s, s.sampleRate * 8,1);
~bus_Vol_gr1=Bus.control(s); //control bus to write to from slider -granulator1
~bus_Rate_gr1=Bus.control(s); //control bus to write from number box -granulator1

~bus_Vol_gr2=Bus.control(s); //control bus to write to from slider -granulator2
~bus_Rate_gr2=Bus.control(s); //control bus to write from number box -granulator2

~bus_Vol_gr3=Bus.control(s); //control bus to write to from slider -granulator3
~bus_Rate_gr3=Bus.control(s); //control bus to write from number box -granulator3

~bus_Vol_gr4=Bus.control(s); //control bus to write to from slider -granulator4
~bus_Rate_gr4=Bus.control(s); //control bus to write from number box -granulator4

~bus_scatterLo1=Bus.control(s); //control bus to write from number box scatterboxLo1
~bus_scatterHi1=Bus.control(s); //control bus to write from number box scatterboxHi1
~bus_scatterLo2=Bus.control(s); //control bus to write from number box scatterboxLo2
~bus_scatterHi2=Bus.control(s); //control bus to write from number box scatterboxHi2
~bus_scatterLo3=Bus.control(s); //control bus to write from number box scatterboxLo3
~bus_scatterHi3=Bus.control(s); //control bus to write from number box scatterboxHi3
~bus_scatterLo4=Bus.control(s); //control bus to write from number box scatterboxLo4
~bus_scatterHi4=Bus.control(s); //control bus to write from number box scatterboxHi4

~range=7; //specify range for the slider

//  TGrains
SynthDef("grain-in",{arg input=8, output=2, density, bufnum=0, rate=1, pos, dur, pan, amp ,loop=0, recBus=0,
	vol=2.0, tgrains, fadeinT=0.001, gate=1,numerator=6, trandlo= (-0.8), trandhi=0.8;
	var envelope, manipulate, out,send1;

	manipulate = MouseY.kr(4,120,1);
	density = Impulse.kr(manipulate);
	pos = MouseX.kr(0,BufDur.kr(bufnum)) + TRand.kr(-0.005, 0.005, density);
	dur =  (numerator / manipulate);
	amp= TRand.kr(0.3, 0.6, density);
	pan = TRand.kr(trandlo, trandhi, density);
	envelope= Line.kr(0,1,fadeinT) * EnvGen.kr(Env.adsr,gate, doneAction: 2);

	tgrains=TGrains.ar(2, density, bufnum, rate, pos, dur, pan, amp);

	Out.ar(output,tgrains*vol*envelope);
	Out.ar(recBus,tgrains*vol*envelope); //send to bus for recording

	send1 = SendTrig.kr(density, [0,1], [pos,dur]);
	out = Out.kr(10, [pos, dur]);
}).send(s);

//**********************
//construct the window
w = GUI.window.new("visualiserMan", Rect(500, 400, 468, 220));
~file1 = SoundFileView.new(w, Rect(10, 35, 450, 60));

//LOAD BUTTON
~a1=Button.new(w,Rect(10, 3, 120, 25)).font_(Font("Arial", 12));
~a1.states= [["Load a mono sound", Color.black, Color.new255(0, 190, 200)]];

//StaticText(w, Rect(305, 195, 200, 20)).font_(Font("Arial", 11))


~a1.action = { arg view;
	(Dialog.getPaths({arg pathSF; b = Buffer.read(s, pathSF[0]);

		f = SoundFile.new;
		f.openRead(pathSF[0]);
		~file1.soundfile = f;
		~file1.read(0, f.numFrames);
		~file1.gridOn = false;

},{"cancelled".postln;});)};

//PLAY BUTTON
~a2=Button.new(w,Rect(135, 3, 60, 25));
~a2.states= [["Play", Color.black, Color.new255(107, 190, 35)],["Stop", Color.white, Color.new255(0, 50, 35)]];

~a2.action = { arg view;  if (view.value == 1, { ~grainIn=Synth("grain-in",[\output,0,\recBus, ~rec1,\bufnum,b,\vol,0],~inGroup); //granulator1
	~grainIn2=Synth("grain-in",[\output,0,\recBus, ~rec2,\bufnum,b,\vol,0],~inGroup); //granulator2
	~grainIn3=Synth("grain-in",[\output,0,\recBus, ~rec3, \bufnum,b,\vol,0],~inGroup); //granulator3
	~grainIn4=Synth("grain-in",[\output,0,\recBus, ~rec4, \bufnum,b,\vol,0],~inGroup); //granulator4

	SystemClock.sched(0.1,{~grainIn.map(\vol,~bus_Vol_gr1,\rate,~bus_Rate_gr1,\trandlo,~bus_scatterLo1, \trandhi,~bus_scatterHi1); //granulator1
		~grainIn2.map(\vol,~bus_Vol_gr2,\rate,~bus_Rate_gr2,\trandlo,~bus_scatterLo2, \trandhi,~bus_scatterHi2);//granulator2
		~grainIn3.map(\vol,~bus_Vol_gr3,\rate,~bus_Rate_gr3, \trandlo,~bus_scatterLo3, \trandhi,~bus_scatterHi3);//granulator3
		~grainIn4.map(\vol,~bus_Vol_gr4,\rate,~bus_Rate_gr4, \trandlo,~bus_scatterLo4, \trandhi,~bus_scatterHi4);//granulator3
	} ); //map volume to slider + rate to number box-granulator1
}, {~grainIn.free;~grainIn2.free;~grainIn3.free;~grainIn4.free; })};

//RECORD BUTTON
~a3=Button.new(w,Rect(200, 3, 80, 25));
~a3.states= [["Record", Color.black, Color.new255(200, 10, 30)], ["Recording", Color.black, Color.new255(255, 10, 0)]];
~a3.action = { arg view; if (view.value == 1, {~startrecord.value; "Recording ... ".postln;}, {~stoprecord.value; "4 soundfiles constructed in User's folder".postln;}) };

~recText =StaticText(w, Rect(285, 0, 190, 35)).font_(Font("Arial", 9))
.stringColor_(Color.black).string_("Pressing record will create 4 individual soundfiles in the User's folder");

//new(inLeft, inTop, inWidth, inHeight)

// ****************************
//SCATTER NUMBER BOX-Lo1
~scatterBoxLo1 =NumberBox(w, Rect(396, 100, 30, 20)).font_(Font("Arial", 12));
~scatterBoxLo1.value = (-0.8);
~scatterBoxLo1.action = {arg i; ~bus_scatterLo1.value=i.value;};
~bus_scatterLo1.value= (-0.8);

//SCATTER NUMBER BOX-Hi1
~scatterBoxHi1 =NumberBox(w, Rect(428, 100, 30, 20)).font_(Font("Arial", 12));
~scatterBoxHi1.value = 0.8;
~scatterBoxHi1.action = {arg i; ~bus_scatterHi1.value=i.value;};
~bus_scatterHi1.value=0.8;

~scatterTextHi1 = StaticText(w, Rect(305, 195, 200, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" ScatterGranules >  [Lo]  -  [Hi]");

// ****************************
//SCATTER NUMBER BOX-Lo2
~scatterBoxLo2 =NumberBox(w, Rect(396, 125, 30, 20)).font_(Font("Arial", 12));
~scatterBoxLo2.value = (-0.5);
~scatterBoxLo2.action = {arg i; ~bus_scatterLo2.value=i.value;};
~bus_scatterLo2.value= (-0.5);

//SCATTER NUMBER BOX-Hi2
~scatterBoxHi2 =NumberBox(w, Rect(428, 125, 30, 20)).font_(Font("Arial", 12));
~scatterBoxHi2.value = 0.5;
~scatterBoxHi2.action = {arg i; ~bus_scatterHi2.value=i.value;};
~bus_scatterHi2.value=0.5;
// ****************************

//SCATTER NUMBER BOX-Lo3
~scatterBoxLo3 =NumberBox(w, Rect(396, 150, 30, 20)).font_(Font("Arial", 12));
~scatterBoxLo3.value = (-1);
~scatterBoxLo3.action = {arg i; ~bus_scatterLo3.value=i.value;};
~bus_scatterLo3.value= (-1);

//SCATTER NUMBER BOX-Hi3
~scatterBoxHi3 =NumberBox(w, Rect(428, 150, 30, 20)).font_(Font("Arial", 12));
~scatterBoxHi3.value = (-0.1);
~scatterBoxHi3.action = {arg i; ~bus_scatterHi3.value=i.value;};
~bus_scatterHi3.value=(-0.1);
// ****************************

//SCATTER NUMBER BOX-Lo4
~scatterBoxLo4 =NumberBox(w, Rect(396, 175, 30, 20)).font_(Font("Arial", 12));
~scatterBoxLo4.value = (0.1);
~scatterBoxLo4.action = {arg i; ~bus_scatterLo4.value=i.value;};
~bus_scatterLo4.value= (0.1);

//SCATTER NUMBER BOX-Hi4
~scatterBoxHi4 =NumberBox(w, Rect(428, 175, 30, 20)).font_(Font("Arial", 12));
~scatterBoxHi4.value = 1;
~scatterBoxHi4.action = {arg i; ~bus_scatterHi4.value=i.value;};
~bus_scatterHi4.value=1;

// ****************************
//SLIDER_1
~s1=Slider.new(w,Rect(10, 100, 180, 20)) // slider
.action_{arg i; ~bus_Vol_gr1.value=i.value*(~range);	};

~s1Text = StaticText(w, Rect(190, 100, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Volume");

//RATE NUMBER BOX_1
~rateBox =	NumberBox(w, Rect(240, 100, 30, 20)).font_(Font("Arial", 12));
~rateBox.value = 1;
~rateBox.action = {arg i; ~bus_Rate_gr1.value=i.value;};
~bus_Rate_gr1.value=1;

~rateText = StaticText(w, Rect(270, 100, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Rate");

~granText1 = StaticText(w, Rect(295, 100, 100, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" > Granules -1");

// ****************************
//SLIDER_2
~s2=Slider.new(w,Rect(10, 125, 180, 20)) // slider
.action_{arg i; ~bus_Vol_gr2.value=i.value*(~range);	};

~s2Text = StaticText(w, Rect(190, 125, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Volume");

//RATE NUMBER BOX_2
~rateBox2 =NumberBox(w, Rect(240, 125, 30, 20)).font_(Font("Arial", 12));
~rateBox2.value = 0.5;
~rateBox2.action = {arg i; ~bus_Rate_gr2.value=i.value;};
~bus_Rate_gr2.value=0.5;

~rateText2 = StaticText(w, Rect(270, 125, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Rate");

~granText2 = StaticText(w, Rect(295, 125, 100, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" > Granules -2");

// ****************************
//SLIDER_3
~s3=Slider.new(w,Rect(10, 150, 180, 20)) // slider
.action_{arg i; ~bus_Vol_gr3.value=i.value*(~range);	};

~s3Text = StaticText(w, Rect(190, 150, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Volume");

//RATE NUMBER BOX_3
~rateBox3 =NumberBox(w, Rect(240, 150, 30, 20)).font_(Font("Arial", 12));
~rateBox3.value = 4;
~rateBox3.action = {arg i; ~bus_Rate_gr3.value=i.value;};
~bus_Rate_gr3.value=4;

~rateText3 = StaticText(w, Rect(270, 150, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Rate");

~granText3 = StaticText(w, Rect(295, 150, 100, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" > Granules -3");

// ****************************
//SLIDER_4
~s4=Slider.new(w,Rect(10, 175, 180, 20)) // slider
.action_{arg i; ~bus_Vol_gr4.value=i.value*(~range);	};

~s4Text = StaticText(w, Rect(190, 175, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Volume");

//RATE NUMBER BOX_4
~rateBox4 =NumberBox(w, Rect(240, 175, 30, 20)).font_(Font("Arial", 12));
~rateBox4.value = 9;
~rateBox4.action = {arg i; ~bus_Rate_gr4.value=i.value;};
~bus_Rate_gr4.value=9;

~rateText4 = StaticText(w, Rect(270, 175, 50, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" Rate");

~granText4 = StaticText(w, Rect(295, 175, 100, 20)).font_(Font("Arial", 11))
.stringColor_(Color.black).string_(" > Granules -4");

// ******  RECORD to the disk
// *** allocate buffers for recording individual SynthDefs to separate files
~recBuf1=Buffer.alloc(s,65536,2);
~recBuf2=Buffer.alloc(s,65536,2);
~recBuf3=Buffer.alloc(s,65536,2);
~recBuf4=Buffer.alloc(s,65536,2);

//define audio buses in order to send an individual signal to rec
~rec1=Bus.audio(s,2);
~rec2=Bus.audio(s,2);
~rec3=Bus.audio(s,2);
~rec4=Bus.audio(s,2);

(SynthDef("diskout", {arg bufnum, input=0;
	DiskOut.ar(bufnum, In.ar(input,2));
}).send(s));

// ******* function to start recording to individual soundfiles
(~startrecord={
	~recBuf1.write("~/grain1.wav".standardizePath, "wav", "int24", 0,0,true);
	~gr1Rec=Synth("diskout",[\bufnum, ~recBuf1, \input, ~rec1],~tailGroup);
	~recBuf2.write("~/grain2.wav".standardizePath, "wav", "int24", 0,0,true);
	~gr2Rec=Synth("diskout",[\bufnum, ~recBuf2, \input, ~rec2],~tailGroup);
	~recBuf3.write("~/grain3.wav".standardizePath, "wav", "int24", 0,0,true);
	~gr3Rec=Synth("diskout",[\bufnum, ~recBuf3, \input, ~rec3],~tailGroup);
	~recBuf4.write("~/grain4.wav".standardizePath, "wav", "int24", 0,0,true);
	~gr4Rec=Synth("diskout",[\bufnum, ~recBuf4, \input, ~rec4],~tailGroup);
};

// function to stop recording to individual soundfiles
~stoprecord={
	~gr1Rec.free;~recBuf1.close;
	~gr2Rec.free;~recBuf2.close;
	~gr3Rec.free;~recBuf3.close;
	~gr4Rec.free;~recBuf4.close;
});

//**************
w.onClose = { s.freeAll };
w.front;

//the osc responder
~responder = OSCresponderNode(nil,'/tr',{ arg time,responder,msg;
	switch (msg[2],
		0, { { ~file1.setSelectionStart(0,msg[3]*f.sampleRate) }.defer },
		1, { { ~file1.setSelectionSize(0,msg[3]*f.sampleRate) }.defer }
	)
}).add;
)
//~grainIn=Synth("grain-in",[\output,0,\bufnum,b,\vol,4]);
//~grainIn.set(\rate,0.5) // set different pitch