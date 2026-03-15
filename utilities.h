#ifndef UTILITIES_H
#define UTILITIES_H

#include <QString>
#include <QDir>
#include <QJsonDocument>

class ModPack;

QJsonDocument parseMMXFile(const QString& modpackFile);

void fetchLatestVersion(ModPack* pack, const QString& serverUrl);

QString resolvePath(QString path);

void initializeFilesystem();

extern QDir mmxDir;

extern QDir iconDir;

extern QDir modpackFileDir;

QString readFullFile(const QString& filePath);



#endif 