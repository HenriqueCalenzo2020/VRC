/************************************************************
* OWNER :
*        Henrique Calenzo
*
* START DATE :
*       13/03/2019
*
* NOTES :
*       Copyright Vida Real Crias 2019.  All rights reserved.
*
*/

#include                        a_samp
#include                        a_mysql
#include                        streamer
#include                        pawn.cmd
#include                        sscanf2

//Login 1 - 10
//Tutorial 11 - 15
#define vip_area                16
#define mob                     17
#define honest                  18
#define transport               19
#define nitro                   20
#define hydraulic               21
#define main_reais              22
#define main_reais_vip          23
#define cmds_adm_pg1            24
#define cmds_adm_pg2            25
#define cmds_adm_pg3            26
#define cmds_adm_pg4            27
#define bank_balance            28
#define bank_draft              29
#define bank_deposit            30
#define DIALOG_BANK             31
#define agency                  32
#define hospital                33
#define hospital_sex            34
#define main_cnh                35
#define main_fines              36
#define government              37
#define help                    38
#define tuning                  39
#define paintjob                40
#define police                  41
#define neon                    42
#define arena                   43
#define arena_kits              44
#define rename                  45
#define colorname               46
#define school_bag              47
#define school_bag_get          48
#define school_bag_add          49
#define wheel                   50
#define radio                   51
#define vip_color_tag           52
#define antiiafk                53
//Houses    5000 - 5015
//Companys  5016 - 5050
//Vehicles  5051 - 5059
//GPS       5060 - 5073
//#define MAIN_FUEL 5100

enum pInfo
{
    ID,
    Profissao,
    Semprofissao,
    Nome[MAX_PLAYER_NAME],
    Senha[MAX_PLAYER_PASS],
    Email[MAX_PLAYER_EMAIL],
    Code[10],
    Admin,
    minUP,
    segUP,
    Level,
    Exp,
    Reais,
    Avisos,
    Estrelas,
    Dinheiro,
    SaldoBancario,
    Matou,
    Morreu,
    Interior,
    lastlogin[25],
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:PosA,
    bool:Logado,

    bool:cnh_a,
    fines_a,
    bool:cnh_b,
    fines_b,
    bool:cnh_c,
    fines_c,
    bool:cnh_cht,
    fines_cht,
    bool:cnh_arrais,
    fines_arrais,

    sexo[10],
    skin,
    bool:healthplan,
    disease,

    medicalkit,
    cellphone,
    sms,
    credits,
    bool:havegallon,
    gallon,
    nonstop,
    vaccine
};

enum ppInfo
{
    pNome[MAX_PLAYER_NAME],
    pSenha[MAX_PLAYER_PASS],
    pSenhaConfirm[MAX_PLAYER_PASS],
    pEmail[MAX_PLAYER_EMAIL]
};

enum PrisonE
{
    pResponsavel[MAX_PLAYER_NAME],
    pTempo,
    pMotivo[20],
    pCadeia[15]
};

enum rankingEnum
{
    player_Score,
    player_ID
}

