#!/bin/bash

# --- Konfiguration ---
SERVER_DIR="/var/minecraft/server"
SERVER_JAR="server.jar"
SCREEN_NAME="minecraft"
JAVA_BIN="/usr/bin/java"

# RAM-Zuweisung (Empfehlung: Min- und Max-RAM gleichsetzen, um Ruckler durch Heap-Resizing zu vermeiden)
MIN_RAM="1G"
MAX_RAM="1G"

# --- Ausführung ---

# Ins Server-Verzeichnis wechseln. 
# (Auch wenn Systemd das WorkingDirectory setzt, macht es das Skript sicherer, falls du es manuell startest)
cd "$SERVER_DIR" || {
    echo "Fehler: Verzeichnis $SERVER_DIR nicht gefunden!"
    exit 1
}

# Prüfen, ob bereits eine Session mit dem Namen läuft, um doppelte Starts zu vermeiden
if screen -list | grep -q "\.${SCREEN_NAME}"; then
    echo "Fehler: Eine Screen-Session mit dem Namen '$SCREEN_NAME' läuft bereits."
    exit 1
fi

# Server direkt in einer 'detached' (-d -m) Screen-Session starten.
# Der Befehl wird am Ende angehängt, anstatt 'stuff' zu verwenden.
screen -dmS "$SCREEN_NAME" "$JAVA_BIN" -Xms"$MIN_RAM" -Xmx"$MAX_RAM" -jar "$SERVER_JAR" nogui
