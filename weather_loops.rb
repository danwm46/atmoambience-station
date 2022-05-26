#set :tempo, 120 # sets tempo in BPM
#set :key, 69  # sets pitch center #1 in MIDI vlaue (0-127)
#set :key2, 57 # sets pitch center #2 in MIDI vlaue (0-127)
#set :key3, 69 # sets pitch center #3 in MIDI vlaue (0-127)
seed = get[:seed] # pulls random seed value from external python program
use_random_seed seed  # sets random seed value
tempo = get[:tempo] # pulls tempo value from external python program
use_bpm tempo # matches project BPM to tempo value

key1 = get[:key]  # pulls pitch center #1 value from external python program
key2 = get[:key2] # pulls pitch center #2 value from external python program
key3 = get[:key3] # pulls pitch center #3 value from external python program
k = key1 # sets pitch center #1 to independent variable
k2 = key2 # sets pitch center #2 to independent variable
#k3 = key1 + 12
k3 = key3 # sets pitch center #3 to independent variable

set :blips, (ring k+4, k+7, k+12, k+14, k+19, k+23) # pitches for pad A
set :dings, (ring k2+7, k2+9, k2+11, k2+14, k2+16, k2+19) # pitches for pad B
set :plucks, (ring k2+24, k2+26, k2+28, k2+31, k2+33, k2+35) # pitches for "piano"
set :low, (ring k-24,k-19,k-17,k-12, k-7, k-5, k) # pitches for bass
#set :low, (ring k-24, k-22,k-20,k-19,k-17,k-15,k-13,k-12,k-24,k-19,k-17,k-12)
set :rplucks, (ring k2+24, :r, k2+26, :r, k2+28, :r, k2+31, :r, k2+33, :r, k2+35, :r, :r)
set :pRests, [0.5,1,1.25,1.5,1.75,2] # rests for piano
set :flanger, 0
set :reverb, 0
set :cutoff, 131
set :resonance, 0
set :density, (ring 4, 1, 1, 3, 9) # adsr

set :synths, [:hollow, :growl, :pretty_bell, :prophet, :kalimba,
                :mod_beep, :subpulse, :blade, :sine]

set :notes, (ring k+9,k+11,k+12,k+14,k+16,k+17,k+19,k+21,k+23,k+24,:r) # pitches for synth lead
set :chrdrsts, [6, 5, 3, 2] # durations for harmonies

set :chrdz, (ring k-10, k-8, k-7, k-5, k-4, k-3, k-1, k, k+2, k+4, k+7, k+9, k+12, k+14) # pitches for harmonies
shr = get[:chrdz]
set :chrdz2, (ring k3-10, k3-8, k3-7, k3-5, k3-4, k3-3, k3-1, k3, k3+2, k3+4, k3+7, k3+9, k3+12, k3+14)
shr2 = get[:chrdz2]
chrd1 = [shr[5], shr[7], shr[10]] # -la do sol
chrd2 = [shr[6], shr[8], shr[9]] # ti re mi
chrd3 = [shr[3], shr[9], shr[13]] # -sol mi +re
chrd4 = [shr[2], shr[9], shr[12]] # -fa mi +do
chrd5 = [shr[4], shr[7], shr[10]] # -le do sol
#chrd5 = [shr[5], shr[7], shr[10]] # -la do sol
chrd6 = [shr[3], shr[7], shr[8]] # -sol do re
chrd7 = [shr[0], shr[6], shr[11]] # -re ti la
chrd8 = [shr[1], shr[8], shr[10]] # -mi re sol
hrmz = [chrd1, chrd2, chrd3, chrd4, chrd5, chrd6, chrd7, chrd8]
#susus = [6, 5, 3, 2]