new pPlayerInfo[MAX_PLAYERS][ppInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new PrisonEnum[MAX_PLAYERS][PrisonE];

new String[256];
new TempoPreso[MAX_PLAYERS];
new UPRelogio[MAX_PLAYERS];

//Police
new bool:Algemado[MAX_PLAYERS],
    bool:Abordado[MAX_PLAYERS],
    bool:Perseguicao[MAX_PLAYERS],
    bool:localizado[MAX_PLAYERS],
    TimerProcurando[MAX_PLAYERS],
    PerseguicaoTime[MAX_PLAYERS];

//Pres�dio
new PlayerText:TempoPresidio[MAX_PLAYERS][3];

//zone
new zone[MAX_ZONE_NAME];

//Sleeping
new TimerEffectSleep[MAX_PLAYERS];
new TimerSleeping[MAX_PLAYERS];
new bool:Sleeping[MAX_PLAYERS];

new Count = 5;
new ContadorTxT[5][19] =
{
	"~y~] ]~w~ 1 ~y~] ]",
	"~y~] ]~w~ 2 ~y~] ]",
	"~r~] ]~w~ 3 ~r~] ]",
	"~r~] ]~w~ 4 ~r~] ]",
	"~r~] ]~w~ 5 ~r~] ]"
};

#define     MAILER_URL "spelsajten.net/mailer.php"
#include    mailer

/* FIRST DB */
#include modules\database\db_accounts

/* TextDraws */
#include modules\textdraws\td_skinlist
#include modules\textdraws\td_barstatus
#include modules\textdraws\td_skinsstore
#include modules\textdraws\td_taximeter
#include modules\textdraws\td_detonated
#include modules\textdraws\td_alterpass
#include modules\textdraws\td_coding
#include modules\textdraws\td_antiafk
#include modules\textdraws\td_time

/* Database */
#include modules\database\db_itens
#include modules\database\db_identidade
#include modules\database\db_ban
#include modules\database\db_status
#include modules\database\db_vehicles
#include modules\database\db_houses
#include modules\database\db_business
#include modules\database\db_base
#include modules\database\db_cnh
//#include modules\database\db_bag

/* Player */
#include modules\player\arena
#include modules\player\sleep
#include modules\player\barstatus
#include modules\player\loginscreen
#include modules\player\vips
#include modules\player\disease
#include modules\player\antiafk

/* Modules */
#include modules\safety
#include modules\concessionaire
#include modules\bank
#include modules\hud
#include modules\agency
#include modules\vehicles
#include modules\speedometer
#include modules\enterexit
#include modules\hospital
#include modules\fuelstation
#include modules\realestate
#include modules\msgrandom
#include modules\npcs
#include modules\gps
#include modules\office
#include modules\prison
#include modules\removebug
#include modules\tutorial
#include modules\texts

/* Profission */
#include modules\profession\police\pfs_police
#include modules\profession\honest\pfs_ej
#include modules\profession\honest\pfs_icecream
#include modules\profession\honest\pfs_pizzaboy
#include modules\profession\honest\pfs_gari
#include modules\profession\honest\pfs_paramedic
#include modules\profession\honest\pfs_lawyer
#include modules\profession\transport\pfs_taxi
#include modules\profession\transport\pfs_tanker
#include modules\profession\government\pfs_internalaffairs
#include modules\profession\government\pfs_navy
#include modules\profession\government\pfs_army
#include modules\profession\government\pfs_aeronautics
#include modules\profession\mob\pfs_thief

/* Player Commands*/
#include modules\player\command\cmds_general
#include modules\player\command\cmds_both

/* Objects */
#include modules\object\obj_objects
#include modules\object\obj_radars
#include modules\object\obj_labels
#include modules\object\obj_pickups
#include modules\object\obj_departament
#include modules\object\obj_mapicons
#include modules\object\obj_tolls
#include modules\object\obj_edit

/* Anti Cheats */
#include modules\anticheats\ac_money

main(){}

public OnGameModeInit()
{
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);

    UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();

	SetGameModeText("Brasil - VRC @BETA");
    SendRconCommand("mapname San Andreas");
	SendRconCommand("hostname Vida Real Crias RPG � #Ultra-h.com");
	SendRconCommand("language Portugu�s - Brasil");
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayAudioStreamForPlayer(playerid, "http://listen.shoutcast.com:80/RadioHunter-TheHitzChannel");
    format(String, sizeof(String), "Entrando_%d", playerid);
    SetPlayerName(playerid, String);

    SetTimerEx("OnPlayerUpdateCreate", 1000, true, "d", playerid);
    UPRelogio[playerid] = SetTimerEx("ClockUP", 1000, true, "d", playerid);
    SetTimerEx("OnPlayerClearChat", 4000, false, "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ZerandoVariaveis(playerid);
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid)
{
    if(IsPlayerInDynamicRaceCP(playerid, CPTrash[0]) || IsPlayerInDynamicRaceCP(playerid, CPTrash[1]) || IsPlayerInDynamicRaceCP(playerid, CPTrash[2]))
    {
        if(PlayerInfo[playerid][Profissao] == gari && GariTrash[LastVehicle[playerid]])
        {
            format(String, sizeof(String), "Voc� entregou {FF8000}%d {FFFFFF}saco(s) de lixo(s) e recebeu {1B6302}$%s", GariTrash[LastVehicle[playerid]], IsMoney((GariTrash[LastVehicle[playerid]] * 115), "."));
            SendClientMessage(playerid, -1, String);

            if(IsPlayerInDynamicRaceCP(playerid, CPTrash[0]))
            {
                TrashsLocal[0] += GariTrash[LastVehicle[playerid]];

                format(String, sizeof(String), "{FFFFFF}Los Santos\n{F29B0D}%d {FFFFFF}Saco(s) de Lixo(s)", TrashsLocal[0]);
                UpdateDynamic3DTextLabelText(LabelTrash[0], 0xFFFFFFFF, String);
            }
            if(IsPlayerInDynamicRaceCP(playerid, CPTrash[1]))
            {
                TrashsLocal[1] += GariTrash[LastVehicle[playerid]];

                format(String, sizeof(String), "{FFFFFF}Las Venturas\n{F29B0D}%d {FFFFFF}Saco(s) de Lixo(s)", TrashsLocal[1]);
                UpdateDynamic3DTextLabelText(LabelTrash[1], 0xFFFFFFFF, String);
            }
            if(IsPlayerInDynamicRaceCP(playerid, CPTrash[2]))
            {
                TrashsLocal[2] += GariTrash[LastVehicle[playerid]];

                format(String, sizeof(String), "{FFFFFF}San Fierro\n{F29B0D}%d {FFFFFF}Saco(s) de Lixo(s)", TrashsLocal[2]);
                UpdateDynamic3DTextLabelText(LabelTrash[2], 0xFFFFFFFF, String);
            }

            PlayerInfo[playerid][Dinheiro] += ( GariTrash[LastVehicle[playerid]] * 115 );
            UpdatePlayerMoney(playerid);

            GariTrash[LastVehicle[playerid]] = 0;
        }
        return 1;
    }
    if(IsPlayerInDynamicRaceCP(playerid, CPVehicleGari[playerid]))
    {
        if(GariTrash[LastVehicle[playerid]] >= 30)
            return SendClientMessage(playerid, Erro, "Seu TrashMaster j� tem est� cheio");

        GariTrash[LastVehicle[playerid]]++;

        format(String, sizeof(String), "Voc� pegou mais um saco de lixo e agora tem faltam apenas {F29B0D}%d", ( 30 - GariTrash[LastVehicle[playerid]] ));
        SendClientMessage(playerid, -1, String);

        DestroyDynamicRaceCP(CPVehicleGari[playerid]);
        RemovePlayerAttachedObject(playerid, 3);
        return 1;
    }
    if(IsPlayerInDynamicRaceCP(playerid, VehiclePlace[playerid]))
    {
        SendClientMessage(playerid, Green, "Voc� chegou at� o local do seu ve�culo");
        DestroyDynamicRaceCP(VehiclePlace[playerid]);
        return 1;
    }
    if(IsPlayerInDynamicRaceCP(playerid, CPSEJ[playerid]) && PlayerInfo[playerid][Profissao] == newspaperdelivery)
    {
        if(BlockNewspaper[playerid])
            return SendClientMessage(playerid, Erro, "Voc� acabou de entregar, aguarde alguns segundos...");

        if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 510 || !IsPlayerInAnyVehicle(playerid))
            return SendClientMessage(playerid, Erro, "Voc� n�o est� em uma Mountain Bike");

        Newspaper[playerid]--;

        if(Newspaper[playerid] > 0)
        {
            format(String, sizeof(String), "Voc� entregou um jornal, e agora tem {FF0000}%d {FFFFFF}jornais!", Newspaper[playerid]);
            SendClientMessage(playerid, White, String);
            format(String, sizeof(String), "Voc� recebeu {00C40A}$%d {FFFFFF}pela entrega localizada em {FF8000}%s", PNL[playerid][VaiReceber], PNL[playerid][RandomLocal]);
            SendClientMessage(playerid, White, String);

            BlockNewspaper[playerid] = true;
            SetTimerEx("UnlockingNewspaper", 1000*30, false, "d", playerid);

            PlayerInfo[playerid][Dinheiro] += PNL[playerid][VaiReceber];
            UpdatePlayerMoney(playerid);

            new rand = random(sizeof(NL));

            if(CPSEJ[playerid])
            {
                DestroyDynamicRaceCP(CPSEJ[playerid]);
            }

            format(PNL[playerid][RandomLocal], 40, NL[rand][nnLocations]);
            PNL[playerid][RandomX] = NL[rand][nnPosX];
            PNL[playerid][RandomY] = NL[rand][nnPosY];
            PNL[playerid][RandomZ] = NL[rand][nnPosZ];
            PNL[playerid][VaiReceber] = NL[rand][nnGetWork];

            CPSEJ[playerid] = CreateDynamicRaceCP(1, NL[rand][nnPosX], NL[rand][nnPosY], NL[rand][nnPosZ], -1, -1, -1, 2.0, -1, -1, playerid, -1.0, -1, 0);
        }
        else
        {
            if(CPSEJ[playerid])
            {
                DestroyDynamicRaceCP(CPSEJ[playerid]);
            }

            PlayerInfo[playerid][Dinheiro] += PNL[playerid][VaiReceber];
            UpdatePlayerMoney(playerid);

            SendClientMessage(playerid, White, "Voc� entregou o �ltimo jornal");
            SendClientMessage(playerid, White, "Para pegar mas jornais, volte para HQ e pegue mais");
        }
        return 1;
    }
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(PlayerInfo[playerid][Logado] == false)
    {
        SendClientMessage(playerid, Erro, "Voc� n�o est� logado");
        return 0;
    }
    if(AntiAfk[playerid][aa_afk] == true)
    {
        SendClientMessage(playerid, Erro, "Antes de usar comando, digite: /Sairafk");
        return 0;
    }
    if(Algemado[playerid] == true)
    {
        SendClientMessage(playerid, Erro, "Voc� est� algemado e n�o pode usar comando");
        return 0;
    }
    if(PrisonEnum[playerid][pTempo] != 0)
    {
        if(!strcmp(PrisonEnum[playerid][pCadeia], "Municipal"))
        {
            if(!strcmp(cmd, "aceitar") || !strcmp(cmd, "recusar") || !strcmp(cmd, "advogados") || !strcmp(cmd, "advogado")) return 1;
        }
        SendClientMessage(playerid, Erro, "Voc� est� preso e n�o pode usar comando");
        return 0;
    }
    if(IsArena[playerid])
    {
        if(!strcmp(cmd, "sairarena")) return 1;

        SendClientMessage(playerid, Erro, "Voc� est� na arena e n�o pode usar comando");
        return 0;
    }
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, Erro, "Comando Inv�lido");
        return 0;
    }

    for(new i=0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerHelper(i) && viewcmds[i] == true)
        {
            format(String, sizeof(String), "| VRC-Admin | O(A) jogador(a) %s[%d] digitou o comando: %s", PlayerInfo[playerid][Nome], playerid, cmd);
            SendClientMessage(i, adm, String);
        }
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == help)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    new txt[500];
                	strcat(txt, "{a4a4a4}A cada 10 minutos jogado Voc� ganhar� 1 ponto de experi�ncia \n");
                    strcat(txt, "{a4a4a4}Juntando 6 pontos de experi�ncia Voc� ganhar� +1 level \n\n");
                    strcat(txt, "{a4a4a4}Jogadores(as) VIPs ter� que juntar 5 experi�ncia para ganhar +1 level \n\n");
                    strcat(txt, "{FFFFFF}�{66cdaa} /MeuLevel {FFFFFF}- Para ver seu level \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Level", txt, "Fechar", "");
                }
                case 1:
                {
                    new txt[500];
                	strcat(txt, "{a4a4a4}O Sal�rio � creditado em sua conta banc�ria ao completar UP ( 6/6 ) \n\n");
                    strcat(txt, "{a4a4a4}Jogadores(as) VIPs ter� sal�rio creditado ao completar UP ( 5/5 ) \n\n");
                    strcat(txt, "{a4a4a4}Cada profiss�o tem um sal�rio diferente e justo \n\n");
                    strcat(txt, "{a4a4a4}Cargos da mafia n�o recebem sal�rio \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Sal�rio", txt, "Fechar", "");
                }
                case 2:
                {
                    new txt[2000];
                	strcat(txt, "{00FFFF}�{FFFFFF} /Regras {FFFFFF}- Para ver as regras do servidor\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Creditos {FFFFFF}- Para ver os cr�ditos do servidor\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Admins {FFFFFF}- Para ver os Admins online no momento\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /MeuLevel {FFFFFF}- Para ver seu level atual\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /VantagensVip {FFFFFF}- Para saber as vantagens V.I.P\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Sairafk {FFFFFF}- Para sair do modo AFK\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Profissao {FFFFFF}- Para ver os comandos da profiss�o\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Abastecer {FFFFFF}- Para abastecer um ve�culo em um determinado posto\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Animes {FFFFFF}- Para ver a lista de animes dispon�vel\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /190 [Den�ncia] {FFFFFF}- Para fazer uma den�ncia � policia\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /193 [Local] {FFFFFF}- Para chamar a equipe de param�dicos\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Duvida [Duvida]{FFFFFF}- Para tirar alguma d�vida com algum membro da Administra��o\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Relatorio [Playerid][Denucia]{FFFFFF}- Para denunciar algum jogador fora das regras ou usando hack\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Transferir {FFFFFF}- Para transferir uma determinada quantia a um determinado jogador\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /identidade {FFFFFF}- Para ver sua identidade\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Toplevel {FFFFFF}- Para ver os Level Alto\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Taxi [Local]{FFFFFF}- Chamar um Taxi\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Mecanico [Local]{FFFFFF}- Chamar um Mecanico\n");
                	strcat(txt, "{00FFFF}�{FFFFFF} /Radio {FFFFFF}- Para ligar a R�dio \n");
                	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Comandos", txt, "Fechar", "");
                }
                case 3:
                {
                    new txt[500];
                    strcat(txt, "{FFFFFF}�{FF0000} F�rum: {FFFFFF}Em Breve \n");
                    strcat(txt, "{FFFFFF}�{FF0000} Facebook: {FFFFFF}Em Breve \n");
                    strcat(txt, "{FFFFFF}�{FF0000} IP do Discord: {FFFFFF}https://discord.gg/Rvcxkg \n");
                    strcat(txt, "{FFFFFF}�{FF0000} IP do Servidor ( v1.0.0 ) {FFFFFF}Em Breve \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Contatos", txt, "Fechar", "");
                }
            }
        }
        return 1;
    }
    if(dialogid == tuning)
	{
        if(response)
		{
            switch(listitem)
            {
                case 0:
                    ShowPlayerDialog(playerid, paintjob, DIALOG_STYLE_LIST, "{FF0000}Paint Jobs", "{FFFFFF}PaintJob 1 \nPaintJob 2\nPaintJob 3 \nRemover PaintJob","Concluir","Voltar");
                case 1:
                    ShowPlayerDialog(playerid, nitro, DIALOG_STYLE_LIST, "{FF0000}Nitros", "{FFFFFF}Nitro 2\nNitro 5 \nNitro 10 \nRemover Nitro","Concluir","Voltar");
                case 2:
                    ShowPlayerDialog(playerid, wheel, DIALOG_STYLE_LIST, "{FF0000}Rodas", "{FFFFFF}Shadow \nMega \nRimshine \nWires \nClassic \nTwist \nCutter \nSwitch \nGrove \nDollar \nTrance \nAtomic \nRemover Rodas","Concluir","Voltar");
                case 3:
                    ShowPlayerDialog(playerid, hydraulic, DIALOG_STYLE_LIST, "{FF0000}Hidraulica", "{FFFFFF}Hidraulica \nRemover Hidraulica","Concluir","Voltar");
            }
        }
        return 1;
    }
    if(dialogid == nitro)
	{
        if(!response)
            return ShowPlayerDialog(playerid, tuning,DIALOG_STYLE_LIST,"{FF0000}Tunar","{FFFFFF}PaintJobs \nNitros \nRodas \nHidraulica","Concluir","Fechar");

        if(response)
		{
            switch(listitem)
            {
                case 0:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1009); // Nitro 1
                case 1:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1008); // Nitro 2
                case 2:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro 3
                case 3:
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1009), // Nitro 1
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1008), // Nitro 2
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro 3
            }
		}
		return 1;
	}
    if(dialogid == paintjob)
	{
        if(!response)
            return ShowPlayerDialog(playerid, tuning,DIALOG_STYLE_LIST,"{FF0000}Tunar","{FFFFFF}PaintJobs \nNitros \nRodas \nHidraulica","Concluir","Fechar");

        if(response)
        {
            switch(listitem)
            {
                case 0:
                    ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 0);
                case 1:
                    ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
                case 2:
                    ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 2);
                case 3:
                    ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 3);
   		 	}
		}
        return 1;
	}
    if(dialogid == wheel)
	{
        if(!response)
            return ShowPlayerDialog(playerid, tuning,DIALOG_STYLE_LIST,"{FF0000}Tunar","{FFFFFF}PaintJobs \nNitros \nRodas \nHidraulica","Concluir","Fechar");

        if(response)
		{
            switch(listitem)
            {
                case 0:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1073); // Shadow
                case 1:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1074); // Mega
                case 2:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1075); // Rimshine
                case 3:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1076); // Wires
                case 4:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1077);  // Classic
                case 5:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1078); //  Twist
                case 6:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1079); //  Cutter
                case 7:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1080); //  Switch
                case 8:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1081); //  Grove
                case 9:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1082); //  Import
                case 10:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1083); //  Dollar
                case 11:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1084); // Trance
                case 12:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1085); // Atomic
                case 13:
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1073),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1074),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1075),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1076),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1077),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1078),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1079),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1080),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1081),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1082),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1083),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1084),
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1085);
            }
		}
		return 1;
	}
    if(dialogid == hydraulic)
	{
        if(response)
		{
            switch(listitem)
            {
                case 0:
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1087); // Hidraulica
                case 1:
                    RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1087); // Hidraulica
			}
		}
        if(!response)
		{
            ShowPlayerDialog(playerid, tuning,DIALOG_STYLE_LIST,"{FF0000}Tunar","{FFFFFF}PaintJobs \nNitros \nRodas \nHidraulica","Concluir","Fechar");
		}
		return true;
	}
    if(dialogid == rename)
    {
        if(!response)
            return SendClientMessage(playerid, Erro, "Voc� cancelou a troca de nome");

        if(response)
        {
            if(strlen(inputtext) < MIN_PLAYER_NAME || strlen(inputtext) > MAX_PLAYER_NAME)
                return ShowPlayerDialog(playerid, rename, DIALOG_STYLE_INPUT, "{FF0000}Mudar nome", "{FFFFFF}Digite seu novo nome e clique em {FF0000}Mudar\n{FFFFFF}Por favor n�o coloque {FF0000}ESPA�O {FFFFFF}em seu nome:\n{FF0000}Erro digite um nome entre 3 a 30 caracteres!", "Mudar", "Sair");

            mysql_format(IDConexao, String, sizeof(String), "SELECT `Nome` FROM Contas WHERE `Nome`='%s'", inputtext);
            mysql_query(IDConexao, String);

            if(cache_num_rows() > 0)
                return ShowPlayerDialog(playerid, rename, DIALOG_STYLE_INPUT, "{FF0000}Mudar nome", "{FF0000}O nome que voc� escolheu j� existe\n\n {FFFFFF}Tente outro nome abaixo e clique em {FF0000}Mudar", "Mudar", "Sair");

            format(String, sizeof(String), "O(A) jogador(a) %s mudou o nome para ( %s )", PlayerInfo[playerid][Nome], inputtext);
            SendClientMessageToAll(Yellow, String);

            PlayerInfo[playerid][Reais] -= 7;

            mysql_format(IDConexao, String, sizeof(String), "UPDATE `Contas` SET `Nome`='%e' WHERE `ID`='%d'", inputtext, PlayerInfo[playerid][ID]);
            mysql_query(IDConexao, String);

            mysql_format(IDConexao, String, sizeof(String), "UPDATE `Identidade` SET `reais`='%d' WHERE `id_contas`='%d'", PlayerInfo[playerid][Reais], PlayerInfo[playerid][ID]);
            mysql_query(IDConexao, String);

            mysql_format(IDConexao, String, sizeof(String), "SELECT `ID` FROM `Houses` WHERE `Nome`='%e'", PlayerInfo[playerid][Nome]);
            mysql_query(IDConexao, String);

            if(cache_num_rows()){
                new idhouse[MAX_PLAYERS];

                cache_get_value_int(0, "ID", idhouse[playerid]);
                format(HouseInfo[idhouse[playerid]][hNome], MAX_PLAYER_NAME, inputtext);
                UpdateHouseExternal(idhouse[playerid]);

                mysql_format(IDConexao, String, sizeof(String), "UPDATE `Houses` SET `Nome`='%e' WHERE `Nome`='%e'", inputtext, PlayerInfo[playerid][Nome]);
                mysql_query(IDConexao, String);
            }

            mysql_format(IDConexao, String, sizeof(String), "SELECT `ID` FROM `Business` WHERE `Nome`='%e'", PlayerInfo[playerid][Nome]);
            mysql_query(IDConexao, String);

            if(cache_num_rows()){
                new businessid[MAX_PLAYERS];

                cache_get_value_int(0, "ID", businessid[playerid]);
                format(BusinessInfo[businessid[playerid]][cName], MAX_PLAYER_NAME, inputtext);
                UpdateCompanyExternal(businessid[playerid]);

                mysql_format(IDConexao, String, sizeof(String), "UPDATE `Business` SET `Nome`='%e' WHERE `Nome`='%e'", inputtext, PlayerInfo[playerid][Nome]);
                mysql_query(IDConexao, String);
            }

            format(PlayerInfo[playerid][Nome], MAX_PLAYER_NAME, inputtext);
            SetPlayerName(playerid, PlayerInfo[playerid][Nome]);
        }
        return 1;
    }
    if(dialogid == radio)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                    PlayAudioStreamForPlayer(playerid, "");
                case 1:
                    PlayAudioStreamForPlayer(playerid, "http://listen.shoutcast.com:80/RadioHunter-TheHitzChannel");
                case 2:
                    PlayAudioStreamForPlayer(playerid, "");
                case 3:
                    PlayAudioStreamForPlayer(playerid, "");
                case 4:
                    StopAudioStreamForPlayer(playerid);
            }
        }
        return 1;
    }
    if(dialogid == colorname)
    {
        if(response)
        {
            if(strlen(inputtext) != 6)
                return ShowPlayerDialog(playerid, colorname, DIALOG_STYLE_INPUT, "{FF0000}Cor nome", "{FFFFFF}Digite um codigo em '{FF0000}HTML{FFFFFF}' abaixo\nPesquise no Google algo como {00FF00}Cores em HTML {FFFFFF}:\n{FF0000}Exemplo {FFFFFF}00FF00 = {00FF00}Calenzo\n{FF0000}Erro digite uma cor 'HTML' com 6 digitos!", "Alterar", "Cancelar");

            format(String, sizeof(String), "0x%sAA", inputtext);
            SetPlayerColor(playerid, HexToInt(String));
            format(String, sizeof(String), "| VRC-Admin | A cor do seu nome {%s}%s{FFFFFF} foi alterado com sucesso!", inputtext, PlayerInfo[playerid][Nome]);
            SendClientMessage(playerid, White, String);
        }
        return 1;
    }

    if(dialogid == vip_area)
    {
        switch(listitem)
        {
            case 0: GivePlayerWeapon(playerid, 9, 100000);
            case 1: GivePlayerWeapon(playerid, 27, 499);
            case 2: GivePlayerWeapon(playerid, 26, 499);
            case 3: GivePlayerWeapon(playerid, 28, 499);
            case 4: GivePlayerWeapon(playerid, 29, 499);
            case 5: GivePlayerWeapon(playerid, 32, 499);
            case 6: GivePlayerWeapon(playerid, 31, 499);
            case 7: GivePlayerWeapon(playerid, 30, 499);
            case 8: GivePlayerWeapon(playerid, 33, 499);
            case 9: GivePlayerWeapon(playerid, 34, 499);
        }
        return 1;
    }
    if(dialogid == main_reais)
    {
        if(response)
        {
            if(listitem == 0)
            {
                new txt[200];
                strcat(txt, "{FF0000}Dia(s) \t\t{1CEB00}Real(is)\n");
                strcat(txt, "{FFFFFF}1 Dia \t\t{31B404}R$1,00\n");
                strcat(txt, "{FFFFFF}15 Dias \t\t{31B404}R$10,00\n");
                strcat(txt, "{FFFFFF}30 Dias \t\t{31B404}R$20,00\n");
                strcat(txt, "{FFFFFF}60 Dias \t\t{31B404}R$45,00\n");
        		ShowPlayerDialog(playerid, main_reais_vip, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos VIP", txt, "Comprar", "Voltar");
            }
        }
        return 1;
    }
    if(dialogid == main_reais_vip)
    {
        if(!response)
            return ShowPlayerDialog(playerid, main_reais, DIALOG_STYLE_LIST, "{FF0000}Reais", "Comprar VIP", "Continuar", "Cancelar");

        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][Reais] < 1)
                    return SendClientMessage(playerid, Erro, "Infelizmente voc� n�o tem Reais o suficiente");

                PlayerInfo[playerid][Reais] -= 1;
                SetVip(playerid, 1);
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][Reais] < 10)
                    return SendClientMessage(playerid, Erro, "Infelizmente voc� n�o tem Reais o suficiente");

                PlayerInfo[playerid][Reais] -= 10;
                SetVip(playerid, 10);
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][Reais] < 20)
                    return SendClientMessage(playerid, Erro, "Infelizmente voc� n�o tem Reais o suficiente");

                PlayerInfo[playerid][Reais] -= 20;
                SetVip(playerid, 20);
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][Reais] < 45)
                    return SendClientMessage(playerid, Erro, "Infelizmente voc� n�o tem Reais o suficiente");

                PlayerInfo[playerid][Reais] -= 45;
                SetVip(playerid, 60);
            }
        }
        return 1;
    }
    if(dialogid == cmds_adm_pg1 && response)
    {
        new txt[2800];
        strcat(txt, "{FF0000}Comandos \t\t{1CEB00}Informa��es\n");
    	strcat(txt, "{87CEFF}/Punicao [id/nome][minutos][motivo] \t\t{FFFFFF}Para prender um(a) jogador(a) \n");
    	strcat(txt, "{87CEFF}/Despunicao [id/nome] \t\t{FFFFFF}Para soltar um(a) jogador(a) \n");
        strcat(txt, "{87CEFF}/EncherVida [id/nome] \t\t{FFFFFF}Para recuperar a vida de um(a) jogador(a) \n");
        strcat(txt, "{87CEFF}/EncherColete [id/nome] \t\t{FFFFFF}Para recuperar o colete de um(a) jogador(a) \n");
        strcat(txt, "{87CEFF}/CriarVeiculo [id-carro][id-cor][id-cor] \t\t{FFFFFF}Para criar um veiculo em sua posi��o \n");
    	strcat(txt, "{87CEFF}/Ac [mensagem] \t\t{FFFFFF}Para digitar no chat da admininstra��o \n");
      	strcat(txt, "{87CEFF}/A [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) global\n");
        strcat(txt, "{87CEFF}/Ann [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) na tela\n");
        strcat(txt, "{87CEFF}/Cnn [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) na tela com o nome\n");
        strcat(txt, "{87CEFF}/Tps \t\t{FFFFFF}Para ver os teletransportes\n");
        strcat(txt, "{87CEFF}/Banir [id/nome][motivo] \t\t{FFFFFF}Para banir um(a) jogador(a) permanente\n");
        strcat(txt, "{87CEFF}/DarArma [id/nome][id-arma] \t\t{FFFFFF}Para dar uma arma para um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/IrCasa [id-casa]\t\t{FFFFFF}Para se teletransportar para a casa com esse id\n");
        strcat(txt, "{87CEFF}/DarDinheiro [id/nome][quantia] \t\t{FFFFFF}Para dar dinheiro para um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/RemoverDinheiro [id/nome][quantia] \t\t{FFFFFF}Para remover dinheiro de um(a) jogador(a)\n");
        ShowPlayerDialog(playerid, cmds_adm_pg2, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos da Admininstra��o - P�gina {00CA00}2", txt, "Pr�xima", "Cancelar");
        return 1;
    }
    if(dialogid == cmds_adm_pg2 && response)
    {
        new txt[2800];
        strcat(txt, "{FF0000}Comandos \t\t{1CEB00}Informa��es\n");
        strcat(txt, "{87CEFF}/DarAdmin [id/nome][Nivel] \t\t{FFFFFF}Para promover/rebaixar/remover jogador(a) da admininstra��o\n");
        strcat(txt, "{87CEFF}/Reiniciar \t\t{FFFFFF}Para reiniciar o servidor\n");
        strcat(txt, "{87CEFF}/DarLevel [id/nome][quantia] \t\t{FFFFFF}Para dar level(s) para um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/RemoverLevel [id/nome][quantia] \t\t{FFFFFF}Para remover level(s) de um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/DarReais [id/nome][quantia] \t\t{FFFFFF}Para dar real(is) de um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/RemoverReais [id/nome][quantia] \t\t{FFFFFF}Para remover real(is) de um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/R [id/nome][resposta] \t\t{FFFFFF}Para responder a d�vida de um(a) jogador(a)\n");
        strcat(txt, "{87CEFF}/AbrirServidor \t\t{FFFFFF}Para retirar a senha do servidor\n");
        strcat(txt, "{87CEFF}/FecharServidor [senha] \t\t{FFFFFF}Para fechar o servidor com senha\n");
        strcat(txt, "{87CEFF}/SalvarContas \t\t{FFFFFF}Para salvar todas as contas logadas no servidor\n");
        ShowPlayerDialog(playerid, cmds_adm_pg3, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos da Admininstra��o - P�gina {00CA00}3", txt, "Fechar", "Cancelar");
        return 1;
    }
    if(dialogid == cmds_adm_pg3 && response)
    {
        /*
        new txt[2800];
        strcat(txt, "{FF0000}Comandos \t\t{1CEB00}Informa��es\n");
        ShowPlayerDialog(playerid, cmds_adm_pg4, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos da Admininstra��o - P�gina {00CA00}4", txt, "Fechar", "Cancelar");
        return 1;
        */
    }
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    ClickTextDrawLoginRegister(playerid, playertextid);
    ClickTextDrawAntiAfk(playerid, playertextid);

    if(playertextid == TDPlayerConcessionaire[playerid][0]) //closed
    {
        HideTDPlayerConcessionaire(playerid);
        HideTDConcessionaire(playerid);
        return 1;
    }
    if(playertextid == TDPlayerConcessionaire[playerid][5]) //purchase
    {
        format(String, sizeof(String), "{FFFFFF}Nome do ve�culo: %s\nCusto: %s\nDesvaloriza��o: %s\n\n{FF4000}Obs: o seu ve�culo precisar� ser conectado!", getVehicleName(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_model]), IsMoney(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_price], "."), IsMoney(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_devaluation], "."));
        ShowPlayerDialog(playerid, MAIN_CONCESSIONAIRE_SHOP, DIALOG_STYLE_MSGBOX, "{FF0000}Comprar ve�culo", String, "Comprar", "Cancelar");
        return 1;
    }
    if(playertextid == TDPlayerConcessionaire[playerid][6]) //left
    {
        if(LocationConcessionaire == 1 || LocationConcessionaire == 2 || LocationConcessionaire == 3)
        {
            if(ShoppingVehicle[playerid] == 0)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }
        if(LocationConcessionaire == 4)
        {
            if(ShoppingVehicle[playerid] == 125)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }
        if(LocationConcessionaire == 5)
        {
            if(ShoppingVehicle[playerid] == 133)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }


        ShoppingVehicle[playerid]--;

        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][2], getVehicleName(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_model]));
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][2]);

        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][3], ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_category]);
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][3]);

        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][4], IsMoney(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_price], "."));
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][4]);

        PlayerTextDrawSetPreviewModel(playerid, TDPlayerConcessionaire[playerid][1], ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_model]);
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][1]);
        return 1;
    }
    if(playertextid == TDPlayerConcessionaire[playerid][7]) //right
    {
        if(LocationConcessionaire == 1 || LocationConcessionaire == 2 || LocationConcessionaire == 3)
        {
            if(ShoppingVehicle[playerid] == 124)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }
        if(LocationConcessionaire == 4)
        {
            if(ShoppingVehicle[playerid] == 132)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }
        if(LocationConcessionaire == 5)
        {
            if(ShoppingVehicle[playerid] == 139)
                return SendClientMessage(playerid, Erro, "N�o tem mais ve�culos");
        }

        ShoppingVehicle[playerid]++;

        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][2], getVehicleName(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_model]));
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][2]);

        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][3], ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_category]);
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][3]);

        format(String, sizeof(String), "$%s", IsMoney(ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_price], "."));
        PlayerTextDrawSetString(playerid, TDPlayerConcessionaire[playerid][4], String);
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][4]);

        PlayerTextDrawSetPreviewModel(playerid, TDPlayerConcessionaire[playerid][1], ShoppingConcessionaire[ShoppingVehicle[playerid]][sc_model]);
        PlayerTextDrawShow(playerid, TDPlayerConcessionaire[playerid][1]);
        return 1;
    }
    if(playertextid == TDPlayerSkinList[playerid][1]) //Escolher
    {
        if(strcmp(PlayerInfo[playerid][sexo], SkinListPolice[SkinList[playerid]][slp_sex]))
            return SendClientMessage(playerid, Erro, "Sexo Inv�lido");

        if((SkinListPolice[SkinList[playerid]][slp_skinid] == 287 || SkinListPolice[SkinList[playerid]][slp_skinid] == 191) && ( PlayerInfo[playerid][Profissao] != navy && PlayerInfo[playerid][Profissao] != army && PlayerInfo[playerid][Profissao] != aeronautics ))
            return SendClientMessage(playerid, Erro, "Voc� n�o trabalhar para as for�as armadas!");

        HideTDPlayerSkinList(playerid);
        SetPlayerSkin(playerid, SkinListPolice[SkinList[playerid]][slp_skinid]);
        return 1;
    }
    if(playertextid == TDPlayerSkinList[playerid][2]) //left
    {
        if(SkinList[playerid] == 0)
            return SendClientMessage(playerid, Erro, "N�o tem mais skins");

        SkinList[playerid]--;

        PlayerTextDrawSetPreviewModel(playerid, TDPlayerSkinList[playerid][0], SkinListPolice[SkinList[playerid]][slp_skinid]);
        PlayerTextDrawShow(playerid, TDPlayerSkinList[playerid][0]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinList[playerid][4], SkinListPolice[SkinList[playerid]][slp_sex]);
        PlayerTextDrawShow(playerid, TDPlayerSkinList[playerid][4]);
        return 1;
    }
    if(playertextid == TDPlayerSkinList[playerid][3]) //right
    {
        if(SkinList[playerid] == 20)
            return SendClientMessage(playerid, Erro, "N�o tem mais skins");

        SkinList[playerid]++;

        PlayerTextDrawSetPreviewModel(playerid, TDPlayerSkinList[playerid][0], SkinListPolice[SkinList[playerid]][slp_skinid]);
        PlayerTextDrawShow(playerid, TDPlayerSkinList[playerid][0]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinList[playerid][4], SkinListPolice[SkinList[playerid]][slp_sex]);
        PlayerTextDrawShow(playerid, TDPlayerSkinList[playerid][4]);
        return 1;
    }

    if(playertextid == TDPlayerSkinList[playerid][5]) return HideTDPlayerSkinList(playerid); //exit

    if(playertextid == TDPlayerSkinsStore[playerid][2]) //exit
    {
        HideTDPlayerSkinsStore(playerid);

        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 217.3514, -98.5038, 1005.2578, 200.0, 0, 0, 0, 0, 0, 0);

        SpawnPlayer(playerid);
        return 1;
    }
    if(playertextid == TDPlayerSkinsStore[playerid][3]) //buy
    {
        if(strcmp(SkinsListStore[skinidlist[playerid]][sls_sex], PlayerInfo[playerid][sexo]))
            return SendClientMessage(playerid, Erro, "Seu sexo n�o � o mesmo que a skin selecionada");

        if(PlayerInfo[playerid][Dinheiro] < SkinsListStore[skinidlist[playerid]][sls_price])
            return SendClientMessage(playerid, Erro, "Voc� n�o tem dinheiro suficiente");

        PlayerInfo[playerid][Dinheiro] -= SkinsListStore[skinidlist[playerid]][sls_price];
        UpdatePlayerMoney(playerid);

        if(strcmp(BusinessInfo[idbusiness[playerid]][cName], "N/A"))
            { BusinessInfo[idbusiness[playerid]][cSafe] += SkinsListStore[skinidlist[playerid]][sls_price]; }

        HideTDPlayerSkinsStore(playerid);
        PlayerInfo[playerid][skin] = SkinsListStore[skinidlist[playerid]][sls_skinid];
        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 217.3514, -98.5038, 1005.2578, 200.0, 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);

        format(String, sizeof(String), "Voc� comprou a skin {FF4000}%s{FFFFFF} por {1b6302}$%d", SkinListName(SkinsListStore[skinidlist[playerid]][sls_skinid]), SkinsListStore[skinidlist[playerid]][sls_price]);
        SendClientMessage(playerid, White, String);
        return 1;
    }
    if(playertextid == TDPlayerSkinsStore[playerid][4]) //left
    {
        if(skinidlist[playerid] == 0)
            return SendClientMessage(playerid, Erro, "N�o tem mais skins");

        skinidlist[playerid]--;

        SetPlayerSkin(playerid, SkinsListStore[skinidlist[playerid]][sls_skinid]);
        format(String, sizeof(String), "~r~%s", SkinsListStore[skinidlist[playerid]][sls_sex]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinsStore[playerid][0], String);
        PlayerTextDrawShow(playerid, TDPlayerSkinsStore[playerid][0]);
        format(String, sizeof(String), "~g~$%d", SkinsListStore[skinidlist[playerid]][sls_price]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinsStore[playerid][1], String);
        PlayerTextDrawShow(playerid, TDPlayerSkinsStore[playerid][1]);
        return 1;
    }
    if(playertextid == TDPlayerSkinsStore[playerid][5]) //right
    {
        if(skinidlist[playerid] == 217)
            return SendClientMessage(playerid, Erro, "N�o tem mais skins");

        skinidlist[playerid]++;

        SetPlayerSkin(playerid, SkinsListStore[skinidlist[playerid]][sls_skinid]);
        format(String, sizeof(String), "~r~%s", SkinsListStore[skinidlist[playerid]][sls_sex]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinsStore[playerid][0], String);
        PlayerTextDrawShow(playerid, TDPlayerSkinsStore[playerid][0]);
        format(String, sizeof(String), "~g~$%d", SkinsListStore[skinidlist[playerid]][sls_price]);
        PlayerTextDrawSetString(playerid, TDPlayerSkinsStore[playerid][1], String);
        PlayerTextDrawShow(playerid, TDPlayerSkinsStore[playerid][1]);
        return 1;
    }
    return 1;
}

