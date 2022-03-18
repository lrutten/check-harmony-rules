//=============================================================================
//  MuseScore - Chord Identifier Plugin (Chgd. by. Ziya Mete Demircan)
//
//  Copyright (C) 2016 Emmanuel Roussel - https://github.com/rousselmanu/msc_plugins
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENSE
//
//  Documentation: https://github.com/rousselmanu/msc_plugins
//  Support: https://github.com/rousselmanu/msc_plugins/issues
//  
//  I started this plugin as an improvement of the "Find Harmonies" plugin by Andresn 
//      (https://github.com/andresn/standard-notation-experiments/tree/master/MuseScore/plugins/findharmonies)
//      itself being an enhanced version of "findharmony" by Merte (http://musescore.org/en/project/findharmony)
//  I took some lines of code or got inspiration from:
//  - Berteh (https://github.com/berteh/musescore-chordsToNotes/)
//  - Jon Ensminger (AddNoteNameNoteHeads v. 1.2 plugin)
//  Thank you :-)
// 
//  Further adapted and extended by Leo Rutten 
//=============================================================================

//import QtQuick 2.3
//import QtQuick.Controls 1.2
//import QtQuick.Dialogs 1.2
//import QtQuick.Layouts 1.1
//import QtQuick.Controls.Styles 1.3
import QtQuick 2.2
import QtQuick.Dialogs 1.1
import MuseScore 3.0


