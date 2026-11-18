    function targMap = targDataMap(),

    ;%***********************
    ;% Create Parameter Map *
    ;%***********************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 1;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc paramMap
        ;%
        paramMap.nSections           = nTotSects;
        paramMap.sectIdxOffset       = sectIdxOffset;
            paramMap.sections(nTotSects) = dumSection; %prealloc
        paramMap.nTotData            = -1;

        ;%
        ;% Auto data (rtP)
        ;%
            section.nData     = 51;
            section.data(51)  = dumData; %prealloc

                    ;% rtP._AccelEndTime2f2SeriesHybridTransmission_sldd_
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP._AccelStartTime2f2SeriesHybridTransmission_sldd_
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtP._AirDensity2f2SeriesHybridTransmission_sldd_
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 2;

                    ;% rtP._BatteryResistance2f2SeriesHybridTransmission_sldd_
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 3;

                    ;% rtP._BatteryVoltage2f2SeriesHybridTransmission_sldd_
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 4;

                    ;% rtP._CommandAcceleration2f2SeriesHybridTransmission_sldd_
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 5;

                    ;% rtP._DCBusVoltage2f2SeriesHybridTransmission_sldd_
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 6;

                    ;% rtP._DecelEndTime2f2SeriesHybridTransmission_sldd_
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 7;

                    ;% rtP._DecelStartTime2f2SeriesHybridTransmission_sldd_
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 8;

                    ;% rtP._EngineInertia2f2SeriesHybridTransmission_sldd_
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 9;

                    ;% rtP._EngineSpeedCorrection2f2SeriesHybridTransmission_sldd_
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 10;

                    ;% rtP._EngineTimeConstant2f2SeriesHybridTransmission_sldd_
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 11;

                    ;% rtP._GeneratorEfficiency2f2SeriesHybridTransmission_sldd_
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 12;

                    ;% rtP._GeneratorTimeConstant2f2SeriesHybridTransmission_sldd_
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 13;

                    ;% rtP._GeneratorTorqueDemand2f2SeriesHybridTransmission_sldd_
                    section.data(15).logicalSrcIdx = 14;
                    section.data(15).dtTransOffset = 14;

                    ;% rtP._MotorEfficiency2f2SeriesHybridTransmission_sldd_
                    section.data(16).logicalSrcIdx = 15;
                    section.data(16).dtTransOffset = 15;

                    ;% rtP._MotorSpeedKi2f2SeriesHybridTransmission_sldd_
                    section.data(17).logicalSrcIdx = 16;
                    section.data(17).dtTransOffset = 16;

                    ;% rtP._MotorSpeedKp2f2SeriesHybridTransmission_sldd_
                    section.data(18).logicalSrcIdx = 17;
                    section.data(18).dtTransOffset = 17;

                    ;% rtP._VehicleDragCoeff2f2SeriesHybridTransmission_sldd_
                    section.data(19).logicalSrcIdx = 18;
                    section.data(19).dtTransOffset = 18;

                    ;% rtP._VehicleFrontalArea2f2SeriesHybridTransmission_sldd_
                    section.data(20).logicalSrcIdx = 19;
                    section.data(20).dtTransOffset = 19;

                    ;% rtP.rpm0
                    section.data(21).logicalSrcIdx = 20;
                    section.data(21).dtTransOffset = 20;

                    ;% rtP.v0
                    section.data(22).logicalSrcIdx = 21;
                    section.data(22).dtTransOffset = 21;

                    ;% rtP.wheel_radius
                    section.data(23).logicalSrcIdx = 22;
                    section.data(23).dtTransOffset = 22;

                    ;% rtP.Sensordynamics_A
                    section.data(24).logicalSrcIdx = 23;
                    section.data(24).dtTransOffset = 23;

                    ;% rtP.Sensordynamics_C
                    section.data(25).logicalSrcIdx = 24;
                    section.data(25).dtTransOffset = 24;

                    ;% rtP.Kp_Gain
                    section.data(26).logicalSrcIdx = 25;
                    section.data(26).dtTransOffset = 25;

                    ;% rtP.u1_UpperSat
                    section.data(27).logicalSrcIdx = 26;
                    section.data(27).dtTransOffset = 26;

                    ;% rtP.u1_LowerSat
                    section.data(28).logicalSrcIdx = 27;
                    section.data(28).dtTransOffset = 27;

                    ;% rtP.Limits4040_IC
                    section.data(29).logicalSrcIdx = 28;
                    section.data(29).dtTransOffset = 28;

                    ;% rtP.Limits4040_UpperSat
                    section.data(30).logicalSrcIdx = 29;
                    section.data(30).dtTransOffset = 29;

                    ;% rtP.Limits4040_LowerSat
                    section.data(31).logicalSrcIdx = 30;
                    section.data(31).dtTransOffset = 30;

                    ;% rtP.u0HzLowpassFilter_A
                    section.data(32).logicalSrcIdx = 31;
                    section.data(32).dtTransOffset = 31;

                    ;% rtP.u0HzLowpassFilter_C
                    section.data(33).logicalSrcIdx = 32;
                    section.data(33).dtTransOffset = 32;

                    ;% rtP.u040_UpperSat
                    section.data(34).logicalSrcIdx = 33;
                    section.data(34).dtTransOffset = 33;

                    ;% rtP.u040_LowerSat
                    section.data(35).logicalSrcIdx = 34;
                    section.data(35).dtTransOffset = 34;

                    ;% rtP.mps2kmh_Gain
                    section.data(36).logicalSrcIdx = 35;
                    section.data(36).dtTransOffset = 35;

                    ;% rtP.Accelerateatt2s_Y0
                    section.data(37).logicalSrcIdx = 36;
                    section.data(37).dtTransOffset = 36;

                    ;% rtP.Accelerateatt2s_YFinal
                    section.data(38).logicalSrcIdx = 37;
                    section.data(38).dtTransOffset = 37;

                    ;% rtP.Stopaccelerationatt7s_Y0
                    section.data(39).logicalSrcIdx = 38;
                    section.data(39).dtTransOffset = 38;

                    ;% rtP.Stopaccelerationatt7s_YFinal
                    section.data(40).logicalSrcIdx = 39;
                    section.data(40).dtTransOffset = 39;

                    ;% rtP.Decelerateatt12s_Y0
                    section.data(41).logicalSrcIdx = 40;
                    section.data(41).dtTransOffset = 40;

                    ;% rtP.Decelerateatt12s_YFinal
                    section.data(42).logicalSrcIdx = 41;
                    section.data(42).dtTransOffset = 41;

                    ;% rtP.Stopdecelerationatt17s_Y0
                    section.data(43).logicalSrcIdx = 42;
                    section.data(43).dtTransOffset = 42;

                    ;% rtP.Stopdecelerationatt17s_YFinal
                    section.data(44).logicalSrcIdx = 43;
                    section.data(44).dtTransOffset = 43;

                    ;% rtP.Integrator_IC
                    section.data(45).logicalSrcIdx = 44;
                    section.data(45).dtTransOffset = 44;

                    ;% rtP.input1_Value
                    section.data(46).logicalSrcIdx = 45;
                    section.data(46).dtTransOffset = 45;

                    ;% rtP.input2_Value
                    section.data(47).logicalSrcIdx = 46;
                    section.data(47).dtTransOffset = 46;

                    ;% rtP.input1_Value_imdncjs2s2
                    section.data(48).logicalSrcIdx = 47;
                    section.data(48).dtTransOffset = 47;

                    ;% rtP.input2_Value_ca3sfw5rnz
                    section.data(49).logicalSrcIdx = 48;
                    section.data(49).dtTransOffset = 48;

                    ;% rtP.input1_Value_ggh4buor1f
                    section.data(50).logicalSrcIdx = 49;
                    section.data(50).dtTransOffset = 49;

                    ;% rtP.input2_Value_ajtyxd4ixo
                    section.data(51).logicalSrcIdx = 50;
                    section.data(51).dtTransOffset = 50;

            nTotData = nTotData + section.nData;
            paramMap.sections(1) = section;
            clear section


            ;%
            ;% Non-auto Data (parameter)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        paramMap.nTotData = nTotData;



    ;%**************************
    ;% Create Block Output Map *
    ;%**************************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 1;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc sigMap
        ;%
        sigMap.nSections           = nTotSects;
        sigMap.sectIdxOffset       = sectIdxOffset;
            sigMap.sections(nTotSects) = dumSection; %prealloc
        sigMap.nTotData            = -1;

        ;%
        ;% Auto data (rtB)
        ;%
            section.nData     = 22;
            section.data(22)  = dumData; %prealloc

                    ;% rtB.mxlggdymth
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtB.gzopggd2h3
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtB.iqjkejjtxl
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 2;

                    ;% rtB.kjwq4q4qoi
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 3;

                    ;% rtB.bbtjf3mpaa
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 4;

                    ;% rtB.eig3b4noss
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 8;

                    ;% rtB.lobuefx021
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 12;

                    ;% rtB.puaiyfntok
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 13;

                    ;% rtB.gdeuysczfp
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 14;

                    ;% rtB.otmbqg5yzs
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 15;

                    ;% rtB.j5d423dshv
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 16;

                    ;% rtB.nzeddfqxfa
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 17;

                    ;% rtB.hi04d2uald
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 18;

                    ;% rtB.ovdfvbuehq
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 19;

                    ;% rtB.nnmpux3se1
                    section.data(15).logicalSrcIdx = 14;
                    section.data(15).dtTransOffset = 20;

                    ;% rtB.acaukxyv3c
                    section.data(16).logicalSrcIdx = 15;
                    section.data(16).dtTransOffset = 24;

                    ;% rtB.k03xt2b02o
                    section.data(17).logicalSrcIdx = 16;
                    section.data(17).dtTransOffset = 25;

                    ;% rtB.p51py0zwam
                    section.data(18).logicalSrcIdx = 17;
                    section.data(18).dtTransOffset = 66;

                    ;% rtB.piw1thaima
                    section.data(19).logicalSrcIdx = 18;
                    section.data(19).dtTransOffset = 75;

                    ;% rtB.cjjifhibam
                    section.data(20).logicalSrcIdx = 19;
                    section.data(20).dtTransOffset = 76;

                    ;% rtB.krgzwqxxc4
                    section.data(21).logicalSrcIdx = 20;
                    section.data(21).dtTransOffset = 77;

                    ;% rtB.a4mgjuzchb
                    section.data(22).logicalSrcIdx = 21;
                    section.data(22).dtTransOffset = 78;

            nTotData = nTotData + section.nData;
            sigMap.sections(1) = section;
            clear section


            ;%
            ;% Non-auto Data (signal)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        sigMap.nTotData = nTotData;



    ;%*******************
    ;% Create DWork Map *
    ;%*******************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 7;
        sectIdxOffset = 1;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc dworkMap
        ;%
        dworkMap.nSections           = nTotSects;
        dworkMap.sectIdxOffset       = sectIdxOffset;
            dworkMap.sections(nTotSects) = dumSection; %prealloc
        dworkMap.nTotData            = -1;

        ;%
        ;% Auto data (rtDW)
        ;%
            section.nData     = 9;
            section.data(9)  = dumData; %prealloc

                    ;% rtDW.cm3yz21kmm
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.dwnluyjp1y
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 2;

                    ;% rtDW.pozeu2skuu
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 4;

                    ;% rtDW.kvhulgmkxg
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 6;

                    ;% rtDW.o5kdmldxnm
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 7;

                    ;% rtDW.ibyrtx3wmn
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 8;

                    ;% rtDW.lxh24ns0v3
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 25;

                    ;% rtDW.ospl1vg2ao
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 26;

                    ;% rtDW.cumjyqtmkz
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 27;

            nTotData = nTotData + section.nData;
            dworkMap.sections(1) = section;
            clear section

            section.nData     = 14;
            section.data(14)  = dumData; %prealloc

                    ;% rtDW.mtl20p1pjf
                    section.data(1).logicalSrcIdx = 9;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.mshwrvwjum
                    section.data(2).logicalSrcIdx = 10;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.ba3wa4xoch
                    section.data(3).logicalSrcIdx = 11;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.hxigt3wu31
                    section.data(4).logicalSrcIdx = 12;
                    section.data(4).dtTransOffset = 3;

                    ;% rtDW.dbcetkdxe1
                    section.data(5).logicalSrcIdx = 13;
                    section.data(5).dtTransOffset = 4;

                    ;% rtDW.e0dwsim2ab
                    section.data(6).logicalSrcIdx = 14;
                    section.data(6).dtTransOffset = 5;

                    ;% rtDW.fi3cjqy0ly
                    section.data(7).logicalSrcIdx = 15;
                    section.data(7).dtTransOffset = 6;

                    ;% rtDW.lbsrijp0kk
                    section.data(8).logicalSrcIdx = 16;
                    section.data(8).dtTransOffset = 7;

                    ;% rtDW.pn4sfv0kpt
                    section.data(9).logicalSrcIdx = 17;
                    section.data(9).dtTransOffset = 8;

                    ;% rtDW.ejajmfuu22
                    section.data(10).logicalSrcIdx = 18;
                    section.data(10).dtTransOffset = 9;

                    ;% rtDW.ddbfa243ff
                    section.data(11).logicalSrcIdx = 19;
                    section.data(11).dtTransOffset = 10;

                    ;% rtDW.jzzidweox5
                    section.data(12).logicalSrcIdx = 20;
                    section.data(12).dtTransOffset = 11;

                    ;% rtDW.bodlhifxqj.AQHandles
                    section.data(13).logicalSrcIdx = 21;
                    section.data(13).dtTransOffset = 12;

                    ;% rtDW.gvjdpirtlp.AQHandles
                    section.data(14).logicalSrcIdx = 22;
                    section.data(14).dtTransOffset = 13;

            nTotData = nTotData + section.nData;
            dworkMap.sections(2) = section;
            clear section

            section.nData     = 2;
            section.data(2)  = dumData; %prealloc

                    ;% rtDW.kkbctdleld
                    section.data(1).logicalSrcIdx = 23;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.bcn1p3foly
                    section.data(2).logicalSrcIdx = 24;
                    section.data(2).dtTransOffset = 1;

            nTotData = nTotData + section.nData;
            dworkMap.sections(3) = section;
            clear section

            section.nData     = 11;
            section.data(11)  = dumData; %prealloc

                    ;% rtDW.nao4oexhpo
                    section.data(1).logicalSrcIdx = 25;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.bvrw4irq2r
                    section.data(2).logicalSrcIdx = 26;
                    section.data(2).dtTransOffset = 12;

                    ;% rtDW.primpwmo4v
                    section.data(3).logicalSrcIdx = 27;
                    section.data(3).dtTransOffset = 13;

                    ;% rtDW.imzgdjkn5o
                    section.data(4).logicalSrcIdx = 28;
                    section.data(4).dtTransOffset = 14;

                    ;% rtDW.plrydhxfue
                    section.data(5).logicalSrcIdx = 29;
                    section.data(5).dtTransOffset = 15;

                    ;% rtDW.dsyjjimhxm
                    section.data(6).logicalSrcIdx = 30;
                    section.data(6).dtTransOffset = 16;

                    ;% rtDW.orssjfag1p
                    section.data(7).logicalSrcIdx = 31;
                    section.data(7).dtTransOffset = 17;

                    ;% rtDW.esquov3qle
                    section.data(8).logicalSrcIdx = 32;
                    section.data(8).dtTransOffset = 18;

                    ;% rtDW.eh3gfeebmo
                    section.data(9).logicalSrcIdx = 33;
                    section.data(9).dtTransOffset = 19;

                    ;% rtDW.fjnrrpwbdk
                    section.data(10).logicalSrcIdx = 34;
                    section.data(10).dtTransOffset = 20;

                    ;% rtDW.gpzjgivblu
                    section.data(11).logicalSrcIdx = 35;
                    section.data(11).dtTransOffset = 21;

            nTotData = nTotData + section.nData;
            dworkMap.sections(4) = section;
            clear section

            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtDW.mifdyfljhg
                    section.data(1).logicalSrcIdx = 36;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            dworkMap.sections(5) = section;
            clear section

            section.nData     = 4;
            section.data(4)  = dumData; %prealloc

                    ;% rtDW.aysmj1fmqf
                    section.data(1).logicalSrcIdx = 37;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.dq3atvr5dh
                    section.data(2).logicalSrcIdx = 38;
                    section.data(2).dtTransOffset = 17;

                    ;% rtDW.ixys421w5u
                    section.data(3).logicalSrcIdx = 39;
                    section.data(3).dtTransOffset = 34;

                    ;% rtDW.bssz4jfejo
                    section.data(4).logicalSrcIdx = 40;
                    section.data(4).dtTransOffset = 35;

            nTotData = nTotData + section.nData;
            dworkMap.sections(6) = section;
            clear section

            section.nData     = 3;
            section.data(3)  = dumData; %prealloc

                    ;% rtDW.g2bcftdtlq
                    section.data(1).logicalSrcIdx = 41;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.ob5s2qr30m
                    section.data(2).logicalSrcIdx = 42;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.iwmksvg23x
                    section.data(3).logicalSrcIdx = 43;
                    section.data(3).dtTransOffset = 2;

            nTotData = nTotData + section.nData;
            dworkMap.sections(7) = section;
            clear section


            ;%
            ;% Non-auto Data (dwork)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        dworkMap.nTotData = nTotData;



    ;%
    ;% Add individual maps to base struct.
    ;%

    targMap.paramMap  = paramMap;
    targMap.signalMap = sigMap;
    targMap.dworkMap  = dworkMap;

    ;%
    ;% Add checksums to base struct.
    ;%


    targMap.checksum0 = 3898635034;
    targMap.checksum1 = 2663004245;
    targMap.checksum2 = 1389757015;
    targMap.checksum3 = 1923455693;

