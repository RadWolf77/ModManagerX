![MMX](https://starwolves.net/wp-content/uploads/2026/03/ModManagerXTitle.png)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
![Qt Version](https://img.shields.io/badge/Qt-5.15%2B-green.svg)
## 🌎 Overview

Mod Manager X is a lightweight, cross-platform modpack manager built with C++ and Qt. It handles local modpack installations, synchronizes with remote repositories to check for updates, and utilizes dynamic environment placeholders to manage modpacks.

This program is meant for those who wish to share modpacks but find using traditional mod managers to be tedious. Mod Manager X has been designed in such a way so that you can use it for more than mods. I'm not too sure what other use cases there could be (maybe distributing an app?), but the goal of this program is to help in that process.

## 🚧 Disclaimer
Mod Manager X is currently in development, and core features are yet to be implemented. The client is able to run for demonstration purposes, but will do nothing besides create a configuration folder in the user's %appdata% directory.

## ✨ Implemented Features
* **Network Synchronization:** Automatically checks remote user-hosted repositories for modpack updates and fetches metadata/icons.
* **Dynamic Path Resolution:** Resolves custom user placeholders and system environment variables for flexible installation paths.
* **Localization Support:** Built-in JSON-based dictionary system for easy multi-language UI support. (Anybody is welcome to help localize!)

## 🚀 Planned Features
* **Delta Installation/Updates:** Only download changed files when updating modpacks, thereby reducing network overhead and IO demand.
* **Game Modules:** Custom instruction modules to install modpacks into their respective games (automatically adding an entries into %appdata%\.minecraft\launcher_profiles.json)
* **User Hosted Repositories:** Users can host their own repositories where they can store modpacks and other users can download them, only needing an .mmx file to do so.
* **Background Updates:** One of the prime features of the original Mod Manager was its ability to run in the background and silently install updates, reducing occurences of (my game has to update).
* **Launch Button:** Some games have the ability to launch with a particular set of mods by passing launch arguments; this feature will allow the user to do that from the Mod Manager X window.

## 🏗️ Contributing
Anybody is welcome to contribute to this project! Once 1.0 is released, I will setup a wiki with the basics of the program for both users, repo hosts, and developers looking to learn or contribute!

## 🔦 Credits & Acknowledgements
This program utilizes the wonderful F77Minecraft Font, and that font is licensed under CC BY-ND 3.0. Amazing font!


#### This program is brought to you by RadWolf! "We are travel through space and time, equations in hand and mind!"
![RadWare](https://starwolves.net/wp-content/uploads/2026/03/radware_full_light.png)
