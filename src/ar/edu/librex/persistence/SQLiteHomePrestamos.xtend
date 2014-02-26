package ar.edu.librex.persistence

import android.app.Activity
import android.content.ContentValues
import android.database.Cursor
import android.util.Log
import ar.edu.librex.domain.Contacto
import ar.edu.librex.domain.Prestamo
import java.util.ArrayList

import static extension ar.edu.librex.config.LibrexConfig.*
import static extension ar.edu.librex.util.DateUtil.*

class SQLiteHomePrestamos implements HomePrestamos {

	public static String TABLA_PRESTAMOS = "Prestamos"
	public static String[] CAMPOS_PRESTAMO = #["id, fecha, fecha_devolucion, contacto_phone, libro_id"]
	
	LibrexSQLLiteHelper db
	Activity activity

	new(Activity activity) {
		db = new LibrexSQLLiteHelper(activity)
		this.activity = activity
	}

	override addPrestamo(Prestamo prestamo) {
		val con = db.writableDatabase

		val values = new ContentValues
		values.put("libro_id", prestamo.libro.id)
		values.put("contacto_phone", prestamo.telefono)
		// uso de extension methods de DateUtil
		values.put("fecha", prestamo.fechaPrestamo.asString)
		if (prestamo.estaPendiente) {
			values.put("fecha_devolucion", null as String)
		} else {
			values.put("fecha_devolucion", prestamo.fechaDevolucion.toString)
		}
		
		con.insert(TABLA_PRESTAMOS, null, values)
		con.close
		Log.w("Librex", "Se creó préstamo " + prestamo + " en SQLite")
	}

	override getPrestamosPendientes() {
		val result = new ArrayList<Prestamo>
		val con = db.readableDatabase

		val curPrestamos = con.query(TABLA_PRESTAMOS, CAMPOS_PRESTAMO, null, null, null, null, null)
		while (curPrestamos.moveToNext) {
			result.add(crearPrestamo(curPrestamos))
		}
		con.close
		Log.w("Librex", "Préstamos pendientes " + result)
		result
	}

	def Prestamo crearPrestamo(Cursor cursor) {
		val contactoBuscar = new Contacto
		contactoBuscar.numero = cursor.getString(3)
		val contacto = activity.homeContactos.getContacto(contactoBuscar)
		val idLibro = cursor.getInt(4)
		Log.w("Librex", "idLibro " + idLibro)
		val libro = activity.homeLibros.getLibro(idLibro)
		Log.w("Librex", "libro " + libro)
		val prestamo = new Prestamo(cursor.getInt(0), contacto, libro)
		// extension method toDate de DateUtil
		prestamo.fechaPrestamo = cursor.getString(1).asDate
		if (cursor.getString(2) != null) {
			prestamo.fechaDevolucion = cursor.getString(2).asDate  
		}
		Log.w("Librex", "genero un prestamo en memoria | " + prestamo)
		prestamo
	}

	override getPrestamo(Long id) {
		val con = db.readableDatabase
		try {
			val curPrestamos = con.query(TABLA_PRESTAMOS, CAMPOS_PRESTAMO, "id = ? ", #["" + id], null, null, null)
			curPrestamos.moveToFirst
			if (curPrestamos.afterLast) {
				null
			} else {
				crearPrestamo(curPrestamos)
			}
		} finally {
			con.close
		}
	}

	override removePrestamo(Prestamo prestamo) {
		val con = db.readableDatabase
		try {
			con.delete(TABLA_PRESTAMOS, "id = ? ", #["" + prestamo.id])
		} finally {
			con.close
		}
	}

}
