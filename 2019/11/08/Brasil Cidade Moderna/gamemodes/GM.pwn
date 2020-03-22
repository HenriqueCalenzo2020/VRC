//-----------------------------------------
//By: Henrique Calenzo
//Date: 23/03/2019
//-----------------------------------------
#include                        a_samp
#include                        a_mysql
#include                        streamer
#include                        cpstream
#include                        modules\color

#define vip_area                        5
#define mob                             6
#define honest                          7
#define transport                       8
#define police                          9
#define government                      10
#define help                            11
#define tuning                          12
#define paintjob                        13
#define nitro                           14
#define hydraulic                       15
#define wheel                           16
#define rename                          17
#define radio                           18
#define colorname                       19
#define vip_color_tag                   20
#define reais                           21
#define reais_vip                       22
#define cmds_adm_pg1                    23
#define cmds_adm_pg2                    24
#define cmds_adm_pg3                    25
#define cmds_adm_pg4                    26
#define bank_balance                    27
#define bank_draft                      28
#define bank_deposit                    29
#define bank                            30
#define agency                          31

#define Desempregado                    0
#define EntregadorJornal                1
#define Advogado                        2

#define Taxi                            3

#define PoliciaMunicipal                4

#define Corregedoria                    5

#define LadraoGas                       6

#define C_Desempregado          0xFFFFFFAA
#define C_EntregadorJornal      0x80FF80AA
#define C_Advogado              0x8000FFAA
#define C_Taxi                  0xFFFF00AA
#define C_PoliciaMunicipal      0x66B3FFAA
#define C_Corregedoria          0x8080C0AA
#define C_LadraoGas             0xFF8080AA

#define Salario_Desempregado        150

#define Salario_EntregadorJornal    250
#define Salario_Advogado            1000

#define Salario_Taxi                350

#define Salario_PoliciaMunicipal    1000

#define Salario_Corregedoria        5000

enum pInfo
{
    ID,
    Profissao,
    Semprofissao,
    Nome[MAX_PLAYER_NAME],
    Senha[MAX_PLAYER_PASS],
    Email[MAX_PLAYER_EMAIL],
    Admin,
    minUP,
    segUP,
    Level,
    Exp,
    Reais,
    Skin,
    Avisos,
    Estrelas,
    Dinheiro,
    SaldoBancario,
    Matou,
    Morreu,
    Interior,
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:PosA,
    bool:Afk,
    bool:Logado
};

enum BanidosE {
    bResponsavel[MAX_PLAYER_NAME],
    bMotivo[24],
    bDia[24],
    bVencimento[24],
    bHora[24]
}

enum ppInfo
{
    pNome[MAX_PLAYER_NAME],
    pSenha[MAX_PLAYER_PASS],
    pEmail[MAX_PLAYER_EMAIL]
};

enum rankingEnum
{
    player_Score,
    player_ID
}

new BanidosEnum[MAX_PLAYERS][BanidosE];
new pPlayerInfo[MAX_PLAYERS][ppInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];

new bool:LiberarRelatorio[MAX_PLAYERS char];
new bool:LiberarDuvida[MAX_PLAYERS char];
new bool:cVehicle[MAX_PLAYERS];
new bool:PegouGas[MAX_PLAYERS];
new bool:Respawnando;

new String[256];
new TempoPreso[MAX_PLAYERS];
new CarroAdmin[MAX_PLAYERS];
new UPRelogio[MAX_PLAYERS];
new Float:X, Float:Y, Float:Z, Float:A;
new Ano, Mes, Dia, Hora, Min, Seg;
new Sem_Chat_Global=0;
new Cor1, Cor2;

new Text:RespawnVeiculos;

new cps_areavip;
new cps_mafia;
new cps_agencia;
new cps_bank;

new PEmprego[MAX_PLAYERS];

new PortaPolicia;

new Count = 5;
new ContadorTxT[5][19] =
{
	"~y~] ]~w~ 1 ~y~] ]",
	"~y~] ]~w~ 2 ~y~] ]",
	"~r~] ]~w~ 3 ~r~] ]",
	"~r~] ]~w~ 4 ~r~] ]",
	"~r~] ]~w~ 5 ~r~] ]"
};

new MSGs[16][128] =
{
    "{FFFFFF}[!] {76EE00}Para ver seu level ~~> /Meulevel",
    "{FFFFFF}[!] {76EE00}Jogar em nosso servidor � um privilegio e n�o direito!",
    "{FFFFFF}[!] {76EE00}Ofensa � Staff Ser� Punido com Ban",
    "{FFFFFF}[!] {76EE00}Se cadastrem no F�rum e fique por dentro das novidades ~~> /Ajuda ~~> Contatos",
    "{FFFFFF}[!] {76EE00}Viu uma pessoa dando Teleporte? /Relatorio",
    "{FFFFFF}[!] {FF8C00}Inscreva-se em nosso canal no YouTube: www.youtube.com/channel/UCMijwRnIbRf2RerUEST-sqg?",
    "{FFFFFF}[!] {76EE00}Deseja VIP ? Acesse nosso site e confira: https://n290690.tryinvision.com/",
    "{FFFFFF}[!] {76EE00}Bem vindo(a) ao Brasil Cidade Moderna",
    "{FFFFFF}[!] {76EE00}Para ver os Players Level Alto Digite ~~> /Toplevel",
    "{FFFFFF}[!] {76EE00}Chame Seus Amigo pro Servidor Fica Mais Divertido",
    "{FFFFFF}[!] {76EE00}Para evitar puni��es, sempre respeite as regras, use: /Regras",
    "{FFFFFF}[!] {76EE00}Caso esteja com pouco combustivel, procure um dos 10 postos espalhados por San Andreas",
    "{FFFFFF}[!] {76EE00}Veja Todos Contatos do Servidor: /Ajuda ~~> Contatos",
    "{FFFFFF}[!] {76EE00}Para denuciar Cheaters ou Abusers ~~> /Relatorio",
    "{FFFFFF}[!] {76EE00}Para ver as vantagens VIP /Vantagensvip",
    "{FFFFFF}[!] {76EE00}Est� precisando de ajuda e n�o tem nenhum admin online ? ~~> /Ajuda"
};

