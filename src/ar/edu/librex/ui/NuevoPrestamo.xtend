package ar.edu.librex.ui

import android.app.Activity
import android.content.CursorLoader
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.provider.ContactsContract
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.Menu
import android.view.View
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.ImageView
import android.widget.TextView
import ar.edu.librex.domain.Contacto
import ar.edu.librex.domain.Libro
import ar.edu.librex.domain.Prestamo
import java.util.HashMap
import java.util.Map

import static extension ar.edu.librex.config.LibrexConfig.*

class NuevoPrestamo extends Activity implements TextWatcher {

	private static int PICK_CONTACT = 1

	AutoCompleteTextView txtLibroAutocomplete
	Map<String, Libro> mapaLibros = new HashMap<String, Libro>
	Libro libroSeleccionado
	Contacto contacto

	override onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		contentView = R.layout.activity_nuevo_prestamo
	}

	override onCreateOptionsMenu(Menu menu) {
		menuInflater.inflate(R.menu.nuevo_prestamo, menu)
		txtLibroAutocomplete = findViewById(R.id.txtLibroTituloAutocomplete) as AutoCompleteTextView
		val libros = this.homeLibros.librosPrestables
		txtLibroAutocomplete.adapter = new ArrayAdapter<Libro>(this, android.R.layout.simple_dropdown_item_1line, libros)
		libros.forEach[ libro | mapaLibros.put(libro.toString, libro)]
		txtLibroAutocomplete.addTextChangedListener(this)
		true
	}

	override onTextChanged(CharSequence s, int start, int before, int count) {
		libroSeleccionado = mapaLibros.get(txtLibroAutocomplete.text.toString)
	}

	override afterTextChanged(Editable arg0) {
	}

	override beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
	}

	def buscarContacto(View view) {
		val intent = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI)
		startActivityForResult(intent, PICK_CONTACT)
	}

	override onActivityResult(int reqCode, int resultCode, Intent data) {
		super.onActivityResult(reqCode, resultCode, data);

		switch (reqCode) {
			case (PICK_CONTACT): 
				if (resultCode == Activity.RESULT_OK) {seleccionarContacto(data) }
		}
	}

	def seleccionarContacto(Intent data) {
		Log.w("Librex", "Data del intent: " + data.data)
		val loader = new CursorLoader (this, data.data, null, null, null, null)
		val cursor = loader.loadInBackground
        if (cursor.moveToFirst) {
        	val name = cursor.getString(cursor.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME))
        	val contactoBuscar = new Contacto
        	contactoBuscar.nombre = name
        	// http://developer.android.com/reference/android/os/StrictMode.html
        	// Log.w("Librex", "Contacto a buscar: " + contactoBuscar)
        	contacto = this.homeContactos.getContacto(contactoBuscar)
        	// Log.w("Librex", "Contacto elegido: " + contacto)
        	val txtContacto = findViewById(R.id.txtContacto) as TextView
        	txtContacto.text = contacto.nombre
        	val imgContacto = findViewById(R.id.imgContactoAPrestar) as ImageView
        	val fotoContacto = contacto.foto
			val bm = BitmapFactory.decodeByteArray(fotoContacto, 0, fotoContacto.length)
			imgContacto.imageBitmap = bm
        }
	}
		
	def void prestar(View view) {
		val prestamo = new Prestamo
		prestamo.libro = libroSeleccionado
		prestamo.contacto = contacto
		prestamo.prestar 
		this.homePrestamos.addPrestamo(prestamo)
		this.finish()
	}
	
}