forward ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5);
public ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i; i <= MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) {
                    SendClientMessage(i, col1, string);
                } else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) {
                    SendClientMessage(i, col2, string);
                } else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) {
                    SendClientMessage(i, col3, string);
                } else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) {
                    SendClientMessage(i, col4, string);
                } else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) {
                    SendClientMessage(i, col5, string);
                }
            }
        }
    }
    return 1;
}

forward OnPlayerClearChat(playerid);
public OnPlayerClearChat(playerid)
{
    for(new i=0; i < 50; i++)
    {
        SendClientMessage(playerid, -1, "");
    }
    return 1;
}

forward ClockUP(playerid);
public ClockUP(playerid)
{
    if(PlayerInfo[playerid][segUP] == 0 && PlayerInfo[playerid][minUP] == 0)
    {
        if(PlayerInfo[playerid][Logado] && !AntiAfk[playerid][aa_afk])
        {
            PlayerInfo[playerid][Exp]++;

            if(IsPlayerVip(playerid))
            {
                if(PlayerInfo[playerid][Exp] >= 3)
                {
                    PlayerInfo[playerid][Level]++;
                    PlayerInfo[playerid][Exp] = 0;

                    SetPlayerScore(playerid, PlayerInfo[playerid][Level]);
                    Salario(playerid);

                    SendClientMessage(playerid, 0x75EA00AA, "Voc� ganhou +1 de Experi�ncia ( 3/3 )");
                    format(String, sizeof(String), "Voc� juntou 3 de Experi�ncia e ganhou +1 level ( %d ) ", PlayerInfo[playerid][Level]);
                }
                else
                {
                    format(String, sizeof(String), "Voc� ganhou +1 de Experi�ncia ( %d/3 )", PlayerInfo[playerid][Exp]);
                }
            }
            else
            {
                if(PlayerInfo[playerid][Exp] >= 6)
                {
                    PlayerInfo[playerid][Level]++;
                    PlayerInfo[playerid][Exp] = 0;

                    SetPlayerScore(playerid, PlayerInfo[playerid][Level]);
                    Salario(playerid);

                    SendClientMessage(playerid, 0x75EA00AA, "Voc� ganhou +1 de Experi�ncia ( 6/6 )");
                    format(String, sizeof(String), "Voc� juntou 6 de Experi�ncia e ganhou +1 level ( %d ) ", PlayerInfo[playerid][Level]);
                }
                else
                {
                    format(String, sizeof(String), "Voc� ganhou +1 de Experi�ncia ( %d/6 )", PlayerInfo[playerid][Exp]);
                }
            }

            SendClientMessage(playerid, 0x75EA00AA, String);
            GameTextForPlayer(playerid, "~w~UP!", 3000, 6);
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
    }

    if(PlayerInfo[playerid][segUP] == -1)
    {
        if(PlayerInfo[playerid][minUP] == 0)
        PlayerInfo[playerid][minUP] = 10;
        PlayerInfo[playerid][segUP] = 59;
        PlayerInfo[playerid][minUP]--;
    }
    format(String, sizeof(String), "~w~+~r~UP: ~w~%02d:%02d", PlayerInfo[playerid][minUP], PlayerInfo[playerid][segUP]);
    PlayerTextDrawSetString(playerid, PlayerBarStatus[playerid][0], String);
    PlayerInfo[playerid][segUP]--;
    return 1;
}

forward RestartServer();
public RestartServer()
{
    SendClientMessageToAll(0xB9FFFFAA, "| VRC-Admin | O Server reiniciara em 1 minuto");
    SetTimer("RestartServer1", 55000, false);
    return 1;
}

forward RestartServer1();
public RestartServer1()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && PlayerInfo[i][Logado])
        {
            SaveAccounts(i);
            Kick(i);
        }
	}
    SetTimer("RestartServer2", 5000, false);
    return 1;
}

