package ar.edu.librex.persistence

import android.app.Activity
import android.content.ContentProviderOperation
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.ContactsContract
import android.provider.ContactsContract.PhoneLookup
import android.util.Log
import ar.edu.librex.domain.Contacto
import java.io.ByteArrayOutputStream
import java.util.ArrayList
import java.util.List

class HomeContactos {

	/**
	 * actividad (página) madre que permite hacer consultas sobre los contactos
	 */
	@Property Activity parentActivity

	new(Activity parent) {
		parentActivity = parent
	}

	/**
	 * Incorporamos un nuevo contacto a la lista del dispositivo sólo si no existe el número
	 */
	def void addContactoSiNoExiste(Contacto contacto) {
		if (this.getContacto(contacto) == null) {
			Log.w("librex", "No existe contacto " + contacto + ".Se crea")
			this.addContacto(contacto)
		} else {
			Log.w("librex", "Ya existe contacto " + contacto + ".")
		}
	}
	 
	/**
	 * Incorporamos un nuevo contacto a la lista que guarda el dispositivo.
	 * El método tiene efecto. 
	 */
	def void addContacto(Contacto contacto) {
		val String tipoCuenta = null
		val String nombreCuenta = null

		/**
		 * INSERT DE A UNO 
		val newContact = new ContentValues
		newContact.put(RawContacts.ACCOUNT_TYPE, tipoCuenta)
		newContact.put(RawContacts.ACCOUNT_NAME, nombreCuenta)
		val uriContactId = parentActivity.contentResolver.insert(RawContacts.CONTENT_URI, newContact)
		val contactId = ContentUris.parseId(uriContactId)
		newContact.clear
		newContact.put(ContactsContract.Data.RAW_CONTACT_ID, contactId)
		newContact.put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
		//newContact.put(StructuredName.DISPLAY_NAME, contacto.nombre)
		newContact.put(ContactsContract.CommonDataKinds.Phone.LABEL, contacto.nombre)
		newContact.put(ContactsContract.CommonDataKinds.Phone.NUMBER, contacto.numero)
		newContact.put(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME)
		parentActivity.contentResolver.insert(ContactsContract.Data.CONTENT_URI, newContact)
		**/
		/** O CON BUILDERS */
		val comandosAgregar = new ArrayList<ContentProviderOperation>
		comandosAgregar.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
			.withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, tipoCuenta)
			.withValue(ContactsContract.RawContacts.ACCOUNT_NAME, nombreCuenta)
			.build
		)
		comandosAgregar.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, 0)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, contacto.nombre)
			.build	
		)
		comandosAgregar.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, 0)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, contacto.numero)
			.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME)
			.build	
		)
		comandosAgregar.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, 0)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.Email.ADDRESS, contacto.email)
			.build	
		)
		val inputFoto = parentActivity.assets.open(contacto.foto)
		val bmpFoto = BitmapFactory.decodeStream(inputFoto)
		Log.w("librex", "bmpFoto: " + bmpFoto)
		val foto = new ByteArrayOutputStream
		bmpFoto.compress(Bitmap.CompressFormat.PNG, 100, foto)
		comandosAgregar.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, 0)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.Photo.PHOTO, foto.toByteArray)
			.build	
		)
		parentActivity.contentResolver.applyBatch(ContactsContract.AUTHORITY, comandosAgregar)
	}

	/**
	 * Permite obtener toda la lista de contactos
	 */
	def List<Contacto> getContactos() {
		var cursorContactos = parentActivity.contentResolver.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null)
		if (cursorContactos == null || cursorContactos.count < 1) {
			return null
		}
		
		val contactos = new ArrayList<Contacto>
		cursorContactos.moveToFirst
		while (!cursorContactos.afterLast) {
			contactos.add(this.crearContacto(cursorContactos))
			cursorContactos.moveToNext
		}
		
		cursorContactos.close
		cursorContactos = null
		
		contactos		
	}
	
	/**
	 * Obtiene los datos de un contacto por número de teléfono o nombre.
	 */
	def Contacto getContacto(Contacto contactoOrigen) {
		// si queremos buscar por nombre
		//var cursorContactos = parentActivity.contentResolver.query(ContactsContract.Contacts.CONTENT_URI, null, ContactsContract.Data.DISPLAY_NAME + " = ?", #[contactoOrigen.nombre], null)
		var Uri lookupUri = null
		if (contactoOrigen.numero != null) {
			lookupUri = Uri.withAppendedPath(PhoneLookup.CONTENT_FILTER_URI, Uri.encode(contactoOrigen.numero))
		} else {
			lookupUri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_FILTER_URI, contactoOrigen.nombre)
		}
			
		var cursorContactos = parentActivity.contentResolver.query(lookupUri, null, null, null, null)
		if (cursorContactos == null || cursorContactos.count < 1) {
			Log.w("librex", "No encontrado")
			return null
		}
		
		cursorContactos.moveToFirst
		val contacto = this.crearContacto(cursorContactos)
		cursorContactos.close
		cursorContactos = null
		contacto
	}
	
	/**
	 * Elimina todos los contactos del dispositivo. 
	 * PRECAUCION: utilizar con cuidado porque tiene efecto (colateral)
	 */
	def eliminarContactos() {
		val contentResolver = parentActivity.contentResolver
		val cursor = contentResolver.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null)
		while (cursor.moveToNext) {
			val clave = cursor.getDataAsString(ContactsContract.Contacts.LOOKUP_KEY)
			val uri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_LOOKUP_URI, clave)
			contentResolver.delete(uri, null, null)
		}		
	}

	/**
	 * ***********************************************************************
	 *     					METODOS INTERNOS
	 * ***********************************************************************
	 */
	/**
	 * Extension method
	 * 
	 * Facilita traer el dato de un cursor como un String
	 */
	private def String getDataAsString(Cursor cursor, String index) {
		cursor.getString(cursor.getColumnIndex(index))
	}

	/**
	 * Método de uso interno.
	 * Permite generar un objeto de dominio Contacto a partir de un cursor de ContactsContract.Contacts,
	 * la API estándar de Android para manejar contactos del dispositivo.
	 */
	private def Contacto crearContacto(Cursor cursorContactos) {
		val contactId = getDataAsString(cursorContactos, ContactsContract.Contacts._ID)
		val contactName = getDataAsString(cursorContactos, ContactsContract.Contacts.DISPLAY_NAME)
		var String contactNumber = null
		var String foto = null
		var email = "" // TODO: Agregarlo
		if (cursorContactos.getDataAsString(ContactsContract.Contacts.HAS_PHONE_NUMBER).equals("1")) {
			val cursorTelefono = parentActivity.contentResolver.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?", #[contactId], null)
			while (cursorTelefono.moveToNext) {
				contactNumber = cursorTelefono.getDataAsString(ContactsContract.CommonDataKinds.Phone.NUMBER)
				foto = getDataAsString(cursorTelefono, ContactsContract.CommonDataKinds.Phone.PHOTO_URI)
			}
		}
		new Contacto(contactId, contactNumber, contactName, email, foto)
	}
	
}
