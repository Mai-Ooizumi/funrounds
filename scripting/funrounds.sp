/*
                       ::
                      :;J7, :,                        ::;7:
                      ,ivYi, ,                       ;LLLFS:
                      :iv7Yi                       :7ri;j5PL
                     ,:ivYLvr                    ,ivrrirrY2X,
                     :;r@Wwz.7r:                :ivu@kexianli.
                    :iL7::,:::iiirii:ii;::::,,irvF7rvvLujL7ur
                   ri::,:,::i:iiiiiii:i:irrv177JX7rYXqZEkvv17
                ;i:, , ::::iirrririi:i:::iiir2XXvii;L8OGJr71i
              :,, ,,:   ,::ir@mingyi.irii:i:::j1jri7ZBOS7ivv,
                 ,::,    ::rv77iiiriii:iii:i::,rvLq@huhao.Li
             ,,      ,, ,:ir7ir::,:::i;ir:::i:i::rSGGYri712:
           :::  ,v7r:: ::rrv77:, ,, ,:i7rrii:::::, ir7ri7Lri
          ,     2OBBOi,iiir;r::        ,irriiii::,, ,iv7Luur:
        ,,     i78MBBi,:,:::,:,  :7FSL: ,iriii:::i::,,:rLqXv::
        :      iuMMP: :,:::,:ii;2GY7OBB0viiii:i:iii:i:::iJqL;::
       ,     ::::i   ,,,,, ::LuBBu BBBBBErii:i:i:i:i:i:i:r77ii
      ,       :       , ,,:::rruBZ1MBBqi, :,,,:::,::::::iiriri:
     ,               ,,,,::::i:  @arqiao.       ,:,, ,:::ii;i7:
    :,       rjujLYLi   ,,:::::,:::::::::,,   ,:i,:,,,,,::i:iii
    ::      BBBBBBBBB0,    ,,::: , ,:::::: ,      ,,,, ,,:::::::
    i,  ,  ,8BMMBBBBBBi     ,,:,,     ,,, , ,   , , , :,::ii::i::
    :      iZMOMOMBBM2::::::::::,,,,     ,,,,,,:,,,::::i:irr:i:::,
    i   ,,:;u0MBMOG1L:::i::::::  ,,,::,   ,,, ::::::i:i:iirii:i:i:
    :    ,iuUuuXUkFu7i:iii:i:::, :,:,: ::::::::i:i:::::iirr7iiri::
    :     :rk@Yizero.i:::::, ,:ii:::::::i:::::i::,::::iirrriiiri::,
     :      5BMBBBBBBSr:,::rv2kuii:::iii::,:i:,, , ,,:,:i@petermu.,
          , :r50EZ8MBBBBGOBBBZP7::::i::,:::::,: :,:,::i;rrririiii::
              :jujYY7LS0ujJL7r::,::i::,::::::::::::::iirirrrrrrr:ii:
           ,:  :@kevensun.:,:,,,::::i:i:::::,,::::::iir;ii;7v77;ii;i,
           ,,,     ,,:,::::::i:iiiii:i::::,, ::::iiiir@xingjief.r;7:i,
        , , ,,,:,,::::::::iiiiiiiiii:,:,:::::::::iiir;ri7vL77rrirri::
         :,, , ::::::::i:::i:::i:i::,,,,,:,::i:i:::iir;@Secbone.ii:::
		 
	
LAST EDITED : 2016-11-08 07:11 GMT+8 Mai Ooizumi
*/
#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <csgoitems>

//who cares?
public Plugin myinfo = {
	name = "Fun Rounds!", 
	author = "Mai Ooizumi,Lust", 
	description = "Fun rounds lite", 
	version = "1.3", 
	url = "http://maiooizumi.xyz"
};

//Primary
char WeaponPrimary[24][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_famas", "weapon_g3sg1", "weapon_galilar", "weapon_m249", "weapon_m4a1", "weapon_mac10", "weapon_mag7", 
	"weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p90", "weapon_sawedoff", "weapon_scar20", "weapon_sg556", "weapon_ssg08", "weapon_ump45", "weapon_xm1014", "weapon_awp", "weapon_m4a1_silencer", "weapon_knife"
};

//Secondary
char WeaponSecondary[11][] = {
	"weapon_deagle", "weapon_elite", "weapon_fiveseven", "weapon_glock", "weapon_hkp2000", "weapon_p250", "weapon_tec9", "weapon_usp_silencer", "weapon_cz75a", "weapon_revolver", "weapon_knife"
};

//Grenades
int GrenadesAll[] = { 15, 17, 16, 14, 18, 17 };


//Keyvalues
Handle Kv;
int Checker;
int INTRoundNumber;
int INTLastNumber;

//KeyValue strings
char RoundNumber[3];
char RoundName[200];
char ThirdPerson[3];
char Weapon[70];
char Health[70];
char Armor[70];
char DodgeBall[70];
char InfiniteAmmo[3];
char InfiniteNade[50];
char GrenadeToGive[50];
char PlayerSpeed[20];
char PlayerGravity[20];
char NoRecoil[3];
char AutoBhop[3];
char NoScope[3];
char NoKnife[3];
char FreeBuy[3];
char Vampire[3];
char PColor[15];
char BackWards[3];
char Fov[10];
char ChickenDefuse[3];
char HeadShot[3];
char SpeedChange[6];
char RecoilView[7];
char AlwaysMove[3];
char FastBomb[3];
char FFA[3];
char SD[3];
char GiveC4[3];


//Bools 
bool g_DodgeBall = false;
bool g_InfiniteNade = false;
bool g_NoScope = false;
bool g_Vampire = false;
bool g_ChickenDefuse = false;
bool g_HeadShot = false;
bool g_SpeedChange = false;
bool g_EnablePluginu = true;
bool g_PluginHalt = true;
bool g_SuddenDeath = false;
bool g_bFired[MAXPLAYERS + 1] = false;
bool g_bHit[MAXPLAYERS + 1] = false;
bool g_EnableBuyC4 = true;