#include modules\database\db_accounts.sql
#include modules\database\db_ban.sql

#include modules\prison
#include modules\profession\police\pm
#include modules\profession\honest\entregadordejornal

#include modules\hud
#include modules\agency
#include modules\vehicles
#include modules\speedometer
#include modules\enterexit
#include modules\nexthospital

#include modules\player\barstatus
#include modules\player\loginscreen
#include modules\player\vips
#include modules\player\houses

#include modules\object\hospital
#include modules\object\labels
#include modules\object\pickups

main(){}

public OnGameModeInit()
{
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);

    RespawnVeiculos = TextDrawCreate(317.799987, 192.346771, "");
    TextDrawLetterSize(RespawnVeiculos, 0.400000, 1.600000);
    TextDrawAlignment(RespawnVeiculos, 2);
    TextDrawColor(RespawnVeiculos, -1);
    TextDrawSetShadow(RespawnVeiculos, 0);
    TextDrawSetOutline(RespawnVeiculos, -1);
    TextDrawBackgroundColor(RespawnVeiculos, 255);
    TextDrawFont(RespawnVeiculos, 1);
    TextDrawSetProportional(RespawnVeiculos, 1);
    TextDrawSetShadow(RespawnVeiculos, 0);

    CreateObject(19302, 250.49590, 63.33670, 1003.84442, 0.00000, 0.00000, 90.00000);//250.49590, 63.33670, 1006.37250
    PortaPolicia = CreateObject(19302, 246.39900, 72.49900, 1003.85809, 0.00000, 0.00000, 0.00000);// 246.39900, 72.49900, 1007.10938

    cps_areavip = CPS_AddCheckpoint(-783.7917, 495.3470, 1376.1953, 1.0, 30);
    cps_bank = CPS_AddCheckpoint(2310.0422, -8.3888, 26.7422, 1.0, 30);
    cps_mafia = CPS_AddCheckpoint(2360.1792, -652.2457, 128.0910, 1.0, 50);
    cps_agencia = CPS_AddCheckpoint(1490.8159, 1305.7130, 1093.2964, 1.0, 30);

    UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();

    SetTimer("RandomMSGs", 1000*60*20, true);
    SetTimer("HourGame", 1000, true);

	SetGameModeText("Brasil - BCM v1.0.0");
	SendRconCommand("mapname San Andreas");
	SendRconCommand("hostname Brasil Cidade Moderna � #Ultra-h.com");
	SendRconCommand("language Portugu�s - Brasil");
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    TogglePlayerSpectating(playerid, true);
    InterpolateCameraPos(playerid, -2397.553710, 1436.038452, 140.798019, -2876.055175, 1382.189697, 159.150161, 17000);
    InterpolateCameraLookAt(playerid, -2401.776855, 1438.431640, 139.599197, -2872.188964, 1384.818359, 157.377395, 17000);
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayAudioStreamForPlayer(playerid, "http://listen.shoutcast.com:80/RadioHunter-TheHitzChannel");
    format(String, sizeof(String), "Entrando_%d", playerid);
    SetPlayerName(playerid, String);
    SelectTextDraw(playerid, Verde);

    ShowTextDrawLogin(playerid);

    SetTimerEx("OnPlayerUpdateCreate", 1000, true, "i", playerid);
    UPRelogio[playerid] = SetTimerEx("ClockUP", 1000,true,"i",playerid);
    SetTimerEx("OnPlayerClearChat", 4000, false, "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ProfessionPmDisconnect(playerid);
    SpeedometerDisconnect(playerid);
    DeletarSair(playerid);
    SaveAccounts(playerid);
    DBSavePrisons(playerid);
    ZerandoVariaveis(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    CancelSelectTextDraw(playerid);
    StopAudioStreamForPlayer(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason);
    PlayerInfo[killerid][Estrelas]+=5;
    PlayerInfo[playerid][Morreu]++;
    PlayerInfo[killerid][Matou]++;
    DeletarSair(playerid);
    format(String, sizeof(String), "%d", PlayerInfo[killerid][Estrelas]);
    PlayerTextDrawSetString(killerid, PlayerStatus[killerid][21], String);
    PlayerTextDrawShow(killerid, PlayerStatus[killerid][21]);
    format(String, sizeof(String), "| PROCURADO(A) | O(A) %s %s[%d] feriu %s[%d] e foi colocado +5 estrelas de procurado(a)",GetProfession(killerid), PlayerInfo[killerid][Nome], killerid, PlayerInfo[playerid][Nome], playerid);
    ProxDetector(50.0, playerid, String, 0xB9FFFFAA, 0xB9FFFFAA, 0xB9FFFFAA, 0xB9FFFFAA, 0xB9FFFFAA);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    DeletarSair(killerid);
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(PlayerInfo[playerid][Afk] == true)
    {
        SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Antes de falar, digite: /Sairafk");
        return false;
    }
    if(PlayerInfo[playerid][Logado] == false)
    {
        SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� n�o est� logado!");
        return false;
    }
    if(PlayerInfo[playerid][Admin] == 5)
    {
        format(String, sizeof(String), "%s {FFFFFF}[{328E0A}Desenvolvedor(a){FFFFFF}][%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    if(PlayerInfo[playerid][Admin] == 4)
    {
        format(String, sizeof(String), "%s {FFFFFF}[{FF0000}Coordenador(a){FFFFFF}][%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    if(PlayerInfo[playerid][Admin] == 3)
    {
        format(String, sizeof(String), "%s {FFFFFF}[{008bce}Admininstrador(a){FFFFFF}][%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    if(PlayerInfo[playerid][Admin] == 2)
    {
        format(String, sizeof(String), "%s {FFFFFF}[{FF8C00}Moderador(a){FFFFFF}][%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    if(PlayerInfo[playerid][Admin] == 1)
    {
        format(String, sizeof(String), "%s {FFFFFF}[{FFFF00}Ajudante{FFFFFF}][%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    if(Sem_Chat_Global == 0)
    {
        format(String, sizeof(String), "%s {FFFFFF}[%d]: %s", PlayerInfo[playerid][Nome], playerid, text);
        ProxDetector(30.0, playerid, String, GetPlayerColor(playerid), GetPlayerColor(playerid), PlayerInfo[playerid][Nome], GetPlayerColor(playerid), GetPlayerColor(playerid));
        return false;
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128], idx;
    cmd = strtok(cmdtext, idx);

    if(PlayerInfo[playerid][Logado] == false)
        return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� n�o est� logado!");

    if(PlayerInfo[playerid][Afk] == true)
        return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Antes de usar comando, digite: /Sairafk");

    if(PrisonEnum[playerid][pTempo] != 0)
        return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� est� preso e n�o pode usar comando!");

    if(Algemado[playerid] == true)
        return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� est� algemado e n�o pode usar comando!");

    #include modules\player\command\cmds_adm

    #include modules\player\command\cmds_ambos
    #include modules\player\command\cmds_policiamilitar
    #include modules\player\command\cmds_ladraodegas

    #include modules\player\command\cmds_vip

    #include modules\player\command\cmds_houses

    #include modules\player\command\cmds_gerais

	return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Comando Inv�lido!");
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    DeletarSair(playerid);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    new cpid = CPS_GetPlayerCheckpoint(playerid);

    if(cpid == cps_mafia)
        return ShowPlayerDialog(playerid, mob, DIALOG_STYLE_LIST, "{FF0000}Cargos", "{FFFFFF}Ladr�o de g�s ", "Selecionar", "Fechar");

    if(cpid == cps_agencia)
        return ShowPlayerDialog(playerid, agency, DIALOG_STYLE_LIST, "{FF0000}Menu Empregos", "{FFFFFF}Classe � {80FF80}Honesta \n{FFFFFF}Classe � {80FFFF}Transporte \n{FFFFFF}Classe � {51A8FF}Policia \n{FFFFFF}Classe � {626262}Governo ", "Selecionar", "Fechar");

    if(cpid == cps_bank)
        return ShowPlayerDialog(playerid, bank, DIALOG_STYLE_LIST, "{FF0000}Banco", "{FFFFFF}Saldo \nSaque \nDeposito", "Selecionar", "Cancelar");

    if(cpid == cps_areavip)
        return ShowPlayerDialog(playerid, vip_area, DIALOG_STYLE_LIST, "{FFFFFF}Armas �rea [{FF0000}VIP{FFFFFF}]", "{FFFFFF}Chainsaw \nCombate Shotgun \nSawnoff \nUZI \nMP5 \nTec-9 \nM4 \nAK-47 \nRifle \nSniper", "Escolher", "Cancelar");

	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    GetEnterExitStatus(playerid, pickupid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_YES))
    {
        if(IsPlayerInRangeOfPoint(playerid, 1.5, 254.1715,74.3339,1003.6406) && PlayerInfo[playerid][Profissao] == PoliciaMunicipal)
        {
            SetPlayerSkin(playerid, 287);
            SetPlayerArmour(playerid, 100);
            GivePlayerWeapon(playerid, 31, 2000);
            GivePlayerWeapon(playerid, 28, 2000);
            GivePlayerWeapon(playerid, 24, 2000);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1.5, 254.1715,74.3339,1003.6406) && PlayerInfo[playerid][Profissao] != PoliciaMunicipal)
        {
            SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� n�o tem permiss�o!");
        }
    }
    if(newkeys == KEY_SECONDARY_ATTACK)
    {
        if(IsPlayerHelper(playerid) || PlayerInfo[playerid][Profissao] == PoliciaMunicipal)
        {
            OpeningPolicePort(playerid);
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
                    new textos[500];
                	strcat(textos, "{a4a4a4}A cada 10 minutos jogado Voc� ganhar� 1 ponto de experi�ncia \n");
                    strcat(textos, "{a4a4a4}Juntando 6 pontos de experi�ncia Voc� ganhar� +1 level \n\n");
                    strcat(textos, "{a4a4a4}Jogadores(as) VIPs ter� que juntar 5 experi�ncia para ganhar +1 level \n\n");
                    strcat(textos, "{FFFFFF}�{66cdaa} /MeuLevel {FFFFFF}- Para ver seu level \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Level", textos, "Fechar", "");
                }
                case 1:
                {
                    new textos[500];
                	strcat(textos, "{a4a4a4}O Sal�rio � creditado em sua conta banc�ria ao completar UP ( 6/6 ) \n\n");
                    strcat(textos, "{a4a4a4}Jogadores(as) VIPs ter� sal�rio creditado ao completar UP ( 5/5 ) \n\n");
                    strcat(textos, "{a4a4a4}Cada profiss�o tem um sal�rio diferente e justo \n\n");
                    strcat(textos, "{a4a4a4}Cargos da mafia n�o recebem sal�rio \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Sal�rio", textos, "Fechar", "");
                }
                case 2:
                {
                    new textos[2000];
                	strcat(textos, "{00FFFF}�{FFFFFF} /Regras {FFFFFF}- Para ver as regras do servidor\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Creditos {FFFFFF}- Para ver os cr�ditos do servidor\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Admins {FFFFFF}- Para ver os Admins online no momento\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /MeuLevel {FFFFFF}- Para ver seu level atual\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /VantagensVip {FFFFFF}- Para saber as vantagens V.I.P\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Sairafk {FFFFFF}- Para sair do modo AFK\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Profissao {FFFFFF}- Para ver os comandos da profiss�o\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Abastecer {FFFFFF}- Para abastecer um ve�culo em um determinado posto\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Animes {FFFFFF}- Para ver a lista de animes dispon�vel\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /190 [Den�ncia] {FFFFFF}- Para fazer uma den�ncia � policia\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /193 [Local] {FFFFFF}- Para chamar a equipe de param�dicos\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Duvida [Duvida]{FFFFFF}- Para tirar alguma d�vida com algum membro da Administra��o\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Relatorio [Playerid][Denucia]{FFFFFF}- Para denunciar algum jogador fora das regras ou usando hack\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Transferir {FFFFFF}- Para transferir uma determinada quantia a um determinado jogador\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /identidade {FFFFFF}- Para ver sua identidade\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Toplevel {FFFFFF}- Para ver os Level Alto\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Taxi [Local]{FFFFFF}- Chamar um Taxi\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Mecanico [Local]{FFFFFF}- Chamar um Mecanico\n");
                	strcat(textos, "{00FFFF}�{FFFFFF} /Radio {FFFFFF}- Para ligar a R�dio \n");
                	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Ajuda Comandos", textos, "Fechar", "");
                }
                case 3:
                {
                    new textos[500];
                    strcat(textos, "{FFFFFF}�{FF0000} F�rum: {FFFFFF}Em Breve \n");
                    strcat(textos, "{FFFFFF}�{FF0000} Facebook: {FFFFFF}Em Breve \n");
                    strcat(textos, "{FFFFFF}�{FF0000} IP do TeamSpeak 3: {FFFFFF}Em Breve \n");
                    strcat(textos, "{FFFFFF}�{FF0000} IP do Servidor ( v1.0.0 ) {FFFFFF}Em Breve \n");
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Contatos", textos, "Fechar", "");
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
        if(response)
        {
            if(strlen(inputtext) < MIN_PLAYER_NAME || strlen(inputtext) > MAX_PLAYER_NAME)
                return ShowPlayerDialog(playerid, rename, DIALOG_STYLE_INPUT, "{FF0000}Mudar nick", "{FFFFFF}Digite seu novo nick e clique em {FF0000}Mudar\n{FFFFFF}Por favor n�o coloque {FF0000}ESPA�O {FFFFFF}em seu nick:\n{FF0000}0xFF4000AA digite um nome entre 6 a 30 caracteres!", "Mudar", "Sair");

            mysql_format(IDConexao, String, sizeof(String), "SELECT `Nome` FROM Contas WHERE `Nome`='%s'", inputtext);
            mysql_query(IDConexao, String);

            if(cache_num_rows() > 0)
                return ShowPlayerDialog(playerid, rename, DIALOG_STYLE_INPUT, "{FF0000}Mudar nick", "{FF0000}O nick que voc� escolheu j� existe\n\n {FFFFFF}Tente outro nick abaixo e clique em {FF0000}Mudar", "Mudar", "Sair");

            format(String, sizeof(String), "| NICK | O(A) jogador(a) %s mudou o nick para ( %s )", PlayerInfo[playerid][Nome], inputtext);
            SendClientMessageToAll(Amarelo, String);

            PlayerInfo[playerid][Reais] -= 7000;

            mysql_format(IDConexao, String, sizeof(String), "UPDATE Contas SET Nome='%e', Reais='%d' WHERE Nome='%e'", inputtext, PlayerInfo[playerid][Reais], PlayerInfo[playerid][Nome]);
            mysql_query(IDConexao, String);

            format(PlayerInfo[playerid][Nome], MAX_PLAYER_NAME, inputtext);
            SetPlayerName(playerid, PlayerInfo[playerid][Nome]);
        }
        if(!response) return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Voc� cancelou a troca de nick!");
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
                return ShowPlayerDialog(playerid, colorname, DIALOG_STYLE_INPUT, "{FF0000}Cor nick", "{FFFFFF}Digite um codigo em '{FF0000}HTML{FFFFFF}' abaixo\nPesquise no Google algo como {00FF00}Cores em HTML {FFFFFF}:\n{FF0000}Exemplo {FFFFFF}00FF00 = {00FF00}Calenzo\n{FF0000}0xFF4000AA digite uma cor 'HTML' com 6 digitos!", "Alterar", "Cancelar");

            format(String, sizeof(String), "0x%sAA", inputtext);
            SetPlayerColor(playerid, HexToInt(String));
            format(String, sizeof(String), "| BCM Admin | A cor do seu nick {%s}%s{FFFFFF} foi alterado com sucesso!", inputtext, PlayerInfo[playerid][Nome]);
            SendClientMessage(playerid, Branco, String);
        }
        return 1;
    }

    #include modules\dialog\bank

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
    if(dialogid == reais)
    {
        if(response)
        {
            if(listitem == 0)
            {
                new textos[200];
                strcat(textos, "{FF0000}Dia(s) \t\t{1CEB00}Real(is)\n");
                strcat(textos, "{FFFFFF}1 Dia \t\t{31B404}R$1,00\n");
                strcat(textos, "{FFFFFF}15 Dias \t\t{31B404}R$10,00\n");
                strcat(textos, "{FFFFFF}30 Dias \t\t{31B404}R$20,00\n");
                strcat(textos, "{FFFFFF}60 Dias \t\t{31B404}R$45,00\n");
        		ShowPlayerDialog(playerid, reais_vip, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos VIP", textos, "Comprar", "Voltar");
            }
        }
        return 1;
    }
    if(dialogid == reais_vip)
    {
        if(!response)
            return ShowPlayerDialog(playerid, reais, DIALOG_STYLE_LIST, "{FF0000}Reais", "Comprar VIP", "Continuar", "Cancelar");

        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][Reais] < 1000)
                    return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Infelizmente voc� n�o tem Reais o suficiente.");

                SetVip(playerid, 1);
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][Reais] < 10000)
                    return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Infelizmente voc� n�o tem Reais o suficiente.");

                SetVip(playerid, 10);
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][Reais] < 20000)
                    return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Infelizmente voc� n�o tem Reais o suficiente.");

                SetVip(playerid, 20);
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][Reais] < 45000)
                    return SendClientMessage(playerid, 0xFF4000AA, "| ERRO | Infelizmente voc� n�o tem Reais o suficiente.");

                SetVip(playerid, 60);
            }
        }
        return 1;
    }
    if(dialogid == cmds_adm_pg1)
    {
        if(response)
        {
            new txt[2800];
            strcat(txt, "{FF0000}Comandos \t\t{1CEB00}Informa��es\n");
            strcat(txt, "{87CEFF}/Ir [id] \t\t{FFFFFF}Para ir at� um(a) jogador(a) \n");
    		strcat(txt, "{87CEFF}/Trazer [id] \t\t{FFFFFF}Para puxar um(a) jogador(a) \n");
    		strcat(txt, "{87CEFF}/Punicao [id][minutos][motivo] \t\t{FFFFFF}Para prender um(a) jogador(a) \n");
    		strcat(txt, "{87CEFF}/Despunicao [id] \t\t{FFFFFF}Para soltar um(a) jogador(a) \n");
            strcat(txt, "{87CEFF}/EncherVida [id] \t\t{FFFFFF}Para recuperar a vida de um(a) jogador(a) \n");
            strcat(txt, "{87CEFF}/EncherColete [id] \t\t{FFFFFF}Para recuperar o colete de um(a) jogador(a) \n");
            strcat(txt, "{87CEFF}/Cv [id][cor][cor] \t\t{FFFFFF}Para criar um veiculo em sua posi��o \n");
    		strcat(txt, "{87CEFF}/Ac [mensagem] \t\t{FFFFFF}Para digitar no chat da admininstra��o \n");
      		strcat(txt, "{87CEFF}/A [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) global\n");
        	strcat(txt, "{87CEFF}/Ann [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) na tela\n");
          	strcat(txt, "{87CEFF}/Cnn [mensagem] \t\t{FFFFFF}Para mandar mensagem(ns) na tela com o nome\n");
            strcat(txt, "{87CEFF}/Tps \t\t{FFFFFF}Para ver os teletransportes\n");
            strcat(txt, "{87CEFF}/Banir [id][motivo] \t\t{FFFFFF}Para banir um(a) jogador(a) permanente\n");
            strcat(txt, "{87CEFF}/DarArma [id][arma-id] \t\t{FFFFFF}Para dar uma arma para um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/DarSkin [id] [id-skin] \t\t{FFFFFF}Para dar uma skin para um(a) jogador(a)\n");
            ShowPlayerDialog(playerid, cmds_adm_pg2, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos da Admininstra��o - P�gina {00CA00}2", txt, "Pr�xima", "Cancelar");
        }
        return 1;
    }
    if(dialogid == cmds_adm_pg2)
    {
        if(response)
        {
            new txt[2800];
            strcat(txt, "{FF0000}Comandos \t\t{1CEB00}Informa��es\n");
            strcat(txt, "{87CEFF}/IrCasa [id-casa]\t\t{FFFFFF}Para se teletransportar para a casa com esse id\n");
            strcat(txt, "{87CEFF}/DarDinheiro [id][quantia] \t\t{FFFFFF}Para dar dinheiro para um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/RemoverDinheiro [id][quantia] \t\t{FFFFFF}Para remover dinheiro de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/DarVip [id][Dias] \t\t{FFFFFF}Para dar vip para um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/RemoverVip [id] \t\t{FFFFFF}Para remover o vip de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/DarAdmin [id][Nivel] \t\t{FFFFFF}Para promover/rebaixar/remover jogador(a) da admininstra��o\n");
            strcat(txt, "{87CEFF}/Reiniciar \t\t{FFFFFF}Para reiniciar o servidor\n");
            strcat(txt, "{87CEFF}/DarLevel [id][quantia] \t\t{FFFFFF}Para dar level(s) para um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/RemoverLevel [id][quantia] \t\t{FFFFFF}Para remover level(s) de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/DarReais [id][quantia] \t\t{FFFFFF}Para dar real(is) de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/RemoverReais [id][quantia] \t\t{FFFFFF}Para remover real(is) de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/R [id][resposta] \t\t{FFFFFF}Para responder a d�vida de um(a) jogador(a)\n");
            strcat(txt, "{87CEFF}/FecharServidor [senha] \t\t{FFFFFF}Para fechar o servidor com senha\n");
            strcat(txt, "{87CEFF}/AbrirServidor \t\t{FFFFFF}Para retirar a senha do servidor\n");
            ShowPlayerDialog(playerid, cmds_adm_pg3, DIALOG_STYLE_TABLIST_HEADERS, "{C0C0C0}Comandos da Admininstra��o - P�gina {00CA00}3", txt, "Pr�xima", "Cancelar");
        }
        return 1;
    }
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(IsPlayerHelper(playerid) && GetPlayerInterior(playerid) == 0)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
            PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), GetPlayerVehicleSeat(playerid));
        } else {
            SetPlayerPosFindZ(playerid, fX, fY, fZ);
        }
    }
	return 1;
}

