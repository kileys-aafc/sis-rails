To enable mapserver, set a similar line in the VirtualHost section of the Apache config file:

	SetEnvIf Request_URI "cgi-bin/ecozones" MS_MAPFILE=/production/systems/services/app/mapserver/ecozones.map
	