//Cvars
Handle sv_allow_thirdperson;
Handle sv_infinite_ammo;
Handle sv_gravity;
Handle weapon_accuracy_nospread;
Handle weapon_recoil_cooldown;
Handle weapon_recoil_decay1_exp;
Handle weapon_recoil_decay2_exp;
Handle weapon_recoil_decay2_lin;
Handle weapon_recoil_scale;
Handle weapon_recoil_suppression_shots;
Handle weapon_recoil_view_punch_extra;
Handle cv_accelerate;
Handle sv_airaccelerate;
Handle sv_friction;
Handle host_timescale;
Handle mp_buytime;
Handle mp_maxmoney;
Handle mp_buy_anywhere;
Handle weapon_air_spread_scale;
Handle sv_autobunnyhopping;
Handle mp_randomspawn;
Handle mp_teammates_are_enemies;

Handle g_PluginEnable = INVALID_HANDLE;


public void OnPluginStart() {
	
	RegAdminCmd("sm_getround", Command_GetRound, ADMFLAG_KICK, "Get round");
	RegConsoleCmd("sm_c4", Command_BuyC4);
	
	//Create convar
	RegAdminCmd("sm_funrounds", Command_EnablePlugin, ADMFLAG_ROOT,"Enable plugin command!");
	
	g_PluginEnable = CreateConVar("fr_enable", "1", "Enable/disable the plugin.", !FCVAR_NOTIFY, true, 0.0, true, 1.0);
	HookConVarChange(g_PluginEnable, ConVarChange);
	g_EnablePluginu = GetConVarBool(g_PluginEnable);
	
	//** EVENTS **//
	HookEvent("weapon_zoom", Fun_EventWeaponZoom, EventHookMode_Pre);
	HookEvent("bomb_planted", Fun_BomPlanted_Event);
	HookEvent("player_hurt", Fun_EventPlayerHurt);
	HookEvent("player_death", Fun_EventInspectWeapon);
	HookEvent("inspect_weapon", Fun_EventInspectWeapon);
	HookEvent("round_end", Fun_EventRoundEnd);
	HookEvent("round_start", Fun_EventRoundStart);
	HookEvent("round_freeze_end", Fun_EventRoundFreezeEnd);
	HookEvent("player_death", Fun_EventPlayerDeath);
	HookEvent("weapon_fire", Fun_EventOnWeaponFire);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			OnClientPutInServer(i);
		}
	}

}

