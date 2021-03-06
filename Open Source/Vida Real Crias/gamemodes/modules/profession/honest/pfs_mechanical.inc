#include YSI\y_hooks

enum e_rsmn
{
    Float:rsmn_x,
    Float:rsmn_y,
    Float:rsmn_z
};

new RandomSpawnMechanical[5][e_rsmn] =
{
    {-41.60, -1154.60, 2.00},
    {-46.16, -1152.34, 2.00},
    {-50.98, -1149.93, 2.00},
    {-55.98, -1147.41, 2.00},
    {-60.86, -1145.13, 2.00}
};

new bool:mechanicalOffer[MAX_PLAYERS];
new bool:mechanicalRefused[MAX_PLAYERS];
new bool:mechanicalAccepted[MAX_PLAYERS];
new mechanicalCount[MAX_PLAYERS];

hook OnGameModeInit()
{
    CreateVehicleLocation(-67.31, -1145.89, 1.07);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES))
	{
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, -67.31, -1145.89, 1.07))
            return 1;

        if(PlayerInfo[playerid][Profissao] != mechanical)
            return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

        if(PV_Profission[playerid])
            return SendClientMessage(playerid, Erro, "Seu ve�culo j� est� criado");

        new rand = random(sizeof(RandomSpawnMechanical));

        CreatePlayerVehicle(playerid, 525, RandomSpawnMechanical[rand][rsmn_x], RandomSpawnMechanical[rand][rsmn_y],RandomSpawnMechanical[rand][rsmn_z], 0.0, 1, 128);

        SendClientMessage(playerid, Profission[PlayerInfo[playerid][Profissao]][pfs_color], "Foi criado um ve�culo profiss�o no estacionamento");
        return 1;
	}
	return 1;
}

forward OnPlayerMechanicalOffer(playerid, playeridoffer, value, vehicleid);
public OnPlayerMechanicalOffer(playerid, playeridoffer, value, vehicleid)
{
    if(AdvogadoOfertou[playeridoffer])
    {
        if(mechanicalCount[playeridoffer] == 10)
        {
            SendClientMessage(playeridoffer, 0x00B57DAA, "Seu tempo de aceitar ou recusar acabou");
            mechanicalCount[playeridoffer] = 0;
            mechanicalOffer[playeridoffer] = false;
            return 1;
        }

        mechanicalCount[playeridoffer]++;
        SetTimerEx("OnPlayerMechanicalOffer", 1000, false, "dddd", playerid, playeridoffer, value, vehicleid);

        switch(mechanicalCount[playeridoffer])
        {
            case 1, 3, 5, 7, 9: SendClientMessage(playeridoffer, 0x00B57DAA, "Para aceitar ou recusar digite ( /aceitar ou /recusar )");
        }
        return 1;
    }
    else
    {
        if(AdvogadoAceitou[playeridoffer])
        {
            mechanicalAccepted[playeridoffer] = false;

            PlayerInfo[playerid][Dinheiro] += value;
            UpdatePlayerMoney(playerid);
            PlayerInfo[playeridoffer][Dinheiro] -= value;
            UpdatePlayerMoney(playeridoffer);

            RepairingVehicle(playerid, vehicleid);

            SendClientMessage(playeridoffer, 0xFFD993AA, "Voc� aceitou � oferta");
            SendClientMessage(playerid, 0xFFD993AA, "Sua oferta foi aceita");
        }
        else
        {
            SendClientMessage(playerid, 0xFFD993AA, "Sua oferta foi recusada");
            SendClientMessage(playeridoffer, 0xFFD993AA, "Voc� recusou � oferta");
            mechanicalRefused[playeridoffer] = false;
        }
    }
    return 1;
}

/******************************************************************************/
/***************************| COMMANDS MECHANICAL |****************************/
/******************************************************************************/

CMD:ofertarreparo(playerid, params[])
{
    if(PlayerInfo[playerid][Profissao] != mechanical)
        return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

    if(GetVehicleModel(LastVehicle[playerid]) != 525)
        return SendClientMessage(playerid, Erro, "Seu �ltimo ve�culo n�o � um Towtruck");

    new id, value;

    if(sscanf(params, "ud", id, value))
        return SendClientMessage(playerid, Erro, "Digite: /Soltar [id/nome] [Valor]");

    if(id == INVALID_PLAYER_ID || !PlayerInfo[id][Logado])
        return SendClientMessage(playerid, Erro, "Jogador(a) n�o conectado(a)");

    if(playerid == id)
        return SendClientMessage(playerid, Erro, "Voc� n�o pode efetuar comando em s� mesmo");

    if(GetDistanceBetweenPlayers(playerid, id) > 10)
        return SendClientMessage(playerid, Erro, "Voc� est� muito longe, chegue mais perto");

    if(!IsPlayerInAnyVehicle(id))
        return SendClientMessage(playerid, Erro, "O(A) Jogador(a) n�o est� no ve�culo");

    new vehicleid = GetPlayerVehicleID(id);

    if(!IsBrokenVehicle(vehicleid))
        return SendClientMessage(playerid, Erro, "Ve�culo do(a) jogador(a) n�o est� quebrado");

    if(mechanicalOffer[id])
        return SendClientMessage(playerid, Erro, "O(A) Jogador(a) j� recebeu uma oferta de reparo");

    if(value < 500 || value > 2000)
        return SendClientMessage(playerid, Erro, "Valores perm�tidos entre $500 e $2000");

    format(String, MAX_STRING, "O(A) Mec�nico(a) %s[%d] est� te oferecendo um reparo no valor de $%s", PlayerInfo[playerid][Nome], playerid, IsMoney(value, "."));
    SendClientMessage(id, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);
    format(String, MAX_STRING, "Voc� ofereceu reparo para o(a) jogador(a) %s[%d] no valor de $%s", PlayerInfo[id][Nome], id, IsMoney(value, "."));
    SendClientMessage(playerid, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);

    mechanicalOffer[id] = true;
    OnPlayerMechanicalOffer(playerid, id, value, vehicleid);
    return 1;
}
