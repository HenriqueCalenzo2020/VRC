#include YSI\y_hooks

new TaximeterValue[MAX_PLAYERS];
new CRRTAXI[6];
new BlockTaxi[MAX_PLAYERS];

hook OnGameModeInit()
{
    CRRTAXI[0] = AddStaticVehicleEx(420, 2230.0000, -1340.0000, 23.5839, 90.0000, -1, -1, 100);
    CRRTAXI[1] = AddStaticVehicleEx(420, 2230.0000, -1344.0000, 23.5839, 90.0000, -1, -1, 100);
    CRRTAXI[2] = AddStaticVehicleEx(420, 2230.0000, -1348.0000, 23.5839, 90.0000, -1, -1, 100);
    CRRTAXI[3] = AddStaticVehicleEx(420, 2230.0000, -1352.0000, 23.5839, 90.0000, -1, -1, 100);
    CRRTAXI[4] = AddStaticVehicleEx(420, 2230.0000, -1356.0000, 23.5839, 90.0000, -1, -1, 100);
    CRRTAXI[5] = AddStaticVehicleEx(420, 2230.0000, -1360.0000, 23.5839, 90.0000, -1, -1, 100);
    for(new i = 0; i < 6; i++) { SetVehicleParamsEx(CRRTAXI[i], 0, 0, 0, 0, 0, 0, 0); }

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    BlockTaxi[playerid] = false;
    TaximeterValue[playerid] = 0;
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    for(new i; i < sizeof(CRRTAXI); i++) if(vehicleid == CRRTAXI[i])
    {
        if(!ispassenger && vehicleid != INVALID_VEHICLE_ID && PlayerInfo[playerid][Profissao] != taxi)
        {
            ClearAnimations(playerid);
            SendClientMessage(playerid, Erro, "Veiculo exclusivo da profiss�o Taxista");
            return 1;
        }
    }
    return 1;
}

forward taximeter(playerid, passengerid);
public taximeter(playerid, passengerid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT || GetPlayerState(passengerid) == PLAYER_STATE_ONFOOT || !PlayerInfo[passengerid][Logado] || !PlayerInfo[playerid][Logado])
    {
        TextDrawHideForPlayer(passengerid, TDTaximetro[0]);
        TextDrawHideForPlayer(passengerid, TDTaximetro[1]);
        TextDrawHideForPlayer(passengerid, TDTaximetro[2]);
        TextDrawHideForPlayer(passengerid, TDTaximetro[3]);
        PlayerTextDrawHide(passengerid, TDPlayerTaximetro[passengerid][0]);
        PlayerTextDrawHide(passengerid, TDPlayerTaximetro[passengerid][1]);
        TextDrawHideForPlayer(playerid, TDTaximetro[0]);
        TextDrawHideForPlayer(playerid, TDTaximetro[1]);
        TextDrawHideForPlayer(playerid, TDTaximetro[2]);
        TextDrawHideForPlayer(playerid, TDTaximetro[3]);
        PlayerTextDrawHide(playerid, TDPlayerTaximetro[playerid][0]);
        PlayerTextDrawHide(playerid, TDPlayerTaximetro[playerid][1]);

        PlayerInfo[playerid][Dinheiro] += TaximeterValue[passengerid];
        UpdatePlayerMoney(playerid);
        PlayerInfo[passengerid][Dinheiro] -= TaximeterValue[passengerid];
        UpdatePlayerMoney(passengerid);

        format(String, 50, "Valor total $%d", TaximeterValue[passengerid]);
        SendClientMessage(playerid, Yellow, "A corrida foi paga automaticamente");
        SendClientMessage(playerid, Yellow, String);
        return 1;
    }

    new Float:x, Float:y, Float:z;

    GetPlayerPos(playerid, x, y, z);
    GetPlayer2DZone(zone, MAX_ZONE_NAME, x, y);

    TaximeterValue[passengerid] += 2;

    format(String, 50, "~g~$%d", TaximeterValue[passengerid]);
    PlayerTextDrawSetString(playerid, TDPlayerTaximetro[playerid][0], String);
    PlayerTextDrawSetString(passengerid, TDPlayerTaximetro[passengerid][0], String);
    format(String, 50, "~r~%s", zone);
    PlayerTextDrawSetString(passengerid, TDPlayerTaximetro[passengerid][1], String);
    PlayerTextDrawSetString(playerid, TDPlayerTaximetro[playerid][1], String);

    SetTimerEx("taximeter", 1000, false, "dd", playerid, passengerid);
    return 1;
}

