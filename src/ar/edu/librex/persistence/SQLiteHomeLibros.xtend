package ar.edu.librex.persistence

import android.app.Activity
import android.content.ContentValues
import ar.edu.librex.domain.Libro
import java.util.ArrayList
import android.database.Cursor
import android.util.Log

class SQLiteHomeLibros implements HomeLibros {

	LibrexSQLLiteHelper db

	new(Activity activity) {
		db = new LibrexSQLLiteHelper(activity)
	}

	override addLibro(Libro libro) {
		val con = db.writableDatabase

		val values = new ContentValues
		values.put("titulo", libro.titulo)
		values.put("autor", libro.autor)

		con.insert("Libros", null, values)
		con.close
		Log.w("Librex", "Se creó libro " + libro)
	}

	override getLibros() {
		val result = new ArrayList<Libro>
		val con = db.readableDatabase

		val curLibros = con.query("Libros", #["titulo, autor, id"], null, null, null, null, null)
		while (curLibros.moveToNext) {
			result.add(crearLibro(curLibros))
		}
		con.close
		Log.w("Librex", "getLibros | result: " + result)
		result
	}

	def Libro crearLibro(Cursor cursor) {
		val libro = new Libro(cursor.getString(0), cursor.getString(1))
		libro.id = cursor.getLong(2)  
		Log.w("Librex", "genero un libro en memoria | id: " + libro.id + " | libro: " + libro)
		libro
	}

	override getLibro(Libro libroOrigen) {
		val con = db.readableDatabase
		try {
			val curLibros = con.query("Libros", #["titulo, autor, id"], "titulo = ? ", #[libroOrigen.titulo], null, null, null)
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
			val curLibros = con.query("Libros", #["titulo, autor, id"], "id = ? ", #["" + posicion], null, null, null)
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
			result = libro
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

}
