package reporte;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class ParametrosReporte {
		
	HashMap parametros;
	
	public ParametrosReporte() {
		super();
		// TODO Auto-generated constructor stub
		parametros = new HashMap(); 
	}
	
	public void agregaParametro(String nombre, String valor) throws UnsupportedEncodingException{
		if (valor !=null){
		byte[] bytes = valor.getBytes("ISO-8859-1");
		valor = new String(bytes, "UTF-8");
		}
		parametros.put(nombre, valor);
	}

	public void agregaParametro(String nombre, int valor){
		parametros.put(nombre, valor);
	}

	public void agregaParametro(String nombre, long valor){
		parametros.put(nombre, valor);
	}

	public void agregaParametro(String nombre, Date valor){
		parametros.put(nombre, valor);
	}
	
	public void agregaParametro(String nombre, float valor){
		parametros.put(nombre, valor);
	}
	public void agregaParametro(String nombre, double valor){
		parametros.put(nombre, valor);
	}
	
	
	public HashMap getParametros() {
		return parametros;
	}
	
	
}