public void OnClientPutInServer(int client) {
	SDKHook(client, SDKHook_TraceAttack, OnTraceAttack);
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public void OnClientDisconnect(int client) {
	SDKUnhook(client, SDKHook_TraceAttack, OnTraceAttack);
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}


public void OnConfigsExecuted() {
	
	//** CVARS **//
	sv_allow_thirdperson = FindConVar("sv_allow_thirdperson");
	sv_infinite_ammo = FindConVar("sv_infinite_ammo");
	sv_gravity = FindConVar("sv_gravity");
	weapon_accuracy_nospread = FindConVar("weapon_accuracy_nospread");
	weapon_recoil_cooldown = FindConVar("weapon_recoil_cooldown");
	weapon_recoil_decay1_exp = FindConVar("weapon_recoil_decay1_exp");
	weapon_recoil_decay2_exp = FindConVar("weapon_recoil_decay2_exp");
	weapon_recoil_decay2_lin = FindConVar("weapon_recoil_decay2_lin");
	weapon_recoil_scale = FindConVar("weapon_recoil_scale");
	weapon_recoil_suppression_shots = FindConVar("weapon_recoil_suppression_shots");
	weapon_recoil_view_punch_extra = FindConVar("weapon_recoil_view_punch_extra");
	cv_accelerate = FindConVar("sv_accelerate");
	sv_airaccelerate = FindConVar("sv_airaccelerate");
	sv_friction = FindConVar("sv_friction");
	host_timescale = FindConVar("host_timescale");
	mp_buytime = FindConVar("mp_buytime");
	mp_maxmoney = FindConVar("mp_maxmoney");
	mp_buy_anywhere = FindConVar("mp_buy_anywhere");
	weapon_air_spread_scale = FindConVar("weapon_air_spread_scale");
	sv_autobunnyhopping = FindConVar("sv_autobunnyhopping");
	mp_randomspawn = FindConVar("mp_randomspawn");
	mp_teammates_are_enemies = FindConVar("mp_teammates_are_enemies");
	
	//** KEYVALUES **//
	int flags = GetConVarFlags(sv_gravity);
	int flags2 = GetConVarFlags(cv_accelerate);
	int flags3 = GetConVarFlags(sv_airaccelerate);
	int flags4 = GetConVarFlags(sv_friction);
	int flags5 = GetConVarFlags(host_timescale);
	int flags6 = GetConVarFlags(mp_buytime);
	int flags7 = GetConVarFlags(mp_maxmoney);
	int flags8 = GetConVarFlags(mp_buy_anywhere);
	int flagsa = GetConVarFlags(weapon_air_spread_scale);
	int flagsb = GetConVarFlags(sv_autobunnyhopping);
	int flagsc = GetConVarFlags(mp_randomspawn);
	int flagsd = GetConVarFlags(mp_teammates_are_enemies);
	SetConVarFlags(sv_gravity, flags & ~FCVAR_NOTIFY);
	SetConVarFlags(cv_accelerate, flags2 & ~FCVAR_NOTIFY);
	SetConVarFlags(sv_airaccelerate, flags3 & ~FCVAR_NOTIFY);
	SetConVarFlags(sv_friction, flags4 & ~FCVAR_NOTIFY);
	SetConVarFlags(host_timescale, flags5 & ~FCVAR_NOTIFY);
	SetConVarFlags(mp_buytime, flags6 & ~FCVAR_NOTIFY);
	SetConVarFlags(mp_maxmoney, flags7 & ~FCVAR_NOTIFY);
	SetConVarFlags(mp_buy_anywhere, flags8 & ~FCVAR_NOTIFY);
	SetConVarFlags(weapon_air_spread_scale, flagsa & ~FCVAR_NOTIFY);
	SetConVarFlags(sv_autobunnyhopping, flagsb & ~FCVAR_NOTIFY);
	SetConVarFlags(mp_randomspawn, flagsc & ~FCVAR_NOTIFY);
	SetConVarFlags(mp_teammates_are_enemies, flagsd & ~FCVAR_NOTIFY);
	
	//Settings for server
	ServerSettings();
}

public Action ServerSettings() {
	if(g_EnablePluginu){
		Handle bot_quota = FindConVar("bot_quota");
		Handle bot_quota_mode = FindConVar("bot_quota_mode");
		Handle mp_ct_default_secondary = FindConVar("mp_ct_default_secondary");
		Handle mp_t_default_secondary = FindConVar("mp_t_default_secondary");
		Handle mp_free_armor = FindConVar("mp_free_armor");
		SetConVarInt(bot_quota, 0);
		SetConVarString(bot_quota_mode, "none");
		SetConVarInt(mp_buytime, 0);
		SetConVarInt(mp_maxmoney, 0);
		SetConVarString(mp_ct_default_secondary, "");
		SetConVarString(mp_t_default_secondary, "");
		SetConVarInt(mp_free_armor, 0);
		ServerCommand("mp_give_player_c4 0");
		ServerCommand("sv_enablebunnyhopping 1");
	}
}

public Action Command_EnablePlugin(int client, int args) {
	char arg[3];
	GetCmdArg(1, arg, sizeof(arg));
	int EnableNumber = StringToInt(arg);
	
	if(EnableNumber == 1) {
		g_EnablePluginu = true;
		PrintToServer("Fun rounds enabled!");
	} else if(EnableNumber == 0) {
		g_EnablePluginu = false;
		PrintToServer("Fun rounds disabled!");
	}
}

public void ConVarChange(Handle cvar, char [] oldValue, char [] newValue) {
	
	int newval = StringToInt(newValue);
	
	if(newval == 1) {
		g_EnablePluginu = true;
		PrintToServer("Fun rounds enabled!");
	} else if(newval == 0) {
		g_EnablePluginu = false;
		PrintToServer("Fun rounds disabled!");
	}
	
}

public Action Fun_EventRoundEnd(Handle event, char [] name, bool dontBroadcast) {
	TurnOffAllSettings();
	g_PluginHalt = false;
}

public Action Fun_EventRoundStart(Handle event, char [] name, bool dontBroadcast) {
	if (g_EnablePluginu) {
		g_PluginHalt = true;
		RemoveWeapons();
	}
}
public Action RemoveWeapon(Handle Timer) {
	for (int iclient = 1; iclient < MaxClients; iclient++) {
		if (IsValidClient(iclient) && IsPlayerAlive(iclient)){
			CSGOItems_RemoveAllWeapons(iclient, CS_SLOT_KNIFE);
			SetEntProp(iclient, Prop_Send, "m_bHasHelmet", 0);
			SetEntProp(iclient, Prop_Send, "m_ArmorValue", 0);
		}
	}
}

public Action Fun_EventRoundFreezeEnd(Handle event, char [] name, bool dontBroadcast) {
	if(GameRules_GetProp("m_bWarmupPeriod") == 1 || !g_EnablePluginu || !g_PluginHalt) {
	} else {
		char classname[65];
		for(int entity = MaxClients; entity < GetMaxEntities(); entity++) {
			if(IsValidEntity(entity)) {
				GetEntityClassname(entity, classname, sizeof(classname));
				if (((StrContains(classname, "weapon_", false) != -1) || (StrContains(classname, "item_", false) != -1) && !StrEqual(classname, "item_defuser")) && (GetEntProp(entity, Prop_Data, "m_iState") == 0) && (GetEntProp(entity, Prop_Data, "m_spawnflags") != 1) && !StrEqual(classname, "weapon_c4")) {
					AcceptEntityInput(entity, "Kill");
				}
			}
		}
		CreateTimer(1.0, StartRound);
	}
}

public Action Command_GetRound(int client, int args) {
	
	GetCmdArg(1, RoundNumber, sizeof(RoundNumber));
	if (StrEqual(RoundNumber, "0")) {
		INTRoundNumber = 0;
	} else {
		INTRoundNumber = StringToInt(RoundNumber);
	}
	
	CreateTimer(0.0, StartRound);
	
	return Plugin_Handled;
	
}

public Action StartRound(Handle Timer) {
	
	if(!g_EnablePluginu || !g_PluginHalt) {
	} else 
	
	TurnSettingsOff();
	
	if (INTRoundNumber == 0 || INTLastNumber == INTRoundNumber) {
		INTRoundNumber = Math_GetRandomInt(1, 35);
	}
	if (INTLastNumber == INTRoundNumber) {
		INTRoundNumber = Math_GetRandomInt(1, 35);
	}
	
	IntToString(INTRoundNumber, RoundNumber, sizeof(RoundNumber));
	
	char KeyValuePath[PLATFORM_MAX_PATH];
	Kv = CreateKeyValues("Rounds");
	BuildPath(Path_SM, KeyValuePath, sizeof(KeyValuePath), "data/funrounds/rounds.txt");
	FileToKeyValues(Kv, KeyValuePath);
	
	if (KvJumpToKey(Kv, RoundNumber, false)) {
		KvGetString(Kv, "name", RoundName, sizeof(RoundName), "No name round!");
		KvGetString(Kv, "thirdperson", ThirdPerson, sizeof(ThirdPerson), "0");
		KvGetString(Kv, "weapon", Weapon, sizeof(Weapon), "none");
		KvGetString(Kv, "health", Health, sizeof(Health), "100");
		KvGetString(Kv, "armor", Armor, sizeof(Armor), "0");
		KvGetString(Kv, "dodgeball", DodgeBall, sizeof(DodgeBall), "0");
		KvGetString(Kv, "noknife", NoKnife, sizeof(NoKnife), "0");
		KvGetString(Kv, "freebuy", FreeBuy, sizeof(FreeBuy), "0");
		KvGetString(Kv, "infiniteammo", InfiniteAmmo, sizeof(InfiniteAmmo), "0");
		KvGetString(Kv, "infinitenade", InfiniteNade, sizeof(InfiniteNade), "weapon_none");
		KvGetString(Kv, "speed", PlayerSpeed, sizeof(PlayerSpeed), "1.0");
		KvGetString(Kv, "gravity", PlayerGravity, sizeof(PlayerGravity), "800");
		KvGetString(Kv, "norecoil", NoRecoil, sizeof(NoRecoil), "0");
		KvGetString(Kv, "vampire", Vampire, sizeof(Vampire), "0");
		KvGetString(Kv, "Pcolor", PColor, sizeof(PColor), "null");
		KvGetString(Kv, "backwards", BackWards, sizeof(BackWards), "0");
		KvGetString(Kv, "fov", Fov, sizeof(Fov), "90");
		KvGetString(Kv, "autobhop", AutoBhop, sizeof(AutoBhop), "0");
		KvGetString(Kv, "chickendef", ChickenDefuse, sizeof(ChickenDefuse), "0");
		KvGetString(Kv, "headshot", HeadShot, sizeof(HeadShot), "0");
		KvGetString(Kv, "speedchange", SpeedChange, sizeof(SpeedChange), "0");
		KvGetString(Kv, "noscope", NoScope, sizeof(NoScope), "0");
		KvGetString(Kv, "recoilview", RecoilView, sizeof(RecoilView), "0.0555");
		KvGetString(Kv, "alwaysmove", AlwaysMove, sizeof(AlwaysMove), "0");
		KvGetString(Kv, "fastbomb", FastBomb, sizeof(FastBomb), "0");
		KvGetString(Kv, "ffa", FFA, sizeof(FFA), "0");
		KvGetString(Kv, "suddendeath", SD, sizeof(SD), "0");
		KvGetString(Kv, "c4", GiveC4, sizeof(GiveC4), "1");
	}
	
	//** print roundname **//
	PrintCenterTextAll("%s", RoundName);
	PrintToChatAll("\x3 \x4 ----------------------------------------");
	PrintToChatAll("\x3 \x4 %s", RoundName);
	PrintToChatAll("\x3 \x4 %s", RoundName);
	PrintToChatAll("\x3 \x4 %s", RoundName);
	PrintToChatAll("\x3 \x4 ----------------------------------------");
	PrintToServer("Round Name: %s", RoundName);
	PrintToServer("Round Number: %s", RoundNumber);
	
	//** ThirdPerson **//
	if (StrEqual(ThirdPerson, "1")) {
		SetConVarInt(sv_allow_thirdperson, 1, true, false);
		CreateTimer(0.1, EnableThirdPerson);
	}
	
	//** GiveC4 **//
	if(StrEqual(GiveC4, "1")) {
		g_EnableBuyC4 = true;
		int clientArray[MAXPLAYERS+1];
		int clientArrayIndex = 0;
		for(int i = 1; i < MaxClients; i++) {
			if(IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == CS_TEAM_T) {
				clientArray[clientArrayIndex++] = i;
			}
		}
		if(clientArrayIndex > 0) {
			clientArrayIndex = clientArray[Math_GetRandomInt(0, clientArrayIndex - 1)];
			GivePlayerItem(clientArrayIndex, "weapon_c4");
		}
	} else {
		g_EnableBuyC4 = false;
	}
	
	//** WEAPONS **//
	GiveWeapons();
	
	//** HEALTH **//
	int HealthInt = StringToInt(Health);
	if (HealthInt != 100) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntityHealth(x, HealthInt);
			}
		}
	} else {
		if (HealthInt == 100) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					int ActualHealth = GetEntProp(x, Prop_Send, "m_iHealth");
					if (ActualHealth != 100) {
						SetEntityHealth(x, 100);
					}
				}
			}
		}
	}
	//** ARMOR **//
	int ArmorInt = StringToInt(Armor);
	if (ArmorInt == 0) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
			SetEntProp(x, Prop_Send, "m_bHasHelmet", 0);
			SetEntProp(x, Prop_Send, "m_ArmorValue", 0);
			}
		}
	} else {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntProp(x, Prop_Send, "m_bHasHelmet", 1);
				SetEntProp(x, Prop_Send, "m_ArmorValue", ArmorInt);
			}
		}
	}
	//** DECOY SOUND **//
	if (StrEqual(DodgeBall, "1")) {
		g_DodgeBall = true;
	}
	
	//** NO KNIFE **//	
	if(StrEqual(NoKnife, "1")) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				int iWeapon = CSGOItems_GetWeaponDefIndexByClassName("weapon_taser");
				CSGOItems_RemoveKnife(x);
				CSGOItems_RemoveWeapon(x, iWeapon);
			}
		}
	}
	
	// ** free buy **//
	if (StrEqual(FreeBuy, "1")) {
		for (int x = 1; x < MaxClients; x++) {
			SetConVarInt(mp_buytime, 45, true, false);
			SetConVarInt(mp_maxmoney, 16000, true, false);
			SetConVarInt(mp_buy_anywhere, 1, true, false);
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				{
					int accountOffset = FindSendPropInfo("CCSPlayer", "m_iAccount");
					if (accountOffset >= 0)
					{
						SetEntData(x, accountOffset, 16000);
					}
				}
			}
		}
	}
	
	//** INFINITE AMMO **//
	if (StrEqual(InfiniteAmmo, "1") || StrEqual(InfiniteAmmo, "2")) {
		int SetAmmoInt = StringToInt(InfiniteAmmo);
		SetConVarInt(sv_infinite_ammo, SetAmmoInt, true, false);
	}
	else {
		int sv_infinite_ammoDEF = GetConVarInt(sv_infinite_ammo);
		if (sv_infinite_ammoDEF > 0) {
			SetConVarInt(sv_infinite_ammo, 0, true, false);
		}
	}
	//** INFINITE NADE **//
	if (StrEqual(InfiniteNade, "weapon_decoy") || StrEqual(InfiniteNade, "weapon_hegrenade") || StrEqual(InfiniteNade, "weapon_flashbang") || StrEqual(InfiniteNade, "weapon_molotov") || StrEqual(InfiniteNade, "weapon_incgrenade") || StrEqual(InfiniteNade, "weapon_smokegrenade")) {
		g_InfiniteNade = true;
		GrenadeToGive = InfiniteNade;
	}
	//** SPEED **//
	float FSpeed = StringToFloat(PlayerSpeed);
	if (FSpeed > 1.0 || FSpeed < 1.0) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", FSpeed);
			}
		}
	} else {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 1.0);
			}
		}
	}
	//** GRAVITY **//
	int INTPlayerGravity = StringToInt(PlayerGravity);
	
	if (INTPlayerGravity > 800 || INTPlayerGravity < 800) {
		SetConVarInt(sv_gravity, INTPlayerGravity, true, false);
		SetConVarInt(weapon_air_spread_scale, 0, true, false);
	} else {
		int DefGravity = GetConVarInt(sv_gravity);
		if (DefGravity != 800) {
			SetConVarInt(sv_gravity, 800, true, false);
		}
	}
	
	//** fastbomb **//
	if (StrEqual(FastBomb, "1")) {
		ServerCommand("mp_c4timer 10");
	}
	
	//** FFA **//
	if (StrEqual(FFA, "1")) {
		SetConVarInt(mp_randomspawn, 1, true, false);
		SetConVarInt(mp_teammates_are_enemies, 1, true, false);
		CreateTimer(0.1, RespawnPlayer);
	}
	
	//** NO RECOIL **//
	
	if (StrEqual(NoRecoil, "1")) {
		if (weapon_accuracy_nospread != INVALID_HANDLE) {
			SetConVarInt(weapon_accuracy_nospread, 1, true, false);
			SetConVarInt(weapon_recoil_cooldown, 0, true, false);
			SetConVarInt(weapon_recoil_decay1_exp, 99999, true, false);
			SetConVarInt(weapon_recoil_decay2_exp, 99999, true, false);
			SetConVarInt(weapon_recoil_decay2_lin, 99999, true, false);
			SetConVarInt(weapon_recoil_scale, 0, true, false);
			SetConVarInt(weapon_recoil_suppression_shots, 500, true, false);
		}
	} else {
		int DefWeaponAccuracy = GetConVarInt(weapon_accuracy_nospread);
		if (DefWeaponAccuracy != 0) {
			SetConVarInt(weapon_accuracy_nospread, 0, true, false);
			SetConVarFloat(weapon_recoil_cooldown, 0.55, true, false);
			SetConVarFloat(weapon_recoil_decay1_exp, 3.5, true, false);
			SetConVarInt(weapon_recoil_decay2_exp, 8, true, false);
			SetConVarInt(weapon_recoil_decay2_lin, 18, true, false);
			SetConVarInt(weapon_recoil_scale, 2, true, false);
			SetConVarInt(weapon_recoil_suppression_shots, 4, true, false);
		}
		
	}
	
	//** AUTO BHOP **//
	if (StrEqual(AutoBhop, "1")) {
		SetConVarInt(sv_autobunnyhopping, 1, true, false);
		SetConVarInt(weapon_air_spread_scale, 0, true, false);
		ServerCommand("sv_staminamax 0");
		ServerCommand("sv_airaccelerate 2000");
		ServerCommand("sv_staminajumpcost 0");
		ServerCommand("sv_staminalandcost 0");
	}
	
	//** suddendeath SD **//
	if (StrEqual(SD, "1")) {
		g_SuddenDeath = true;
	}
	
	//** NOSCOPE **//
	if (StrEqual(NoScope, "1")) {
		g_NoScope = true;
	} else {
		g_NoScope = false;
	}
	
	//** VAMPIRE **//
	if (StrEqual(Vampire, "1")) {
		g_Vampire = true;
	} else {
		g_Vampire = false;
	}
	//** PLAYER COLOR **//
	
	int ColorR = 255;
	int ColorG = 255;
	int ColorB = 255;
	
	int LastPlayerColor = Checker;
	
	Checker = 0;
	if (StrEqual(PColor, "black")) {
		ColorR = 0;
		ColorG = 0;
		ColorB = 0;
		Checker = 1;
	}
	
	else if (StrEqual(PColor, "pink")) {
		ColorR = 255;
		ColorG = 0;
		ColorB = 255;
		Checker = 1;
	}
	
	else if (StrEqual(PColor, "green")) {
		ColorR = 0;
		ColorG = 255;
		ColorB = 0;
		Checker = 1;
	}
	
	else if (StrEqual(PColor, "red")) {
		ColorR = 255;
		ColorG = 0;
		ColorB = 0;
		Checker = 1;
	}
	
	else if (StrEqual(PColor, "blue")) {
		ColorR = 0;
		ColorG = 0;
		ColorB = 255;
		Checker = 1;
	}
	
	if (LastPlayerColor == 1) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntityRenderColor(x, 255, 255, 255, 0);
			}
		}
	}
	
	if (Checker == 1) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x)) {
				SetEntityRenderColor(x, ColorR, ColorG, ColorB, 0);
			}
		}
	}
	
	//** BackWards **//
	if (StrEqual(BackWards, "1")) {
		SetConVarFloat(cv_accelerate, -5.5, true, false);
	} else {
		int Defaccelerete = GetConVarInt(cv_accelerate);
		if (Defaccelerete == -5) {
			SetConVarFloat(cv_accelerate, 5.5, true, false);
		}
	}
	
	//** FOV **//
	int INTFov;
	INTFov = StringToInt(Fov);
	
	if (INTFov > 90 || INTFov < 90) {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
				SetEntProp(x, Prop_Send, "m_iDefaultFOV", INTFov);
				SetEntProp(x, Prop_Send, "m_iFOV", INTFov);
			}
		}
		
	} else {
		for (int x = 1; x < MaxClients; x++) {
			if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
				SetEntProp(x, Prop_Send, "m_iDefaultFOV", 90);
				SetEntProp(x, Prop_Send, "m_iFOV", 90);
			}
		}
	}
	//** CHICKEN DEFUSE **//
	if (StrEqual(ChickenDefuse, "1")) {
		g_ChickenDefuse = true;
	} else {
		g_ChickenDefuse = false;
	}
	//** HEADSHOT ONLY **//
	if (StrEqual(HeadShot, "1")) {
		g_HeadShot = true;
	}
	
	//** SPEEDCHANGE **//
	if (StrEqual(SpeedChange, "1")) {
		g_SpeedChange = true;
	} else {
		g_SpeedChange = false;
	}
	//** RECOIL VIEW **//
	
	float INTRecoilView = StringToFloat(RecoilView);
	
	if (INTRecoilView > 0.055 || INTRecoilView < 0.055) {
		SetConVarFloat(weapon_recoil_view_punch_extra, INTRecoilView, true, false);
	} else {
		SetConVarFloat(weapon_recoil_view_punch_extra, 0.055, true, false);
	}
	
	//** FRICTION **//
	if (StrEqual(AlwaysMove, "1")) {
		SetConVarInt(sv_friction, 0, true, false);
	}
	
	INTLastNumber = INTRoundNumber;
	
}