forward RestartServer2();
public RestartServer2()
{
    SendClientMessageToAll(0xB9FFFFAA, "| VRC-Admin | O Server reinicio aguarde");
    SendRconCommand("gmx");
    return 1;
}

stock ZerandoVariaveis(playerid)
{
    PlayerInfo[playerid][ID] = 0;
    PlayerInfo[playerid][Profissao] = 0;
    PlayerInfo[playerid][Semprofissao] = 0;
    PlayerInfo[playerid][Nome] = 0;
    PlayerInfo[playerid][Senha] = 0;
    PlayerInfo[playerid][Email] = 0;
    PlayerInfo[playerid][Admin] = 0;
    PlayerInfo[playerid][minUP] = 0;
    PlayerInfo[playerid][segUP] = 0;
    PlayerInfo[playerid][Level] = 0;
    PlayerInfo[playerid][Exp] = 0;
    PlayerInfo[playerid][Reais] = 0;
    PlayerInfo[playerid][skin] = -1;
    PlayerInfo[playerid][Avisos] = 0;
    PlayerInfo[playerid][Estrelas] = 0;
    PlayerInfo[playerid][Dinheiro] = 0;
    PlayerInfo[playerid][SaldoBancario] = 0;
    PlayerInfo[playerid][Matou] = 0;
    PlayerInfo[playerid][Morreu] = 0;
    PlayerInfo[playerid][Interior] = 0;
    PlayerInfo[playerid][PosX] = 0;
    PlayerInfo[playerid][PosY] = 0;
    PlayerInfo[playerid][PosZ] = 0;
    PlayerInfo[playerid][PosA] = 0;
    PlayerInfo[playerid][Logado] = false;

    PlayerInfo[playerid][sexo] = 0;

    pPlayerInfo[playerid][pNome] = 0;
    pPlayerInfo[playerid][pSenha] = 0;
    pPlayerInfo[playerid][pEmail] = 0;

    CarroAdmin[playerid] = 0;

    viewcmds[playerid] = false;

    KillTimer(TempoPreso[playerid]);
    KillTimer(UPRelogio[playerid]);
    return 1;
}

