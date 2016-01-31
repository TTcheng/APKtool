#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent)
{

}

int Settings::intValue(QString key)
{
    return st.value(key).toInt();
}

QString Settings::strValue(QString key)
{
    return st.value(key).toString();
}

bool Settings::boolValue(QString key)
{
    return st.value(key).toBool();
}


void Settings::setIntValue(QString key, int value)
{
    st.setValue(key, value);
}

void  Settings::setStrValue(QString key, QString value)
{
    st.setValue(key,value);
}

void Settings::setBoolValue(QString key, bool value)
{
    st.setValue(key,value);
}
