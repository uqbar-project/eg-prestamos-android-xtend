package ar.edu.librex.persistence

import android.app.Activity
import android.content.ContentValues
import android.database.Cursor
import android.util.Log
import ar.edu.librex.domain.Libro
import java.util.ArrayList

class SQLiteHomeLibros implements HomeLibros {

	private String[] CAMPOS_LIBRO = #["titulo, autor, prestado, id"]

	LibrexSQLLiteHelper db

	new(Activity activity) {
		db = new LibrexSQLLiteHelper(activity)
	}

	override addLibro(Libro libro) {
		val con = db.writableDatabase

		var prestado = 0
		if (libro.estaPrestado) {
			prestado = 1
		}
		val values = new ContentValues
		values.put("titulo", libro.titulo)
		values.put("autor", libro.autor)
		values.put("prestado", prestado)

		con.insert("Libros", null, values)
		con.close
		Log.w("Librex", "Se creó libro " + libro)
	}

	override getLibros() {
		val result = new ArrayList<Libro>
		val con = db.readableDatabase

		val curLibros = con.query("Libros", CAMPOS_LIBRO, null, null, null, null, null)
		while (curLibros.moveToNext) {
			result.add(crearLibro(curLibros))
		}
		con.close
		Log.w("Librex", "getLibros | result: " + result)
		result
	}

	def Libro crearLibro(Cursor cursor) {
		val libro = new Libro(cursor.getString(0), cursor.getString(1))
		libro.id = cursor.getLong(3)
		if (cursor.getInt(2) == 1) {
			libro.prestar()  
		}
		Log.w("Librex", "genero un libro en memoria | id: " + libro.id + " | libro: " + libro)
		libro
	}

	override getLibro(Libro libroOrigen) {
		val con = db.readableDatabase
		try {
			val curLibros = con.query("Libros", CAMPOS_LIBRO, "titulo = ? ", #[libroOrigen.titulo], null, null, null)
			curLibros.moveToFirst
			if (curLibros.afterLast) {
				null
			} else {
				crearLibro(curLibros)
			}
		} finally {
			con.close
		}
	}

	override getLibro(int posicion) {
		val con = db.readableDatabase
		try {
			val curLibros = con.query("Libros", CAMPOS_LIBRO, "id = ? ", #["" + posicion], null, null, null)
			curLibros.moveToFirst
			if (curLibros.afterLast) {
				null
			} else {
				crearLibro(curLibros)
			}
		} finally {
			con.close
		}
	}

	override removeLibro(Libro libro) {
		val con = db.readableDatabase
		try {
			con.delete("Libros", "id = ? ", #["" + libro.id])
		} finally {
			con.close
		}
	}

	override removeLibro(int posicion) {
		val con = db.readableDatabase
		try {
			con.delete("Libros", "id = ? ", #["" + posicion + 1])
		} finally {
			con.close
		}
	}

	override addLibroSiNoExiste(Libro libro) {
		var result = this.getLibro(libro)
		if (result == null) {
			this.addLibro(libro)
			result = this.getLibro(libro)
		}	
		result
	}

	override eliminarLibros() {
		val con = db.readableDatabase
		try {
			con.delete("Libros", null, null)
		} finally {
			con.close
		}
	}

	override getLibrosPrestables() {
		libros.filter [ libro | libro.estaDisponible ].toList
	}

}