forward Respawn1(); public Respawn1()
{
    TextDrawHideForAll(RespawnVeiculos);
    SetTimer("Respawn2", 12*1000, false);
    return 1;
}

forward Respawn2(); public Respawn2()
{
    TextDrawSetString(RespawnVeiculos, "~r~>> ~w~Respawn de veiculos nao em uso em ~g~15 ~w~segundos... ~r~<<");
    TextDrawShowForAll(RespawnVeiculos);
    SetTimer("Respawn3", 3000, false);
    return 1;
}

forward Respawn3(); public Respawn3()
{
    TextDrawHideForAll(RespawnVeiculos);
    SetTimer("CountDown", 7000, false);
    return 1;
}

forward CountDown(); public CountDown()
{
    if(Count > 0)
    {
        GameTextForAll(ContadorTxT[Count-1], 2500, 3);
        Count--;
        SetTimer("CountDown", 1000, 0);
    } else {
        TextDrawHideForAll(RespawnVeiculos);
        SendClientMessageToAll(Amarelo, "| INFO | Todos os veiculos n�o em uso foram respawnados!");
        Respawnando=false;
        GameTextForAll("~g~]] ~w~RESPAWNANDO~g~ ]]", 2500, 3);
        Count=5;
        for(new i; i < MAX_VEHICLES; i++) if(!IsVehicleInUse(i)) SetVehicleToRespawn(i);
    }
    return 1;
}

