/* Create event of this object's children should be in this format :
 *    secret_number = 1 // any number you want
 *    event_inherited();
*/

if(!ENABLE_SECRETITEMS_SYSTEM){
    instance_destroy();
}

activated = global.other_player_data.secret_items[secret_number];
image_alpha = activated ? 0.5 : 1;
get = false;
saved = false;