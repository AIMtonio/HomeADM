package psl.rest;

public enum MetodoHTTP {
	POST("POST"), GET("GET"), PUT("PUT");
	
	private String nombre;
	
	MetodoHTTP(String nombre) {
		this.nombre = nombre; 
	}
	
	public String getNombre() {
		return nombre;
	}
}