public Action Command_BuyC4(int client, int args) {
	if (g_EnableBuyC4 && GetClientTeam(client) == CS_TEAM_T){
		if (CS_GetClientContributionScore(client) >= 15){
			GivePlayerItem(client, "weapon_c4");
			CS_SetClientContributionScore(client, CS_GetClientContributionScore(client) - 15);
		}
	}
}

public Action TurnSettingsOff() {
	SetConVarInt(sv_allow_thirdperson, 0, true, false);
}

//** RespawnPlayer **//
public Action RespawnPlayer(Handle timer) {
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && (GetClientTeam(x) > 1)) {
			CS_RespawnPlayer(x);
		}
	}
}

//** THIRD PERSON **//
public Action EnableThirdPerson(Handle timer) {
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
			ClientCommand(x, "thirdperson");
		}
	}
}

//** GIVE WEAPON **//
public Action GiveWeapons() {
	if (!StrContains(Weapon, "weapon_")) {
		
		RemoveWeapons();
		RemoveNades();
		
		char bit[10][80];
		int SumOfStrings = ExplodeString(Weapon, ";", bit, sizeof bit, sizeof bit[]);
		
		if (SumOfStrings >= 2) {
			
			for (int i = 0; i < SumOfStrings; i++) {
				if (StrEqual(bit[i], "weapon_primary_random") || StrEqual(bit[i], "weapon_secondary_random")) {
				} else {
					for (int x = 1; x < MaxClients; x++) {
						if (IsValidClient(x) && IsPlayerAlive(x)) {
							GivePlayerItem(x, bit[i]);
						}
					}
				}
			}
			
			
			//give random weapon
			
			for (int i = 0; i < SumOfStrings; i++) {
				
				//primary
				if (StrEqual(bit[i], "weapon_primary_random")) {
					int random = Math_GetRandomInt(0, 23);
					for (int x = 1; x < MaxClients; x++) {
						if (IsValidClient(x) && IsPlayerAlive(x)) {
							GivePlayerItem(x, WeaponPrimary[random]);
						}
					}
				}
				//secodary
				if (StrEqual(bit[i], "weapon_secondary_random")) {
					int random = Math_GetRandomInt(0, 10);
					for (int x = 1; x < MaxClients; x++) {
						if (IsValidClient(x) && IsPlayerAlive(x)) {
							GivePlayerItem(x, WeaponSecondary[random]);
						}
					}
				}
				
			}
			
		} else {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					GivePlayerItem(x, Weapon);
				}
			}
		}
		
	} else {
		
		if (StrEqual(Weapon, "none")) {
			RemoveWeapons();
			RemoveNades();
		}
	}
	
}


