/*
	What does obj_world do?

	1. Initialize macros and global variables for the game management
	2. Manages each datas of the player 
	3. Manages simple pause screen
	4. Simply initializes the music of each rooms
	5. Manages system options
	6. Draws UI of system options
	7. Manages trigger activators' ids
	8. Draws animation effect when the player gets an achievement
	9. Sets the window caption of the program
	10. Enables / disables debug options and manages debug modes
	
*/

// Load every function of user events
event_user(0); // Saving & Loading Datas
event_user(1); // Settings UI
event_user(2); // Settings
event_user(3); // Trigger
event_user(4); // Window Caption
event_user(5); // Simple Pause
event_user(6); // Debug

on_setting = false; // Check if we're on settings screen.

settings_array_of_index = handle_settings_array_of_index(); // Set all of categories as a string format.
settings_row_index = 0; // Set the index for the main categories in the settings screen.
is_settings_row_index_selected = false; // Check if the player selected one of the main categories.
settings_column_index = 0; // Set the index for the sub categories in the settings screen.

settings_index_arrow1_y = 0; // Set a Y position of the arrow UI in main categories.
settings_index_arrow2_y = 0; // Set a Y position of the arrow UI in sub categories.
settings_arrow2_to_y_list = []; 
/* Since sub categories can be freely positioned opposite the main category,
we should customize the Y position of each arrow individually throughout the array.
(If this isn't clear, refer to how the handle_settings_ui and the series of handle ~ ui functions updated the array above.) */

settings_index_arrow_time = 0; 
/* Control the animation of the UI of the each arrows.
(Since the only one arrow can move in the settings screen, we use a single variable.) */
settings_skin_ui_anim_time = 0; 
settings_item_ui_anim_time = 0;
settings_inventory_ui_anim_time = 0; 

settings_master_alpha = 0; // Control the overall visibility (alpha value) of the settings screen.

settings_skin_index = 0;
settings_item_index = 0;
settings_inventory_index = 0; 

settings_achievement_index = 0;

settings_keyboard_controls_skip_key_action = false;
/* In the keyboard control section, the player can reassign keys, including the ones used in the settings screen. 
To prevent the default action from triggering when the player changes a key, use the variable above */

index_ui_str = handle_index_ui_str();
index_array_length = handle_index_array_length();

trigger_activator_ids = [];
is_trigger_activator_ids_initialized = false;
triggers_features = [];
enable_update_trigger_activator_triggers = true;

last_window_caption = "";

pause_sprite = undefined;
simple_pause = false;
pause_alpha = 0;

achievement_index = 0;

//event_function
function game_start(){
	initialize_world();
	// It initializes all global variables and macros.

	load_settings_and_key_config_data();
	/* It loads settings and key config datas only once in the whole process of the program.
	  (We saves settings and key config datas in the game end event in this object.) */

	room_goto_next();
	// Escape rm_init and go to the rm_title
}

function begin_step(){
	handle_window_caption();
}

function step(){
	handle_data_selection();
	handle_player_respawning();
	
	handle_settings();
	back_to_title_with_f2();
	synchronize_music_with_fps();
	toggle_fullscreen();
	handle_smoothing_mode();
	
	handle_simple_pause();
	update_trigger_activator_triggers();
	handle_debug();
}

function draw_gui(){
	draw_debug_info();
	draw_settings_ui();
	handle_simple_pause_ui();
}

function room_start(){
	initialize_room_music();
 	handle_player_spawning();
}

function room_end(){
	trigger_activator_ids = [];
	is_trigger_activator_ids_initialized = false;
	triggers_features = [];
	enable_update_trigger_activator_triggers = true;
}

function game_end_event(){
	handle_snapshot();
	save_settings_and_key_config_data();
	save_other_player_data();
}