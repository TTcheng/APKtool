#include "txteditor.h"
#include "ui_txteditor.h"
#include <QLineEdit>
#include <QTextBlock>
#include <QTextStream>
#include <QMessageBox>
#include <QDebug>

TxtEditor::TxtEditor(QWidget *parent, QString file) :
    QWidget(parent),
    ui(new Ui::TxtEditor),_file(file)
{
    ui->setupUi(this);
    editor = ui->plainTextEdit;
    editor->setCursorWidth(10);
//    editor->installEventFilter(this);
    QLineEdit *linenum = ui->linenum_3;
    linenum->setValidator(new QIntValidator(1,99999,this));
    QFile f(_file);
    if(f.open(QIODevice::ReadOnly|QIODevice::Text)){
        QTextStream in(&f);
        editor->setPlainText(in.readAll());
        f.close();
        ui->save_button->setText(tr("Save"));
        _textchanged = false;
    }
    else
        emit noreadperm();
    editor->setFocus();
    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
    QApplication::postEvent(editor, event);
}

TxtEditor::~TxtEditor()
{
    delete ui;
}

void TxtEditor::closeEvent(QCloseEvent *e)
{
    if(_textchanged){
        QMessageBox msgBox;
        msgBox.setText(tr("Save?"));
        msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);
        int ret = msgBox.exec();
        switch(ret){
        case QMessageBox::Save:
            savefile1();
            break;
        case QMessageBox::Discard:
            break;
        case QMessageBox::Cancel:
            e->ignore();
            editor->setFocus();
            QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
            QApplication::postEvent(editor, event);
            return;
        }
    }
    emit closed();
    deleteLater();
}



void TxtEditor::up()
{
    editor->moveCursor(QTextCursor::Up);
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
  //  QApplication::postEvent(editor, event);
}

void TxtEditor::down()
{
    editor->moveCursor(QTextCursor::Down);
    editor->setFocus();
  //  QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
    //QApplication::postEvent(editor, event);
}

void TxtEditor::left()
{
    editor->moveCursor(QTextCursor::Left);
    editor->setFocus();
  //  QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
    //QApplication::postEvent(editor, event);
    //delete event; no need to do
}

void TxtEditor::right()
{
    editor->moveCursor(QTextCursor::Right);
    editor->setFocus();
  //  QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
    //QApplication::postEvent(editor, event);
}

void TxtEditor::prev()
{
    editor->moveCursor(QTextCursor::PreviousWord);
    editor->setFocus();
 //   QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
  //  QApplication::postEvent(editor, event);
}

void TxtEditor::next()
{
    editor->moveCursor(QTextCursor::NextWord);
    editor->setFocus();
  //  QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
    //QApplication::postEvent(editor, event);
}
void TxtEditor::pageup()
{
    QKeyEvent *event = new QKeyEvent(QEvent::KeyPress, Qt::Key_PageUp, Qt::NoModifier);
    QApplication::postEvent(editor, event);
    editor->setFocus();
//    QEvent *event1 = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event1);
 //   delete event;
}

void TxtEditor::pagedown()
{
    QKeyEvent *event = new QKeyEvent(QEvent::KeyPress, Qt::Key_PageDown, Qt::NoModifier);
    QApplication::postEvent(editor, event);
    editor->setFocus();
    //QEvent *event1 = new QEvent(QEvent::RequestSoftwareInputPanel);
    //QApplication::postEvent(editor, event1);
 //   delete event;
}

void TxtEditor::setlinenum()
{
    QLineEdit *linenum = ui->linenum_3;
    linenum->setText(QString::number(editor->textCursor().blockNumber()+1));
}

void TxtEditor::gotoline()
{
    QLineEdit *linenum = ui->linenum_3;
    QTextCursor cursor = editor->textCursor();
    QTextBlock block = editor->document()->findBlockByLineNumber(linenum->text().toInt()-1);
    cursor.setPosition(block.position());
    editor->setTextCursor(cursor);
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
}

void TxtEditor::totalline(int lines)
{
    QLabel *label = ui->totalline_3;
    label->setText("/"+QString::number(lines));
}

void TxtEditor::findnext()
{
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
    QString keyword = ui->search_lineedit->text();
    if(ui->case_checkbox->isChecked())
        editor->find(keyword, QTextDocument::FindCaseSensitively);
    else
        editor->find(keyword);

}

void TxtEditor::findprev()
{
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
    QString keyword = ui->search_lineedit->text();
    if(ui->case_checkbox->isChecked())
        editor->find(keyword, QTextDocument::FindCaseSensitively|QTextDocument::FindBackward);
    else
        editor->find(keyword, QTextDocument::FindBackward);
}

void TxtEditor::replace()
{
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
    QTextCursor cursor = editor->textCursor();
    if(!cursor.selectedText().isEmpty())
        cursor.insertText(ui->replace_lineedit->text());
    editor->setTextCursor(cursor);
}

void TxtEditor::replaceall()
{
    editor->moveCursor(QTextCursor::Start);
    QString keyword = ui->search_lineedit->text();
    QTextCursor cursor = editor->textCursor();
    cursor.beginEditBlock();
    if(ui->case_checkbox->isChecked()){
        while(editor->find(keyword, QTextDocument::FindCaseSensitively)){
            QTextCursor cursor = editor->textCursor();
            cursor.insertText(ui->replace_lineedit->text());
            editor->setTextCursor(cursor);
        }
    }
    else{
        while(editor->find(keyword)){
            QTextCursor cursor = editor->textCursor();
            cursor.insertText(ui->replace_lineedit->text());
            editor->setTextCursor(cursor);
        }
    }
    cursor.endEditBlock();
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
}

void TxtEditor::undo()
{
    editor->undo();
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
}

void TxtEditor::redo()
{
    editor->redo();
    editor->setFocus();
//    QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
//    QApplication::postEvent(editor, event);
}

void TxtEditor::copy()
{
    editor->setFocus();
  //  QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
   // QApplication::postEvent(editor, event);
    editor->copy();
}

void TxtEditor::cut()
{
    editor->setFocus();
 //   QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
 //   QApplication::postEvent(editor, event);
    editor->cut();
}

void TxtEditor::paste()
{
    editor->setFocus();
 //   QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
 //   QApplication::postEvent(editor, event);
    editor->paste();
}

void TxtEditor::savefile()
{
    QFile f(_file);
    if(f.open(QIODevice::WriteOnly|QIODevice::Text)){
        QTextStream out(&f);
        out<<editor->toPlainText();
        f.close();
        ui->save_button->setText(tr("Save"));
        _textchanged = false;
    }
    else
        emit nowriteperm();
    editor->setFocus();
 //   QEvent *event = new QEvent(QEvent::RequestSoftwareInputPanel);
 //   QApplication::postEvent(editor, event);
}

void TxtEditor::savefile1()
{
    QFile f(_file);
    if(f.open(QIODevice::WriteOnly|QIODevice::Text)){
        QTextStream out(&f);
        out<<editor->toPlainText();
        f.close();
        ui->save_button->setText(tr("Save"));
        _textchanged = false;
    }
    else
        emit nowriteperm();
}
void TxtEditor::textchanged()
{
    ui->save_button->setText(tr("Save*"));
    _textchanged = true;

}
