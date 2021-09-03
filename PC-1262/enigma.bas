' WEHRMACHT ENIGMA I SIMULATOR
' For SHARP PC-126x/1475 by Robert van Engelen

' Recommended reading:
'  https://math.dartmouth.edu/~jvoight/Fa2012-295/EnigmaSimManual.pdf
'  https://en.wikipedia.org/wiki/Enigma_machine

' RUN to execute steps 1 to 5
' Steps 1 to 5 can be selected and reexecuted at any time after RUN:
' DEF-A step 1: select plugboard settings, enter a pair of letters, repeats
' DEF-B step 2: select scramblers, left-to-right, enter three numbers 1 to 5
' DEF-C step 3: specify ring settings, left-to-right, enter three letters
' DEF-D step 4: specify starting position, left-to-right, enter three letters
' DEF-X step 5: text encode/decode
' DEF-SPACE: start over

' Example decryption steps, same as performed by an Enigma operator
'  ENIGMA UKW (B/C) B                   (Enigma B type)
'  STECKERVERBINDUNG PO                 (plugboard settings)
'  STECKERVERBINDUNG ML
'  STECKERVERBINDUNG IU
'  STECKERVERBINDUNG KJ
'  STECKERVERBINDUNG NH
'  STECKERVERBINDUNG YT
'  STECKERVERBINDUNG GB
'  STECKERVERBINDUNG VF
'  STECKERVERBINDUNG RE
'  STECKERVERBINDUNG DC
'  STECKERVERBINDUNG [ENTER]
'  WALZENLAGE 125                       (scrambler arrangement)
'  RINGSTELLUNG FVN                     (scrambler orientation)
'  GRUNDSTELLUNG EHZ                    (start position to retrieve message key)
'  ?TBS                                 (decrypt the message key)
'  XWB                                  (the message key to decrypt text)
'  [DEF-D]
'  GRUNDSTELLUNG XWB                    (start position to decrypt text)
'  ?QBLTW LDAHH YEOEF PTWYB
'  DERFU ..... ..... .....
'  ?LENDP MKOXL DFAMU DWIJD
'  KAMPF ..... ..... .....
'  ?XRJZ
'  ITZX
'  ?[ENTER]
'  END

' Example encryption steps, same as performed by an Enigma operator
' Note that the random start position key and encrypted message key are shared
' with the receiver by including EHZ TBS in the message sent. To do so, enable
' print and include EHZ in the print heading text. TBS is printed as the cipher
' of the plain message key XWB entered as text to encrypt. The heading text may
' also be used to send the key identification group of five letters.
'  ENIGMA UKW (B/C) B                   (Enigma B type)
'  STECKERVERBINDUNG PO                 (plugboard settings)
'  STECKERVERBINDUNG ML
'  STECKERVERBINDUNG IU
'  STECKERVERBINDUNG KJ
'  STECKERVERBINDUNG NH
'  STECKERVERBINDUNG YT
'  STECKERVERBINDUNG GB
'  STECKERVERBINDUNG VF
'  STECKERVERBINDUNG RE
'  STECKERVERBINDUNG DC
'  STECKERVERBINDUNG [ENTER]
'  WALZENLAGE 125                       (scrambler arrangement)
'  RINGSTELLUNG FVN                     (scrambler orientation)
'  GRUNDSTELLUNG EHZ                    (randomly selected start position key to share)
'  ?XWB                                 (randomly selected message key)
'  TBS                                  (encrypted message key to share)
'  [DEF-D]
'  GRUNDSTELLUNG XWB                    (start position to decrypt text)
'  ?.....
'  ?[ENTER]
'  END

' VARIABLES
'  R     reflector selection (11 or 12)
'  S,T,U scrambler selections 2*(1 to 5)-1
'  X,Y,Z ring orientations (1 to 26)
'  I,J,K scrambler rotation index (0 to 25)
'  L,M   scrambler rotation triggers (0 to 25)
'  P     print output flag (0 or 1)
'  Q     print keys flag (0 or 1)
'  A$    input string
'  W$()  plugboard, scramblers, reflectors
'  T$(0) text to encode/decode
'  A     plain character (1 to 26)
'  B     plain ASCII character ('A' to 'Z')
'  C     cypher ASCII character ('A' to 'Z')
'  N     loop counter
'  W     column counter

100 REM WEHRMACHT ENIGMA