chrd11 = [shr2[5], shr2[7], shr2[10]] # -la do sol
chrd22 = [shr2[6], shr2[8], shr2[9]] # ti re mi
chrd33 = [shr2[3], shr2[9], shr2[13]] # -sol mi +re
chrd44 = [shr2[2], shr2[9], shr2[12]] # -fa mi +do
chrd55 = [shr2[4], shr2[7], shr2[10]] # -le do sol
#chrd5 = [shr[5], shr[7], shr[10]] # -la do sol
chrd66 = [shr2[3], shr2[7], shr2[8]] # -sol do re
chrd77 = [shr2[0], shr2[6], shr2[11]] # -re ti la
chrd88 = [shr2[1], shr2[8], shr2[10]] # -mi re sol
hrmz2 = [chrd11, chrd22, chrd33, chrd44, chrd55, chrd66, chrd77, chrd88]

susus = get[:chrdrsts]

b = get[:blips]
d = get[:dings]
p = get[:plucks]
p3 = get[:rplucks]
bass = get[:low]
fl = get[:flanger]
rvb = get[:reverb]
adsr = get[:density]

live_loop :seed1 do # sets random seed value
  use_real_time
  val = sync "/osc*/seed"
  puts val[0]
  set :seed,val[0]
end

live_loop :tonality0 do # sets pitches to pent
  use_real_time
  val = sync "/osc*/pent"
  set :blips, (ring k+4, k+7, k+12, k+14, k+19, k+21)
  set :dings, (ring k2-5, k2-3, k2+2, k2+4, k2+7) #k2+7, k2+9, k2+11, k2+14, k2+16, k2+19)
  set :plucks, (ring k2+24, k2+26, k2+28, k2+31, k2+33, k2+36)
  set :low, (ring k-12, k-7, k-5, k) #k-24, k-22,k-20,k-19,k-17,k-15,k-12,k-13,k-24,k-19,k-17,k-12
  set :rplucks, (ring k2+24, :r, k2+26, :r, k2+28, :r, k2+31, :r, k2+33, :r, k2+36, :r)
  set :notes, (ring k+9,k+12,k+14,k+16,k+19,k+21,k+24,:r)
  set :chrdz, (ring k-10, k-8, k-5, k-5, k-3, k-3, k, k, k+2, k+4, k+7, k+9, k+12, k+14)
end

live_loop :tonality1 do # sets pitches to maj
  use_real_time
  val = sync "/osc*/major"
  set :blips, (ring k+4, k+7, k+12, k+14, k+19, k+23)
  set :dings, (ring k2-5, k2-3, k2+2, k2+4, k2+7) #k2+7, k2+9, k2+11, k2+14, k2+16, k2+19
  set :plucks, (ring k2+24, k2+26, k2+28, k2+31, k2+33, k2+35)
  set :low, (ring k-24,k-19,k-17,k-12, k-7, k-5, k) #k-24, k-22,k-20,k-19,k-17,k-15,k-12,k-13,k-24,k-19,k-17,k-12
  set :rplucks, (ring k2+24, :r, k2+26, :r, k2+28, :r, k2+31, :r, k2+33, :r, k2+35, :r)
  set :notes, (ring k+9,k+12,k+14,k+16,k+19,k+21,k+24,:r)
  set :chrdz, (ring k-10, k-8, k-7, k-5, k-4, k-3, k-1, k, k+2, k+4, k+7, k+9, k+12, k+14)
end

live_loop :tonality2 do # sets pitches to min
  use_real_time
  val = sync "/osc*/minor"
  set :blips, (ring k+3, k+7, k+12, k+14, k+19, k+22)
  set :dings, (ring k2-5, k2-4, k2+2, k2+3, k2+5) #k2+7, k2+8, k2+10, k2+14, k2+15, k2+19
  set :plucks, (ring k2+24, k2+26, k2+27, k2+31, k2+32, k2+34)
  set :low, (ring k-24, k-22,k-21,k-19,k-17,k-16,k-14,k-12,k-24,k-19,k-17,k-12)
  set :rplucks, (ring k2+24, :r, k2+26, :r, k2+27, :r, k2+31, :r, k2+32, :r, k2+34, :r, :r)
  set :notes, (ring k+8,k+11,k+12,k+14,k+15,k+16,k+17,k+19,k+20,k+21,k+23,k+24,:r)
  set :chrdz, (ring k-10, k-9, k-7, k-5, k-4, k-4, k-2, k, k+2, k+3, k+7, k+8, k+12, k+14)
