#include YSI\y_hooks

hook OnGameModeInit()
{
    mysql_query(IDConexao, "CREATE TABLE IF NOT EXISTS `Prison` (`responsible` varchar(24) NOT NULL, `chain` varchar(15) NOT NULL, `reason` varchar(30) NOT NULL, `time` int(10) NOT NULL, `id_contas` int PRIMARY KEY NOT NULL, FOREIGN KEY (`id_contas`) REFERENCES `Contas`(`id`) ON DELETE CASCADE )", false);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    DB_SavePrisons(playerid);
	return 1;
}

forward DB_LoadPrisons(playerid);
public DB_LoadPrisons(playerid)
{
    if(cache_num_rows() == 0)
        return SpawnHouse(playerid);

    new tmp[128];
    cache_get_value_name(0, "responsible", tmp); format(PrisonEnum[playerid][pResponsavel], MAX_PLAYER_NAME, tmp);
    cache_get_value_int(0, "time", PrisonEnum[playerid][pTempo]);
    cache_get_value_name(0, "reason", tmp); format(PrisonEnum[playerid][pMotivo], 20, tmp);
    cache_get_value_name(0, "chain", tmp); format(PrisonEnum[playerid][pCadeia], 15, tmp);

    GameTextForPlayer(playerid, "~w~~h~PRESO!", 2000, 0);
    SendClientMessage(playerid, 0x2894FFAA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Pris�o ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    SendClientMessage(playerid, White, "�� Voc� est� preso!");
    format(String, MAX_STRING, "�� Foi preso por ( %s )", PrisonEnum[playerid][pResponsavel]);
    SendClientMessage(playerid, White, String);
    format(String, MAX_STRING, "�� Motivo da pris�o ( %s )", PrisonEnum[playerid][pMotivo]);
    SendClientMessage(playerid, White, String);
    SendClientMessage(playerid, 0x2894FFAA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Pris�o ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

    if(!strcmp(PrisonEnum[playerid][pCadeia], "Federal")){
        SetPlayerInterior(playerid, 10);
        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 223.5335, 110.3779, 999.0156, 0, 0, 0, 0, 0, 0, 0);
    } else {
        SetPlayerInterior(playerid, 6);
        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 264.2374, 77.4612, 1001.0391, 0, 0, 0, 0, 0, 0, 0);
    }

    ResetPlayerWeapons(playerid);
    SetPlayerHealth(playerid, 99999);

    PlayerTextDrawShow(playerid, TempoPresidio[playerid][1]);
    PlayerTextDrawShow(playerid, TempoPresidio[playerid][0]);

    PrisonSystem(playerid);
    TogglePlayerSpectating(playerid, false);
    return 1;
}

stock DB_SavePrisons(playerid)
{
    if(PrisonEnum[playerid][pTempo] != 0)
    {
        KillTimer(TempoPreso[playerid]);

        new query[300];
        mysql_format(IDConexao, query, 300, "UPDATE `Prison` SET `responsible`='%e', `chain`='%e', `reason`='%e', `time`='%d' WHERE `id_contas`='%d'", PrisonEnum[playerid][pResponsavel], PrisonEnum[playerid][pCadeia], PrisonEnum[playerid][pMotivo], PrisonEnum[playerid][pTempo], PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, query);
    }

    PrisonEnum[playerid][pTempo] = 0;
    PrisonEnum[playerid][pResponsavel] = 0;
    PrisonEnum[playerid][pCadeia] = 0;
    PrisonEnum[playerid][pMotivo] = 0;
    return 1;
}

stock IsPlayerArrested(playerid)
{
    if(PrisonEnum[playerid][pTempo] != 0) return true;
    return false;
}

