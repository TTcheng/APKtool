#ifndef TXTEDITOR_H
#define TXTEDITOR_H

#include <QWidget>
#include <QPlainTextEdit>

namespace Ui {
class TxtEditor;
}

class TxtEditor : public QWidget
{
    Q_OBJECT

public:
    explicit TxtEditor(QWidget *parent = 0, QString file = "");
    ~TxtEditor();


signals:
    void noreadperm();
    void nowriteperm();
    void closed();
public slots:
    void up();
    void down();
    void left();
    void right();
    void prev();
    void next();
    void pageup();
    void pagedown();
    void setlinenum();
    void gotoline();
    void totalline(int lines);
    void findnext();
    void findprev();
    void replace();
    void replaceall();
    void undo();
    void redo();
    void savefile();
    void textchanged();
    void copy();
    void cut();
    void paste();


protected:
    void closeEvent(QCloseEvent *);
//    bool eventFilter(QObject *, QEvent *);

private:
    Ui::TxtEditor *ui;
    QPlainTextEdit *editor;
    QString _file;
    bool _textchanged;
    void savefile1();
};

#endif // TXTEDITOR_H