//REMOVE WEAPONS
public Action RemoveWeapons() {
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x)) {
			CSGOItems_RemoveAllWeapons(x, CS_SLOT_KNIFE);
		}
	}
}


//REMOVE NADES
public Action RemoveNades() {
	
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
			while(RemoveWeaponBySlot(x, 3)){}
			for (int i = 0; i < 6; i++) {
				SetEntProp(x, Prop_Send, "m_iAmmo", 0, _, GrenadesAll[i]);
			}
		}
	}
	
}

stock bool RemoveWeaponBySlot(int x, int iSlot) {
	int iEntity = GetPlayerWeaponSlot(x, iSlot);
	if(IsValidEdict(iEntity)) {
		CSGOItems_RemoveWeapon(x, iEntity);
	}
	return false;
}


//DECOY + INFINITE NADES
public void OnEntityCreated(int iEntity, const char [] classname) {
	if (StrContains(classname, "_projectile") != -1) {
		SDKHook(iEntity, SDKHook_Spawn, OnEntitySpawned);
		SDKHook(iEntity, SDKHook_StartTouch, OnEntityTouch);
	}
}

public Action OnEntitySpawned(int iEntity) {
	//INFINITE NADES
	if (g_InfiniteNade) {
		int client = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
		if (IsValidClient(client) && IsPlayerAlive(client)) {
			int nadeslot = GetPlayerWeaponSlot(client, 3);
			if (nadeslot > 0) {
				CSGOItems_RemoveWeapon(client, nadeslot);
			}
			GivePlayerItem(client, GrenadeToGive);
		}
	}
	//DECOY
	if (g_DodgeBall) {
		int iClient = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
		if (!iClient || !IsValidClient(iClient) || !IsPlayerAlive(iClient)) {
		}
	}
}

