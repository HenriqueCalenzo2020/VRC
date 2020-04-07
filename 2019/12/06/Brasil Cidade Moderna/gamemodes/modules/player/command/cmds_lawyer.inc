    if(!strcmp(cmd, "/soltar", true))
    {
        if(PlayerInfo[playerid][Profissao] != Advogado)
            return SendClientMessage(playerid, Erro, "| ERRO | Voc� n�o tem permiss�o!");

        if(!IsPlayerInRangeOfPoint(playerid, 2.0, 252.1618, 67.7849, 1003.6478))
            return SendClientMessage(playerid, Erro, "| ERRO | Voc� n�o est� em nenhum departamento de pol�cia!");

        new tmp[128], id;

        tmp = strtok(cmdtext, idx);

		if(!strlen(tmp))
            return SendClientMessage(playerid, 0xFF0000AA, "| ERRO | Digite: /Soltar [id]");

        id = strval(tmp);

        if(PrisonEnum[id][pTempo] == 0)
            return SendClientMessage(playerid, Erro, "| ERRO | O(A) Jogador(a) n�o est� preso!");

        if(!strcmp(PrisonEnum[id][pCadeia], "Federal", true))
            return SendClientMessage(playerid, Erro, "| ERRO | O(A) Jogador(a) foi preso pela admininstra��o!");

        if(AdvogadoOfertou[id] == true)
            return SendClientMessage(playerid, Erro, "| ERRO | O(A) Jogador(a) j� recebeu uma oferta!");

        format(String, sizeof(String), "| ADVOGADO | Voc� ofereceu ao jogador(a) %s[%d] a liberdade no valor de $%s", PlayerInfo[id][Nome], id, IsMoney(PlayerInfo[id][Estrelas] * 100, "."));
        SendClientMessage(playerid, 0x8000FFAA, String);
        format(String, sizeof(String), "| ADVOGADO | O(A) Advogado(a) %s[%d] est� te oferecendo  a liberdade no valor de $%s", PlayerInfo[playerid][Nome], playerid, IsMoney(PlayerInfo[id][Estrelas] * 100, "."));
        SendClientMessage(id, 0x8000FFAA, String);

        AdvogadoOfertou[id] = true;
        SetTimerEx("LowyerOffer", 1000, false, "ii", playerid, id);
		return 1;
	}