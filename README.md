**preview**
[https://github.com/Gizmo199/audio-tempo/assets/25496262/2df10800-10dc-45ff-b85e-15e9cfcc47e5]


# audio_tempo_*
A very simple set of audio tempo control functions for Game Maker Studio 2
---

Below is the list of functions included for managing tempos, getting pulses, and queuing sounds / functions. Tempos use *time sources* so they **MUST** be cleaned up manually to prevent memory leaks.

`audio_tempo_create(bpm)`<br/>
takes in a number that sets the beats per minute and returns a tempo id struct. Tempos automatically begin updating once created<br/><br/>

`audio_tempo_destroy(tempo_id)`<br/>
This will cleanup any tempo you have created<br/><br/>

`audio_tempo_pulse(tempo_id)`<br/>
This will return **true** if a beat has occured or **false** if not<br/><br/>

`audio_tempo_queue_method(tempo_id, method)`<br/>
This will set it so that a function will be automatically called on the next available down beat of the tempo<br/><br/>

`audio_tempo_queue_sound(tempo_id, sound_id, [priority=1], [loop=false], [pitch=1], [gain=1])`<br/>
This will set it so that a sound will automatically be played (resumed) on the next available down beat of the tempo. It effectively functions the same as **audio_play_sound** and returns and audio_id.<br/><br/>

---

Example:
```gml

// Create event
tempo = audio_tempo_create(120);
audio_tempo_queue_sound(tempo, snd_main_music);

// Step event
if ( audio_tempo_pulse(tempo) ) show_debug_message("A beat occured!!");

```
