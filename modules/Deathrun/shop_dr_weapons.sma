#include <amxmodx>
#include <cstrike>
#include <cromchat2>
#include <fakemeta_util>

#include <credits>
#include <shop>
#include <deathrun>

#define PLUGIN "DR Shop"
#define VERSION "1.1"
#define AUTHOR "MrShark45"

new g_iTero[MAX_PLAYERS];
new g_iHP[MAX_PLAYERS];

public plugin_init(){
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_event("HLTV", "eventNewRound", "a", "1=0", "2=0");

	registerItems();
	
	//Chat prefix
	CC_SetPrefix("&x04[SHOP]");
}

public plugin_cfg(){
	register_dictionary("shop_dr_weapons.txt");
}

public client_putinserver(id){
	g_iTero[id] = 0;
	g_iHP[id] = 0;
}

public eventNewRound(){
	for(new i;i<MAX_PLAYERS;i++)
		g_iHP[i] = 0;
}

registerItems(){
	register_item("Terorist Runda Urmatoare", "handleBuyTerro", "shop_dr_weapons.amxx", 100);
	register_item("50 HP", "handleHealth50", "shop_dr_weapons.amxx", 100);
	register_item("50 Armura", "handleArmor50", "shop_dr_weapons.amxx", 50);
	register_item("Desert Eagle", "handleDeagle", "shop_dr_weapons.amxx", 50);
	register_item("M4a1", "handleM4a1", "shop_dr_weapons.amxx", 100);
	register_item("Ak47", "handleAk47", "shop_dr_weapons.amxx", 100);
	register_item("AWP", "handleAwp", "shop_dr_weapons.amxx", 150);
}

public handleBuyTerro(id){
	new terro = get_next_terrorist();
	new szName[64];
	if(g_iTero[id] >= 3){
		CC_SendMessage(id, "%L", id, "MAX_ITEM_LIMIT_REACHED");
		return -1;
	}
	if(terro){
		get_user_name(terro, szName, sizeof(szName));
		CC_SendMessage(id, "%L", id, "ALREADY_SELECTED_TERRORIST", szName);
		return -1;
	}
	else{
		set_next_terrorist(id);
		get_user_name(id, szName, 63);
		CC_SendMessage(0, "%l", "TERRORIST_SELECTED_NEXT_ROUND", szName);
		g_iTero[id]++;
	}

	return 1;
}
//Doar pentru tero
public handleHealth50(id){
	if(cs_get_user_team(id) != CS_TEAM_T){
		CC_SendMessage(id, "%L", id, "OPTION_ONLY_FOR_TERRORIST");
		return -1;
	}
	if(g_iHP[id] >= 5){
		CC_SendMessage(id, "%L", id, "MAX_ITEM_LIMIT_REACHED");
		return -1;
	}

	new health = get_user_health(id)+50;

	fm_set_user_health(id, health);

	g_iHP[id]++;

	return 1;
}

public handleArmor50(id){
	if(cs_get_user_team(id) != CS_TEAM_T){
		CC_SendMessage(id, "%L", id, "OPTION_ONLY_FOR_TERRORIST");
		set_user_credits(id, get_user_credits(id) + 50)
		return - 1;
	}
	fm_set_user_armor(id, get_user_armor(id) + 50);

	return 1;
}

public handleDeagle(id){
	fm_give_item(id, "weapon_deagle");
	fm_give_item(id, "ammo_deagle");
	fm_give_item(id, "ammo_deagle");
}

public handleM4a1(id){
	fm_give_item(id, "weapon_m4a1");
	fm_give_item(id, "ammo_m4a1");
	fm_give_item(id, "ammo_m4a1");
}

public handleAk47(id){
	fm_give_item(id, "weapon_ak47");
	fm_give_item(id, "ammo_ak47");
	fm_give_item(id, "ammo_ak47");
}

public handleAwp(id){
	fm_give_item(id, "weapon_awp");
	fm_give_item(id, "ammo_awp");
	fm_give_item(id, "ammo_awp");
}