MuseScore
{
   menuPath: "Plugins.Harmony.Check primary chord harmony"
   description: "Check primary chords I, IV, V and VI\nCheck harmony rules"
   version: "0.9.0.0"
 
   // ---- check chords ----

   property variant sop_e: 0
   property variant alt_e: 1
   property variant ten_e: 2
   property variant bas_e: 3

   property var v: {
      SOP: 0;
      ALT: 1;
      TEN: 2;
      BAS: 3;
      /*
      properties:  {
         0: {name: "SOP"},
         1: {name: "ALT"},
         2: {name: "TEN"},
         3: {name: "BAS"}
      }
       */
   }

   // ---- check intervals ----
   
   // colors taken from harmonyRules plugin
   property var colorFifth: "#e21c48";
   property var colorOctave: "#ff6a07";
   property var colorLargeInt: "#7b0e7f";
   property var colorError: "#ff6a64";

   property bool processAll: false;
   property bool errorChords: false;



   MessageDialog
   {
      id: msgError
      title: "Error"
      text: "This score does not contain 4 voices."
      
      onAccepted:
      {
         Qt.quit();
      }

      visible: false;
   }

   MessageDialog
   {
      id: msgNoErrors
      title: "No errors"
      text: "No errors hav been found."
      
      onAccepted:
      {
         Qt.quit();
      }

      visible: false;
   }


   function sgn(x)
   {
      if (x > 0) return(1);
      else if (x == 0) return(0);
      else return(-1);
   }

   function isBetween(note1,note2,n)
   {
      // test if pitch of note n is between note1 and note2
      if (note1.pitch > note2.pitch)
      {
         if (n.pitch < note1.pitch && n.pitch > note2.pitch)
            return true;
      } 
      else 
      {
         if (n.pitch < note2.pitch && n.pitch > note1.pitch)
            return true;
      }
      return false;
   }      

   function markColor(note1, note2, color) 
   {
      note1.color = color;
      note2.color = color;
   }

   function markColorNote(note, color) 
   {
      note.color = color;
   }

      function markText(note1, note2, msg, color, trck, tick) 
   {
      markColor(note1, note2, color);
      var myText = newElement(Element.STAFF_TEXT);
      myText.text = msg;
      //myText.pos.x = 0;
      myText.offsetY = 1;
      
      var cursor = curScore.newCursor();
      cursor.rewind(0);
      cursor.track = trck;
      while (cursor.tick < tick) 
      {
         cursor.next();
      }
      cursor.add(myText);
   }      

   function markTextTick(msg, tick) 
   {
      console.log("text " + msg);
      
      var myText = newElement(Element.STAFF_TEXT);
      myText.text = msg;
      //myText.pos.x = 0;
      myText.offsetY = 1;
      
      var cursor = curScore.newCursor();
      cursor.rewind(0);
      cursor.track = 0;  // use track 0
      while (cursor.tick < tick) 
      {
         cursor.next();
      }
      cursor.add(myText);
   }      

   function isAugmentedInt(note1, note2) 
   {
      var dtpc = note2.tpc - note1.tpc;
      var dpitch = note2.pitch - note1.pitch;

      // augmented intervals have same sgn for dtpc and dpitch
      if (sgn(dtpc) != sgn(dpitch))
         return false;

      dtpc = Math.abs(dtpc);
      dpitch = Math.abs(dpitch) % 12;

      // augmented intervalls have tpc diff > 5
      if (dtpc < 6)
         return false;
      if (dtpc == 7 && dpitch == 1) // aug. Unison / Octave
         return true;
      if (dtpc == 9 && dpitch == 3) // aug. Second / Ninth
         return true;
      if (dtpc == 11 && dpitch == 5) // aug. Third / ...
         return true;
      if (dtpc == 6 && dpitch == 6) // aug. Fourth
         return true;
      if (dtpc == 8 && dpitch == 8) // aug. Fifth
         return true;
      if (dtpc == 10 && dpitch == 10) // aug. Sixth
         return true;
      if (dtpc == 12 && dpitch == 0) // aug. Seventh
         return true;
      
      // not augmented
      return false;
   }

   function checkDim47(note1, note2, track, tick) 
   {
      var dtpc = note2.tpc - note1.tpc;
      var dpitch = note2.pitch - note1.pitch;

      // diminished intervals have opposite sgn for dtpc and dpitch
      if (sgn(dtpc) == sgn(dpitch)) 
      {
         return;
      }

      dtpc = Math.abs(dtpc);
      dpitch = Math.abs(dpitch) % 12;

      if (dtpc == 8 && dpitch == 4) 
      { // dim. Fourth
         markText(note1, note2, "dim. 4th, avoid for now",
            colorError,track,tick);
      } 
      else
      if (dtpc == 9 && dpitch == 9) 
      { // dim. Seventh
         markText(note1, note2, "dim. 7th, avoid for now",
            colorError,track,tick);
      }
   }

   function checkDim5(note1, note2, note3, track, tick) 
   {
      var dtpc = note2.tpc - note1.tpc;
      var dpitch = note2.pitch - note1.pitch;

      // diminished intervals have opposite sgn for dtpc and dpitch
      if (sgn(dtpc) == sgn(dpitch)) 
      {
         return;
      }

      dtpc = Math.abs(dtpc);
      dpitch = Math.abs(dpitch) % 12;

      if (dtpc == 6 && dpitch == 6) 
      {
         // check if note3 is inbetween
         if (!isBetween(note1,note2,note3)) 
         {
            note3.color = colorError;
            markText(note1,note2,
            "dim. 5th should be followed by\nnote within interval",
               colorError,track,tick);
         }
      }
   }

   function check6NextNote(note1, note2, note3, track, tick) 
   {
      var dtpc = note2.tpc - note1.tpc;
      var dpitch = note2.pitch - note1.pitch;
      var sameSgn = (sgn(dtpc) == sgn(dpitch));
      dtpc = Math.abs(dtpc);
      dpitch = Math.abs(dpitch) % 12;
   
      // check dim6th, min. 6th or maj. 6th
      if ((dtpc == 11 && dpitch == 7 && !sameSgn)
       || (dtpc == 4 && dpitch == 8 && !sameSgn)
       || (dtpc == 3 && dpitch == 9 && sameSgn)) 
      {
         // check if note3 is inbetween
         if (!isBetween(note1,note2,note3)) 
         {
            note3.color = colorError;
            markText(note1,note2,
            "6th better avoided, but should be followed by\nnote within interval",
               colorError,track,tick);
         } 
         else
         {
            markText(note1,note2,
            "6th better avoided",
               colorError,track,tick);
         }
      }
   }

   function check7AndLarger(note1, note2, track, tick, flag) 
   {
      var dtpc = Math.abs(note2.tpc - note1.tpc);
      var dpitch = Math.abs(note2.pitch - note1.pitch);
      
      if (dpitch > 9 && dpitch != 12 && dtpc < 6) 
      {
         if (flag) 
         {
            markText(note1,note2,
            "No 7ths, 9ths or larger\nnor with 1 note in between",
            colorLargeInt,track,tick);
         } 
         else
         {
            markText(note1, note2,
            "No 7ths, 9ths or larger",colorLargeInt,track,tick);
         }
      }
   }

   function isOctave(note1, note2) 
   {
      var dtpc = Math.abs(note2.tpc - note1.tpc);
      var dpitch = Math.abs(note2.pitch - note1.pitch);
      if (dpitch == 12 && dtpc == 0)
         return true;
      else
         return false;
   }

   function check8(note1, note2, note3, track, tick) 
   {
      // check if note2 and note3 form an octave
      // and note1 is not inbetween
      if (isOctave(note2,note3) && !isBetween(note2,note3,note1)) 
      {
         note3.color = colorError;
         markText(note1,note2,
            "Octave should be preceeded by note within compass",
            colorError,track,tick);
      }
      // check if note1 and note2 form an octave
      // and note3 is not inbetween
      if (isOctave(note1,note2) && !isBetween(note1,note2,note3))
      {
         note3.color = colorError;
         markText(note1,note2,
            "Octave should be followed by note within compass",
            colorError,track,tick);
      }
   }        

   function onRunIntervals()
   {
      console.log("start")
      if (typeof curScore == 'undefined' || curScore == null) 
      {
         console.log("no score found");
         Qt.quit();
      }

      // find selection
      var startStaff;
      var endStaff;
      var endTick;

      var cursor = curScore.newCursor();
      cursor.rewind(1);
      if (!cursor.segment) 
      {
         // no selection
         console.log("no selection: processing whole score");
         processAll = true;
         startStaff = 0;
         endStaff = curScore.nstaves;
      } 
      else
      {
         startStaff = cursor.staffIdx;
         cursor.rewind(2);
         endStaff = cursor.staffIdx+1;
         endTick = cursor.tick;
         if(endTick == 0) 
         {
            // selection includes end of score
            // calculate tick from last score segment
            endTick = curScore.lastSegment.tick + 1;
         }
         cursor.rewind(1);
         console.log("Selection is: Staves("+startStaff+"-"+endStaff+") Ticks("+cursor.tick+"-"+endTick+")");
      }   

      // initialize data structure

      var changed = [];
      var curNote = [];
      var prevNote = [];
      var curRest = [];
      var prevRest = [];
      var curTick = [];
      var prevTick = [];

      var foundParallels = 0;

      var track;

      var startTrack = startStaff * 4;
      var endTrack = endStaff * 4;

      for (track = startTrack; track < endTrack; track++) 
      {
         curRest[track] = true;
         prevRest[track] = true;
         changed[track] = false;
         curNote[track] = 0;
         prevNote[track] = 0;
         curTick[track] = 0;
         prevTick[track] = 0;
      }

      // go through all staves/voices simultaneously

      if(processAll) 
      {
         cursor.track = 0;
         cursor.rewind(0);
      } 
      else
      {
         cursor.rewind(1);
      }

      var segment = cursor.segment;

      while (segment && (processAll || segment.tick < endTick)) 
      {
         // Pass 1: read notes
         for (track = startTrack; track < endTrack; track++) 
         {
            if (segment.elementAt(track)) 
            {
               if (segment.elementAt(track).type == Element.CHORD) 
               {
                  // we ignore grace notes for now
                  var notes = segment.elementAt(track).notes;

                  if (notes.length > 1) 
                  {
                     console.log("found chord with more than one note!");
                     errorChords = true;
                  }

                  var note = notes[notes.length-1];

                  // check for some voice rules
                  // if we have a new pitch
                  if ((! curRest[track]) 
                       && curNote[track].pitch != note.pitch) 
                       {
                     // previous note present
                     // check for augmented interval
                     if (isAugmentedInt(note, curNote[track])) 
                     {
                        markText(curNote[track],note,
                        "augmented interval",colorError,
                        track,curTick[track]);
                     }
                     // check for diminished 4th and 7th
                     checkDim47(curNote[track], note,
                        track,curTick[track]);
                     check7AndLarger(curNote[track],note,
                        track,curTick[track],false);

                     // have three notes?
                     if (! prevRest[track]) 
                     {
                        // check for diminished 5th
                        checkDim5(prevNote[track],curNote[track],
                          note, track, prevTick[track]);
                        // check for 6th
                        check6NextNote(prevNote[track],curNote[track],
                          note, track, prevTick[track]);
                        if(!isOctave(prevNote[track],curNote[track]) &&
                           !isOctave(curNote[track],note))
                           check7AndLarger(prevNote[track],note,
                             track,prevTick[track],true);
                        check8(prevNote[track],curNote[track],note,
                           track, prevTick[track]);
                     }
                  }

                  // remember note

                  if (curNote[track].pitch != note.pitch) 
                  {
                     prevTick[track]=curTick[track];
                     prevRest[track]=curRest[track];
                     prevNote[track]=curNote[track];
                     changed[track]=true;
                  } 
                  else
                  {
                     changed[track]=false;
                  }
                  curRest[track]=false;
                  curNote[track]=note;
                  curTick[track]=segment.tick;
               }
               else
               if (segment.elementAt(track).type == Element.REST)
               {
                  if (!curRest[track]) 
                  {
                     // was note
                     prevRest[track]=curRest[track];
                     prevNote[track]=curNote[track];
                     curRest[track]=true;
                     changed[track]=false; // no need to check against a rest
                  }
               }
               else
               {
                  changed[track] = false;
               }
            } 
            else
            {
               changed[track] = false;
            }
         }
         // Pass 2: find paralleles
         for (track=startTrack; track < endTrack; track++)
         {
            var i;
            // compare to other tracks
            if (changed[track] && (!prevRest[track]))
            {
               var dir1 = sgn(curNote[track].pitch - prevNote[track].pitch);
               if (dir1 == 0) continue; // voice didn't move
               for (i=track+1; i < endTrack; i++)
               {
                  if (changed[i] && (!prevRest[i]))
                  {
                     var dir2 = sgn(curNote[i].pitch-prevNote[i].pitch);
                     if (dir1 == dir2) 
                     { // both voices moving in the same direction
                        var cint = curNote[track].pitch - curNote[i].pitch;
                        var pint = prevNote[track].pitch-prevNote[i].pitch;
                        // test for 5th
                        if (Math.abs(cint%12) == 7) 
                        {
                           // test for open parallel
                           if (cint == pint) 
                           {
                              foundParallels++;
                              console.log ("P5:"+cint+", "+pint);
                              markText(prevNote[track],prevNote[i],"parallel 5th",
                                 colorFifth,track,prevTick[track]);
                              markColor(curNote[track],curNote[i],colorFifth);
                           } 
                           else
                           if (dir1 == 1 && Math.abs(pint) < Math.abs(cint))
                           {
                              // hidden parallel (only when moving up)
                              foundParallels++;
                              console.log ("H5:"+cint+", "+pint);
                              markText(prevNote[track],prevNote[i],"hidden 5th",
                                 colorFifth,track,prevTick[track]);
                              markColor(curNote[track],curNote[i],colorFifth);
                           }                        
                        }
                        // test for 8th
                        if (Math.abs(cint%12) == 0) 
                        {
                           // test for open parallel
                           if (cint == pint) 
                           {
                              foundParallels++;
                              console.log ("P8:"+cint+", "+pint+"Tracks "+track+","+i+" Tick="+segment.tick);
                              markText(prevNote[track],prevNote[i],"parallel 8th",
                                 colorOctave,track,prevTick[track]);
                              markColor(curNote[track],curNote[i],colorOctave);
                           } 
                           else 
                           if (dir1 == 1 && Math.abs(pint) < Math.abs(cint)) 
                           {
                              // hidden parallel (only when moving up)
                              foundParallels++;
                              console.log ("H8:"+cint+", "+pint);
                              markText(prevNote[track],prevNote[i],"hidden 8th",
                                 colorOctave,track,prevTick[track]);
                              markColor(curNote[track],curNote[i],colorOctave);
                           }                        
                        }
                     }
                  }
               }
            }
         }
         segment = segment.next;
      }

      // set result dialog

      if (errorChords) 
      {
         console.log("finished with error");
         msgMoreNotes.visible = true;
      } 
      else
      {
         console.log("finished");
         Qt.quit();
      }
   }
  
   
   
   
   
   
   
   
   
   // ---- check chords ----

   function v_to_s(vo)
   {
      //return v.properties[vo].name;

      /*
      if (vo === v.SOP) return "SOP";
      if (vo === v.ALT) return "ALT";
      if (vo === v.TEN) return "TEN";
      if (vo === v.BAS) return "BAS";
      return "XXX";
       */
      /*
      switch (vo)
      {
         case v.SOP: return "SOP";
         case v.ALT: return "ALT";
         case v.TEN: return "TEN";
         case v.BAS: return "BAS";
         default:    return "XXX";
      }
        */
      switch (vo)
      {
         case sop_e: return "SOP";
         case alt_e: return "ALT";
         case ten_e: return "TEN";
         case bas_e: return "BAS";
         default:    return "XXX";
      }
   }

   function show_elementtype(tp)
   {
      switch (tp)
      {
         case Element.ACCIDENTAL:
            console.log("ACCIDENTAL");
            break;
         case Element.AMBITUS:
            console.log("AMBITUS");
            break;
         case Element.ARPEGGIO:
            console.log("ARPEGGIO");
            break;
         case Element.BAGPIPE_EMBELLISHMENT:
            console.log("BAGPIPE_EMBELLISHMENT");
            break;
         case Element.BAR_LINE:
            console.log("BAR_LINE");
            break;
         case Element.BEAM:
            console.log("BEAM");
            break;
         case Element.BEND:
            console.log("BEND");
            break;
         case Element.BRACKET:
            console.log("BRACKET");
            break;
         case Element.BREATH:
            console.log("BREATH");
            break;
         case Element.CHORD:
            console.log("CHORD");
            break;
         case Element.CHORDLINE:
            console.log("CHORDLINE");
            break;
         case Element.CLEF:
            console.log("CLEF");
            break;
         case Element.COMPOUND:
            console.log("COMPOUND");
            break;
         case Element.DYNAMIC:
            console.log("DYNAMIC");
            break;
         case Element.ELEMENT:
            console.log("ELEMENT");
            break;
         case Element.ELEMENT_LIST:
            console.log("ELEMENT_LIST");
            break;
         case Element.FBOX:
            console.log("FBOX");
            break;
         case Element.FIGURED_BASS:
            console.log("FIGURED_BASS");
            break;
         case Element.FINGERING:
            console.log("FINGERING");
            break;
         case Element.FRET_DIAGRAM:
            console.log("FRET_DIAGRAM");
            break;
         case Element.FSYMBOL:
            console.log("FSYMBOL");
            break;
         case Element.GLISSANDO:
            console.log("GLISSANDO");
            break;
         case Element.GLISSANDO_SEGMENT:
            console.log("GLISSANDO_SEGMENT");
            break;
         case Element.HAIRPIN:
            console.log("HAIRPIN");
            break;
         case Element.HAIRPIN_SEGMENT:
            console.log("HAIRPIN_SEGMENT");
            break;
         case Element.HARMONY:
            console.log("HARMONY");
            break;
         case Element.HBOX:
            console.log("HBOX");
            break;
         case Element.HOOK:
            console.log("HOOK");
            break;
         case Element.ICON:
            console.log("ICON");
            break;
         case Element.IMAGE:
            console.log("IMAGE");
            break;
         case Element.INSTRUMENT_CHANGE:
            console.log("INSTRUMENT_CHANGE");
            break;
         case Element.INSTRUMENT_NAME:
            console.log("INSTRUMENT_NAME");
            break;
         case Element.JUMP:
            console.log("JUMP");
            break;
         case Element.KEYSIG:
            console.log("KEYSIG");
            break;
         case Element.LASSO:
            console.log("LASSO");
            break;
         case Element.LAYOUT_BREAK:
            console.log("LAYOUT_BREAK");
            break;
         case Element.LEDGER_LINE:
            console.log("LEDGER_LINE");
            break;
         case Element.LINE:
            console.log("LINE");
            break;
         case Element.LYRICS:
            console.log("LYRICS");
            break;
         case Element.LYRICSLINE:
            console.log("LYRICSLINE");
            break;
         case Element.LYRICSLINE_SEGMENT:
            console.log("LYRICSLINE_SEGMENT");
            break;
         case Element.MARKER:
            console.log("MARKER");
            break;
         case Element.MEASURE:
            console.log("MEASURE");
            break;
         case Element.MEASURE_LIST:
            console.log("MEASURE_LIST");
            break;
         case Element.NOTE:
            console.log("NOTE");
            break;
         case Element.NOTEDOT:
            console.log("NOTEDOT");
            break;
         case Element.NOTEHEAD:
            console.log("NOTEHEAD");
            break;
         case Element.NOTELINE:
            console.log("NOTELINE");
            break;
         case Element.OSSIA:
            console.log("OSSIA");
            break;
         case Element.OTTAVA:
            console.log("OTTAVA");
            break;
         case Element.OTTAVA_SEGMENT:
            console.log("OTTAVA_SEGMENT");
            break;
         case Element.PAGE:
            console.log("PAGE");
            break;
         case Element.PEDAL:
            console.log("PEDAL");
            break;
         case Element.PEDAL_SEGMENT:
            console.log("PEDAL_SEGMENT");
            break;
         case Element.REHEARSAL_MARK:
            console.log("REHEARSAL_MARK");
            break;
         case Element.REPEAT_MEASURE:
            console.log("REPEAT_MEASURE");
            break;
         case Element.REST:
            console.log("REST");
            break;
         case Element.SEGMENT:
            console.log("SEGMENT");
            break;
         case Element.SELECTION:
            console.log("SELECTION");
            break;
         case Element.SHADOW_NOTE:
            console.log("SHADOW_NOTE");
            break;
         case Element.SLUR:
            console.log("SLUR");
            break;
         case Element.SLUR_SEGMENT:
            console.log("SLUR_SEGMENT");
            break;
         case Element.SPACER:
            console.log("SPACER");
            break;
         case Element.STAFF_LINES:
            console.log("STAFF_LINES");
            break;
         case Element.STAFF_LIST:
            console.log("STAFF_LIST");
            break;
         case Element.STAFF_STATE:
            console.log("STAFF_STATE");
            break;
         case Element.STAFF_TEXT:
            console.log("STAFF_TEXT");
            break;
         case Element.STEM:
            console.log("STEM");
            break;
         case Element.STEM_SLASH:
            console.log("STEM_SLASH");
            break;
         case Element.SYMBOL:
            console.log("SYMBOL");
            break;
         case Element.SYSTEM:
            console.log("SYSTEM");
            break;
         case Element.TAB_DURATION_SYMBOL:
            console.log("TAB_DURATION_SYMBOL");
            break;
         case Element.TBOX:
            console.log("TBOX");
            break;
         case Element.TEMPO_TEXT:
            console.log("TEMPO_TEXT");
            break;
         case Element.TEXT:
            console.log("TEXT");
            break;
         case Element.TEXTLINE:
            console.log("TEXTLINE");
            break;
         case Element.TEXTLINE_SEGMENT:
            console.log("TEXTLINE_SEGMENT");
            break;
         case Element.TIE:
            console.log("TIE");
            break;
         case Element.TIMESIG:
            console.log("TIMESIG");
            break;
         case Element.TREMOLO:
            console.log("TREMOLO");
            break;
         case Element.TREMOLOBAR:
            console.log("TREMOLOBAR");
            break;
         case Element.TRILL:
            console.log("TRILL");
            break;
         case Element.TRILL_SEGMENT:
            console.log("TRILL_SEGMENT");
            break;
         case Element.TUPLET:
            console.log("TUPLET");
            break;
         case Element.VBOX:
            console.log("VBOX");
            break;
         case Element.VOLTA:
            console.log("VOLTA");
            break;
         case Element.VOLTA_SEGMENT:
            console.log("VOLTA_SEGMENT");
            break;
      }
   }

   function segmenttype_to_s(tp)
   {
      switch (tp)
      {
         case Segment.All:                return "All";
         case Segment.Ambitus:            return "Ambitus";
         case Segment.BarLine:            return "BarLine";
         case Segment.Breath:             return "Breath";
         case Segment.ChordRest:          return "ChordRest";
         case Segment.Clef:               return "Clef";
         case Segment.EndBarLine:         return "EndBarLine";
         case Segment.Invalid:            return "Invalid";
         case Segment.KeySig:             return "KeySig";
         case Segment.KeySigAnnounce:     return "KeySigAnnounce";
         case Segment.StartRepeatBarLine: return "StartRepeatBarLine";
         case Segment.TimeSig:            return "TimeSig";
         case Segment.TimeSigAnnounce:    return "TimeSigAnnounce";
         default: "unknown type";
      }
   }

   function elementtype_to_s(tp)
   {
      switch (tp)
      {
         case Element.ACCIDENTAL:            return "ACCIDENTAL";
         case Element.AMBITUS:               return "AMBITUS";
         case Element.ARPEGGIO:              return "ARPEGGIO";
         case Element.BAGPIPE_EMBELLISHMENT: return "BAGPIPE_EMBELLISHMENT";
         case Element.BAR_LINE:              return "BAR_LINE";
         case Element.BEAM:                  return "BEAM";
         case Element.BEND:                  return "BEND";
         case Element.BRACKET:               return "BRACKET";
         case Element.BREATH:                return "BREATH";
         case Element.CHORD:                 return "CHORD";
         case Element.CHORDLINE:             return "CHORDLINE";
         case Element.CLEF:                  return "CLEF";
         case Element.COMPOUND:              return "COMPOUND";
         case Element.DYNAMIC:               return "DYNAMIC";
         case Element.ELEMENT:               return "ELEMENT";
         case Element.ELEMENT_LIST:          return "ELEMENT_LIST";
         case Element.FBOX:                  return "FBOX";
         case Element.FIGURED_BASS:          return "FIGURED_BASS";
         case Element.FINGERING:             return "FINGERING";
         case Element.FRET_DIAGRAM:          return "FRET_DIAGRAM";
         case Element.FSYMBOL:               return "FSYMBOL";
         case Element.GLISSANDO:             return "GLISSANDO";
         case Element.GLISSANDO_SEGMENT:     return "GLISSANDO_SEGMENT";
         case Element.HAIRPIN:               return "HAIRPIN";
         case Element.HAIRPIN_SEGMENT:       return "HAIRPIN_SEGMENT";
         case Element.HARMONY:               return "HARMONY";
         case Element.HBOX:                  return "HBOX";
         case Element.HOOK:                  return "HOOK";
         case Element.ICON:                  return "ICON";
         case Element.IMAGE:                 return "IMAGE";
         case Element.INSTRUMENT_CHANGE:     return "INSTRUMENT_CHANGE";
         case Element.INSTRUMENT_NAME:       return "INSTRUMENT_NAME";
         case Element.JUMP:                  return "JUMP";
         case Element.KEYSIG:                return "KEYSIG";
         case Element.LASSO:                 return "LASSO";
         case Element.LAYOUT_BREAK:          return "LAYOUT_BREAK";
         case Element.LEDGER_LINE:           return "LEDGER_LINE";
         case Element.LINE:                  return "LINE";
         case Element.LYRICS:                return "LYRICS";
         case Element.LYRICSLINE:            return "LYRICSLINE";
         case Element.LYRICSLINE_SEGMENT:    return "LYRICSLINE_SEGMENT";
         case Element.MARKER:                return "MARKER";
         case Element.MEASURE:               return "MEASURE";
         case Element.MEASURE_LIST:          return "MEASURE_LIST";
         case Element.NOTE:                  return "NOTE";
         case Element.NOTEDOT:               return "NOTEDOT";
         case Element.NOTEHEAD:              return "NOTEHEAD";
         case Element.NOTELINE:              return "NOTELINE";
         case Element.OSSIA:                 return "OSSIA";
         case Element.OTTAVA:                return "OTTAVA";
         case Element.OTTAVA_SEGMENT:        return "OTTAVA_SEGMENT";
         case Element.PAGE:                  return "PAGE";
         case Element.PEDAL:                 return "PEDAL";
         case Element.PEDAL_SEGMENT:         return "PEDAL_SEGMENT";
         case Element.REHEARSAL_MARK:        return "REHEARSAL_MARK";
         case Element.REPEAT_MEASURE:        return "REPEAT_MEASURE";
         case Element.REST:                  return "REST";
         case Element.SEGMENT:               return "SEGMENT";
         case Element.SELECTION:             return "SELECTION";
         case Element.SHADOW_NOTE:           return "SHADOW_NOTE";
         case Element.SLUR:                  return "SLUR";
         case Element.SLUR_SEGMENT:          return "SLUR_SEGMENT";
         case Element.SPACER:                return "SPACER";
         case Element.STAFF_LINES:           return "STAFF_LINES";
         case Element.STAFF_LIST:            return "STAFF_LIST";
         case Element.STAFF_STATE:           return "STAFF_STATE";
         case Element.STAFF_TEXT:            return "STAFF_TEXT";
         case Element.STEM:                  return "STEM";
         case Element.STEM_SLASH:            return "STEM_SLASH";
         case Element.SYMBOL:                return "SYMBOL";
         case Element.SYSTEM:                return "SYSTEM";
         case Element.TAB_DURATION_SYMBOL:   return "TAB_DURATION_SYMBOL";
         case Element.TBOX:                  return "TBOX";
         case Element.TEMPO_TEXT:            return "TEMPO_TEXT";
         case Element.TEXT:                  return "TEXT";
         case Element.TEXTLINE:              return "TEXTLINE";
         case Element.TEXTLINE_SEGMENT:      return "TEXTLINE_SEGMENT";
         case Element.TIE:                   return "TIE";
         case Element.TIMESIG:               return "TIMESIG";
         case Element.TREMOLO:               return "TREMOLO";
         case Element.TREMOLOBAR:            return "TREMOLOBAR";
         case Element.TRILL:                 return "TRILL";
         case Element.TRILL_SEGMENT:         return "TRILL_SEGMENT";
         case Element.TUPLET:                return "TUPLET";
         case Element.VBOX:                  return "VBOX";
         case Element.VOLTA:                 return "VOLTA";
         case Element.VOLTA_SEGMENT:         return "VOLTA_SEGMENT";
         default: "unknown type";
      }
   }


   function pitch_to_s(pi)
   {
      var pi2 = pi %12;
      switch (pi2)
      {
         case 0: return "c";
         case 1: return "db";
         case 2: return "d";
         case 3: return "eb";
         case 4: return "e";
         case 5: return "f";
         case 6: return "gb";
         case 7: return "g";
         case 8: return "ab";
         case 9: return "a";
         case 10: return "bb";
         case 11: return "b";
      }
   }


   // class note_t
   function note_t(ppi, voi)
   {
      this.pitch = ppi;    // original pitch
      this.bpitch = ppi%12; // pitch in 0-11 range
      this.voice  = voi;    // voice SOP, ALT or TEN
      this.step   = 0;      // 1, 3 or 5

      console.log("new note_t " + ppi + " " + v_to_s(voi));

      this.show = function(base) {
         console.log("      note_t v" + v_to_s(this.voice) + " " + this.pitch + " " + pitch_to_s(this.bpitch) + " base " + (this.pitch-base) +
         " step " + this.step);
      }
   }

   // class triad_t()
   function triad_t(co)
   {
      this.notes = [];
      this.notes[0] = new note_t(co.notes[0].pitch, sop_e);
      this.notes[1] = new note_t(co.notes[1].pitch, alt_e);
      this.notes[2] = new note_t(co.notes[2].pitch, ten_e);

      this.show = function() {
         console.log("   triad_t");
         this.notes[0].show(this.notes[2].pitch);
         this.notes[1].show(this.notes[2].pitch);
         this.notes[2].show(this.notes[2].pitch);
      }

      this.rotate = function() {
         this.notes[2].pitch += 12;
         while (this.notes[2].pitch < this.notes[0].pitch)
         {
            this.notes[2].pitch += 12;
         }
         var tmp = this.notes[2];
         this.notes[2] = this.notes[1];
         this.notes[1] = this.notes[0];
         this.notes[0] = tmp;
      }

      this.sort_on_pitch = function() {
         console.log("sort_on_pitch");
         var cont = true;
         while (cont)
         {
            cont = false;
            if (this.notes[0].pitch < this.notes[1].pitch)
            {
               var tmp = this.notes[0];
               this.notes[0] = this.notes[1];
               this.notes[1] = tmp;
               cont = true;
               console.log("switch 0-1");
            }
            if (this.notes[1].pitch < this.notes[2].pitch)
            {
               var tmp = this.notes[1];
               this.notes[1] = this.notes[2];
               this.notes[2] = tmp;
               cont = true;
               console.log("switch 1-2");
            }
         }
      }

      this.normalize = function() {
         while (this.notes[1].pitch-12 > this.notes[2].pitch)
         {
            this.notes[1].pitch -= 12;
         }
         while (this.notes[0].pitch-12 > this.notes[2].pitch)
         {
            this.notes[0].pitch -= 12;
         }
         this.sort_on_pitch();
      }

      this.is_major_triad = function() {
         var hig = this.notes[0].pitch;
         var mid = this.notes[1].pitch;
         var low = this.notes[2].pitch;

         if (hig-low == 7  && mid-low == 4)
         {
            this.notes[0].step = 5;
            this.notes[1].step = 3;
            this.notes[2].step = 1;
            console.log("is major triad");

            this.is_wide();

            return true;
         }
         else
         {
            console.log("is not major triad");
            return false;
         }
      }


      this.is_minor_triad = function() {
         var hig = this.notes[0].pitch;
         var mid = this.notes[1].pitch;
         var low = this.notes[2].pitch;

         console.log("is_minor_triad");
         
         if (hig-low == 7  && mid-low == 3)
         {
            this.notes[0].step = 5;
            this.notes[1].step = 3;
            this.notes[2].step = 1;
            console.log("is minor triad");

            this.is_wide();

            return true;
         }
         else
         {
            console.log("is not minor triad");
            return false;
         }
      }


      //   degree |   minor scale  | major scale
      //   -------|----------------|-------------
      //      1   |   min triad    | maj triad
      //      4   |   min triad    | maj triad
      //      5   |   maj triad    | maj triad
      //      6   |   maj triad    | min triad
      this.is_majmin_triad = function(isminor, degree) {
         if (isminor)
         {
            console.log("is minor key");
            if (degree == 5 && degree == 6)
            {
               return this.is_major_triad();
            }
            else
            {
               return this.is_minor_triad();
            }
         }
         else
         {
            console.log("is major key, degree " + degree);
            if (degree == 6)
            {
               return this.is_minor_triad();
            }
            else
            {
               return this.is_major_triad();
            }
         }
      }


      this.is_wide = function() {
         console.log("wide_or_narrow");

         // collect all the steps
         var voic = {};
         voic[this.notes[0].voice] = this.notes[0].step;
         voic[this.notes[1].voice] = this.notes[1].step;
         voic[this.notes[2].voice] = this.notes[2].step;

         console.log("   sop step " + voic[sop_e]);
         console.log("   alt step " + voic[alt_e]);
         console.log("   ten step " + voic[ten_e]);

         if (voic[sop_e] == 3 && voic[alt_e] == 1 || 
             voic[sop_e] == 1 && voic[alt_e] == 5 || 
             voic[sop_e] == 5 && voic[alt_e] == 3)
         {
            console.log("   narrow");
            return false;
         }
         else
         {
            console.log("   wide");
            return true;
         }
      }
   }

   // class chord_t
   function chord_t()
   {
      this.notes  = [];
      this.wide   = false;
      this.degree = 0; // degree 1, 4, 5 or 6
      this.tick   = 0;

      this.add = function(not) {
         this.notes.push(not);
      }

      this.show = function() {
         console.log("   chord w " + this.wide);

         for (var i=0; i<this.notes.length; i++)
         {
             console.log("      note " + this.notes[i].pitch);
         }
      }

      // check wether every note is higher then the next
      // of differently said, no crossing between voices
      this.no_crossing_voice = function()
      {
         //console.log("no_crossing_voice " + 
         //   this.notes[0].pitch + " " +
         //   this.notes[1].pitch + " " +
         //   this.notes[2].pitch + " " +
         //   this.notes[3].pitch);

         var noc =
            this.notes[0].pitch > this.notes[1].pitch &&
            this.notes[1].pitch > this.notes[2].pitch &&
            this.notes[2].pitch > this.notes[3].pitch;

         return noc;
      }
   }


   // class score_t
   function score_t(n)
   {
      this.nr     = n;
      this.cusc   = curScore;
      this.nst    = curScore.nstaves;
      this.chords = [];
      this.minor  = false;

      this.show = function() {
         console.log("show");
         console.log('curScore.nstaves: ' + curScore.nstaves);
      }
   

      this.show_score = function() {
         console.log('+++++++++++++++++++++');
         console.log('show_score');

         console.log('curScore.nstaves: ' + curScore.nstaves);
         console.log('curScore.lastSegment.tick: ' + curScore.lastSegment.tick);

         var cursor = curScore.newCursor();
         cursor.rewind(0); // beginning of score
         cursor.voice    = 0;
         cursor.staffIdx = 0; // 1st staff;
         console.log('cursor.tick: ' + cursor.tick);
 
         var keySig = cursor.keySignature;
         console.log('keysig: ' + keySig);

         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            console.log("   segment " + segm.tick + " " + elementtype_to_s(segm.type));
            console.log("      segmenttype " + segm.segmentType);
            console.log("                  " + segmenttype_to_s(segm.segmentType));

            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  console.log("      element " + el + " elementtype_to_s(el.type)");
                  if (el.duration)
                  {
                     console.log("         duration " + el.duration.numerator + "/" + el.duration.denominator);
                  }

                  if (el.type == Element.CHORD)
                  {
                     var notes = el.notes;
                     for (var j = 0; j < notes.length; j++)
                     {
                        console.log("         note " + elementtype_to_s(notes[j].type) 
                       + " " + notes[j].pitch + " " + pitch_to_s(notes[j].pitch)
                       + " els " + notes[j].elements.length);

                        for (var k=0; k<notes[j].elements.length; k++)
                        {
                           console.log("            element " + elementtype_to_s(notes[j].elements[k].type)); 
                        }
                     }
                  }
                  else
                  {
                  }
               }
               else
               {
                  //console.log("      elementt null " + el);
               }
            }

            segm = segm.next;
         }

         console.log('=====================');
      }

      this.show_notes = function() {
         console.log("chords");

         for (var i=0; i<this.chords.length; i++)
         {
            this.chords[i].show();
         }
      }
      
      // Calculates the number of voices
      //
      // This function loops through all the segments.
      // Each segment starts at a fixed tick and can have max. 4 voices
      // per stave. Each voice is represented by a chord. Each chord can
      // several parallel notes of the same length.  
      this.get_nr_voices = function() {
         console.log('get_nr_voices');

         console.log('curScore.nstaves: ' + curScore.nstaves);
        
         // Each voice (or chords, max 4 per stave) starts with 0 notes 
         var nvoices = [];
         for (var i=0; i<4*this.nst; i++)
         {
            nvoices[i] = 0;
         }

         // for all segments
         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   segment " + segm.tick + " " + elementtype_to_s(segm.type));

            // for all voices
            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  if (el.type == Element.CHORD)
                  {
                     var notes = el.notes;
                     for (var j = 0; j < notes.length; j++)
                     {
                        //console.log("       voice " + i + "  note " + j + " " + elementtype_to_s(notes[j].type) 
                        //   + " " + notes[j].pitch + " " + pitch_to_s(notes[j].pitch));
                     }
                     if (notes.length > nvoices[i])
                     {
                        nvoices[i] = notes.length;
                     }                     
                     //nvoices[i] = 1;
                  }
               }
            }
            segm = segm.next;
         }
         
         // count all the available voices
         var nv = 0
         for (var i=0; i<4*this.nst; i++)
         {
            nv += nvoices[i];
         }
         return nv;
      }


      // Checks whether each chord has a single note.
      // Only chords with 1 note are allowed.
      this.check_single_note_chord = function() {
         console.log('check_single_note_chord');

         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   segment " + segm.tick + " " + elementtype_to_s(segm.type));

            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  if (el.type == Element.CHORD)
                  {
                     var notes = el.notes;
                     if (notes.length > 1)
                     {
                        return false;
                     }
                  }
               }
            }
            segm = segm.next;
         }
         
         return true;
      }


      // Checks no rests exist in voices with notes
      // Voice-only voices or staff are allowed.
      this.check_no_rests = function() {
         console.log('check_no_rests');

        
         var hasvoice = [];
         for (var i=0; i<4*this.nst; i++)
         {
            hasvoice[i] = false;
         }

         // pass 1: search all the voices with notes
         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   p1 segment " + segm.tick + " " + elementtype_to_s(segm.type));

            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  if (el.type == Element.CHORD)
                  {
                     var notes = el.notes;
                     hasvoice[i] = true;
                  }
               }
            }
            segm = segm.next;
         }

         segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   p2 segment " + segm.tick + " " + elementtype_to_s(segm.type));

            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  if (el.type == Element.REST && hasvoice[i])
                  {
                     return false;
                  }
               }
            }
            segm = segm.next;
         }
         
         return true;
      }


      // Checks all notes have the same duration
      this.check_same_duration = function() {
         console.log('check_same_duration');
        
         var hasvoice = [];
         for (var i=0; i<4*this.nst; i++)
         {
            hasvoice[i] = false;
         }

         // pass 1: search all the voices with notes
         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   s1 segment " + segm.tick + " " + elementtype_to_s(segm.type));

            for (var i=0; i<4*this.nst; i++)
            {
               var el = segm.elementAt(i);
               if (el != null)
               {
                  if (el.type == Element.CHORD)
                  {
                     var notes = el.notes;
                     hasvoice[i] = true;
                  }
               }
            }
            segm = segm.next;
         }

         // pass 2: search for missing elements within segments
         segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   s2 segment " + segm.tick + " " + elementtype_to_s(segm.type));
            //console.log("      segmenttype " + segm.segmentType);

            if (segm.segmentType == Segment.ChordRest)  // 128 is probably Segment.ChordRest
            {
               for (var i=0; i<4*this.nst; i++)
               {
                  //console.log("      " + i + " hasvoice " + hasvoice[i]); 
                  var el = segm.elementAt(i);
                  if (el == null && hasvoice[i])
                  {
                     return false;
                  }
               }
            }
            else
            {
               //console.log("      no chord in this segment");
            }
            segm = segm.next;
         }
         
         return true;
      }



      // Make a list of chords
      this.make_chords = function() {
         console.log('make_chords');
        
         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            //console.log("   m segment " + segm.tick + " " + elementtype_to_s(segm.type));

            if (segm.segmentType == Segment.ChordRest)  // 128 is probably Segment.ChordRest
            {
               var co = new chord_t();
               co.tick = segm.tick;
               this.chords.push(co);

               for (var i=0; i<4*this.nst; i++)
               {
                  var el = segm.elementAt(i);
                  if (el != null)
                  {
                     if (el.type == Element.CHORD)
                     {
                        //console.log("      add note " + el.notes[0].pitch);   
                        var nots = el.notes;
                        co.add(nots[0]);
                     }
                  }
               }
            }
            segm = segm.next;
         }
      }

      // check no crossings between voices
      this.no_crossing_voices = function() {
         console.log('no_crossing_voices');

         for (var i=0; i<this.chords.length; i++)
         {
            //console.log("   noc " + i);
            if (!this.chords[i].no_crossing_voice())
            {
               return false;
            }
         }
         return true;
      }   

      // check bass voice has only primary chords
      this.bass_primary_chords = function() {
         console.log("bass_primary_chords");

         var cursor = curScore.newCursor();
         //cursor.rewind(0); // beginning of score
         //cursor.voice    = 0;
         //cursor.staffIdx = 0; // 1st staff;
 
         var keysig = cursor.keySignature;
         console.log("keysig: " + keysig);

         var keynote = 0;
         var n       = 0;
         var step    = 0; // quart or fifth up
         if (keysig < 0)
         {
            n    = -keysig;
            step = 5;  // quart
         }
         else
         {
            n    = keysig;
            step = 7;  // fifth
         }
         for (var i=0; i<n; i++)
         {
            keynote += step;
            keynote = keynote % 12;
         }

         console.log("key " + keynote + " " + pitch_to_s(keynote));

         var ncho = this.chords.length;
         var lastbassnote = this.chords[ncho-1].notes[3].pitch;
         console.log("last bass note " + lastbassnote + " " + pitch_to_s(lastbassnote));

         var minorkeynote = keynote - 3; // minor third lower
         if (minorkeynote < 0)
         {
            minorkeynote += 12;
         }
         console.log("minor keynote " + minorkeynote + " " + pitch_to_s(minorkeynote));

         var b1 = 0;
         if (lastbassnote % 12 == minorkeynote)
         {
            this.minor = true;
            b1 = minorkeynote;
            console.log("minor key detected");
         }
         else
         if (lastbassnote % 12 == keynote)
         {
            this.minor = false;
            b1 = keynote;
            console.log("major key detected");
         }
         else
         {
            console.log("last note of bass is neither major nor minor key note");
            Qt.quit();
         }

         var b2 = (b1 + 2) % 12; 
         var b4 = (b1 + 5) % 12; 
         var b5 = (b1 + 7) % 12;
         var b6 = (b1 + 9) % 12;
         if (this.minor)
         {
            // in a minor key degree 6 is only 8
            // half notes higher than the key note
            b6 = (b1 + 8) % 12;
         }

         console.log("b1 " + b1 + " " + pitch_to_s(b1));
         console.log("b2 " + b2 + " " + pitch_to_s(b2));
         console.log("b4 " + b4 + " " + pitch_to_s(b4));
         console.log("b5 " + b5 + " " + pitch_to_s(b5));
         console.log("b6 " + b6 + " " + pitch_to_s(b6));

         for (var i=0; i<this.chords.length; i++)
         {
            var bassnote = this.chords[i].notes[3].pitch % 12;
            console.log("bassnote " + bassnote + " " + pitch_to_s(bassnote));
            
            if (bassnote == b1)
            {
               this.chords[i].degree = 1;
            }
            else
            if (bassnote == b4)
            {
               this.chords[i].degree = 4;
            }
            else
            if (bassnote == b5)
            {
               this.chords[i].degree = 5;
            }
            else
            if (bassnote == b6)
            {
               this.chords[i].degree = 6;
            }
            else
            if (bassnote == b2)
            {
               this.chords[i].degree = 2;
            }
            
            
            
            if (bassnote != b1 && bassnote != b4 && bassnote != b5 && bassnote != b6 && bassnote != b2)
            {
               console.log("wrong bass note, not I, IV, V, VI or II" + b2 + " " + pitch_to_s(b2));

               markColorNote(this.chords[i].notes[3], colorError);
               markTextTick("wrong bass note", this.chords[i].tick);

               return false;
            }
         }
         return true;
      }

      // only triads consisting of 2 ground notes, one third and one fifth
      // are allowed
      this.only_triads = function() {
         console.log("only_triads");

         // determine the number of different notes in the chords
         for (var i=0; i<this.chords.length; i++)
         {
            console.log("   chord");
            var set = {};
            for (var j=0; j<4; j++)
            {
               var no = this.chords[i].notes[j].pitch % 12;
               console.log("      no " + no);
               set[no] = true;
            }
            var len = Object.keys(set).length;
            console.log("      set #" + len);

            if (len != 3)
            {
               console.log("a chord must have exact 3 different notes, you have " + len);
               Qt.quit();
            }
         }


         // the bass has the groundnote of the chord
         // this note must appear twice
         for (var i=0; i<this.chords.length; i++)
         {
            console.log("   chord bis");
            var sop = this.chords[i].notes[0].pitch % 12;
            var alt = this.chords[i].notes[1].pitch % 12;
            var ten = this.chords[i].notes[2].pitch % 12;
            var bas = this.chords[i].notes[3].pitch % 12;
            console.log("      " + sop + " " + alt + " " + ten + " " + bas);

            if (!(sop == bas || alt == bas || ten == bas))
            {
               console.log("the ground note of the chord must appear twice");
               Qt.quit();
            }
         }

         // test for major triad in soprano, alto and tenor
         console.log("chord tris");
         for (var i=0; i<this.chords.length; i++)
         {
            console.log("----------- ch-" + i + "--------------");
            console.log("before any action");
            var triad = new triad_t(this.chords[i]);
            triad.show();

            console.log("after normalize");
            triad.normalize();
            triad.show();

            var matriad = triad.is_majmin_triad(this.minor, this.chords[i].degree);

            if (!matriad)
            {
               console.log("after rotate");
               triad.rotate();
               triad.show();

               //console.log("after normalize");
               //triad.normalize();
               //triad.show();

               matriad = triad.is_majmin_triad(this.minor, this.chords[i].degree);
               if (!matriad)
               {
                  console.log("after rotate2");
                  triad.rotate();
                  triad.show();

                  //console.log("after normalize2");
                  //triad.normalize();
                  //triad.show();

                  matriad = triad.is_majmin_triad(this.minor, this.chords[i].degree);

                  if (!matriad)
                  {
                     console.log("not correct triad");
                     markColorNote(this.chords[i].notes[0], colorError);
                     //markTextTick("is not a correct triad", this.chords[i].tick);

                     return false;
                  }
               }
            }

            if (matriad)
            {
               var wi = triad.is_wide();
               console.log("   wi " + wi);
               this.chords[i].wide = wi;
            }
         }


         return true;
      }

   } // class score_t



   onRun:
   {
      console.log('onRun');
      if (typeof curScore === 'undefined')
      {
         Qt.quit();
      }

      var sco = new score_t();
      //sco.show();
      // only for test
      sco.show_score();

      // Test rule 1
      var nv = sco.get_nr_voices();
      console.log("nv " + nv);

      if (nv == 4)
      {
         // continuing rule 1
         var si = sco.check_single_note_chord();
         console.log("si " + si);

         if (!si)
         {
            msgError.text = "Having more than 1 note in a voice is not allowed";
            msgError.open();

            Qt.quit();
         }
         
         // rule 2
         var nor = sco.check_no_rests();
         console.log("nor " + nor);

         if (!nor)
         {
            msgError.text = "Rests are not allowed";
            msgError.open();

            Qt.quit();
         }

         // rule 3
         var sad = sco.check_same_duration();
         console.log("sad " + sad);

         if (!sad)
         {
            msgError.text = "All notes must have the same duration";
            msgError.open();

            Qt.quit();
         }

         if (si && nor && sad)
         {
            sco.make_chords();
            sco.show_notes();

            // rule 4
            var noc = sco.no_crossing_voices();
            console.log("no crossing voices " + noc);

            if (!noc)
            {
               msgError.text = "Voices cannot cross";
               msgError.open();
               Qt.quit();
            }

            // rule 5
            var prim = sco.bass_primary_chords();
            console.log("prim " + prim);

            if (!prim)
            {
               console.log("use only primary chords");
               Qt.quit();
            }
            else
            {
               console.log("start triadok");
               var triadok = sco.only_triads();
               console.log("triadok " + triadok);
               if (!triadok)
               {
                  console.log("each chord should have exact 3 different notes");
                  Qt.quit();
               }
               sco.show_notes();
            }
         }
      }
      else
      {
         console.log("the score should have 4 voices");
         msgError.text = "Rule 1, the score should have 4 voices";
         msgError.open();
      }
      //msgNoErrors.open();

      Qt.quit();
   } // end onRun
}

