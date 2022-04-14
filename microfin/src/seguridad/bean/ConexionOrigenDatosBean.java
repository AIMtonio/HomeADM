package seguridad.bean;

import java.util.HashMap;

public class ConexionOrigenDatosBean {

	//Mapa con Todos los Posibles Origenes de Datos de la Aplicacion
	HashMap origenDatosMapa = new HashMap();
	
	//Mapa para el manejo de Transacciones de Todos los Origenes de Datos
	HashMap manejadorTransaccionesMapa = new HashMap();
	
	
	public HashMap getOrigenDatosMapa() {
		return origenDatosMapa;
	}
	public void setOrigenDatosMapa(HashMap origenDatosMapa) {
		this.origenDatosMapa = origenDatosMapa;
	}
	public HashMap getManejadorTransaccionesMapa() {
		return manejadorTransaccionesMapa;
	}
	public void setManejadorTransaccionesMapa(HashMap manejadorTransaccionesMapa) {
		this.manejadorTransaccionesMapa = manejadorTransaccionesMapa;
	}

	
}