forward OnPlayerUpdateCreate(playerid); public OnPlayerUpdateCreate(playerid)
{
    if(PlayerInfo[playerid][Logado] == false) return 0;

    switch(PlayerInfo[playerid][Admin])
    {
        case 1:
            SetPlayerChatBubble(playerid, "Ajudante", 0xFFFF00AA, 80.0, 100000);
        case 2:
            SetPlayerChatBubble(playerid, "Moderador(a)", 0xFF8C00AA, 80.0, 100000);
        case 3:
            SetPlayerChatBubble(playerid, "Administrador(a)", 0x008bceAA, 80.0, 100000);
        case 4:
            SetPlayerChatBubble(playerid, "Coordenador(a)", 0xFF0000AA, 80.0, 100000);
        case 5:
            SetPlayerChatBubble(playerid, "Desenvolvedor(a)", 0x328E0AAA, 80.0, 100000);
    }
    return 1;
}

forward Kicka(playerid); public Kicka(playerid)
{
    #undef Kick
    Kick(playerid);
    #define Kick(%0) SetTimerEx("Kicka", 100, false, "i", %0)
    return 1;
}

forward Bana(playerid); public Bana(playerid)
{
    #undef Ban
    Ban(playerid);
    #define Ban(%0) SetTimerEx("Bana", 100, false, "i", %0)
    return 1;
}

