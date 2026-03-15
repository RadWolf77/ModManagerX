#include "stdafx.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <Qfile>
#include <QDirIterator>
#include <QQmlContext>
#include <QQmlEngine>
#include <QLocalSocket>
#include <QLocalServer>
#include <QQuickStyle>
#include <QPalette>
#include <QStyleHints>
#include "backend.h"
#include "utilities.h"
#include "modpack.h"
#include "language.h"


int main(int argc, char* argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#endif

	QString appDir = QCoreApplication::applicationDirPath();

	QDir::setCurrent(appDir);

	QCoreApplication::setApplicationName("ModManagerX");
	QCoreApplication::setOrganizationName("RadWare");
	QCoreApplication::setApplicationVersion("0.0.1");


	QGuiApplication app(argc, argv);

	Language::instance()->loadLanguage("en_US");


	app.styleHints()->setColorScheme(Qt::ColorScheme::Light);


	QString passedFilePath;
	if (argc > 1) {
		passedFilePath = QString::fromLocal8Bit(argv[1]);
	}

	QLocalSocket socket;
	socket.connectToServer("ModManagerX_IPC");
	if (socket.waitForConnected(500)) {
		if (!passedFilePath.isEmpty()) {
			socket.write(passedFilePath.toUtf8());
			socket.waitForBytesWritten(500);
		}
		return 0;
	}

	QLocalServer server;

	QLocalServer::removeServer("ModManagerX_IPC");
	server.listen("ModManagerX_IPC");

	Backend* backend = Backend::instance();

	QObject::connect(&server, &QLocalServer::newConnection, [&server, backend]() {
		QLocalSocket* clientSocket = server.nextPendingConnection();
		QObject::connect(clientSocket, &QLocalSocket::readyRead, [clientSocket, backend]() {
			QString newFilePath = QString::fromUtf8(clientSocket->readAll());

			backend->stageImportFile(newFilePath);
			});
		});


	app.setWindowIcon(QIcon(":/qt/qml/modmanagerx/images/Mod Manager X.ico"));

	initializeFilesystem();
	

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("backend", Backend::instance());
	engine.rootContext()->setContextProperty("Language", Language::instance());

	engine.load(QUrl(QStringLiteral("qrc:/qt/qml/modmanagerx/Main.qml")));
	//engine.load(QUrl(u"qrc:/Main/Main.qml"_qs));
	if (engine.rootObjects().isEmpty())
		return -1;



	checkForMMXFiles();


	return app.exec();
}
