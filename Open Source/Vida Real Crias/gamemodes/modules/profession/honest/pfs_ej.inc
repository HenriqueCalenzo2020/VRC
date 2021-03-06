#include YSI\y_hooks

enum NewspaperNext
{
    nnLocations[40],
    Float:nnPosX,
    Float:nnPosY,
    Float:nnPosZ,
    nnGetWork
};

new NL[19][NewspaperNext] = //NewspaperLocations
{
    {"Marina", 852.1297,-1422.2274,13.7665, 110},
    {"Market", 1195.6843,-1017.1591,32.5469, 130},
    {"Market", 1234.0033,-1016.5063,32.6067, 120},
    {"Mulholland", 1247.0552,-908.7471,42.8828, 140},
    {"Mulholland", 1248.8364,-877.6268,42.8828, 160},
    {"Mulholland", 1290.2649,-897.1113,42.8828, 170},
    {"Mulholland", 1281.4331,-874.5957,42.9572, 150},
    {"Jefferson", 1905.9628,-1113.0104,26.6641, 180},
    {"Jefferson", 2022.8094,-1120.6379,26.4210, 200},
    {"Jefferson", 2091.9280,-1166.4626,26.5859, 180},
    {"Jefferson", 2111.0930,-1243.4509,25.8516, 190},
    {"Jefferson", 2147.6541,-1367.1768,25.6418, 210},
    {"East Beach", 2776.0256,-1245.9175,49.3598, 170},
    {"East Beach", 2147.6541,-1367.1768,25.6418, 210},
    {"Marina", 901.2523,-1471.0151,13.9762, 190},
    {"Marina", 767.3795,-1655.7631,5.6094, 250},
    {"Marina", 693.6930,-1705.7681,3.8195, 230},
    {"Marina", 692.9327,-1602.1597,15.0469, 180},
    {"Marina", 783.2158,-1464.5664,13.5469, 150}
};

enum e_rsnd
{
    Float:rsnd_x,
    Float:rsnd_y,
    Float:rsnd_z
};

new RandomSpawnND[5][e_rsnd] =
{
    {784.9813, -1356.2255, 13.1522},
    {784.9813, -1358.1863, 13.1522},
    {784.9813, -1360.1813, 13.1522},
    {784.9813, -1362.1833, 13.1522},
    {784.9813, -1364.1859, 13.1522}
};

enum JornalProx
{
    RandomLocal[40],
    Float:RandomX,
    Float:RandomY,
    Float:RandomZ,
    VaiReceber,
    pnl_rand
};

new PNL[MAX_PLAYERS][JornalProx]; //PlayerNewspaperLocations

new Newspaper[MAX_PLAYERS];
new CPSEJ[MAX_PLAYERS];
new bool:BlockNewspaper[MAX_PLAYERS];

hook OnGameModeInit()
{
    CreateVehicleLocation(784.98, -1334.88, 13.54);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    DestroyDynamicRaceCP(CPSEJ[playerid]);
    CPSEJ[playerid] = 0;

    Newspaper[playerid] = 0;
    BlockNewspaper[playerid] = false;
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES) && IsPlayerInRangeOfPoint(playerid, 2.0, 784.98, -1334.88, 13.54))
	{
        if(PlayerInfo[playerid][Profissao] != newspaperdelivery)
            return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

        if(PV_Profission[playerid])
            return SendClientMessage(playerid, Erro, "Voc� j� criou um ve�culo profiss�o");

        new rand = random(sizeof(RandomSpawnND));

        CreatePlayerVehicle(playerid, 510, RandomSpawnND[rand][rsnd_x], RandomSpawnND[rand][rsnd_y], RandomSpawnND[rand][rsnd_z], 90.0000, -1, -1);

        SendClientMessage(playerid, Profission[PlayerInfo[playerid][Profissao]][pfs_color], "Foi criado um ve�culo profiss�o no estacionamento");
        return 1;
	}
	return 1;
}

forward UnlockingNewspaper(playerid);
public UnlockingNewspaper(playerid)
{
    return BlockNewspaper[playerid] = false;
}

