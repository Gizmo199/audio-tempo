function audio_tempo_create(_bpm) {
	
	// Tempo constructor
	static __tempo = function() constructor {
		
		#region Variables
		
			bpm		= 120;		// beats per minute
			bias	= 0.05;		// the bias between the start and end of a beat frame
			queue	= [];		// queued sounds to be played on beat
			tick	= 0;		// The tick between frames
			wait	= 0;		// Frame wait ( so that it doesn't pulse early AND on beat )
			pulse	= false;	// hold that a pulse occured
			
		#endregion
		#region Metronome
		
			metronome = time_source_create(time_source_game, 1, time_source_units_frames, function(this){
				
				// Setup delta targets
				var _target_fps = 1/60;
				var _target_dlt = delta_time / 1_000_000;
				var _target_mls = ( bpm / 60 ) / 1000;
				
				// Reset variables
				this.pulse = false;
				
				// Calculate frame waiting and delta tick between frames
				this.wait -= _target_dlt/_target_fps;
				this.tick += ( delta_time / 1000 ) * _target_mls;
				
				// Check for difference between frames
				var diff = this.tick - floor(this.tick);	
				
				// <= calls on or slightly after beat should pulse
				// >= calls on or slightly before beat should pulse
				if ( diff <= this.bias || diff >= 1-this.bias ){
					
					// Check that we are not waiting frames
					if ( this.wait <= 0 ) {
						
						// Wait 4 frames
						this.wait = 4;
						
						// Set pulse and execute queue
						this.pulse = true;
						this.__queue_execute();

					}
				
				} 	
			
			}, [self], -1);
			
		#endregion
		#region Events
		
			static __create = function(_bpm=bpm){
				
				// Set bpm and start metronome
				bpm = _bpm;
				time_source_start(metronome);
				
				// return ourselves
				return self;
			}
			static __destroy = function(){
				
				// stop and destroy metronome
				time_source_destroy(metronome);	
				
			}
			
		#endregion
		#region Queueing
		
			static __queue_execute = function(){
			
				// Iterate through queue
				var n = array_length(queue);
				repeat(n){
				
					// Get values of queued data
					var _indx  = array_shift(queue);
					var _type  = _indx.type;
					var _value = _indx.value;
				
					// Execute queued data
					switch(_type){
						case "method" : _value(); break;
						case "audio"  : if ( audio_is_playing(_value) ) audio_resume_sound(_value); break;
					}
				
				}

			}
			static __queue_sound = function(_soundid, _priority=0, _loop=false, _pitch=1, _gain=1){
			
				// Play and pause new sound created
				var new_sound = audio_play_sound(_soundid, _priority, _loop, _gain, 0, _pitch);
				audio_pause_sound(new_sound);
			
				// Push sound to be resumed on beat
				array_push(queue, { 
					type  : "audio", 
					value : new_sound
				});
			
				// Return the sound id for other use
				return new_sound;
			
			}
			static __queue_method = function(_func){
			
				// Push function to the queue
				array_push(queue, { 
					type  : "method", 
					value : _func 
				});
			
				// Return function call
				return _func;
			
			}
			
		#endregion
	
	}
	
	// Create new tempo class, intialize it, and return its id
	return new __tempo().__create(_bpm);
	
}