forward OpeningPolicePort(playerid); public OpeningPolicePort(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, 246.39900,72.49900,1003.85809))
    {
        MoveObject(PortaPolicia,246.39900,72.49900,1007.10938,3.0);
        SetTimerEx("ClosingPolicePort", 5000, false, "i", playerid);
        SendClientMessage(playerid, Verde_Escurinho, "| INFO | O Port�o do Departamento de Policia foi aberto e fechara em 5 segundos");
    }
    return 1;
}

forward ClosingPolicePort(playerid); public ClosingPolicePort(playerid)
    return MoveObject(PortaPolicia,246.39900,72.49900,1003.85809,3.0);

forward ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5);
public ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i; i < MAX_PLAYERS; i++)
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

forward HideTextRespawn(playerid); public HideTextRespawn(playerid)
{
    TextDrawHideForPlayer(playerid, RespawnVeiculos);
    return 1;
}

forward RandomMSGs(COLOR, const string[]); public RandomMSGs(COLOR, const string[])
{
    new random1 = random(sizeof(MSGs));
    format(String, sizeof(String), "%s", MSGs[random1]);
    return SendClientMessageToAll(COLOR,String);
}

forward ChatAdmin(COLOR, const string[]); public ChatAdmin(COLOR, const string[])
{
    for(new i; i != MAX_PLAYERS; i++) if(IsPlayerHelper(i))
    {
        SendClientMessage(i, COLOR, string);
    }
    return 1;
}