end

live_loop :synths_low do
  use_real_time
  val = sync "/osc*/synth_low"
  set :synths, [:pluck, :dark_ambience, :blade, :piano, :kalimba,
                  :mod_beep, :subpulse, :pluck, :sine]
end

live_loop :synths_mid do
  use_real_time
  val = sync "/osc*/synth_mid"
  set :synths, [:hollow, :growl, :pretty_bell, :prophet, :kalimba,
                  :mod_beep, :subpulse, :blade, :sine]
end

live_loop :synths_hi do
  use_real_time
  val = sync "/osc*/synth_hi"
  set :synths, [:hollow, :growl, :pretty_bell, :prophet, :kalimba,
                  :chiplead, :hoover, :blade, :subpulse]
end


live_loop :pressure_density0 do # sets adsr to widest
  use_real_time
  val = sync "/osc*/dense0"
  set :density, (ring 12, 4, 4, 18, 12)
  set :pRests, [4,8,10,12,14,16]
  set :chrdrsts, [12, 10, 6, 4]
end

live_loop :pressure_density1 do # sets adsr to wide
  use_real_time
  val = sync "/osc*/dense1"
  set :density, (ring 9, 3, 3, 14, 9)
  set :pRests, [3,6,8,9,10,12]
  set :chrdrsts, [8, 6, 4, 3]
end

live_loop :pressure_density2 do # sets adsr to narrow
  use_real_time
  val = sync "/osc*/dense2"
  set :density, (ring 6, 2, 2, 9, 6)
  set :pRests, [2,4,5,6,7,8]
  set :chrdrsts, [6, 5, 3, 2]
end

live_loop :pressure_density3 do # sets adsr to narrowest
  use_real_time
  val = sync "/osc*/dense3"
  set :density, (ring 3, 1, 1, 4.5, 3)
  set :pRests, [1,2,2.5,3,3.5,4]
  set :chrdrsts, [3, 2.5, 1.5, 1]
end

live_loop :keys1 do # sets pitch center 1
  use_real_time
  val = sync "/osc*/key"
  puts val[0]
  set :key,val[0]
end

live_loop :keys2 do # sets pitch center 2
  use_real_time
  val = sync "/osc*/key2"
  puts val[0]
  set :key2,val[0]
end

live_loop :keys3 do # sets pitch center 3
  use_real_time
  val = sync "/osc*/key3"
  puts val[0]
  set :key3,val[0]
end

live_loop :tempo1 do # sets tempo
  use_real_time
  val = sync "/osc*/tempo"
  puts val[0]
  set :tempo,val[0]
end

live_loop :fx1 do # sets flanger
  use_real_time
  val = sync "/osc*/flanger"
  puts val[0]
  set :flanger,val[0]
end

live_loop :fx2 do # sets reverb
  use_real_time
  val = sync "/osc*/reverb"
  puts val[0]
  set :reverb,val[0]
end

live_loop :fx3 do # sets cutoff
  use_real_time
  val = sync "/osc*/cutoff"
  puts val[0]
  set :cutoff,val[0]
end

live_loop :fx4 do # sets resonance
  use_real_time
  val = sync "/osc*/resonance"
  puts val[0]
  set :resonance,val[0]
end

live_loop :p00 do
  toggle_00_state = sync "/osc*/rain"
  set :t00, toggle_00_state[0] # 1 if pushed 0 when released
  do_rain if toggle_00_state[0]==1
end

live_loop :p0 do
  toggle_0_state = sync "/osc*/piano"
  set :t0, toggle_0_state[0] # 1 if pushed 0 when released
  do_piano_plucks if toggle_0_state[0]==1
end

live_loop :p1 do
  toggle_1_state = sync "/osc*/padA"
  set :t1, toggle_1_state[0] # 1 if pushed 0 when released
  if one_in(2)
    do_copland_pad if toggle_1_state[0]==1
    print "cop"
  else
    if one_in(2)
    do_harmonies if toggle_1_state[0]==1
    print "har"
    else
    do_harmoniesAlt if toggle_1_state[0]==1
    print "harmoniesAlt"
    end
  end
