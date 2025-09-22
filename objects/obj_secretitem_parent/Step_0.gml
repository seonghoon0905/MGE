if(keyboard_check_pressed(global.key_config.load)){
    activated = global.other_player_data.secret_items[secret_number];
    image_alpha = activated ? 0.1 : 1;
    get = false;
    saved = false;
}


if(secret_number < array_length(SECRETITEMS_SPRITES) && !activated && get && saved){
    global.other_player_data.secret_items[secret_number] = true;
    activated = true;
}