150 CLEAR: DIM W$(12,26)*1,T$(0)*80: R=11, S=1, T=3, U=5, X=1, Y=1, Z=1, I=0, J=0, K=0, L=5, M=22
160 GOSUB 1000: PRINT "wait..."
170 FOR A=1 TO 26
180 W$(0,A)=CHR$(A+64)
' scrambler 1 (Walze I)
190 C=ASC MID$("EKMFLGDQVZNTOWYHXUSPAIBRCJ",A,1), W$(1,A)=CHR$ C, W$(2,C-64)=CHR$(A+64)
' scrambler 2 (Walze II)
200 C=ASC MID$("AJDKSIRUXBLHWTMCQGZNPYFVOE",A,1), W$(3,A)=CHR$ C, W$(4,C-64)=CHR$(A+64)
' scrambler 3 (Walze III)
210 C=ASC MID$("BDFHJLCPRTXVZNYEIWGAKMUSQO",A,1), W$(5,A)=CHR$ C, W$(6,C-64)=CHR$(A+64)
' scrambler 4 (Walze IV)
220 C=ASC MID$("ESOVPZJAYQUIRHXLNFTGKDCMWB",A,1), W$(7,A)=CHR$ C, W$(8,C-64)=CHR$(A+64)
' scrambler 5 (Walze V)
230 C=ASC MID$("VZBRGITYUPSDNHLXAWMJQOFECK",A,1), W$(9,A)=CHR$ C, W$(10,C-64)=CHR$(A+64)
' reflector B (UKW B)
240 W$(11,A)=MID$("YRUHQSLDPXNGOKMIEBFZCWVJAT",A,1)
' reflector C (UKW C)
250 W$(12,A)=MID$("FVPJIAOYEDRZXWGCTKUQSBNMHL",A,1)
260 NEXT A
' turnover positions of scramblers 1-5 when stepping to a letter
270 W$(1,0)="R", W$(3,0)="F", W$(5,0)="W", W$(7,0)="K", W$(9,0)="A"

280 GOSUB 1000: GOSUB 1100: A$="": INPUT "ENIGMA UKW (B/C) ";A$
290 R=(ASC A$ AND 1)+11
300 IF Q LPRINT "ENIGMA I UKW ";CHR$(R+55)

310 " " GOSUB 1000: PAUSE "DEFA DEFB DEFC DEFD DEFX"

330 "A" GOSUB 1000: REM PLUGBOARD SETTINGS
340 FOR A=1 TO 26: W$(0,A)=CHR$(A+64): NEXT A
350 GOSUB 1000: A$="": INPUT "STECKERVERBINDUNG ";A$
360 IF LEN A$<2 GOTO 410
370 B=(ASC A$ AND 31)+64, C=(ASC MID$(A$,2,1) AND 31)+64: IF B<65 OR B>90 OR C<65 OR C>90 BEEP 1: GOTO 350
380 IF ASC W$(0,B-64)<>B OR ASC W$(0,C-64)<>C BEEP 1: GOTO 350
390 W$(0,B-64)=CHR$ C, W$(0,C-64)=CHR$ B
400 GOTO 350
410 GOSUB 1000: PRINT "STECKER ";: IF Q LPRINT "STECKER ";
420 FOR A=1 TO 26
430 B=A+64, C=ASC W$(0,A): IF C>B PRINT " ";CHR$ B;CHR$ C;: IF Q LPRINT " ";CHR$ B;CHR$ C;
440 NEXT A
450 IF Q LPRINT ""

460 "B" GOSUB 1000: REM SCRAMBLER ARRANGEMENT
470 A$="": INPUT "WALZENLAGE ";A$
480 IF LEN A$<>3 BEEP 1: GOTO 470
490 S=VAL MID$(A$,1,1), T=VAL MID$(A$,2,1), U=VAL MID$(A$,3,1)
500 IF S<1 OR S>5 OR T<1 OR T>5 OR U<1 OR U>5 BEEP 1: GOTO 470
510 S=2*S-1, T=2*T-1, U=2*U-1
520 IF Q LPRINT "WALZENLAGE ";A$