end

live_loop :p11 do
  toggle_11_state = sync "/osc*/padB"
  set :t11, toggle_11_state[0]
  if one_in(6)
    do_harmonies if toggle_11_state[0]==1
    print "har"
  else
    do_bell_pad if toggle_11_state[0]==1
  end
end

live_loop :p2 do
  toggle_2_state = sync "/osc*/bass"
  set :t2, toggle_2_state[0]
  do_bass_loop if toggle_2_state[0]==1
end

live_loop :p3 do
  toggle_3_state = sync "/osc*/melody"
  set :t3, toggle_3_state[0]
  do_synth_lead if toggle_3_state[0]==1
end

live_loop :p5 do
  toggle_5_state = sync "/osc*/chirp"
  set :t5, toggle_5_state[0]
  do_chirp_run if toggle_5_state[0]==1
end

live_loop :p55 do
  toggle_55_state = sync "/osc*/min_chirp"
  set :t55, toggle_55_state[0]
  do_min_chirp_run if toggle_55_state[0]==1
end

live_loop :p6 do
  toggle_6_state = sync "/osc*/brit"
  set :t6, toggle_6_state[0]
  do_brit_pluck if toggle_6_state[0]==1
end

live_loop :p7 do
  toggle_7_state = sync "/osc*/riff"
  set :t7, toggle_7_state[0]
  do_brit_riff if toggle_7_state[0]==1
end

live_loop :p77 do
  toggle_77_state = sync "/osc*/min_riff"
  set :t77, toggle_77_state[0]
  do_min_brit_riff if toggle_77_state[0]==1
end

define :do_rain do
  set :kill00,false
  tempo = get[:tempo]
  use_bpm tempo
  use_synth :pnoise
  live_loop :rain do
    play 60, amp: 0.1, attack: 3, decay: 6, sustain: 1, release: 5
    sleep 10
    in_thread do
      loop do
        if get(:t00)==0
          #kill s1
          set :kill00,true
          stop
        end
        sleep 1
      end
    end
    1.times do
      #s1
      sleep 1
      stop if get(:kill00)
    end
  end
end

define :do_piano_plucks do
  set :kill0,false
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
  use_synth synth[0] #:hollow
  with_fx :reverb, room: rvb do
    with_fx :echo do
      with_fx :rlpf, cutoff: ctf, res: rzz do
        with_fx :rlpf, cutoff: 100, res: 0.6 do
          live_loop :control_piano_plucks do
            p = get[:plucks]
            pr = get[:pRests]
            n = pr.choose
            s0 = play p.choose, decay: 1, sustain: n, amp: 0.2
            sleep n
            in_thread do #in a thread poll for button up cue (:C1=>0)
              loop do
                if get(:t0)==0 #if button up cue then
                  #kill s0 #kill the sample pointed to by the s1 reference
                  set :kill0,true #set kill1 flag true
                  stop # quit loop
                end
                sleep 1 #time between checks for button up cue
              end
            end
            4.times do
              s0
              sleep 1
              stop if get(:kill0)
            end
          end
        end
      end
    end
  end #of live loop
end #of function

define :do_copland_pad do
  set :kill1,false
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  live_loop :control_copland_pad do
    use_synth synth[1]#[:growl, :dark_ambience].choose
    fl=get[:flanger]
    ctf = get[:cutoff]
    rzz = get[:resonance]
    with_fx :rlpf, cutoff: ctf, res: rzz do
      with_fx :flanger, mix: fl, phase: 0.75 do
        b = get[:blips]
        bmod = shuffle b
        adsr = get[:density]
        print adsr[0], adsr[1], adsr[2], adsr[3], adsr[4]
        s1 = play bmod.tick, amp: 0.2, attack: adsr[0], decay: adsr[1], sustain: adsr[2], release: adsr[3],  cutoff: 90, res: 0.6
        sleep adsr[4]
        in_thread do
          loop do
            if get(:t1)==0
              #kill s1
              set :kill1,true
              stop
            end
            sleep 1
          end
        end
        1.times do
          #s1
          sleep 1
          stop if get(:kill1)
        end
      end
    end
  end #of live loop