stock SetPlayerPrision(playerid, responsible[], chain[], reason[], time)
{
    if(Perseguicao[playerid]) KillTimer(PerseguicaoTime[playerid]);

    format(PrisonEnum[playerid][pResponsavel], 24, responsible);
    format(PrisonEnum[playerid][pCadeia], 10, chain);
    format(PrisonEnum[playerid][pMotivo], 50, reason);
    PrisonEnum[playerid][pTempo] = time*60;

    GameTextForPlayer(playerid, "~w~~h~PRESO!", 2000, 0);
    SendClientMessage(playerid, 0x2894FFAA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Pris�o ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    SendClientMessage(playerid, White, "�� Voc� est� preso");
    format(String, MAX_STRING, "�� Foi preso por ( %s )", PrisonEnum[playerid][pResponsavel]);
    SendClientMessage(playerid, White, String);
    format(String, MAX_STRING, "�� Motivo da pris�o ( %s )", PrisonEnum[playerid][pMotivo]);
    SendClientMessage(playerid, White, String);
    SendClientMessage(playerid, 0x2894FFAA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Pris�o ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

    new query[300];
    mysql_format(IDConexao, query, 300, "INSERT INTO `Prison` (`responsible`, `chain`, `reason`, `time`, `id_contas`) VALUES ('%e', '%e', '%e', '%d', '%d')", PrisonEnum[playerid][pResponsavel], PrisonEnum[playerid][pCadeia], PrisonEnum[playerid][pMotivo], PrisonEnum[playerid][pTempo], PlayerInfo[playerid][ID]);
    mysql_query(IDConexao, query);

    if(!strcmp(PrisonEnum[playerid][pCadeia], "Federal")){
        SetPlayerInterior(playerid, 10);
        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 223.5335, 110.3779, 999.0156, 0, 0, 0, 0, 0, 0, 0);
    } else {
        SetPlayerInterior(playerid, 6);
        SetSpawnInfo(playerid, 0, PlayerInfo[playerid][skin], 264.2374, 77.4612, 1001.0391, 0, 0, 0, 0, 0, 0, 0);
    }

    ResetPlayerWeapons(playerid);
    SetPlayerHealth(playerid, 99999);

    PlayerTextDrawShow(playerid, TempoPresidio[playerid][1]);
    PlayerTextDrawShow(playerid, TempoPresidio[playerid][0]);

    PrisonSystem(playerid);
    SpawnPlayer(playerid);
    return 1;
}

forward PrisonSystem(playerid);
public PrisonSystem(playerid)
{
    if(PrisonEnum[playerid][pTempo])
    {
        new hours, minutes, seconds;

        TempoPreso[playerid] = SetTimerEx("PrisonSystem", 1000, false, "i", playerid);

        formatSeconds(PrisonEnum[playerid][pTempo], hours, minutes, seconds);
        format(String, 50,"%02d:%02d:%02d", hours, minutes, seconds);
        PlayerTextDrawSetString(playerid, TempoPresidio[playerid][2], String);
        PlayerTextDrawShow(playerid, TempoPresidio[playerid][2]);

        PrisonEnum[playerid][pTempo]--;

        new query[150];
        mysql_format(IDConexao, query, 150, "UPDATE `Prison` SET `time`='%d' WHERE `id_contas`='%d'", PrisonEnum[playerid][pTempo], PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, query);
    }
    else
    {
        KillTimer(TempoPreso[playerid]);
        format(PrisonEnum[playerid][pMotivo], 1, "");
        PrisonEnum[playerid][pCadeia] = 0;
        PlayerInfo[playerid][Estrelas] = 0;

        format(String, 10, "%d", PlayerInfo[playerid][Estrelas]);
        PlayerTextDrawSetString(playerid, PlayerBarStatus[playerid][1], String);
        PlayerTextDrawShow(playerid, PlayerBarStatus[playerid][1]);

        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100);
        SetPlayerPos(playerid, 1551.6987, -1675.3806, 15.9631);

        PlayerTextDrawHide(playerid, TempoPresidio[playerid][2]);
        PlayerTextDrawHide(playerid, TempoPresidio[playerid][1]);
        PlayerTextDrawHide(playerid, TempoPresidio[playerid][0]);

        mysql_format(IDConexao, String, sizeof(String), "DELETE FROM `Prison` WHERE `id_contas`='%d'", PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, String);

        GameTextForPlayer(playerid, "~w~SOLTO!", 3000, 0);
        SendClientMessage(playerid, 0xA9C4E4AA, "Voc� cumpriu sua pena e est� livre novamente");
    }
    return 1;
}
