package ar.edu.librex.ui

import android.content.Context
import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.TextView
import ar.edu.librex.domain.Prestamo
import java.util.List

class PrestamoAdapter extends BaseAdapter {

	Context context
	List<Prestamo> prestamos

	new() {
	}

	new(Context pContext, List<Prestamo> pPrestamos) {
		context = pContext
		prestamos = pPrestamos
	}

	override getCount() {
		prestamos.size
	}

	override getItem(int position) {
		prestamos.get(position)
	}

	override getItemId(int position) {
		position
	}

	override getView(int position, View convertView, ViewGroup parent) {
		val Prestamo prestamo = getItem(position) as Prestamo
		val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
		val row = inflater.inflate(R.layout.prestamo_row, parent, false) as View
		val lblLibro = row.findViewById(R.id.txtLibro) as TextView
		val lblPrestamo = row.findViewById(R.id.txtPrestamo) as TextView
		val imgContacto = row.findViewById(R.id.imgContacto) as ImageView
		lblLibro.text = prestamo.libro.titulo
		lblPrestamo.text = prestamo.datosPrestamo
		val fotoContacto = prestamo.contacto.foto
		val bm = BitmapFactory.decodeByteArray(fotoContacto, 0, fotoContacto.length)
		imgContacto.imageBitmap = bm
		row
	}

}
