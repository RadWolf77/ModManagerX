#include "language.h"
#include <QStringBuilder>

void Language::loadLanguage(const QString& languageCode) {
	dictionary.clear();

	QString path = QString(":/qt/qml/modmanagerx/lang/%1.json").arg(languageCode);
	QFile file(path);

	if (file.open(QIODevice::ReadOnly)) {
		QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
		QJsonObject obj = doc.object();

		for (auto it = obj.begin(); it != obj.end(); ++it) {
			dictionary.insert(it.key(), it.value().toString());
		}
	}
}

QString Language::get(const QString& key, const QString& defaultValue) const {
	return dictionary.value(key, defaultValue.isEmpty() ? ("MISSING_" % key) : defaultValue);
}