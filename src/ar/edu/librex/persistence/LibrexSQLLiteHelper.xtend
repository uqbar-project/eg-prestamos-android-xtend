package ar.edu.librex.persistence

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class LibrexSQLLiteHelper extends SQLiteOpenHelper {

	private static final String DATABASE_NAME = "librex.db"
	private static final int DATABASE_VERSION = 1

	new(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION)
	}

	override onCreate(SQLiteDatabase db) {
		val crearTablas = new StringBuffer
		crearTablas.append("CREATE TABLE Libros (ID INTEGER PRIMARY KEY AUTOINCREMENT,")
		crearTablas.append(" TITULO TEXT NOT NULL,")
		crearTablas.append(" AUTOR TEXT NOT NULL);")
		crearTablas.append("CREATE TABLE Prestamos (ID INTEGER PRIMARY KEY AUTOINCREMENT,")
		crearTablas.append(" LIBRO_ID INTEGER NOT NULL,")
		crearTablas.append(" CONTACTO_ID INTEGER NOT NULL,")
		crearTablas.append(" FECHA TEXT NOT NULL,")
		crearTablas.append(" FECHA_DEVOLUCION TEXT NULL);")

		db.execSQL(crearTablas.toString)
	}

	override onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS Libros; ")
		db.execSQL("DROP TABLE IF EXISTS Prestamos; ")
		onCreate(db)
	}

}
