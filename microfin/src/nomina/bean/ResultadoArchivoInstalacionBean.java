package nomina.bean;

public class ResultadoArchivoInstalacionBean {
	public int exitosos=0;
	public int fallidos=0;
	private int numero;
	private String descripcion;
	private String nombreControl;
	private String consecutivoString;
	private String consecutivoInt;
	private String ruta;
	
	public int getExitosos() {
		return exitosos;
	}
	public void setExitosos(int exitosos) {
		this.exitosos = exitosos;
	}
	public int getFallidos() {
		return fallidos;
	}
	public void setFallidos(int fallidos) {
		this.fallidos = fallidos;
	}
	public int getNumero() {
		return numero;
	}
	public void setNumero(int numero) {
		this.numero = numero;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombreControl() {
		return nombreControl;
	}
	public void setNombreControl(String nombreControl) {
		this.nombreControl = nombreControl;
	}
	public String getConsecutivoString() {
		return consecutivoString;
	}
	public void setConsecutivoString(String consecutivoString) {
		this.consecutivoString = consecutivoString;
	}
	public String getConsecutivoInt() {
		return consecutivoInt;
	}
	public void setConsecutivoInt(String consecutivoInt) {
		this.consecutivoInt = consecutivoInt;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	
}