end #of function

define :do_harmonies do
  set :kill1, false
  tempo = get[:tempo]
  use_bpm tempo
  live_loop :control_harmonies do
    fl=get[:flanger]
    ctf = get[:cutoff]
    rzz = get[:resonance]
    with_fx :rlpf, cutoff: ctf, res: rzz do
      with_fx :flanger, mix: fl, phase: 0.75 do
        with_fx :compressor, amp: 0.8 do
          harmonies
          #sleep 2
          in_thread do
            loop do
              if get(:t1)==0
                set :kill1,true
                stop
              end
              sleep 1
            end
          end
          1.times do
            sleep 1
            stop if get(:kill1)
          end
        end
      end
    end
  end
end

define :do_harmoniesAlt do
  set :kill1, false
  tempo = get[:tempo]
  use_bpm tempo
  live_loop :control_harmonies do
    fl=get[:flanger]
    ctf = get[:cutoff]
    rzz = get[:resonance]
    with_fx :rlpf, cutoff: ctf, res: rzz do
      with_fx :flanger, mix: fl, phase: 0.75 do
        with_fx :compressor, amp: 0.4 do
          with_fx :hpf, cutoff: 50 do
            with_fx :reverb, mix: 0.6, room: 0.8 do
              harmoniesAlt
              in_thread do
                loop do
                  if get(:t1)==0
                    set :kill1,true
                    stop
                  end
                  sleep 1
                end
              end
              1.times do
                sleep 1
                stop if get(:kill1)
              end
            end
          end
        end
      end
    end
  end
end

define :do_bell_pad do
  set :kill11, false
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  live_loop :control_bell_pad do
    use_synth synth[2]
    fl=get[:flanger]
    ctf = get[:cutoff]
    rzz = get[:resonance]
    with_fx :rlpf, cutoff: ctf, res: rzz do
      with_fx :flanger, mix: fl, phase: 0.75 do
        d = get[:dings]
        dmod = shuffle d
        ss1 = play dmod.choose, amp: 0.03, attack: 1, decay: 5, sustain: 2
        sleep 1
        in_thread do
          loop do
            if get(:t11)==0
              #kill ss1
              set :kill11,true
              stop
            end
            sleep 1
          end
        end
        1.times do
          #s1
          sleep 1
          stop if get(:kill11)
        end
      end
    end
  end
end


define :do_bass_loop do
  set :kill2, false
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  use_synth synth[3]
  live_loop :control_bass_loop do
    bass = get[:low]
    s4 = play bass.choose, amp: 0.2, attack: 2, decay: 6, sustain: 2, cutoff: 65, res: 0.6
    sleep 4
    in_thread do
      loop do
        if get(:t2)==0
          #kill s4
          set :kill2,true
          stop
        end
        sleep 1
      end
    end
    1.times do
      sleep 1
      stop if get(:kill2)
    end
  end
end

define :do_synth_lead do
  set :kill3, false
  tempo = get[:tempo]
  use_bpm tempo
  live_loop :control_synth_lead do
    fl=get[:flanger]
      with_fx :flanger, mix: fl, phase: 0.75 do
      with_fx :compressor, pre_amp: 1.5, threshold: 0.1 do
        with_fx :tanh, mix: 0.25, krunch: 3 do
          with_fx :rlpf, cutoff: 55, res: 0.7 do
            with_fx :reverb do
              with_fx :ping_pong, mix: 0.5, phase: 0.5, feedback: 0.75 do
                melody
                sleep 8
                in_thread do
                  loop do
                    if get(:t3)==0
                      #kill s4
                      set :kill3,true
                      stop
                    end
                    sleep 1
                  end
                end
                1.times do
                  melody
                  sleep 1
                  stop if get(:kill3)
                end
              end
            end
          end
        end
      end
    end
  end
