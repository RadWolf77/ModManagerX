#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonParseError>
#include <QStringBuilder>
#include "backend.h"
#include "utilities.h"

// Functions in backend.cpp help maintain the data that the Backend holds (like the list of ModPacks).

void Backend::setTaskInProgress(bool inProgress) {
	if (taskInProgress == inProgress) return;

	taskInProgress = inProgress;
	emit taskInProgressChanged();
}



void Backend::loadPlaceholders() {
	userPlaceholders.clear();

	QString path = mmxDir.path() + "/placeholders.json";
	QFile file(path);

	if (!file.exists()) {

		if (file.open(QIODevice::WriteOnly)) {
			file.write("{}");
			file.close();
		}
	}

	if (file.open(QIODevice::ReadOnly)) {
		QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
		QJsonObject obj = doc.object();

		for (auto it = obj.begin(); it != obj.end(); ++it) {
			userPlaceholders.insert("%" + it.key() + "%", it.value().toString());
		}
	}
}

void checkForMMXFiles() {

	if (Backend::instance()->isTaskInProgress() == true) return;

	Backend::instance()->resetIcon();

	Backend::instance()->clearModpacks();

	QStringList mmxFiles = modpackFileDir.entryList(QDir::Files | QDir::NoDotAndDotDot);

	for (const QString& modpackFile : mmxFiles) {

		QJsonDocument jsonDoc = parseMMXFile(modpackFile);

		if (jsonDoc.isObject()) {
			QJsonObject jsonObj = jsonDoc.object();

			QString name = jsonObj.value("name").toString("Modpack");
			QString location = jsonObj.value("location").toString("");
			QString path = jsonObj.value("path").toString("");

			QDir modpackPath(path);

			if (!modpackPath.exists()) {
				modpackPath.mkdir(".");
			}

			QString curVersion = "None";

			if (modpackPath.exists("version")) {
				curVersion = readFullFile(modpackPath.filePath("version"));
			}

			ModPack* newPack = new ModPack(name, (QString)"Checking server...", curVersion, (QString)"...", location, path, Backend::instance());
			Backend::instance()->addModpack(newPack);

			fetchLatestVersion(newPack, location);
		}
	}


}

Q_INVOKABLE void Backend::stageImportFile(const QString& filePath) {

	QJsonDocument jsonDoc = parseMMXFile(filePath);

	if (jsonDoc.isObject()) {
		QJsonObject jsonObj = jsonDoc.object();

		QString name = jsonObj.value("name").toString("Modpack");
		QString location = jsonObj.value("location").toString("");
		QString path = jsonObj.value("path").toString("");

		emit showImportDialogRequested(name, location, path, filePath);
	}
}

Q_INVOKABLE void Backend::updateButtonClicked() {
	// Update functionality TBA.
}

Q_INVOKABLE void Backend::clearModpacks() {
	qDeleteAll(modpackMasterList);
	modpackMasterList.clear();

	selectedModPack = nullptr;
	emit selectedModPackChanged();
	emit modpackListChanged();
}

Q_INVOKABLE void Backend::addModpack(ModPack* mp) {

	modpackMasterList.append(mp);

	emit modpackListChanged();
}

Q_INVOKABLE void Backend::selectModPack(int index) {
	if (index >= 0 && index < modpackMasterList.size()) {
		if (selectedModPack) {
			disconnect(selectedModPack, &ModPack::dataChanged, this, &Backend::selectedModPackChanged);
			disconnect(selectedModPack, &ModPack::statusChanged, this, &Backend::selectedModPackChanged);
		}

		selectedModPack = modpackMasterList[index];
		currentIconPath = selectedModPack->getIconPath();

		connect(selectedModPack, &ModPack::dataChanged, this, &Backend::selectedModPackChanged);
		connect(selectedModPack, &ModPack::statusChanged, this, &Backend::selectedModPackChanged);

		emit selectedModPackChanged();
		emit currentIconPathChanged();
	}
}

void Backend::importPackFile(const QString& filePath) {

	QFileInfo fileInfo(filePath);
	QString fileName = fileInfo.fileName();
	QString destinationPath = modpackFileDir.path() % "/" % fileName;


	if (QFile::exists(destinationPath)) {
		QFile::remove(destinationPath);
	}

	if (QFile::copy(filePath, destinationPath)) {
		resyncModPacks();
	}
}

Q_INVOKABLE void Backend::resyncModPacks() {
	if (taskInProgress) return;

	checkForMMXFiles();
	loadPlaceholders();
}

void Backend::resetIcon() {
	currentIconPath = "";
	emit currentIconPathChanged();

}