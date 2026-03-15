#include "modpack.h"
#include <QDebug>
#include <QDir>
#include <QUrl>
#include <QCoreApplication>
#include <QMetaEnum>
#include "language.h"
#include "utilities.h"


Q_INVOKABLE QString ModPack::getButtonText() const {
	switch (status) {
	case UpToDate:           return Language::instance()->get("STATUS_UPTODATE");
	case UpdateAvailable:    return Language::instance()->get("STATUS_UPDATEAVAILABLE");
	case NotInstalled:       return Language::instance()->get("STATUS_NOTINSTALLED");
	case Error:              return Language::instance()->get("STATUS_ERROR");
	case Warning:            return Language::instance()->get("STATUS_WARNING");
	default:                 return "...";
	}
}

Q_INVOKABLE bool ModPack::getCanUpdate() const {
	switch (status) {
	case UpToDate:           return false;
	case UpdateAvailable:    return true;
	case NotInstalled:       return true;
	case Error:              return false;
	case Warning:            return true;
	default:                 return false;
	}
}

Q_INVOKABLE QString ModPack::getNoticeText() const {
	QMetaEnum meta = QMetaEnum::fromType<ModPack::Notice>();
	QString key = QString("NOTICE_%1").arg(meta.valueToKey(notice));


	return Language::instance()->get(key);
}

Q_INVOKABLE void ModPack::setStatus(Status newStatus, Notice newNotice) {
	status = newStatus;
	notice = newNotice;
	emit statusChanged();
}

Q_INVOKABLE QString ModPack::getIconPath() {
	QString fullPath = QDir::cleanPath((QString)iconDir.filePath(name + ".png"));
	return QUrl::fromLocalFile(fullPath).toString();
}