stock formatSeconds(seconds, &hours_left, &minutes_left, &seconds_left)
{
    hours_left = seconds/60/60;
    minutes_left = (seconds - hours_left*60*60 )/60;
    seconds_left = (seconds - hours_left*60*60 - minutes_left*60);
    return 1;
}

stock GetDistanceBetweenPlayers(playerid,playerid2)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    new Float:dis;
    GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerPos(playerid2,x2,y2,z2);
    dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(dis);
}

stock NitroInfinito(arg)
{
    switch(GetVehicleModel(arg))
    {
        case 444: return 0;
        case 581: return 0;
        case 586: return 0;
        case 481: return 0;
        case 509: return 0;
        case 446: return 0;
        case 556: return 0;
        case 443: return 0;
        case 452: return 0;
        case 453: return 0;
        case 454: return 0;
        case 472: return 0;
        case 473: return 0;
        case 484: return 0;
        case 493: return 0;
        case 595: return 0;
        case 462: return 0;
        case 463: return 0;
        case 468: return 0;
        case 521: return 0;
        case 522: return 0;
        case 417: return 0;
        case 425: return 0;
        case 447: return 0;
        case 487: return 0;
        case 488: return 0;
        case 497: return 0;
        case 501: return 0;
        case 548: return 0;
        case 563: return 0;
        case 406: return 0;
        case 520: return 0;
        case 539: return 0;
        case 553: return 0;
        case 557: return 0;
        case 573: return 0;
        case 460: return 0;
        case 593: return 0;
        case 464: return 0;
        case 476: return 0;
        case 511: return 0;
        case 512: return 0;
        case 577: return 0;
        case 592: return 0;
        case 471: return 0;
        case 448: return 0;
        case 461: return 0;
        case 523: return 0;
        case 510: return 0;
        case 430: return 0;
        case 465: return 0;
        case 469: return 0;
        case 513: return 0;
        case 519: return 0;
    }
    return 1;
}

