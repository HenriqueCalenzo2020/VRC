#include YSI\y_hooks

new bool:locate[MAX_PLAYERS];
new maplocate[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason)
{
    if(locate[playerid])
    {
        locate[playerid] = false;
        KillTimer(TimerProcurando[playerid]);
        DestroyDynamicMapIcon(maplocate[playerid]);
    }
    return 1;
}

forward OnPlayerLocate(playerid, id);
public OnPlayerLocate(playerid, id)
{
    if(IsValidDynamicMapIcon(maplocate[playerid])) DestroyDynamicMapIcon(maplocate[playerid]);

    if(!PlayerInfo[id][Logado] || PrisonEnum[id][pCadeia])
    {
        locate[playerid] = false;
        KillTimer(TimerProcurando[playerid]);

        SendClientMessage(playerid, Erro, (!PlayerInfo[id][Logado]) ? ("O(A) Jogador(a) que voc� localizou desconectou-se") : ("O(A) Jogador(a) que voc� localizou foi preso"));
        return 1;
    }
    if(GetDistanceBetweenPlayers(playerid, id) <= 1.0)
    {
        locate[playerid] = false;
        KillTimer(TimerProcurando[playerid]);

        SendClientMessage(playerid, Green, "Voc� chegou at� o procurado(a)");
        return 1;
    }

    new Float:x, Float:y, Float:z;

    GetPlayerPos(id, x, y, z);

    maplocate[playerid] = CreateDynamicMapIcon(x, y, z, 0, 0xFF0000AA, -1, -1, playerid, -1.0, MAPICON_GLOBAL);
    return 1;
}
