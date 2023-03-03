#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui -> setupUi(this);

    QList <QSerialPortInfo> com_port_list = QSerialPortInfo::availablePorts();

    if ( com_port_list.QList::empty() )
    {
        ui -> statusbar -> showMessage( "Нет доступных COM-портов", 2000 );
    }
    else
    {
        ui -> comboBox -> addItem( com_port_list.at( 0 ).QSerialPortInfo::portName() );
    }

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_3_clicked() // refresh
{
    QList <QSerialPortInfo> com_port_list = QSerialPortInfo::availablePorts();

    if (com_port_list.QList::empty())
    {
        ui -> comboBox -> removeItem(0);
        ui -> statusbar -> showMessage("Нет доступных COM-портов", 2000);
    }
    else
    {
        ui -> comboBox -> addItem( com_port_list.at(0).QSerialPortInfo::portName() );
        ui -> statusbar -> clearMessage();
    }

}

void MainWindow::on_pushButton_2_clicked() // Transfer
{

    QSerialPort port( ui -> comboBox -> currentText(), this );

    if ( !port.open( QIODevice::ReadWrite ) )
    {
        ui -> statusbar -> showMessage( "COM-порт не открылся", 2000 );
    }
    else
    {
        port.setBaudRate( QSerialPort::Baud9600 );
        port.setDataBits( QSerialPort::Data8 );
        port.setStopBits( QSerialPort::OneStop );
        port.setFlowControl( QSerialPort::NoFlowControl );
        port.setParity( QSerialPort::NoParity );

        QByteArray Data_reg ("3");

        QString Data = ui -> Data -> text();

        port.write( Data_reg );
        port.write( Data.toUtf8() );
        port.flush();

        qDebug() << port.readAll();

        //if ( port.readAll() == "Hello\r" )
            ui -> Terminal -> append( QTime::currentTime().toString() + " - " + port.readAll() );
        //else
           // ui -> Terminal -> append( QTime::currentTime().toString() + " - Ничего" );

        port.close();

    }

}

void MainWindow::on_pushButton_clicked()
{
    QSerialPort port( ui -> comboBox -> currentText(), this );

    if ( !port.open( QIODevice::WriteOnly ) )
    {
        ui -> statusbar -> showMessage( "COM-порт не открылся", 2000 );
    }
    else
    {
        port.setBaudRate( QSerialPort::Baud9600 );
        port.setDataBits( QSerialPort::Data8 );
        port.setStopBits( QSerialPort::OneStop );
        port.setFlowControl( QSerialPort::NoFlowControl );
        port.setParity( QSerialPort::NoParity );

        QString Speed = ui -> Speed -> text();
        QString Period = ui -> Period -> text();

        QByteArray Speed_reg ("0");
        QByteArray Period_reg("1");

        port.write( Speed_reg );
        port.write( Speed.toUtf8() );

        port.flush();

        port.write( Period_reg );
        port.write( Period.toUtf8() );

        port.flush();

        port.close();

        ui -> statusbar -> showMessage( "Настройки сохранены", 2000 );

    }

}

