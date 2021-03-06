// проверка некоторых виджетов в qte5
import core.runtime;
import std.stdio;
import asc1251;
import qte5;

// const string strElow  = "background: #FCFDC6"; //#F8FFA1";
const string strElow  = "background: #F8FFA1";

// Проверка события KeyPressEvent 
bool onChar(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	QKeyEvent qe = new QKeyEvent('+', ev); 
	// 2 - Выдать тип события
	writeln(qe.type, "  -- key -> ", qe.key, "  -- count -> ", qe.count);
	if(qe.key == 65) return false;
	return true;
}

extern (C) void test2(CTest1* z) {
	(*z).test();
}

class CTest1 : QWidget {
	QHBoxLayout layH;
	QVBoxLayout layV;
	QPushButton pb1, pb2, pb3;
	QPlainTextEdit te1;
	
	this() {
		super(null);
		// Изготовим 3 кнопки
		QPushButton pb1 = new QPushButton("Кнопка №1"); pb1.setNoDelete(true);
		pb1.setToolTip("Просто кнопка №1").setToolTipDuration(3000);
		pb1.setMaximumWidth(100);
		
		QPushButton pb2 = new QPushButton("Кнопка №2"); pb2.setNoDelete(true); pb2.setStyleSheet(strElow);
		QPushButton pb3 = new QPushButton("Кнопка №3"); pb3.setNoDelete(true); pb3.setStyleSheet(strElow);
		// Горизонтальный выравниватель для них
		QHBoxLayout layH = new QHBoxLayout(); 
		layH.addWidget(pb1).addWidget(pb2).addWidget(pb3).setNoDelete(true);
		// layH.setMargin(50);
		// Окно редактора
		QPlainTextEdit te1 = new QPlainTextEdit(null);  
		te1.setKeyPressEvent(&onChar);
		
		// te1.setSizePolicy(QWidget.Policy.Fixed, QWidget.Policy.Expanding);
		// Вертикальный выравниватель
		QVBoxLayout layV = new QVBoxLayout(); 
		layV.addWidget(te1).addLayout(layH).setNoDelete(true);
		// setSizePolicy(QWidget.Policy.Expanding, QWidget.Policy.Expanding);
		// Всё в окно
		setLayout(layV);  // layV.setMargin(10); te1.setSizePolicy(QWidget.Policy.Expanding, QWidget.Policy.Expanding);

		// QSlot slotKn1 = new QSlot(&onKn1);
		QSlot slotKn1 = new QSlot(cast(void*)&test2, aThis); // А что, пусть так и будет!
		connect(pb1.QtObj, MSS("clicked()", QSIGNAL), slotKn1.QtObj, MSS("Slot()", QSLOT));
	}
	void test() {
		writeln("--TEST--");
	}
}


int main(string[] args) {
	bool fDebug = true; // To switch on debugging messages
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	CTest1 w1 = new CTest1(); w1.saveThis(&w1);
	w1.show();
	
	app.exec();
	return 0;
}
