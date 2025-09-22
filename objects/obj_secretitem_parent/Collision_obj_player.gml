if(secret_number < array_length(SECRETITEMS_SPRITES) && !activated && !get){
    image_alpha = 0.5;
    play_sound(snd_secret_item_get, 0);
    
    if(DONT_SAVE_SECRETITEM_UNTIL_SAVING){
        get = true;
    }
    else{
        global.other_player_data.secret_items[secret_number] = true;
        activated = true;
    }
}