package ar.edu.librex.ui

import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import ar.edu.librex.domain.Libro

import static extension ar.edu.librex.config.LibrexConfig.*

/**
 * A fragment representing a single Libro detail screen. This fragment is either
 * contained in a {@link LibroListActivity} in two-pane mode (on tablets) or a
 * {@link LibroDetailActivity} on handsets.
 */
class LibroDetailFragment extends Fragment {
	public static final String ARG_ITEM = "libro"
	public static final String EDITABLE = "editable"

	private Libro libro
	private boolean editable
	private boolean actualiza
	private int posicion = 0

	/**
	 * Mandatory empty constructor for the fragment manager to instantiate the
	 * fragment (e.g. upon screen orientation changes).
	 */
	new() {
		
	}

	override onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		actualiza = getArgument(ARG_ITEM)
		if (actualiza) {
			libro = arguments.getSerializable(ARG_ITEM) as Libro
		} else {
			libro = new Libro
		}
		editable = arguments.getBoolean(EDITABLE)
	}

	override onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// Asociamos botón con su listener
		val rootView = inflater.inflate(R.layout.fragment_libro_detail,	container, false)
		val txTitulo =  rootView.findViewById(R.id.txtTitulo) as EditText
		val txAutor = rootView.findViewById(R.id.txtAutor) as EditText
		rootView.findViewById(R.id.btnGuardar).onClickListener = [ View v | guardar(v) ] as View.OnClickListener
		txTitulo.focusable = editable
		txAutor.focusable = editable
		val btnGuardar = rootView.findViewById(R.id.btnGuardar) as Button
		if (editable) {
			btnGuardar.visibility = View.VISIBLE 
		} else {
			btnGuardar.visibility = View.INVISIBLE
		}
		if (libro != null) {
			txTitulo.text = libro.titulo
			txAutor.text = libro.autor
		}
		rootView
	}	

	def txtTitulo() {
		view.findViewById(R.id.txtTitulo) as EditText
	}
	
	def txtAutor() {
		view.findViewById(R.id.txtAutor) as EditText
	}

	def void guardar(View view) {
		libro.titulo = txtTitulo.text.toString
		libro.autor = txtAutor.text.toString
		val homeLibros = activity.homeLibros
		if (actualiza) {
			homeLibros.removeLibro(posicion)
		} 
		homeLibros.addLibro(libro)
		activity.finish()
	}	

	def getArgument(String key) {
		arguments.containsKey(key) && arguments.getSerializable(key) != null
	}

}