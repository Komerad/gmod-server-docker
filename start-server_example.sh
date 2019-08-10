#!/bin/bash
/${GAME_NAME}-base/srcds_run -game ${GAME_NAME} -norestart -port ${SERVER_PORT} -maxplayers ${SERVER_MAXPLAYERS} +hostname ${SERVER_HOSTNAME} ${SERVER_ARGS} +map ${SERVER_MAP} +sv_lan ${SERVER_LAN}
