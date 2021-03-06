//#include YSI\y_hooks



/******************************************************************************/
/*************************| COMMANDS INTERNAL AFFAIRS |************************/
/******************************************************************************/

CMD:prenderpolicial(playerid, params[])
{
    if(PlayerInfo[playerid][Profissao] != internalaffairs)
        return SendClientMessage(playerid, Erro, "Voc� n�o tem permiss�o");

    new id, tmp[128];

    if(sscanf(params, "us[128]", id, tmp))
        return SendClientMessage(playerid, Erro, "Digite: /PrenderPolicial [id/nome] [motivo]");

    if(id == INVALID_PLAYER_ID || !PlayerInfo[id][Logado])
        return SendClientMessage(playerid, Erro, "Jogador(a) n�o conectado(a)");

    if(playerid == id)
        return SendClientMessage(playerid, Erro, "Voc� n�o pode efetuar comando em s� mesmo");

    if(!IsPlayerPolice(id))
        return SendClientMessage(playerid, Erro, "O(A) Jogador(a) n�o � policial");

    if(PrisonEnum[id][pTempo] != 0)
        return SendClientMessage(playerid, Erro, "O(A) Jogador(a) j� est� preso(a)");

    format(String, MAX_STRING, "Voc� prendeu o(a) o(a) jogador(a) %s[%d] voc� por 30 minutos ( Motivo: %s )", PlayerInfo[id][Nome], id, PrisonEnum[id][pMotivo]);
    SendClientMessage(playerid, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);
    format(String, MAX_STRING, "O(A) Corregedor(a) %s[%d] prendeu o(a) voc� por 30 minutos ( Motivo: %s )", PlayerInfo[playerid][Nome], playerid, PrisonEnum[id][pMotivo]);
    SendClientMessage(id, Profission[PlayerInfo[playerid][Profissao]][pfs_color], String);

    SetPlayerPrision(PlayerInfo[id][Nome], PlayerInfo[playerid][Nome], "Federal", tmp, 30);
    return 1;
}
