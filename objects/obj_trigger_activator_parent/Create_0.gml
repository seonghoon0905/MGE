key = undefined;
triggers = []; // This will store all trigger IDs having same key with me

snd = snd_no_music;

respawned = false;

call_later_insts = [];

event_user(0); // local Library

activate = function(){
	return false;
}

// event functions
function step(){
	handle_respawning_mode();
	
	if(!respawned && activate()){
		send_signal_to_triggers();
	}

	respawned = false;
}