forward ChatVIP(COLOR, const string[]); public ChatVIP(COLOR, const string[])
{
    for(new i; i != MAX_PLAYERS; i++) if(IsPlayerHelper(i) || IsPlayerVip(i))
    {
        SendClientMessage(i, COLOR, string);
    }
    return 1;
}

forward UnlockingReport(playerid);
public UnlockingReport(playerid)
{
    LiberarRelatorio{playerid} = false;
    return true;
}

forward UnlockingDoubt(playerid);
public UnlockingDoubt(playerid)
{
    LiberarDuvida{playerid} = false;
    return true;
}

forward Report(COLOR, const string[]);
public Report(COLOR, const string[])
{
    for(new i; i != MAX_PLAYERS; i++) if(IsPlayerHelper(i))
    {
        SendClientMessage(i, COLOR, String);
        GameTextForPlayer(i, "~n~~r~RELATORIO" , 3000, 3);
        PlayerPlaySound(i,1057,0,0,0);
    }
    return 1;
}

forward Doubt(COLOR, const string[]);
public Doubt(COLOR, const string[])
{
    for(new i; i != MAX_PLAYERS; i++) if(IsPlayerHelper(i))
    {
        SendClientMessage(i, COLOR, string);
        GameTextForPlayer(i, "~n~~b~DUVIDA" , 3000, 3);
        PlayerPlaySound(i, 1057, 0, 0, 0);
    }
    return 1;
}

