package ar.edu.paiu.ui

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Menu
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ListView
import android.widget.TextView
import ar.edu.librex.domain.Prestamo
import ar.edu.librex.persistence.MemoryBasedHomePrestamos
import java.util.List

class MainActivity extends Activity {

	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_main)
		this.llenarPrestamosPendientes()
	}
	
	override def onCreateOptionsMenu(Menu menu) {
		menuInflater.inflate(R.menu.main, menu)
		true
	}

	def llenarPrestamosPendientes() {
		// Primera versión, listview con una sola columna
		// val lv = findViewById(R.id.lvPrestamos) as ListView
		// val arrayAdapter = new ArrayAdapter<Prestamo> (this, android.R.layout.simple_list_item_1, MemoryBasedHomePrestamos.instance.prestamosPendientes)
		// lv.adapter = arrayAdapter
		
		// Segunda versión, dos columnas
		val lv = findViewById(R.id.lvPrestamos) as ListView
		val prestamoAdapter = new PrestamoAdapter(this, MemoryBasedHomePrestamos.instance.prestamosPendientes)
		lv.adapter = prestamoAdapter
	}
	
}

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
		lblLibro.text = prestamo.libro.toString
		lblPrestamo.text = prestamo.datosPrestamo
		row
	}
	
}