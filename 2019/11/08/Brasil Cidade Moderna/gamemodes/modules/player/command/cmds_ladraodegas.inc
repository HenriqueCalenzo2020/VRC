    if(strcmp(cmd, "/planejarroubo", true)==0)
    {
        if(PlayerInfo[playerid][Profissao] != LadraoGas)
            return SendClientMessage(playerid, Erro, "ERRO:{FFFFFF} Voc� n�o tem permiss�o!");
        return 1;
    }
    if(strcmp(cmd, "/pegargas", true)==0)
    {
        if(PlayerInfo[playerid][Profissao] != LadraoGas)
            return SendClientMessage(playerid, Erro, "ERRO:{FFFFFF} Voc� n�o tem permiss�o!");
        return 1;
    }
    if(strcmp(cmd, "/colocargas", true)==0)
    {
        if(PlayerInfo[playerid][Profissao] != LadraoGas)
            return SendClientMessage(playerid, Erro, "ERRO:{FFFFFF} Voc� n�o tem permiss�o!");

        if(PegouGas[playerid] == false)
            return SendClientMessage(playerid, Erro, "ERRO:{FFFFFF} Voc� n�o tem nenhum Buj�o de G�s na m�o!");
        return 1;
    }
    if(strcmp(cmd, "/cancelarroubo", true)==0)
    {
        if(PlayerInfo[playerid][Profissao] != LadraoGas)
            return SendClientMessage(playerid, Erro, "ERRO:{FFFFFF} Voc� n�o tem permiss�o!");

        return 1;
    }