forward OnPlayerMessageCorregedoria(COLOR, const string[]);
public OnPlayerMessageCorregedoria(COLOR, const string[])
{
    for(new i; i != MAX_PLAYERS; i++) if(PlayerInfo[i][Profissao] == Corregedoria)
    {
        SendClientMessage(i, COLOR, string);
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
        if(PlayerInfo[playerid][Logado] == true)
        {
            if(PlayerInfo[playerid][Afk] == false)
            {
                if(PlayerInfo[playerid][Exp] == 5)
                {
                    PlayerInfo[playerid][Level]++;
                    SendClientMessage(playerid, 0x75EA00AA, "| UP | Voc� ganhou +1 de Experi�ncia ( 6/6 )");
                    format(String, sizeof(String), "| UP | Voc� juntou 5 de Experi�ncia e ganhou +1 level ( %d ) ", PlayerInfo[playerid][Level]);
                    SendClientMessage(playerid, 0x75EA00AA, String);
                    PlayerPlaySound(playerid, 1057, 0, 0, 0);
                    PlayerInfo[playerid][Exp]=0;
                    Salario(playerid);
                    SetPlayerScore(playerid, PlayerInfo[playerid][Level]);
                } else {
                    PlayerInfo[playerid][Exp]++;
                    format(String, sizeof(String), "| UP | Voc� ganhou +1 de Experi�ncia ( %d/5 )",PlayerInfo[playerid][Exp]);
                    SendClientMessage(playerid, 0x75EA00AA, String);
                    PlayerPlaySound(playerid, 1057, 0, 0, 0);
                    GameTextForPlayer(playerid, "~w~UP!", 3000, 6);
                }
            }
        }
    }

    if(PlayerInfo[playerid][segUP]==-1)
    {
        if(PlayerInfo[playerid][minUP]==0)
        PlayerInfo[playerid][minUP]=10;
        PlayerInfo[playerid][segUP]=59;
        PlayerInfo[playerid][minUP]--;
    }
    format(String, sizeof(String), "~w~+~p~UP: ~w~%02d:%02d", PlayerInfo[playerid][minUP],PlayerInfo[playerid][segUP]);
    PlayerTextDrawSetString(playerid, PlayerStatus[playerid][20], String);
    PlayerInfo[playerid][segUP]--;
    return 1;
}

SetColorProfession(playerid)
{
    switch(PlayerInfo[playerid][Profissao])
    {
        case Desempregado:
            SetPlayerColor(playerid, C_Desempregado);
        case EntregadorJornal:
            SetPlayerColor(playerid, C_EntregadorJornal);
        case Advogado:
            SetPlayerColor(playerid, C_Advogado);
        case Taxi:
            SetPlayerColor(playerid, C_Taxi);
        case PoliciaMunicipal:
            SetPlayerColor(playerid, C_PoliciaMunicipal);
        case Corregedoria:
            SetPlayerColor(playerid, C_Corregedoria);
        case LadraoGas:
            SetPlayerColor(playerid, C_LadraoGas);
    }
    return 1;
}

forward RestartServer(); public RestartServer()
{
    SendClientMessageToAll(0xB9FFFFAA, "| INFO | O Server reiniciara em 1 minuto!");
    return SetTimer("RestartServer1", 1000*60, false);

}

forward RestartServer1(); public RestartServer1()
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SaveAccounts(i);
            Kick(i);
    	}
	}
    SendClientMessageToAll(0xB9FFFFAA, "| INFO | O Server reinicio aguarde!");
    return SendRconCommand("gmx");
}

forward ExitPersecution(playerid); public ExitPersecution(playerid)
{
    format(String, sizeof(String), "| PERSEGUI��O | O(A) jogador(a) %s[%d] n�o est� sendo mais perseguido pela pocilia por passar 5 minutos!", PlayerInfo[playerid][Nome], playerid);
    SendClientMessage(playerid, 0x2894FFAA, String);
    SendClientMessage(playerid, 0xB9FFFFAA, "| INFO | Voc� n�o est� mas em persegui��o");
    KillTimer(PerseguicaoTime[playerid]);
    Perseguicao[playerid] = false;
    Abordado[playerid] = false;
    return 1;
}

