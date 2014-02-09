package ar.edu.paiu.ui

import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import ar.edu.librex.domain.Libro
import ar.edu.librex.persistence.MemoryBasedHomeLibros
import android.util.Log

/**
 * A fragment representing a single Libro detail screen. This fragment is either
 * contained in a {@link LibroListActivity} in two-pane mode (on tablets) or a
 * {@link LibroDetailActivity} on handsets.
 */
class LibroDetailFragment extends Fragment {
	/**
	 * The fragment argument representing the item ID that this fragment
	 * represents.
	 */
	public static final String ARG_ITEM_ID = "item_id"

	/**
	 * The dummy content this fragment is presenting.
	 */
	private Libro libro

	/**
	 * Mandatory empty constructor for the fragment manager to instantiate the
	 * fragment (e.g. upon screen orientation changes).
	 */
	new() {
		
	}

	override onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)

		if (getArguments().containsKey(ARG_ITEM_ID)) {
			// Load the dummy content specified by the fragment
			// arguments. In a real-world scenario, use a Loader
			// to load content from a content provider.
			// TODO: Hay que ver qué recibimos
			val libroPosicion = Integer.parseInt(arguments.getString(ARG_ITEM_ID))
			Log.w("Librex", "Arg Item Id: " + libroPosicion)
			libro = MemoryBasedHomeLibros.instance.getLibro(libroPosicion)
		}
	}

	override onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		val rootView = inflater.inflate(R.layout.fragment_libro_detail,	container, false)
		if (libro != null) {
			((rootView.findViewById(R.id.txtTitulo) as TextView)).text = libro.getTitulo()
			((rootView.findViewById(R.id.txtAutor) as TextView)).text = libro.autor
		}
		rootView
	}	
	
}