end


define :do_chirp_run do
  set :kill5, false
  tempo = get[:tempo]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
  with_fx :rlpf, cutoff: ctf, res: rzz do
    with_fx :reverb, room: rvb do
      with_fx :flanger, phase: 6 do
        with_fx :ping_pong do
          live_loop :control_chirps do
            chirp_run
            in_thread do #in a thread poll for button up cue (:C1=>0)
              loop do
                if get(:t5)==0 #if button up cue then
                  #kill s5 #kill the sample pointed to by the s1 reference
                  set :kill5,true #set kill1 flag true
                  stop # quit loop
                end
                sleep 1 #time between checks for button up cue
              end
            end
            1.times do
              chirp_run
              #s3
              sleep 1
              stop if get(:kill5)
            end
          end
        end
      end
    end
  end
end

define :do_min_chirp_run do
  set :kill55, false
  tempo = get[:tempo]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
  with_fx :rlpf, cutoff: ctf, res: rzz do
    with_fx :reverb, room: rvb do
      with_fx :flanger, phase: 6 do
        with_fx :ping_pong do
          live_loop :control_min_chirps do
            min_chirp_run
            in_thread do #in a thread poll for button up cue (:C1=>0)
              loop do
                if get(:t55)==0 #if button up cue then
                  #kill s5 #kill the sample pointed to by the s1 reference
                  set :kill55,true #set kill1 flag true
                  stop # quit loop
                end
                sleep 1 #time between checks for button up cue
              end
            end
            1.times do
              min_chirp_run
              #s3
              sleep 1
              stop if get(:kill55)
            end
          end
        end
      end
    end
  end
end

define :do_brit_pluck do
  set :kill6, false
  tempo = get[:tempo]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
  with_fx :rlpf, cutoff: ctf, res: rzz do
    with_fx :reverb, room: rvb do
      with_fx :panslicer, phase: 2, wave: 3 do
        live_loop :control_brit do
          brit_pluck
          in_thread do #in a thread poll for button up cue (:C1=>0)
            loop do
              if get(:t6)==0 #if button up cue then
                #kill s6 #kill the sample pointed to by the s1 reference
                set :kill6,true #set kill1 flag true
                stop # quit loop
              end
              sleep 1 #time between checks for button up cue
            end
          end
          1.times do
            brit_pluck
            #s3
            sleep 2
            stop if get(:kill6)
          end
        end
      end
    end
  end
end

define :do_brit_riff do
  set :kill7, false
  tempo = get[:tempo]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
    with_fx :rlpf, cutoff: ctf, res: rzz do
    with_fx :reverb, room: rvb do
      with_fx :tanh, amp: 0.5, mix: 0.5, krunch: 3 do
        with_fx :ping_pong do
          live_loop :control_brit_riff do
            brit_riff
            sleep 8
            in_thread do
              loop do
                if get(:t7)==0
                  set :kill7,true
                  stop
                end
                sleep 1
              end
            end
            1.times do
              brit_riff
              sleep 1
              stop if get(:kill7)
            end
          end
        end
      end
    end
  end
end

define :do_min_brit_riff do
  set :kill77, false
  tempo = get[:tempo]
  use_bpm tempo
  rvb = get[:reverb]
  ctf = get[:cutoff]
  rzz = get[:resonance]
  with_fx :rlpf, cutoff: ctf, res: rzz do
    with_fx :reverb, room: rvb do
      with_fx :tanh, amp: 0.5, mix: 0.5, krunch: 3 do
        with_fx :ping_pong do
          live_loop :control_min_brit_riff do
            min_brit_riff
            sleep 8
            in_thread do
              loop do
                if get(:t77)==0
                  set :kill77,true
                  stop
                end
                sleep 1
              end
            end
            1.times do
              min_brit_riff
              stop if get(:kill77)
              sleep 1
            end
          end
        end
      end
    end
  end
end

