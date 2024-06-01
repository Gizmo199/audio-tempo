scale = 1;
tempo = audio_tempo_create(130*2); // Multiply by 2 to get eighth note tempo instead of quarter note tempo (for kick pattern)
audio_tempo_queue_sound(tempo, snd_example);

// Functions
do_scale = function(){ 
	scale = 2;
}
add_event = function(){
	if ( array_length(events) <= 0 ) return;
	
	var _ev = array_shift(events);
	if( _ev == 1 ) audio_tempo_queue_method(tempo, do_scale);
	audio_tempo_queue_method(tempo, add_event);	
	
}  

// Event array
events = [];

// Intro pattern
repeat(16) events = array_concat(events, [1, 0, 0, 0]); 

// Kick pattern
repeat(4)  events = array_concat(events, [

	1, 0, 0, 1, 0, 0, 0, 1, 
	0, 0, 1, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 1, 
	0, 0, 1, 0, 0, 0, 1, 1
	
]);

// Final kick
array_push(events, 1);
add_event();