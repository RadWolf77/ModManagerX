#include "utilities.h"
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDir>
#include <QStandardPaths>
#include <QJsonValue>
#include <QJsonParseError>
#include <QProcessEnvironment>
#include <QRegularExpression>
#include <QStringBuilder>
#include "modpack.h"
#include "backend.h"

// Utilities contains a bunch of boilerplate functions for other parts of the program to call.
// It also includes some QDir variables.

QDir mmxDir;

QDir modpackFileDir;

QDir iconDir;

QJsonDocument parseMMXFile(const QString& modpackFile) {

	QString fullPath = modpackFileDir.absoluteFilePath(modpackFile);

	QString fileContent = readFullFile(fullPath);

	QByteArray jsonData = fileContent.toUtf8();

	QJsonParseError parseError;
	QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData, &parseError);

	if (parseError.error != QJsonParseError::NoError) {
	}

	return jsonDoc;
}

void initializeFilesystem() {
	QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
	QDir appDataDir(appDataPath);

	mmxDir.setPath(appDataDir.path());

	modpackFileDir.setPath(mmxDir.filePath("modpacks"));

	iconDir = mmxDir;

	iconDir.setPath(iconDir.filePath("iconcache"));

	// Check if the MMX folder exists, and if it doesn't create it. This is run at the start of the program.

	if (!modpackFileDir.exists()) {
		modpackFileDir.mkpath(".");
	}

	if (!iconDir.exists()) {
		iconDir.mkpath(".");
	}

	Backend::instance()->loadPlaceholders();

}

QString resolvePath(QString path) {
	if (path.isEmpty()) return path;

	QHashIterator<QString, QString> i(Backend::instance()->getUserPlaceholders());
	while (i.hasNext()) {
		i.next();
		path.replace(i.key(), i.value(), Qt::CaseInsensitive);
	}

	static QRegularExpression envRegex("%([^%]+)%");
	QRegularExpressionMatchIterator matchIt = envRegex.globalMatch(path);

	QList<QRegularExpressionMatch> matches;
	while (matchIt.hasNext()) matches.prepend(matchIt.next());

	QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
	for (const QRegularExpressionMatch& match : matches) {
		QString varName = match.captured(1);
		if (env.contains(varName)) {
			path.replace(match.capturedStart(0), match.capturedLength(0), env.value(varName));
		}
	}

	return QDir::fromNativeSeparators(path);
}

static QNetworkAccessManager* getNetworkManager() {
	static QNetworkAccessManager* manager = new QNetworkAccessManager();
	return manager;
}

QString readFullFile(const QString& filePath) {
	QFile file(filePath);

	if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
		return "";
	}

	QString content = file.readAll();

	file.close();

	return content;
}

void downloadIcon(const QString& iconURL, ModPack* modpack) {


	QString filePath = iconDir.path() % modpack->name % ".png";

	QNetworkRequest request((QUrl(iconURL)));
	QNetworkReply* reply = getNetworkManager()->get(request);

	QObject::connect(reply, &QNetworkReply::finished, modpack, [reply, modpack, filePath]() {
		if (reply->error() == QNetworkReply::NoError) {
			QFile file(filePath);
			if (file.open(QIODevice::WriteOnly)) {
				file.write(reply->readAll());
				file.close();

				modpack->iconSource = "file:///" % QDir::current().absoluteFilePath(filePath);
				emit modpack->dataChanged();
			}
		}
		reply->deleteLater();
		});
}

void fetchLatestVersion(ModPack* pack, const QString& serverUrl) {

	// Instead of using numbers or some other fancy thing to denote versions, a simple string is used. If the string don't match, clearly the
	// modpack needs to be updated to the repo's version, regardless if the repo's version is higher or lower or whatever.

	pack->setStatus(ModPack::Status::Checking);

	QString versionFilePath = resolvePath(pack->path) % "/version";

	QUrl checkUrl(serverUrl);
	if (!checkUrl.isValid() || checkUrl.scheme().isEmpty()) {
		return;
	}

	QJsonObject jsonPayload;
	jsonPayload["name"] = pack->name;
	QJsonDocument doc(jsonPayload);
	QByteArray postData = doc.toJson();


	QNetworkRequest request((QUrl(serverUrl)));
	request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

	QNetworkReply* reply = getNetworkManager()->post(request, postData);

	QObject::connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);

	QObject::connect(reply, &QNetworkReply::finished, pack, [reply, pack]() {

		if (reply->error() == QNetworkReply::NoError) {
			QByteArray responseData = reply->readAll();
			QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);

			if (responseDoc.isObject()) {
				QJsonObject jsonObj = responseDoc.object();

				pack->latestVersion = jsonObj.value("latestVersion").toString(pack->version);
				pack->description = jsonObj.value("description").toString();
				QString iconURLStr = jsonObj.value("iconurl").toString();
				QUrl iconUrl(iconURLStr);
				if (iconUrl.isValid() && !iconUrl.scheme().isEmpty()) {
					downloadIcon(iconURLStr, pack);
				}

				QString versionFilePath = resolvePath(pack->path) % "/version";

				QFileInfo checkFile(versionFilePath);

				if (checkFile.exists() && checkFile.isFile()) {

					pack->version = readFullFile(versionFilePath);

					if (pack->version == pack->latestVersion) {
						pack->setStatus(ModPack::Status::UpToDate);
					}
					else {
						pack->setStatus(ModPack::Status::UpdateAvailable);
					}
				}
				else {
					pack->setStatus(ModPack::Status::NotInstalled);
				}

				emit pack->dataChanged();
			}
		}
		else {
			pack->setStatus(ModPack::Status::Error, ModPack::Notice::RepoUnavailable);
		}
		});
}

