hook OnPlayerText(playerid, text[])
{
    /*
    if(!strcmp(text, "/192"))
    {
        if(PlayerInfo[playerid][cellphone]){
            SendClientMessage(playerid, Erro, "Voc� n�o tem celular");
            return 1;
        }

        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(PlayerInfo[i][Profissao] == paramedic)
            {
                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                GetPlayer2DZone(zone, MAX_ZONE_NAME, x, y);

                SendClientMessage(playerid, Green, "Param�dicos informados");
                format(String, sizeof(String), "O(A) Jogador(a) %s[%d] est� pedindo um(a) Param�dico(a) na localidade ( %s )", PlayerInfo[playerid][Nome], playerid, zone);
                SendClientMessage(i, color_paramedic, String);
                return 1;
            }
        }
        return 0;
    }
    */
    return 0;
}