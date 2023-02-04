#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui -> setupUi(this);

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


void MainWindow::on_pushButton_clicked()
{
    QSerialPort::open();
}

