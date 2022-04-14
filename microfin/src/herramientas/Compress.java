package herramientas;

import java.io.File;
import java.util.ArrayList;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

public class Compress {
	
	public void comprimir(String pathZipDestino,String contrasenia, String... files) throws ZipException{
	
		ZipFile zipFile = new ZipFile(pathZipDestino);
		ArrayList<File> filesToAdd = null;
		ZipParameters parameters = null;
		
		if(files == null){
			throw new ZipException("LA LISTA DE ARCHIVS A COMPRIMIR ES NULA");
		}
		if(files.length == 0){
			throw new ZipException("LA LISTA DE ARCHIVOS ESTA VACIA");
		}
		
		filesToAdd = new ArrayList<File>();
		for(String file:files){
			filesToAdd.add(new File(file));
		}
		
		parameters = new ZipParameters();
		parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE); // set compression method to deflate compression
		parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL);
		parameters.setEncryptFiles(true);
		parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);
		parameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
		parameters.setPassword(contrasenia);
		zipFile.addFiles(filesToAdd, parameters);
		
		zipFile.addFiles(filesToAdd, parameters);
		zipFile= null;
		filesToAdd = null;
		parameters = null;
		
	}
	
}