define :chirp_run do
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  use_synth synth[4]
  1.times do
    play k, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+2, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+4, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+7, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    sleep 4
    play k+14, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+16, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+19, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
    play k+21, amp: 0.5, sustain: 0.5, cutoff: 100, res: 0.5, detune: 12
    sleep 1
  end
  sleep 8
end

define :min_chirp_run do
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  use_synth synth[4]
  1.times do
    play k, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+2, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+3, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+7, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    sleep 4
    play k+14, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+15, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+19, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
    play k+20, amp: 0.5, sustain: 0.5, cutoff: 70, res: 0.5, detune: 12
    sleep 1
  end
  sleep 8
end

define :brit_pluck do
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  use_synth synth[0]
  pl = (p.choose)
  play pl, release: 0.75
  sleep 0.5
  play (pl-12), decay: 0.75, sustain: 1, release: 6
  sleep 7.5
end

define :brit_riff do
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  key1 = get[:key]
  key2 = get[:key2]
  k = key1
  k2 = key2
  use_synth synth[5]
  1.times do
    play k2, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+7, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+5, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+12, amp: 0.15, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 4
    play k, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+7, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+5, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+14, amp: 0.15, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    sleep 16
  end
  sleep 2
end

define :min_brit_riff do
  tempo = get[:tempo]
  synth = get[:synths]
  use_bpm tempo
  key1 = get[:key]
  key2 = get[:key2]
  k = key1
  k2 = key2
  use_synth synth[5]
  1.times do
    play k2, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+7, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+5, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k2+12, amp: 0.15, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 4
    play k, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+7, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+5, amp: 0.125, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    play k+10, amp: 0.15, release: 1.5, mod_phase: 1.5, mod_range: 12, cutoff: 70
    sleep 2
    sleep 16
  end
  sleep 2
end

define :melody do
  synth = get[:synths]
  use_synth synth[7]
  pitches = get[:notes]
  z = shuffle pitches
  durz = [1,1,1,1,2,2,2,3,3,4,5,6]
  dz = shuffle durz
  8.times do
    n = (z.tick)
    dzz = dz.tick
    print dzz
    play n, sustain: dzz, amp: 0.85, release: 1
    sleep dzz
  end
end

define :harmonies do
  synth = get[:synths]
  use_synth synth[6]
  susus = get[:chrdrsts]
  grrr = shuffle susus
  print grrr
  brrr = shuffle hrmz
  print brrr
  play_chord brrr[0], attack: 1, sustain: grrr[0], release: 1, amp: 0.2, cutoff: 85, pulse_width: 0.75
  sleep grrr[0]
  play_chord brrr[1], attack: 1, sustain: grrr[1], release: 1, amp: 0.2,  cutoff: 85, pulse_width: 0.75
  sleep grrr[1]
  play_chord brrr[2], attack: 1, sustain: grrr[2], release: 1, amp: 0.2,  cutoff: 85, pulse_width: 0.75
  sleep grrr[2]
  play_chord brrr[3], attack: 1, sustain: grrr[3], release: 1, amp: 0.2,  cutoff: 85, pulse_width: 0.75
  sleep grrr[3]
end

define :harmoniesAlt do
  synth = get[:synths]
  use_synth synth[8]
  susus = get[:chrdrsts]
  grrr = shuffle susus
  print grrr
  brrr = shuffle hrmz2
  print brrr
  grrr[0].times do
    play_pattern brrr[0], (0.5), attack: 0.25, amp: 0.2, sustain: 1.5, cutoff: 60, pulse_width: 0.75
  end
  grrr[1].times do
    play_pattern brrr[1], (0.5), attack: 0.25, amp: 0.2, sustain: 1.5, cutoff: 60, pulse_width: 0.75
  end
  grrr[2].times do
    play_pattern brrr[2], (0.5), attack: 0.25, amp: 0.2, sustain: 1.5, cutoff: 60, pulse_width: 0.75
  end
  grrr[3].times do
    play_pattern brrr[3], (0.5), attack: 0.25, amp: 0.2, sustain: 1.5, cutoff: 60, pulse_width: 0.75
  end
end
