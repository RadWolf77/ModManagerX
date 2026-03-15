#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QObject>
#include <QHash>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>

class Language : public QObject {
	Q_OBJECT

public:
	static Language* instance() {
		static Language _instance;
		return &_instance;
	}

	void loadLanguage(const QString& languageCode = "en_US");

	Q_INVOKABLE QString get(const QString& key, const QString& defaultValue = "") const;

private:
	explicit Language(QObject* parent = nullptr) : QObject(parent) {}
	QHash<QString, QString> dictionary;
};


#endif