public Action OnEntityTouch(int iEntity, int itEntity) {
	if (!g_DodgeBall) {
		return;
	}
	int iOwner = GetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity");
	if (iOwner > MaxClients || iOwner < 1) {
		KillEntity(iEntity);
		return;
	}
	KillEntity(iEntity);
}

stock bool KillEntity(int iEntity) {
	if (!g_DodgeBall || iEntity < 1) {
	}
	AcceptEntityInput(iEntity, "kill");
}

//NOSCOPE
public Action Fun_EventWeaponZoom(Handle event, char [] name, bool dontBroadcast) {
	
	if (g_NoScope) {
		
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
		if (IsValidClient(client) && IsPlayerAlive(client) && !IsFakeClient(client)) {
			int ent = GetPlayerWeaponSlot(client, 0);
			CS_DropWeapon(client, ent, true, true);
			PrintToChat(client, "This is noscope round! Don't try to scope!");
		}
	}
	
}


//PLAYER HURT

public Action Fun_EventPlayerHurt(Handle event, char [] name, bool dontBroadcast) {
	
	if (g_Vampire) {
		int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
		int dmg_health = GetEventInt(event, "dmg_health");
		int dmg_armor = GetEventInt(event, "dmg_armor");
		int attackerH = GetEntProp(attacker, Prop_Send, "m_iHealth");
		int attackerA = GetEntProp(attacker, Prop_Send, "m_ArmorValue");
		if (IsValidClient(attacker) && IsPlayerAlive(attacker)) {
			int GiveHealth = attackerH + dmg_health;
			int GiveArmor = attackerA + dmg_armor;
			SetEntityHealth(attacker, GiveHealth);
			if (attackerA < 1) {
			GivePlayerItem(attacker, "item_assaultsuit");
			}
			if (GiveArmor > 255){
				GiveArmor = 255;
			}
			SetEntProp(attacker, Prop_Data, "m_ArmorValue", GiveArmor);
		}
	}
	
	if (g_HeadShot) {
		
		int hitgroup = GetEventInt(event, "hitgroup");
		int victim = GetClientOfUserId(GetEventInt(event, "userid"));
		int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
		int dhealth = GetEventInt(event, "dmg_health");
		int darmor = GetEventInt(event, "dmg_armor");
		int armor = GetEventInt(event, "armor");
		int health = GetEventInt(event, "health");
		int healthOffset = FindSendPropInfo("CCSPlayer", "m_iHealth");
		int armorOffset = FindSendPropInfo("CCSPlayer", "m_ArmorValue");
		if (hitgroup != 1) {
		
			if (attacker != victim && victim != 0) {
			
				if (dhealth > 0) {
				
					SetEntData(victim, healthOffset, (health + dhealth), 4, true);
				}
				if (darmor > 0) {
				
					SetEntData(victim, armorOffset, (armor + darmor), 4, true);
				}
			}
		}
	}
	
	if (g_SuddenDeath) {
	
		int client = GetClientOfUserId(GetEventInt(event, "attacker"));
		if(client < 1 || client > MaxClients)
			return;
		
		g_bHit[client] = true;
	
	}
	
}