530 "C" GOSUB 1000: REM SCRAMBLER ORIENTATION
540 A$="":INPUT "RINGSTELLUNG ";A$
550 IF LEN A$<>3 BEEP 1: GOTO 540
560 X=ASC MID$(A$,1,1) AND 31, Y=ASC MID$(A$,2,1) AND 31, Z=ASC MID$(A$,3,1) AND 31
570 IF X=0 OR X>26 OR Y=0 OR Y>26 OR Z=0 OR Z>26 BEEP 1: GOTO 540
580 IF Q LPRINT "RINGSTELLUNG ";A$
590 L=ASC W$(T,0)-64-Y, L=L-26*INT(L/26), M=ASC W$(U,0)-64-Z, M=M-26*INT(M/26)

600 "D" GOSUB 1000: REM STARTING POSITION
610 A$="": INPUT "GRUNDSTELLUNG ";A$
620 IF LEN A$<>3 BEEP 1: GOTO 610
630 I=ASC MID$(A$,1,1) AND 31, J=ASC MID$(A$,2,1) AND 31, K=ASC MID$(A$,3,1) AND 31
640 IF I=0 OR I>26 OR J=0 OR J>26 OR K=0 OR K>26 BEEP 1: GOTO 610
650 IF Q LPRINT "GRUNDSTELLUNG ";A$
660 I=I-X, I=I-26*INT(I/26), J=J-Y, J=J-26*INT(J/26), K=K-Z, K=K-26*INT(K/26)

670 "X" CLS: WAIT 0: REM ENCRYPT/DECRYPT TEXT
680 W=0, T$(0)="": INPUT T$(0): CURSOR 24
690 IF T$(0)="" END
700 FOR N=1 TO LEN T$(0)
' character C to encrypt/decrypt (1<=C<=26)
710 C=ASC MID$(T$(0),N,1) AND 31: IF C=0 OR C>26 GOTO 970
' rotate scramblers
720 K=K+1: IF K>25 LET K=0
730 IF K=M LET J=J+1, J=J-26*INT(J/26): IF J=L LET I=I+1, I=I-26*INT(I/26)
' pass C through the plugboard
740 C=ASC W$(0,C)-64
' pass C through the rightmost scrambler in slot 3 rotated by K (0<=K<=25)
750 C=C+K: IF C>26 LET C=C-26
760 C=ASC W$(U,C)-64
770 C=C-K: IF C<1 LET C=C+26
' pass C through the middle scrambler in slot 2 rotated by J (0<=J<=25)
780 C=C+J: IF C>26 LET C=C-26
790 C=ASC W$(T,C)-64
800 C=C-J: IF C<1 LET C=C+26
' pass C through the leftmost scrambler in slot 1 rotated by I (0<=I<=25)
810 C=C+I: IF C>26 LET C=C-26
820 C=ASC W$(S,C)-64
830 C=C-I: IF C<1 LET C=C+26
' pass C through the reflector
840 C=ASC W$(R,C)-64
' pass C back through the leftmost scrambler in slot 1 rotated by I (0<=I<=25)
850 C=C+I: IF C>26 LET C=C-26
860 C=ASC W$(S+1,C)-64
870 C=C-I: IF C<1 LET C=C+26
' pass C back through the middle scrambler in slot 2 rotated by J (0<=J<=25)
880 C=C+J: IF C>26 LET C=C-26
890 C=ASC W$(T+1,C)-64
900 C=C-J: IF C<1 LET C=C+26
' pass C back through the rightmost scrambler in slot 3 rotated by K (0<=K<=25)
910 C=C+K: IF C>26 LET C=C-26
920 C=ASC W$(U+1,C)-64
930 C=C-K: IF C<1 LET C=C+26
' pass C through the plugboard and convert to ASCII (65<=C<=91)
940 C=ASC W$(0,C)
950 PRINT CHR$ C;: IF P LPRINT CHR$ C;
960 W=W+1: IF W=5 PRINT " ";: W=0: IF P LPRINT " ";
970 NEXT N
980 PRINT: CURSOR 0: IF P LPRINT ""
990 GOTO 680

' display header and footer
1000 CLS: WAIT 0: PRINT "+++ WEHRMACHT ENIGMA +++": CURSOR 24: RETURN

' printer settings
1100 A$="": INPUT "PRINT (y/N) ";A$
1110 P=ASC A$ AND 1, Q=P: IF P=0 RETURN
1120 LPRINT "+++ WEHRMACHT ENIGMA +++"
1130 A$="Y": INPUT "PRINT KEYS (Y/n) ";A$
1140 Q=ASC A$ AND 1,T$(0)="": INPUT "HEADING TEXT TO PRINT?",T$(0): LPRINT T$(0)
1150 RETURN
