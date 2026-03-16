#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QList>
#include <QHash>
#include "modpack.h"

void checkForMMXFiles();

class Backend : public QObject
{
	Q_OBJECT

		Q_PROPERTY(QList<ModPack*> modpackItems READ modpackItems NOTIFY modpackListChanged)

		Q_PROPERTY(ModPack* getSelectedModPack READ getSelectedModPack NOTIFY selectedModPackChanged)

		Q_PROPERTY(QString getCurrentIconPath READ getCurrentIconPath NOTIFY currentIconPathChanged)

		Q_PROPERTY(bool taskInProgress READ isTaskInProgress NOTIFY taskInProgressChanged)


public:
	static Backend* instance() {
		static Backend _instance;
		return &_instance;
	}

	Q_INVOKABLE void importPackFile(const QString& filePath);

	Q_INVOKABLE void stageImportFile(const QString& filePath);

	QString getCurrentIconPath() const { return currentIconPath; }

	QList<ModPack*> modpackItems() const { return modpackMasterList; }

	ModPack* getSelectedModPack() const { return selectedModPack; }

	QHash<QString, QString> getUserPlaceholders() { return userPlaceholders; }
	bool isTaskInProgress() { return taskInProgress; }
	void setTaskInProgress(bool isInProgress);
	void resetIcon();

	Q_INVOKABLE void loadPlaceholders();
	Q_INVOKABLE void resyncModPacks();
	Q_INVOKABLE void selectModPack(int index);
	Q_INVOKABLE void addModpack(ModPack* mp);
	Q_INVOKABLE void clearModpacks();
	Q_INVOKABLE void updateButtonClicked();


signals:
	void modpackListChanged();
	void selectedModPackChanged();
	void currentIconPathChanged();
	void showImportDialogRequested(QString name, QString location, QString path, QString file);
	void taskInProgressChanged();

private:
	explicit Backend(QObject* parent = nullptr) : QObject(parent) {

		selectedModPack = nullptr;
		taskInProgress = false;

	}

	bool taskInProgress;
	QList<ModPack*> modpackMasterList;
	ModPack* selectedModPack;
	QString currentIconPath;
	QHash<QString, QString> userPlaceholders;


};

#endif