#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "MyViewer/fileio.h"

int main(int argc, char *argv[])
{
    //register FileIO component
    qmlRegisterType<FileIO, 1>("FileIO", 1, 0, "FileIO");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