public Action Fun_EventOnWeaponFire(Handle event, char [] name, bool dontBroadcast) {
	if (g_SuddenDeath) {
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
		g_bFired[client] = true;
	}
}

public void OnGameFrame() {
	if (g_SuddenDeath) {
		for (int client = 1; client <= MaxClients; client++) {
			if(IsValidClient(client)) {
				if(g_bFired[client] && !g_bHit[client]) {
					ForcePlayerSuicide(client);
				}
				g_bFired[client] = false;
				g_bHit[client] = false;
			}
		}
	}
}

public Action OnTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup) {
	if (g_HeadShot){
		if (IsValidClient(attacker) && (hitgroup == 1)) {
			return Plugin_Continue;
		} else {
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	
	if (IsValidClient(attacker) && (victim == attacker)){
		damage = 0.0;
		return Plugin_Changed;
	}
	
	return Plugin_Continue;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {
	if (g_HeadShot){
		if (IsValidClient(attacker) && (damagetype & CS_DMG_HEADSHOT)) {
			return Plugin_Continue;
		} else {
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	
	if (IsValidClient(attacker) && (victim == attacker)){
		damage = 0.0;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}



//CHICKEN DEFUSE

public Action Fun_BomPlanted_Event(Handle event, char [] name, bool dontBroadcast) {
	if (g_ChickenDefuse) {
		int c4 = -1;
		c4 = FindEntityByClassname(c4, "planted_c4");
		if (c4 != -1) {
			int chicken = CreateEntityByName("chicken");
			if (chicken != -1) {
				int player = GetClientOfUserId(GetEventInt(event, "userid"));
				float pos[3];
				GetEntPropVector(player, Prop_Data, "m_vecOrigin", pos);
				pos[2] += -15.0;
				DispatchSpawn(chicken);
				SetEntProp(chicken, Prop_Data, "m_takedamage", 0);
				SetEntProp(chicken, Prop_Send, "m_fEffects", 0);
				TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR);
				TeleportEntity(c4, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}), NULL_VECTOR);
				SetVariantString("!activator");
				AcceptEntityInput(c4, "SetParent", chicken, c4, 0);
			}
		}
	}
}


public Action Fun_EventInspectWeapon(Handle event, char [] name, bool dontBroadcast) {
	
	if (g_SpeedChange) {
		
		int motion = Math_GetRandomInt(0, 5);
		
		if (motion == 5) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 10.0);
				}
			}
		}
		
		if (motion == 4) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 4.0);
				}
			}
		}
		
		if (motion == 3) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 2.0);
				}
			}
		}
		
		if (motion == 2) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 1.0);
				}
			}
		}
		
		if (motion == 1) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 0.5);
				}
			}
		}
		
		if (motion == 0) {
			for (int x = 1; x < MaxClients; x++) {
				if (IsValidClient(x) && IsPlayerAlive(x)) {
					SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 0.1);
				}
			}
		}
	}	
}