Salario(playerid)
{
    switch(PlayerInfo[playerid][Profissao])
    {
        case Desempregado:
        {
            PlayerInfo[playerid][SaldoBancario] += Salario_Desempregado;
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Sal�rio: {00A600}$%d", Salario_Desempregado);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-Salario_Desempregado);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
        case EntregadorJornal:
        {
            PlayerInfo[playerid][SaldoBancario] += Salario_EntregadorJornal;
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Sal�rio: {00A600}$%d", Salario_EntregadorJornal);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-Salario_EntregadorJornal);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
        case Taxi:
        {
            PlayerInfo[playerid][SaldoBancario] += Salario_Taxi;
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Sal�rio: {00A600}$%d", Salario_Taxi);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-Salario_Taxi);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
        case PoliciaMunicipal:
        {
            PlayerInfo[playerid][SaldoBancario] += Salario_PoliciaMunicipal;
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Sal�rio: {00A600}$%d", Salario_PoliciaMunicipal);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-Salario_PoliciaMunicipal);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
        case Corregedoria:
        {
            PlayerInfo[playerid][SaldoBancario] += Salario_Corregedoria;
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Sal�rio: {00A600}$%d", Salario_Corregedoria);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-Salario_Corregedoria);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
        case LadraoGas:
        {
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
        	SendClientMessage(playerid, Amarelo, "| AVISO | Mafia n�o recebe Sal�rio!");
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o antigo: {FF0000}$%d", PlayerInfo[playerid][SaldoBancario]-0);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	format(String,sizeof(String),"{EDA909}� {FFFFFF}Balan�o atual: {00A600}$%d", PlayerInfo[playerid][SaldoBancario]);
        	SendClientMessage(playerid, 0xEDA909AA, String);
        	SendClientMessage(playerid, 0xEDA909AA,"~~~~~~~~~~~~~~~~~~~~~~ Sal�rio ~~~~~~~~~~~~~~~~~~~~~~");
            PlayerPlaySound(playerid, 1057, 0, 0, 0);
        }
    }
    return 1;
}

IsVehicleInUse(vehicleid)
{
    new VeiculoRcd;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(GetPlayerVehicleID(i) == vehicleid)
            VeiculoRcd = vehicleid;
        if(GetVehicleTrailer(GetPlayerVehicleID(i)) == vehicleid)
            VeiculoRcd = vehicleid;
    }
    return VeiculoRcd;
}

DeletarSair(playerid)
{
    if(cVehicle[playerid])
    {
        DestroyVehicle(GetPlayerVehicleID(playerid));
        cVehicle[playerid] = false;
        return 1;
    }
    return 1;
}

GetProfession(playerid)
{
    static var[30];
    switch(PlayerInfo[playerid][Profissao])
    {
        case 0: var = "Desempregado(a)";
        case 1: var = "Entregador(a) de Jornal";
        case 2: var = "Taxi";
        case 3: var = "Policia";
        case 4: var = "Corregedoria";
        case 5: var = "Ladr�o de G�s";
    }
    return var;
}

CargoAdmin(playerid)
{
    static var[21];
    switch(PlayerInfo[playerid][Admin])
    {
        case 1: var = "Ajudante";
        case 2: var = "Moderador(a)";
        case 3: var = "Administrador(a)";
        case 4: var = "Coordenador(a)";
        case 5: var = "Desenvolvedor(a)";
    }
    return var;
}

ZerandoVariaveis(playerid)
{
    //Enum PlayerInfo
    for(new pInfo:i; i < pInfo; ++i)
    {
        if(pInfo:i == minUP || pInfo:i == segUP )
        {
            PlayerInfo[playerid][minUP] = 9;
            PlayerInfo[playerid][segUP] = 59;
        } else if(pInfo:i == Afk || pInfo:i == Logado ) {
            PlayerInfo[playerid][Afk] = false;
            PlayerInfo[playerid][Logado] = false;
        } else {
            PlayerInfo[playerid][pInfo:i] = 0;
        }
    }
    for(new ppInfo:i; i < ppInfo; ++i)
    {
        pPlayerInfo[playerid][ppInfo:i] = 0;
    }

    CarroAdmin[playerid]=0;

    Algemado[playerid] = false;
    Abordado[playerid] = false;
    Perseguicao[playerid] = false;
    PegouGas[playerid] = false;

    KillTimer(TimerProcurando[playerid]);
    KillTimer(PerseguicaoTime[playerid]);
    KillTimer(TempoPreso[playerid]);
    KillTimer(UPRelogio[playerid]);
    return 1;
}

formatSeconds(seconds, &hours_left, &minutes_left, &seconds_left)
{
    hours_left = seconds/60/60;
    minutes_left = (seconds - hours_left*60*60 )/60;
    seconds_left = (seconds - hours_left*60*60 - minutes_left*60);
    return 1;
}

GetDistanceBetweenPlayers(playerid,playerid2)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    new Float:dis;
    GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerPos(playerid2,x2,y2,z2);
    dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(dis);
}

IsPlayerHelper(playerid)
{
    if(PlayerInfo[playerid][Admin] >= 1 && PlayerInfo[playerid][Admin] <= 5) return true;
    return false;
}

IsPlayerModerator(playerid)
{
    if(PlayerInfo[playerid][Admin] >= 2 && PlayerInfo[playerid][Admin] <= 5) return true;
    return false;
}

IsPlayerAdmininstrator(playerid)
{
    if(PlayerInfo[playerid][Admin] >= 3 && PlayerInfo[playerid][Admin] <= 5) return true;
    return false;
}

IsPlayerDeveloper(playerid)
{
    if(PlayerInfo[playerid][Admin] == 5) return true;
    return false;
}

IsPlayerVip(playerid)
{
    if(VipInfo[playerid][Vip] == true) return true;
    return false;
}

IsPlayerUniformePM(playerid)
{
    if(GetPlayerSkin(playerid) == 287) return true;
    return false;
}

NitroInfinito(arg)
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

GetPlayerHighestScores(array[][rankingEnum], left, right)
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

HexToInt(string[])
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

IsValidUsername(name[])
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

IsValidMessageHouse(name[])
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

IsValidNumber(const ipstr[])
{
    for(new i = 0; ipstr[i] != EOS; ++i)
    {
        switch(ipstr[i])
        {
            case '0'..'9':
                continue;
            default:
                return 0;
        }
    }
    return 1;
}
