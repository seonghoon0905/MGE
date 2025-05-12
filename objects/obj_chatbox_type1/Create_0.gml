event_user(0); // local library

chatbox_id = noone;
dialogues = undefined;
sign_alpha = 1;
message_alpha = 0;
is_initialized = false;

//event function
function begin_step(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(!is_initialized){
		chatbox_id = instance_create_depth(0, 0, layer_get_depth(layer) - 200, obj_chatbox);
		initialize_chatbox_id();
		is_initialized = true;
	}
	
	handle_sign_alpha();
	handle_sign_position();
}

function draw(){
	draw_self();
	handle_sign_message();
}