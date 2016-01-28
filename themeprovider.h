#ifndef THEMEPROVIDER_H
#define THEMEPROVIDER_H
#include <QQuickImageProvider>


class ThemeProvider : public QQuickImageProvider
{
public:
    ThemeProvider();
    QPixmap requestPixmap(const QString& id, QSize* size, const QSize& requestedSize);
};

#endif // THEMEPROVIDER_H
