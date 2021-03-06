#include YSI\y_hooks

hook OnPlayerDisconnect(playerid, reason)
{
    if(Abordado[playerid])
    {
        format(String, MAX_STRING, "VRC-Admin ~ O(A) Bot agendou a pris�o do(a) jogador(a) %s por 30 minutos ( Motivo: Saiu abordado(a) )", PlayerInfo[playerid][Nome]);
        SendClientMessageToAll(adm, String);

        format(PrisonEnum[playerid][pMotivo], 30, "Saiu abordado");

        new query[300];
        mysql_format(IDConexao, query, 300, "INSERT INTO `Prison` (`responsible`, `chain`, `reason`, `time`, `id_contas`) VALUES ('%e', '%e', '%e', '%d', '%d')", "Bot", "Federal", PrisonEnum[playerid][pMotivo], (30*60), PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, query);

        Abordado[playerid] = false;
        KillTimer(t_approach[playerid]);
    }
    if(Algemado[playerid])
    {
        format(String, MAX_STRING, "VRC-Admin ~ O(A) Bot agendou a pris�o do(a) jogador(a) %s por 30 minutos ( Motivo: Saiu algemado(a) )", PlayerInfo[playerid][Nome]);
        SendClientMessageToAll(adm, String);

        format(PrisonEnum[playerid][pMotivo], 30, "Saiu algemado");

        new query[300];
        mysql_format(IDConexao, query, 300, "INSERT INTO `Prison` (`responsible`, `chain`, `reason`, `time`, `id_contas`) VALUES ('%e', '%e', '%e', '%d', '%d')", "Bot", "Federal", PrisonEnum[playerid][pMotivo], (30*60), PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, query);

        Algemado[playerid] = false;
        KillTimer(t_handcuffed[playerid]);
    }
    if(Perseguicao[playerid])
    {
        format(String, MAX_STRING, "VRC-Admin ~ O(A) Bot agendou a pris�o do(a) jogador(a) %s por 30 minutos ( Motivo: Saiu em persegui��o )", PlayerInfo[playerid][Nome]);
        SendClientMessageToAll(adm, String);

        format(PrisonEnum[playerid][pMotivo], 30, "Saiu em persegui��o e algemado");

        new query[300];
        mysql_format(IDConexao, query, 300, "INSERT INTO `Prison` (`responsible`, `chain`, `reason`, `time`, `id_contas`) VALUES ('%e', '%e', '%e', '%d', '%d')", "Bot", "Federal", PrisonEnum[playerid][pMotivo], (30*60), PlayerInfo[playerid][ID]);
        mysql_query(IDConexao, query);

        Perseguicao[playerid] = false;
        KillTimer(PerseguicaoTime[playerid]);
    }

    if(PerseguicaoTime[playerid]) KillTimer(PerseguicaoTime[playerid]);
    if(IsValidDynamicObject(TapeteInfo[playerid][tpt_obj])) DestroyDynamicObject(TapeteInfo[playerid][tpt_obj]);
    if(IsValidDynamic3DTextLabel(TapeteInfo[playerid][tpt_label])) DestroyDynamic3DTextLabel(TapeteInfo[playerid][tpt_label]);
    if(IsValidDynamicObject(BarrierObj[playerid])) DestroyDynamicObject(BarrierObj[playerid]);
    if(IsValidDynamic3DTextLabel(BarrierLabel[playerid])) DestroyDynamic3DTextLabel(BarrierLabel[playerid]);

    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][PosA]);
    GetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);

    LeftArena(playerid);
    LeftBusiness(playerid);
    LeftHouse(playerid);
    LeftEnterExit(playerid);
    LeftBase(playerid);

    SavePos(playerid);
    SaveLastLogin(playerid);

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
    PlayerInfo[playerid][sexo] = 0;
    PlayerInfo[playerid][tutorial] = 0;
    PlayerInfo[playerid][disease] = 0;
    PlayerInfo[playerid][medicalkit] = 0;
    PlayerInfo[playerid][cellphone] = 0;
    PlayerInfo[playerid][sms] = 0;
    PlayerInfo[playerid][credits] = 0;
    PlayerInfo[playerid][gallon] = 0;
    PlayerInfo[playerid][nonstop] = 0;
    PlayerInfo[playerid][vaccine] = 0;
    PlayerInfo[playerid][cannabis] = 0;
    PlayerInfo[playerid][bag] = 0;
    PlayerInfo[playerid][c4] = 0;
    PlayerInfo[playerid][active] = 0;
    PlayerInfo[playerid][youtube] = 0;

    PlayerInfo[playerid][healthplan] = false;
    PlayerInfo[playerid][havegallon] = false;
    PlayerInfo[playerid][blockReport] = false;
    PlayerInfo[playerid][blockDoubt] = false;
    PlayerInfo[playerid][blockAd] = false;
    PlayerInfo[playerid][Logado] = false;
    PlayerInfo[playerid][load] = false;

    pPlayerInfo[playerid][pNome] = 0;
    pPlayerInfo[playerid][pSenha] = 0;
    pPlayerInfo[playerid][pEmail] = 0;
    VehicleAdmin[playerid] = 0;

    viewcmds[playerid] = false;
    IsMobile[playerid] = false;

    //Arena
    Kills[playerid] = 0;
    WeaponsKit[playerid] = -1;
    Enter_Arena[playerid] = -1;
    IsArena[playerid] = false;
    BlockEnterArena[playerid] = false;

    //Business
    withinbusiness[playerid] = 0;
    idbusiness[playerid] = 0;
    Mercadoria[playerid] = false;
    EntregouMercadoria[playerid] = false;

    //Police
    Algemado[playerid] = false;
    Abordado[playerid] = false;
    Perseguicao[playerid] = false;
    BarrierObj[playerid] = 0;
    TimerProcurando[playerid] = 0;
    PerseguicaoTime[playerid] = 0;
	return 1;
}
