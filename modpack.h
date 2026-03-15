#ifndef MODPACK_H
#define MODPACK_H

#include <QObject>
#include <QString>
#include <QtQml/qqml.h>
#include <QDir>
#include <QUrl>


// modpacks are called Modpacks or modpacks, but this specific class is called ModPack with the capitalized P to show its talking about this class.

// Location refers to the location on the internet where the ModPack's repo is. Path is the path.

// Status will affect whether the modpack can be updated, etc.

class ModPack : public QObject {
	Q_OBJECT

		QML_ELEMENT
		QML_UNCREATABLE("ModPack is managed here")

		Q_PROPERTY(QString name MEMBER name NOTIFY dataChanged)
		Q_PROPERTY(QString description MEMBER description NOTIFY dataChanged)
		Q_PROPERTY(QString version MEMBER version NOTIFY dataChanged)
		Q_PROPERTY(QString latestVersion MEMBER latestVersion NOTIFY dataChanged)
		Q_PROPERTY(QString location MEMBER location NOTIFY dataChanged)
		Q_PROPERTY(QString path MEMBER path NOTIFY dataChanged)
		Q_PROPERTY(QString iconSource MEMBER iconSource NOTIFY dataChanged)
		Q_PROPERTY(Status status MEMBER status NOTIFY statusChanged)
		Q_PROPERTY(Notice notice MEMBER notice NOTIFY statusChanged)
		Q_PROPERTY(bool canUpdate MEMBER canUpdate NOTIFY statusChanged)

public:
	enum Status {
		Checking,       // This should be the default for all ModPacks upon creation.
		NotInstalled,
		UpToDate,       // Versions match
		UpdateAvailable,// Versions differ
		Updating,       // Downloading/Extracting
		Warning,        // Warn the user if something needs attention
		Error           // Network or File I/O failure
	};
	Q_ENUM(Status);

	enum Notice {
		// Everything is good.
		None,

		// Errors
		RepoUnavailable,     // What it says.
		MissingPlaceholders, // Placeholders missing; cannot find path to install.

		// Warnings
		FilesAlreadyPresent  // Files exist in the modpack's path directory, but no version file exists.
	};
	Q_ENUM(Notice)

		explicit ModPack(QString n, QString desc, QString v, QString lv, QString l, QString p, QObject* parent = nullptr)
		: QObject(parent),
		name(n),
		description(desc),
		version(v),
		latestVersion(lv),
		location(l),
		path(p),
		status(Checking),
		notice(None)
	{
	}

	Q_INVOKABLE QString getButtonText() const;
	Q_INVOKABLE bool getCanUpdate() const;
	Q_INVOKABLE QString getNoticeText() const;
	Q_INVOKABLE Status getStatus() { return status; }
	Q_INVOKABLE Notice getNotice() { return notice; }
	Q_INVOKABLE QString getIconPath();

	Q_INVOKABLE void setStatus(Status newStatus, Notice newNotice = None);

	QString name;
	QString description;
	QString version;
	QString latestVersion;
	QString location;
	QString path;
	QString iconSource;

	bool canUpdate;


signals:
	void statusChanged();
	void dataChanged();

private:
	Status status;
	Notice notice;
};

#endif