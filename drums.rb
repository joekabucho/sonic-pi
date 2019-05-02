# 'waking up finally v05' Sonic Pi 2.11 dev
# Alexandre rANGEL www.quasecinema.org

set_volume! 1.1
set_sched_ahead_time! 3

#http://www.freesound.org/people/modularsamples/sounds/279656/
sine = '/Users/rangel/Documents/SamplesPi/sine-b6-95.aiff'
#http://www.freesound.org/people/caculo/sounds/347040/
rooster = '/Users/rangel/Documents/SamplesPi/rooster.wav'
#http://www.freesound.org/people/thecityrings/sounds/174162/
rings = '/Users/rangel/Documents/SamplesPi/ring.wav'



y = 0
live_loop :b6 do
  with_fx :band_eq, freq: rrand(20,50), freq_slide: 2, db: rrand(1,2.4) do
    s = sample sine, amp: 2, rate: 0.25 / 2
    16.times do
      control s,
        hpf: (ring 40,120)[y],hpf_slide: (ring 0.5,0.25,0.5,1)[y/4]
      sleep 0.5
      y = y + 1
    end
  end
  sleep 16
end

with_fx :compressor, slope_below: 5, slope_below: 0.7, threshold: 0.8 do
  live_loop :rooster do
    with_fx :pitch_shift, pitch: rrand(-6,0), window_size: rrand(0.001,0.01), mix: 0.5 do
      with_fx :pitch_shift, pitch: rrand(-8,4), window_size: rrand(0.0001,0.01) do
        with_fx :octaver, mix: 0.33 do
          sample rooster, start: 0.04, amp: 1.333,
            rate: rrand(0.9,1.03), pan: -0.8 if one_in([3,2].choose)
        end
      end
      with_fx :pitch_shift, pitch: rrand(-8,4), window_size: rrand(0.01,0.1) do
        with_fx :octaver, mix: 0.33 do
          sample rooster, start: 0.04, amp: 1.333,
            rate: rrand(0.91,1.03), pan: 0.8 if one_in([2,3].choose)
        end
      end
      with_fx :pitch_shift, pitch: rrand(-8,4), window_size: rrand(0.001,0.01) do
        with_fx :octaver, mix: 0.66 do
          sample rooster, start: 0.04, amp: 1.4, rate: rrand(0.9,1.1) * 0.5 * [-1,1].choose,
            pan: [-1,1].choose, pan_slide: [1,2,4].choose if one_in(2)
        end
      end
    end
    sleep 8
  end
end

x = 0
live_loop :drums do
  with_fx :level, amp: 0.9 do
    sample :tabla_ghe2, amp: ring(2,0,1,0) [x]
    #sample :tabla_ghe5, amp: ring(2,0,0,0, 2,0,2,0, 2,0,0,0, 2,2,2,1)[x] #sr
    sample :tabla_dhec, amp: ring(0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0)[x] #ch
    sample :tabla_ke3,  amp: ring(0,1,0,0, 0,1,0,1, 0,1,0,0, 0,1,1,1)[x], pan: -1 #oh
    #sample :tabla_na_o, amp: ring(0,0,0,0, 0,0,0,0, 1,0,1,1, 0,0,0,0)[x] #cp
    sample :tabla_tas2, amp: ring(0,0,1,1, 0,0,0,0, 0,0,0,0, 1,1,1,1)[x] #cp
    #sample :tabla_te_ne,amp: ring(0,0,0,0, 1,2,1,2, 0,0,0,0, 0,0,0,0,)[x] #cp
  end
  x = x + 1
  sleep 0.25
end

live_loop :drums2 do
  sleep 4
  8.times do
    with_fx :slicer, phase: 1.0/8, pulse_width: rrand(0.85,0.95) do
      with_fx :bitcrusher, bits: rrand(5,9) do
        sample :drum_snare_soft, amp: rrand(0.6,0.8), rate: rrand(0.43,0.45)
      end
    end
    sleep (ring 0.25,0.25,0.5).tick
  end
end

live_loop :rings do
  z = tick
  with_fx :pitch_shift, pitch: (ring -6,-12,6,-6)[z], mix: 0.7 do
    sample rings, rate: (ring 0.2,0.1)[z], amp: 0.66, start: 0.01, pan: -1
  end
  with_fx :pitch_shift, pitch: (ring 6,12,6,-6)[z], mix: 0.7 do
    sample rings, rate: (ring 0.2,0.1)[z], amp: 0.66, start: 0.01, pan: 1
  end
  sleep 16
end


