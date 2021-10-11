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
//=============================================================================

//import QtQuick 2.3
//import QtQuick.Controls 1.2
//import QtQuick.Dialogs 1.2
//import QtQuick.Layouts 1.1
//import QtQuick.Controls.Styles 1.3
import MuseScore 1.0
import QtQuick 2.0


MuseScore
{
   menuPath: "Plugins.Chords.Check Primary Chords"
   description: "Check primary chords I, IV and V."
   version: "0.9.0.0"
    
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
      this.ppitch = ppi;    // original pitch
      this.bpitch = ppi%12; // pitch in 0-11 range
      this.voice  = voi;    // voice SOP, ALT or TEN
      this.step   = 1;      // 1, 3 or 5

      console.log("new note_t " + voi);

      this.show = function(base) {
         console.log("      note_t v" + this.voice + " " + this.ppitch + " " + pitch_to_s(this.bpitch) + " base " + (this.ppitch-base));
      }
   }

   // class triad_t()
   function triad_t(co)
   {
      this.notes = [];
      this.notes[0] = new note_t(co.notes[0].ppitch, "SOP");
      this.notes[1] = new note_t(co.notes[1].ppitch, "ALT");
      this.notes[2] = new note_t(co.notes[2].ppitch, "TEN");

      this.show = function() {
         console.log("   triad_t");
         this.notes[0].show(this.notes[2].ppitch);
         this.notes[1].show(this.notes[2].ppitch);
         this.notes[2].show(this.notes[2].ppitch);
      }

      this.rotate = function() {
         this.notes[2].ppitch += 12;
         while (this.notes[2].ppitch < this.notes[0].ppitch)
         {
            this.notes[2].ppitch += 12;
         }
         var tmp = this.notes[2];
         this.notes[2] = this.notes[1];
         this.notes[1] = this.notes[0];
         this.notes[0] = tmp;
      }

      this.sort_on_ppitch = function() {
         var cont = true;
         while (cont)
         {
            cont = false;
            if (this.notes[0].ppitch < this.notes[1].pitch)
            {
               var tmp = this.notes[0];
               this.notes[0] = this.notes[1];
               this.notes[1] = tmp;
               cont = true;
            }
            if (this.notes[1].ppitch < this.notes[2].pitch)
            {
               var tmp = this.notes[1];
               this.notes[1] = this.notes[2];
               this.notes[2] = tmp;
               cont = true;
            }
         }
      }

      this.normalize = function() {
         while (this.notes[1].ppitch-12 > this.notes[2].ppitch)
         {
            this.notes[1].ppitch -= 12;
         }
         while (this.notes[0].ppitch-12 > this.notes[1].ppitch)
         {
            this.notes[0].ppitch -= 12;
         }
         //this.sort_on_ppitch();
      }

      this.is_major_triad = function() {
         var hig = this.notes[0].ppitch;
         var mid = this.notes[1].ppitch;
         var low = this.notes[2].ppitch;

         if (hig-low == 7  && mid-low == 4)
         {
            this.notes[0].step = 5;
            this.notes[1].step = 3;
            this.notes[2].step = 1;
            console.log("is major triad narrow");

            return true;
         }
         else
         if (hig-low == 16 && mid-low == 7)
         {
            this.notes[0].step = 3;
            this.notes[1].step = 5;
            this.notes[2].step = 1;
            console.log("is major triad wide");

            return true;
         }
         else
         {
            return false;
         }
      }

      /*
      this.wide_or_narrow = function() {
         // collect all the steps
         var voic = {};
         voic[this.notes[0].voice] = this.notes[0].step;
         voic[this.notes[1].voice] = this.notes[1].step;
         voic[this.notes[2].voice] = this.notes[2].step;

         console.log("sop step " + voic["SOP"]);
         console.log("alt step " + voic["ALT"]);
         console.log("ten step " + voic["TEN"]);

         if (voic["SOP"] == 3 && voic["ALT"] == 1 || 
             voic["SOP"] == 1 && voic["ALT"] == 5 || 
             voic["SOP"] == 5 && voic["ALT"] == 3)
         {
            console.log("narrow");
         }
         else
         {
            console.log("wide");
         }
      }
       */
   }

   // class chord_t
   function chord_t()
   {
      this.notes = [];

      this.add = function(not) {
         this.notes.push(not);
      }

      this.show = function() {
         console.log("   chord");

         for (var i=0; i<this.notes.length; i++)
         {
             console.log("      note " + this.notes[i].ppitch);
         }
      }

      // chech wether every note is higher then the next
      // of differently said, no crssing between voices
      this.no_crossing_voice = function()
      {
         console.log("no_crossing_voice " + 
            this.notes[0].ppitch + " " +
            this.notes[1].ppitch + " " +
            this.notes[2].ppitch + " " +
            this.notes[3].ppitch);

         var noc =
            this.notes[0].ppitch > this.notes[1].ppitch &&
            this.notes[1].ppitch > this.notes[2].ppitch &&
            this.notes[2].ppitch > this.notes[3].ppitch;

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
                       + " " + notes[j].ppitch + " " + pitch_to_s(notes[j].ppitch)
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
                  console.log("      elementt " + el);
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
      this.get_nr_voices = function() {
         console.log('get_nr_voices');

         console.log('curScore.nstaves: ' + curScore.nstaves);
        
         var nvoices = [];
         for (var i=0; i<4*this.nst; i++)
         {
            nvoices[i] = 0;
         }

         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            console.log("   segment " + segm.tick + " " + elementtype_to_s(segm.type));

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
                        console.log("       " + i + "  note " + elementtype_to_s(notes[j].type) 
                       + " " + notes[j].ppitch + " " + pitch_to_s(notes[j].ppitch));
                     }
                     //if (notes.length > nvoices[i])
                     //{
                     //}
                     nvoices[i] = 1;
                  }
               }
            }
            segm = segm.next;
         }
         
         var nv = 0
         for (var i=0; i<4*this.nst; i++)
         {
            nv += nvoices[i];
         }
         return nv;
      }


      // Checks whether each chord has a single note
      this.check_single_note_chord = function() {
         console.log('check_single_note_chord');

         var segm = curScore.firstSegment();
         while (segm)
         {  //loop through the selection
            console.log("   segment " + segm.tick + " " + elementtype_to_s(segm.type));

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
            console.log("   p1 segment " + segm.tick + " " + elementtype_to_s(segm.type));

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
            console.log("   p2 segment " + segm.tick + " " + elementtype_to_s(segm.type));

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
            console.log("   s1 segment " + segm.tick + " " + elementtype_to_s(segm.type));

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
            console.log("   s2 segment " + segm.tick + " " + elementtype_to_s(segm.type));
            console.log("      segmenttype " + segm.segmentType);

            if (segm.segmentType == Segment.ChordRest)  // 128 is probably Segment.ChordRest
            {
               for (var i=0; i<4*this.nst; i++)
               {
                  console.log("      " + i + " hasvoice " + hasvoice[i]); 
                  var el = segm.elementAt(i);
                  if (el == null && hasvoice[i])
                  {
                     return false;
                  }
               }
            }
            else
            {
               console.log("      no chord in this segment");
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
            console.log("   m segment " + segm.tick + " " + elementtype_to_s(segm.type));

            if (segm.segmentType == Segment.ChordRest)  // 128 is probably Segment.ChordRest
            {
               var co = new chord_t();
               this.chords.push(co);

               for (var i=0; i<4*this.nst; i++)
               {
                  var el = segm.elementAt(i);
                  if (el != null)
                  {
                     if (el.type == Element.CHORD)
                     {
                        console.log("      add note");   
                        var notes = el.notes;
                        co.add(notes[0]);
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
            console.log("   noc " + i);
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
         var lastbassnote = this.chords[ncho-1].notes[3].ppitch;
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

         var b4 = (b1 + 5) % 12; 
         var b5 = (b1 + 7) % 12;

         console.log("b1 " + b1 + " " + pitch_to_s(b1));
         console.log("b4 " + b4 + " " + pitch_to_s(b4));
         console.log("b5 " + b5 + " " + pitch_to_s(b5));

         for (var i=0; i<this.chords.length; i++)
         {
            var bassnote = this.chords[i].notes[3].ppitch % 12;
            console.log("bassnote " + bassnote + " " + pitch_to_s(bassnote));
            if (bassnote != b1 && bassnote != b4 && bassnote != b5)
            {
               console.log("wrong bass note, not I, IV or V " + b5 + " " + pitch_to_s(b5));
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
               var no = this.chords[i].notes[j].ppitch % 12;
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
            var sop = this.chords[i].notes[0].ppitch % 12;
            var alt = this.chords[i].notes[1].ppitch % 12;
            var ten = this.chords[i].notes[2].ppitch % 12;
            var bas = this.chords[i].notes[3].ppitch % 12;
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

            var matriad = triad.is_major_triad();

            if (!matriad)
            {
               console.log("after rotate");
               triad.rotate();
               triad.show();

               console.log("after normalize");
               triad.normalize();
               triad.show();

               matriad = triad.is_major_triad();
               if (!matriad)
               {
                  console.log("after rotate2");
                  triad.rotate();
                  triad.show();

                  console.log("after normalize2");
                  triad.normalize();
                  triad.show();

                  matriad = triad.is_major_triad();

                  if (!matriad)
                  {
                     return false;
                  }
                  //triad.wide_or_narrow();
               }
               //triad.wide_or_narrow();
            }
            //triad.wide_or_narrow();
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
      sco.show_score();

      var nv = sco.get_nr_voices();
      console.log("nv " + nv);

      if (nv == 4)
      {
         var si = sco.check_single_note_chord();
         console.log("si " + si);

         var nor = sco.check_no_rests();
         console.log("nor " + nor);

         var sad = sco.check_same_duration();
         console.log("sad " + sad);

         if (si && nor && sad)
         {
            sco.make_chords();
            sco.show_notes();

            var noc = sco.no_crossing_voices();
            console.log("no crossing voices " + noc);

            if (!noc)
            {
               Qt.quit();
            }

            var prim = sco.bass_primary_chords();
            console.log("prim " + prim);

            if (!prim)
            {
               console.log("use only primary chords");
               Qt.quit();
            }

            var triadok = sco.only_triads();
            console.log("triadok " + triadok);
            if (!triadok)
            {
               console.log("each chord should have exact 3 different notes");
               Qt.quit();
            }
         }
      }
      else
      {
         console.log("the score should have 4 voices");
      }

      Qt.quit();
   } // end onRun
}

