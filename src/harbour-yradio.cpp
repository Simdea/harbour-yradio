#include <QtQuick>

#include <QTranslator>
#include <QTextCodec>
#include <QLocale>

#include <sailfishapp.h>
#include "settings.h"

#include "FileDownloader.hpp"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));    
    QTranslator translator;
    Settings *settings;
    const QString applicationVersion("0.3.0");

    qmlRegisterType<FileDownloader>("harbour.org.tal", 1, 0, "FileDownloader");

    app->setApplicationName("harbour-yradio");
    app->setApplicationVersion(applicationVersion);
    app->setOrganizationDomain("org.tal");
    app->setOrganizationName("TalOrg");

    // QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));
    QString locale(QLocale::system().name());

    qDebug() << "Locale is: " << locale;
    if (translator.load("yradio." + locale, ":/nls")) {
        app->installTranslator(&translator);
    } else {
        qDebug() << "Failed to load translation";
    }

    settings = new Settings();

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty("settings", settings);
    view->rootContext()->setContextProperty("appVersion", applicationVersion);
    view->setSource(SailfishApp::pathTo("qml/harbour-yradio.qml"));
    view->showFullScreen();

    return app->exec();
}