public Action TurnOffAllSettings() {

	if (!g_EnablePluginu){
	} else
	
	//THIRD PERSON
	SetConVarInt(sv_allow_thirdperson, 0, true, false);
	
	//DECOY SOUND
	g_DodgeBall = false;
	
	//NOKNIFE
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x)) {
			GivePlayerItem(x, "weapon_knife");
		}
	}
	
	//** suddendeath SD **/
	g_SuddenDeath = false;

	//** GiveC4 **/
	g_EnableBuyC4 = true;
	
	//no ffa
	SetConVarInt(mp_randomspawn, 0, true, false);
	SetConVarInt(mp_teammates_are_enemies, 0, true, false);
	
	//fastbomb
	ServerCommand("mp_c4timer 60");
	
	//NO RUSH
	SetConVarFloat(sv_friction, 5.2, true, false);
	
	//INFINITE AMMO
	SetConVarInt(sv_infinite_ammo, 0, true, false);
	g_InfiniteNade = false;
	
	//SPEED
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x)) {
			SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 1.0);
		}
	}
	
	//GRAVITY
	SetConVarInt(sv_gravity, 800, true, false);
	SetConVarInt(weapon_air_spread_scale, 1, true, false);
	
	//NO RECOIL
	SetConVarInt(weapon_accuracy_nospread, 0, true, false);
	SetConVarFloat(weapon_recoil_cooldown, 0.55, true, false);
	SetConVarFloat(weapon_recoil_decay1_exp, 3.5, true, false);
	SetConVarInt(weapon_recoil_decay2_exp, 8, true, false);
	SetConVarInt(weapon_recoil_decay2_lin, 18, true, false);
	SetConVarInt(weapon_recoil_scale, 2, true, false);
	SetConVarInt(weapon_recoil_suppression_shots, 4, true, false);
	
	//AUTO BHOP
	SetConVarInt(sv_autobunnyhopping, 0, true, false);
	SetConVarInt(weapon_air_spread_scale, 1, true, false);
	ServerCommand("sv_airaccelerate 12");
	
	//freebuy
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x)) {
			{
				int accountOffset = FindSendPropInfo("CCSPlayer", "m_iAccount");
				if (accountOffset >= 0) {
					SetEntData(x, accountOffset, 0); 
				}
			}
		}
	}
	SetConVarInt(mp_buytime, 0, true, false);
	SetConVarInt(mp_maxmoney, 0, true, false);
	SetConVarInt(mp_buy_anywhere, 0, true, false);
	
	//NO SCOPE
	g_NoScope = false;
	
	//VAMPIRE
	g_Vampire = false;
	
	//COLOR
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x)) {
			SetEntityRenderColor(x, 255, 255, 255, 0);
		}
	}
	
	//BACKWARDS
	SetConVarFloat(cv_accelerate, 5.5, true, false);
	
	//FOV
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
			SetEntProp(x, Prop_Send, "m_iDefaultFOV", 90);
			SetEntProp(x, Prop_Send, "m_iFOV", 90);
		}
	}
	
	//CHICKEN DEFUSE
	g_ChickenDefuse = false;
	
	//HEADSHOT
	g_HeadShot = false;
	
	//SPEEDCHANGE
	g_SpeedChange = false;
	
	//WEIRD RECOIL
	for (int x = 1; x < MaxClients; x++) {
		if (IsValidClient(x) && IsPlayerAlive(x) && !IsFakeClient(x)) {
			SetConVarFloat(weapon_recoil_view_punch_extra, 0.055, true, false);
		}
	}
}

public Action Fun_EventPlayerDeath(Handle event, char [] name, bool dontBroadcast) {
	if (g_EnablePluginu) {
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	
		//Thirdperson
		if (IsValidClient(client) && !IsFakeClient(client)) {
		
			SendConVarValue(client, sv_allow_thirdperson, "0");
		
			//Fov
			SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
			SetEntProp(client, Prop_Send, "m_iFOV", 90);
		
		}
	}
}

bool IsValidClient(int client) {
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client)) {
		return false;
	}
	return true;
}

stock int Math_GetRandomInt(int min, int max) {
	int random = GetURandomInt();
	if (random == 0) {
		random++;
	}
	return RoundToCeil(float(random) / (float(2147483647) / float(max - min + 1))) + min - 1;
}