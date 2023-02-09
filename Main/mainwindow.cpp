#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui -> setupUi(this);

    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {

    }

    QList <QSerialPortInfo> com_port_list = QSerialPortInfo::availablePorts();

    if (com_port_list.QList::empty())
    {
        ui -> textBrowser -> append("Нет доступных COM-портов.\nПодключите устройство и обновите список.");
    }
    else
    {
        ui -> comboBox -> addItem(com_port_list.at(0).QSerialPortInfo::portName());
    }


}

MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::on_pushButton_3_clicked()
{
    QList <QSerialPortInfo> com_port_list = QSerialPortInfo::availablePorts();

    if (com_port_list.QList::empty())
    {
        ui -> comboBox -> removeItem(0);
        ui -> textBrowser -> append("Нет доступных COM-портов.\nПодключите устройство и обновите список.");
    }
    else
    {
        ui -> comboBox -> addItem(com_port_list.at(0).QSerialPortInfo::portName());
    }

}

void MainWindow::on_pushButton_2_clicked()
{

    QSerialPort port(ui -> comboBox ->currentText(), this);

    if ( !port.open( QIODevice::ReadWrite ) )
    {
        ui -> textBrowser -> append("COM-порт не открылся.");
    }
    else
    {
        ui -> textBrowser -> append("COM-порт открыт.");

        port.setBaudRate(QSerialPort::Baud115200);
        port.setDataBits(QSerialPort::Data8);
        port.setStopBits(QSerialPort::OneStop);
        port.setFlowControl(QSerialPort::NoFlowControl);
        port.setParity(QSerialPort::NoParity);

        QString data = ui -> lineEdit -> text();

        port.write( data.toUtf8() );

        port.flush();

        port.close();

    }

}