forward UnlockTaxi(playerid);
public UnlockTaxi(playerid)
{
    BlockTaxi[playerid] = false;
    return 1;
}

/******************************************************************************/
/******************************| COMMANDS TAX� |*******************************/
/******************************************************************************/

CMD:taxi(playerid)
{
    if(BlockTaxi[playerid])
        return SendClientMessage(playerid, Erro, "Voc� acabou de pedir tax�, aguarde alguns segundos...");

    new Float:x, Float:y, Float:z;

    GetPlayerPos(playerid, x, y, z);
    GetPlayer2DZone(zone, MAX_ZONE_NAME, x, y);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerInfo[i][Profissao] == taxi)
        {
            format(String, MAX_STRING, "O(A) Jogador(a) %s[%d] est� requisitando um T�xi nas Localidades ( %s )", PlayerInfo[playerid][Nome], playerid, zone);
            SendClientMessage(i, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);
        }
    }

    BlockTaxi[playerid] = true;
    SetTimerEx("UnlockTaxi", 120000, false, "d", playerid);
    SendClientMessage(playerid, Green, "Os(As) tax�stas foram informados");
    return 1;
}
CMD:taximetro(playerid, params[])
{
    new id, vehicleid = GetPlayerVehicleID(playerid);

    if(PlayerInfo[playerid][Profissao] != taxi)
        return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

    if(sscanf(params, "u", id))
        return SendClientMessage(playerid, Erro, "Digite: /taximetro [id/nome]");

    if(id == INVALID_PLAYER_ID || !PlayerInfo[id][Logado])
        return SendClientMessage(playerid, Erro, "Jogador(a) n�o conectado(a)");

    if(playerid == id)
        return SendClientMessage(playerid, Erro, "Voc� n�o pode efetuar comando em s� mesmo");

    for(new i = 0; i < sizeof(CRRTAXI); i++)
    {
        if(vehicleid == CRRTAXI[i])
        {
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return SendClientMessage(playerid, Erro, "Voc� n�o est� dirigindo");

            if(CRRTAXI[i] != GetPlayerVehicleID(id))
                return SendClientMessage(playerid, Erro, "O passageiro n�o est� no taxi");

            format(String, MAX_STRING, "O(A) T�xista %s[%d] inicou o t�ximetro", PlayerInfo[playerid][Nome], playerid);
            SendClientMessage(id, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);
            format(String, MAX_STRING, "Voc� in�ciou o t�ximetro para o(a) jogador(a) %s[%d]", PlayerInfo[id][Nome], id);
            SendClientMessage(playerid, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);

            TextDrawShowForPlayer(id, TDTaximetro[0]);
            TextDrawShowForPlayer(id, TDTaximetro[1]);
            TextDrawShowForPlayer(id, TDTaximetro[2]);
            TextDrawShowForPlayer(id, TDTaximetro[3]);
            PlayerTextDrawShow(id, TDPlayerTaximetro[id][0]);
            PlayerTextDrawShow(id, TDPlayerTaximetro[id][1]);
            TextDrawShowForPlayer(playerid, TDTaximetro[0]);
            TextDrawShowForPlayer(playerid, TDTaximetro[1]);
            TextDrawShowForPlayer(playerid, TDTaximetro[2]);
            TextDrawShowForPlayer(playerid, TDTaximetro[3]);
            PlayerTextDrawShow(playerid, TDPlayerTaximetro[playerid][0]);
            PlayerTextDrawShow(playerid, TDPlayerTaximetro[playerid][1]);

            taximeter(playerid, id);
            return 1;
        }
    }
    SendClientMessage(playerid, Erro, "Voc� n�o est� em um t�xi");
    return 1;
}
