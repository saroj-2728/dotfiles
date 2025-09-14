#!/bin/bash

# Close control center first
eww close control-center
eww close control-center-closer

# Small delay to ensure clean transition
sleep 0.1

# Open power menu
eww open power-menu-closer
eww open power-menu