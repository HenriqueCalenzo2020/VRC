CMD:fecharservidor(playerid, params[])
{
    if(!IsPlayerCoordinator(playerid))
		return SendClientMessage(playerid, Erro, "Comando Inv�lido");

    new tmp[128];

    if(sscanf(params, "s[128]", tmp))
        return SendClientMessage(playerid, Erro, "Digite: /FecharServidor [senha]");

    format(String, 50, "password %s", tmp);
	SendRconCommand(String);

    format(String, MAX_STRING, "VRC-Admin ~ O(A) %s %s trancou o servidor", CargoAdmin(playerid), PlayerInfo[playerid][Nome]);
    SendClientMessageToAll(adm, String);
    format(String, MAX_STRING, "VRC-Admin ~ Senha do servidor {FF0000}%s", tmp);
    SendClientMessage(playerid, adm, String);
    return 1;
}
CMD:abrirservidor(playerid)
{
    if(!IsPlayerCoordinator(playerid))
		return SendClientMessage(playerid, Erro, "Comando Inv�lido");

	SendRconCommand("password 0");

    format(String, MAX_STRING, "VRC-Admin ~ O(A) %s %s abriu o servidor", CargoAdmin(playerid), PlayerInfo[playerid][Nome]);
    SendClientMessageToAll(adm, String);
    SendClientMessage(playerid, adm, "VRC-Admin ~ O servidor acaba de ser destrancado por voc�");
    return 1;
}
CMD:reiniciar(playerid)
{
    if(!IsPlayerCoordinator(playerid))
		return SendClientMessage(playerid, Erro, "Comando Inv�lido");

    format(String, 30, "password %s", GetRandomString(10));
	SendClientMessageToAll(0xB9FFFFAA, "VRC-BOT ~ O Servidor reiniciar� em 2 minutos");
	SetTimer("RestartServer", 60000, false);
    return 1;
}
