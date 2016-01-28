#ifndef MYIMAGEPROVIDER_H
#define MYIMAGEPROVIDER_H
#include <QQuickImageProvider>

class FileImageProvider : public QQuickImageProvider
{
public:
    FileImageProvider();
    QPixmap requestPixmap(const QString& id, QSize* size, const QSize& requestedSize);
};

#endif // MYIMAGEPROVIDER_H
