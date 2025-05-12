// Initialize all variables for the player object

frozen = false; // Sets whether the player can move and interact with any instances

skin = undefined;
enable_dotkid_indicator = true;

skin_changing_sfx_start = false;
skin_changing_sfx_value = 0;
skin_changing_sfx_value_limit = 15;

/*
	<global.player.kidmode>
	1. default : Just a normal kid!
	
	2. dotkid : The kid from "I Wanna Go The DotKid!"
				You can become a very small kid. (4px squared dot)
				
	3. telekid : The kid from "Not Another Needle Game".
				 You can shoot your ghost to a wall and teleport to his position 
				 when he collides against a wall.

	4. vkid : The kid from "Not Another VVVVVV game"
			  You can flip gravity when you press jump key
*/

////////////////////////////////////////////////////////////////////

old_x = x; // Value that x had one frame before 
old_y = y; // Value that y had one frame before 

backstep_sign = sign(global.player.xscale); // For backstep mode

hspd = 0; // Added to "x" on every frame
vspd = 0; // Added to "y" on every frame

old_hspd = hspd; // Value that  hspd had one frame before 
old_vspd = vspd; // Value that vspd had one frame before 

gravity_pull = 0.4; // Added to vspd on every frame
max_hspd = 3; // Horizontal speed of kid
max_vspd = 9.4; // Limits max value of vspd

jump_total = global.player.jump_total; // Counts jumps of the player
jump_spd = 8.5; // Sets how fast the player jumps on the ground
djump_spd = 7; // Sets how fast the player jumps in air
vjump = 0.45;
can_coyote_jump = true; // When it's true, you can jump even if you falls from the ground

draw_yscale = global.player.yscale;
// Sets scale of the player's sprite
// Not image_yscale of the player's mask
				 
draw_angle = global.player.gravity_dir - 270;
// Sets image_angle of the player's sprite
// Not image_angle of the player's mask

alpha = 1;
// Sets image_alpha of the player's sprite

no_draw_angle_animation = false;
skip_gravity_changing_anim = false;

oak_cask_mode = false;

// For Screen Rotator
screen_angle = 0;
saved_screen_angle = 0;
screen_rotate_anim_time_limit = 45;
screen_rotate_anim_time = screen_rotate_anim_time_limit;

// For Panda
collide_with_panda_black = false;
collide_with_panda_white = true;
panda_anim_time_limit = 45;
panda_anim_time = panda_anim_time_limit;
panda_block_id = noone;
panda_message_alpha = 0;

pastel_incollidable_instances = []; 
// It takes all instances that obj_pastel_green_water had collided and make them incollidable.

// For Speed Field
in_high_gravity_field = false;
in_low_gravity_field = false;
in_high_speed_field = false;
in_low_speed_field = false;

// For Walljump
touching_walljump = false;
walljump_key = undefined;
purple_walljumping = false;
fire_walljumping = false;

jump_star_id = noone; 
jump_refresher_id = noone;
gravity_changer_id = noone;

water_id = noone; // It takes all instances that have their parent as obj_water_parent

poison_water_time_alpha = 0;
poison_water_time = 0;
poison_water_time_limit = 120;

dynamic_block_id = noone; // It takes all instances that have their parent as obj_dynamic_block
on_block = false; 
on_ladder = false; 

slip_block_id = noone;
hspd_on_slip_block = 0;

slide_block_id = noone;

collided_instances = [];

platform_top_left = undefined; // Updated by update_platform_top_left
platform_id = noone; // instance id of the platform the player is on
previous_platform_id = platform_id;
/* This will be used for preventing snapping on platform
   If the player falls from a platform, platform_id becomes noone and it gets a previous id of the platform */

fall_from_platform = false;
platform_escaping_spd = 0;
descendable_platform_message_alpha = 0;

inventory_anmation_value = 0;

min_distance = 16;
r1 = undefined;
r2 = undefined;
r3 = undefined;

image_index_ext = 0;

// Debug variables
show_debug_info = false; // When it's true, guides for debug mode appears on the god mode
debug_player_death = false;

// Load every function of user events
event_user(0); // Kidmodes
event_user(1); // Movement & Collision 
event_user(2); // PlayerDeath
event_user(3); // Actions 
event_user(4); // Sprites
event_user(5); // ETC
event_user(6); // Debug

/*																										 *\
	I recommend not to edit functions on each user events' pages since it's too messy
	You can open functions with F1 on event funtions below (It's good to grasp a whole context at once)
\*																										 */

// event functions
function end_step(){ 
	handle_collided_instances();
	handle_kid_mode();
	handle_player_movement_and_collision();
	handle_collision_variables();
	handle_player_death();
	handle_actions();
	handle_time();
	handle_debug();
}

function draw(){
	handle_sprites();
	handle_external_drawing();
	draw_player_sprite();
	draw_debug_player_mask();
}

function draw_gui(){
	draw_debug_info();
}

function clean_up(){
	global.game_over = false;
}