stock GetPlayerHighestScores(array[][rankingEnum], left, right)
{
    new tempLeft = left,
        tempRight = right,
        pivot = array[(left + right) / 2][player_Score],
        tempVar;

    while(tempLeft <= tempRight)
    {
        while(array[tempLeft][player_Score] > pivot) tempLeft++;
        while(array[tempRight][player_Score] < pivot) tempRight--;

        if(tempLeft <= tempRight)
        {
            tempVar = array[tempLeft][player_Score], array[tempLeft][player_Score] = array[tempRight][player_Score], array[tempRight][player_Score] = tempVar;
            tempVar = array[tempLeft][player_ID], array[tempLeft][player_ID] = array[tempRight][player_ID], array[tempRight][player_ID] = tempVar;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) GetPlayerHighestScores(array, left, tempRight);
    if(tempLeft < right) GetPlayerHighestScores(array, tempLeft, right);
}

stock HexToInt(string[])
{
    if(!string[0]) return 0;
    new cur = 1, res = 0;
    for(new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

stock IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if(string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

stock IsValidUsername(name[])
{
	new i, len = strlen(name);

	if(len < 3) return 0;

	while(i < len)
	{
		switch(name[i])
		{
			case 'a'..'z', 'A'..'Z', '0'..'9', '.', '_':
				i++;
			default:
				return 0;
		}
	}
	return 1;
}

stock IsValidMessageHouse(name[])
{
	new i, len = strlen(name);

	if(len < 3) return 0;

	while(i < len)
	{
		switch(name[i])
		{
			case 'a'..'z', 'A'..'Z', '0'..'9', '.', '_', ' ', '{', '}', '?', '!':
				i++;
			default:
				return 0;
		}
	}
	return 1;
}

stock IsMoney(integer, delimiter[] = ",")
{
    new str[16];

    format(str, sizeof str, "%i", integer);

    for (new i = strlen(str) - 3, j = ((integer < 0) ? 1 : 0); i > j; i -= 3)
    {
        strins(str, delimiter, i, sizeof str);
    }
    return str;
}

stock GetPlayerID(playername[])
{
    for(new i=0; i <= MAX_PLAYERS; i++)
    {
        if(strcmp(playername, PlayerInfo[i][Nome], true)==0 && PlayerInfo[i][Logado] == true)
        {
            return i;
        }
        else
        {
            return true;
        }
    }
    return true;
}

stock CrashPlayer(playerid)
{
    GameTextForPlayer(playerid, "~wwwwww", 1000, 4);
    Kick(playerid);
    return 1;
}

stock TextConverter(string[])
{
    for(new arraysize = 0; arraysize < strlen(string); arraysize++)
    {
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
        if(strfind(string, "�", true) != -1){new pos = strfind(string, "�", true); strdel(string, pos, pos+strlen("�")); strins(string, "�", pos, sizeof(pos));}
    }
    return 1;
}

stock CreateRandomCode()
{
    new code[10], Coding[36][2] =
    {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "W", "Y", "Z"
    };

    code[0] = random(sizeof(Coding));
    code[1] = random(sizeof(Coding));
    code[2] = random(sizeof(Coding));
    code[3] = random(sizeof(Coding));
    code[4] = random(sizeof(Coding));
    code[5] = random(sizeof(Coding));
    code[6] = random(sizeof(Coding));
    code[7] = random(sizeof(Coding));
    code[8] = random(sizeof(Coding));
    code[9] = random(sizeof(Coding));

    format(String, sizeof(String), "%s%s%s%s%s%s%s%s%s%s", Coding[code[0]], Coding[code[1]], Coding[code[2]], Coding[code[3]], Coding[code[4]], Coding[code[5]], Coding[code[6]], Coding[code[7]], Coding[code[8]], Coding[code[9]]);

    new query[100];

    mysql_format(IDConexao, query, sizeof(query), "SELECT `Code` FROM `Contas` WHERE `Code`='%e'", String);
    mysql_query(IDConexao, query);

    if(cache_num_rows() != 0) return CreateRandomCode();

    return String;
}

stock IsValidCodingAccount(playerid, coding[])
{
    new query[100];
    mysql_format(IDConexao, query, sizeof(query), "SELECT `Code` FROM `Contas` WHERE `Code`='%e' AND `id`='%d'", coding, PlayerInfo[playerid][ID]);
    mysql_query(IDConexao, query);

    if(cache_num_rows() != 0) return true;
    return false;
}
