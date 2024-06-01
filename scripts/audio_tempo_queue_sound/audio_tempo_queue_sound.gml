function audio_tempo_queue_sound(_tempo_id, _soundid, _priority=1, _loop=false, _pitch=1, _gain=1){
	return _tempo_id.__queue_sound(_soundid, _priority, _loop, _pitch, _gain);
}