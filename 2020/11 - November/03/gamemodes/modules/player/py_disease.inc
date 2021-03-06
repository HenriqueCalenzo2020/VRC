#include YSI\y_hooks

new t_diasease[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    t_diasease[playerid] = SetTimerEx("OnPlayerDisease", 600000, true, "d", playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(t_diasease[playerid]);
    return 1;
}

/*
forward OnPlayerSickDisease(playerid, sickid);
public OnPlayerSickDisease(playerid, sickid)
{
    if(PlayerInfo[playerid][Logado] && PlayerInfo[sickid][Logado])
    {
    	if(!PlayerInfo[playerid][disease] && disease[sickid])
    	{
            switch(disease[sickid])
    		{
    			case 1://Coronav�rus
    		  	{
    		  		PlayerInfo[playerid][disease] = 1;
                    format(String, sizeof(String), "%s passou Coronav�rus para voc� e agora voc� est� doente", PlayerInfo[sickid][Nome]);
    		  		SendClientMessage(playerid, 0x33CCFFAA, String);
                    SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
    			}
    			case 2://Pneumonia
    		  	{
    		  		PlayerInfo[playerid][disease] = 2;
                    format(String, sizeof(String), "%s passou Pneumonia para voc� e agora voc� est� doente", PlayerInfo[sickid][Nome]);
    		  		SendClientMessage(playerid, 0x33CCFFAA, String);
    		  		SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
    			}
    			case 3://Dengue
    		  	{
    		  		PlayerInfo[playerid][disease] = 3;
                    format(String, sizeof(String), "%s passou Dengue para voc� e agora voc� est� doente", PlayerInfo[sickid][Nome]);
    		  		SendClientMessage(playerid, 0x33CCFFAA, String);
    		  		SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
    			}
    		}
    	}
    }
	return 1;
}
*/

forward OnPlayerDisease(playerid);
public OnPlayerDisease(playerid)
{
    if(!PlayerInfo[playerid][Logado] || IsArena[playerid]) return 1;

    if(PlayerInfo[playerid][disease])
    {
        if(Progress[playerid][Vida] < 100.0)
        {
            if(Progress[playerid][Vida] == 97.0 || Progress[playerid][Vida] == 95.0 || Progress[playerid][Vida] == 90.0)
            {
                format(String, sizeof(String), "Voc� est� com %s, e poder� morrer � qualquer momento", DiseaseName(playerid));
                SendClientMessage(playerid, 0x33CCFFAA, String);
            }
        }
        else
        {
            PlayerInfo[playerid][Health] -= 10.0;

            if(PlayerInfo[playerid][Health] <= 0.0)
            {
                PlayerInfo[playerid][Health] = 0.0;
                SetPlayerHealth(playerid, PlayerInfo[playerid][Health]);

                Progress[playerid][Vida] = 95.0;

                SendClientMessage(playerid, 0x008000AA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                SendClientMessage(playerid, 0xFFFFFFAA, "Voc� perdeu a conci�ncia e foi levado pro hospital mais pr�ximo!");
                SendClientMessage(playerid, 0xFFFFFFAA, "V� at� o hospita ou procure um Param�dico!");
                SendClientMessage(playerid, 0x008000AA, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            }
            else
            {
                SetPlayerHealth(playerid, PlayerInfo[playerid][Health]);
            }
        }
        UpdateProgressBar(playerid);
    }
    else
    {
        if((gettime() < PlayerInfo[playerid][vaccine]) || PlayerInfo[playerid][Level] <= 10) return 0;

        new diseaserandom = random(3);

        switch(diseaserandom)
        {
            case 0:
            {
                PlayerInfo[playerid][disease] = 1;
    		  	SendClientMessage(playerid, 0x33CCFFAA, "Voc� acabou pegando Coronav�rus");
                SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
            }
            case 1:
            {
                PlayerInfo[playerid][disease] = 2;
                SendClientMessage(playerid, 0x33CCFFAA, "Voc� acabou pegando Pneumonia");
                SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
            }
            case 2:
            {
                PlayerInfo[playerid][disease] = 3;
                SendClientMessage(playerid, 0x33CCFFAA, "Voc� acabou pegando Dengue");
                SendClientMessage(playerid, 0x33CCFFAA, "V� at� um Hospital ou chame um Param�dico: /192");
            }
        }
        UpdatePlayerDisease(playerid);
    }
    return 1;
}

stock UpdatePlayerDisease(playerid)
{
    new query[70];

    mysql_format(IDConexao, query, sizeof(query), "UPDATE `Identidade` SET `disease`='%d' WHERE `id_contas`='%d'", PlayerInfo[playerid][disease], PlayerInfo[playerid][ID]);
    mysql_query(IDConexao, query);

    mysql_format(IDConexao, query, sizeof(query), "UPDATE `Itens` SET `vaccine`='%d' WHERE `id_contas`='%d'", PlayerInfo[playerid][vaccine], PlayerInfo[playerid][ID]);
    mysql_query(IDConexao, query);
    return 1;
}

stock DiseaseName(playerid)
{
    new var[17];

    switch(PlayerInfo[playerid][disease])
    {
        case 1: var = "Coronav�rus";
        case 2: var = "Pneumonia";
        case 3: var = "Dengue";
        default: var = "N/A";
    }
    return var;
}

stock IsPlayerVaccinated(playerid)
    return ( PlayerInfo[playerid][vaccine] > gettime() ) ? true : false;

