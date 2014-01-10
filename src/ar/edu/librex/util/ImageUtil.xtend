package ar.edu.librex.util

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.ContactsContract
import java.io.BufferedInputStream
import java.io.ByteArrayOutputStream
import java.io.InputStream

class ImageUtil {

	/**
	 * Si la imagen es de un proyecto debe estar en el directorio assets (o bien un directorio ubicable)
	 */
	def static byte[] convertToImage(Activity activity, String path) {
		val inputFoto = activity.assets.open(path)
		convertToByteArray(inputFoto)
	}
	
	def static convertToByteArray(InputStream inputFoto) {
		val bmpFoto = BitmapFactory.decodeStream(inputFoto)
		val foto = new ByteArrayOutputStream
		bmpFoto.compress(Bitmap.CompressFormat.PNG, 100, foto)
		foto.toByteArray
	}	

	/**
	 * Si la imagen es de un proyecto debe estar en el directorio assets (o bien un directorio ubicable)
	 */
	def static byte[] convertToImage(Activity activity, Uri uri) {
		val fotoStream = ContactsContract.Contacts.openContactPhotoInputStream(activity.contentResolver, uri)
		val inputFoto = new BufferedInputStream(fotoStream)
		convertToByteArray(inputFoto)
	}	
	
}