stock BoyNewspaper_DynamicRaceCP(playerid)
{
    if(IsPlayerInDynamicRaceCP(playerid, CPSEJ[playerid]) && PlayerInfo[playerid][Profissao] == newspaperdelivery)
    {
        if(BlockNewspaper[playerid])
            return SendClientMessage(playerid, Erro, "Voc� acabou de entregar, aguarde alguns segundos...");

        if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 510 || !IsPlayerInAnyVehicle(playerid))
            return SendClientMessage(playerid, Erro, "Voc� n�o est� em uma Mountain Bike");

        Newspaper[playerid]--;

        if(Newspaper[playerid] > 0)
        {
            format(String, MAX_STRING, "Voc� entregou um jornal, e agora tem {FF0000}%d {FFFFFF}jornais!", Newspaper[playerid]);
            SendClientMessage(playerid, White, String);
            format(String, MAX_STRING, "Voc� recebeu {00C40A}$%d {FFFFFF}pela entrega localizada em {FF8000}%s", PNL[playerid][VaiReceber], PNL[playerid][RandomLocal]);
            SendClientMessage(playerid, White, String);

            GiveBonus(playerid, 500);

            PlayerInfo[playerid][Dinheiro] += PNL[playerid][VaiReceber];
            UpdatePlayerMoney(playerid);

            BlockNewspaper[playerid] = true;
            SetTimerEx("UnlockingNewspaper", 1000*30, false, "d", playerid);

            new rand = random(sizeof(NL));

            if(PNL[playerid][pnl_rand] == rand) rand = random(sizeof(NL));

            format(PNL[playerid][RandomLocal], 40, NL[rand][nnLocations]);
            PNL[playerid][RandomX] = NL[rand][nnPosX];
            PNL[playerid][RandomY] = NL[rand][nnPosY];
            PNL[playerid][RandomZ] = NL[rand][nnPosZ];
            PNL[playerid][VaiReceber] = NL[rand][nnGetWork];
            PNL[playerid][pnl_rand] = rand;

            DestroyDynamicRaceCP(CPSEJ[playerid]);
            CPSEJ[playerid] = CreateDynamicRaceCP(1, PNL[playerid][RandomX], PNL[playerid][RandomY], PNL[playerid][RandomZ], -1, -1, -1, 2.0, -1, -1, playerid, -1.0, -1, 0);
        }
        else
        {
            format(String, MAX_STRING, "Voc� recebeu {00C40A}$%d {FFFFFF}pela entrega localizada em {FF8000}%s", PNL[playerid][VaiReceber], PNL[playerid][RandomLocal]);
            SendClientMessage(playerid, White, String);
            SendClientMessage(playerid, White, "Para pegar mas jornais, volte para LT e pegue mais");

            GiveBonus(playerid, 500);

            DestroyDynamicRaceCP(CPSEJ[playerid]);
            CPSEJ[playerid] = 0;

            PlayerInfo[playerid][Dinheiro] += PNL[playerid][VaiReceber];
            UpdatePlayerMoney(playerid);

            PNL[playerid][RandomLocal] = 0;
            PNL[playerid][RandomX] = 0;
            PNL[playerid][RandomY] = 0;
            PNL[playerid][RandomZ] = 0;
            PNL[playerid][VaiReceber] = 0;
            PNL[playerid][pnl_rand] = 0;
        }
        return 1;
    }
    return 1;
}

stock LeftPfsNewspaperDelivery(playerid)
{
    if(PlayerInfo[playerid][Profissao] == newspaperdelivery)
    {
        if(IsValidDynamicRaceCP(Newspaper[playerid])) DestroyDynamicRaceCP(CPSEJ[playerid]);

        CPSEJ[playerid] = 0;
        Newspaper[playerid] = 0;
        BlockNewspaper[playerid] = false;

        PNL[playerid][RandomLocal] = 0;
        PNL[playerid][RandomX] = 0;
        PNL[playerid][RandomY] = 0;
        PNL[playerid][RandomZ] = 0;
        PNL[playerid][VaiReceber] = 0;
        PNL[playerid][pnl_rand] = 0;
    }
    return 1;
}

/******************************************************************************/
/***********************| COMMANDS NEWSPAPER DELIVERY |************************/
/******************************************************************************/

CMD:pegarjornais(playerid)
{
    if(PlayerInfo[playerid][Profissao] != newspaperdelivery)
        return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 510)
        return SendClientMessage(playerid, Erro, "Voc� n�o est� em uma Mountain Bike");

    if(!IsPlayerInRangeOfPoint(playerid, 20.0, 784.9813, -1345.0000, 13.1522))
        return SendClientMessage(playerid, Erro, "Voc� n�o est� na sua HQ");

    if(Newspaper[playerid] != 0)
        return SendClientMessage(playerid, Erro, "Voc� j� pegou jornal");

    BlockNewspaper[playerid] = false;
    Newspaper[playerid] = 20;

    new rand = random(sizeof(NL));

    format(PNL[playerid][RandomLocal], 40, NL[rand][nnLocations]);
    PNL[playerid][RandomX] = NL[rand][nnPosX];
    PNL[playerid][RandomY] = NL[rand][nnPosY];
    PNL[playerid][RandomZ] = NL[rand][nnPosZ];
    PNL[playerid][VaiReceber] = NL[rand][nnGetWork];
    PNL[playerid][pnl_rand] = rand;

    CPSEJ[playerid] = CreateDynamicRaceCP(1, PNL[playerid][RandomX], PNL[playerid][RandomY], PNL[playerid][RandomZ], -1, -1, -1, 2.0, -1, -1, playerid, -1.0, -1, 0);

    SendClientMessage(playerid, White, "Voc� pegou 20 jornais, v� at� o checkpoint vermelho marcado no mini-mapa");
    return 1;
}
