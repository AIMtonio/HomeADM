package general.bean;

public class MensajeTransaccionArchivoBean {
	
	private int numero;
	private String descripcion;
	private String nombreControl;
	private String recursoOrigen;
	private String consecutivoString;
	private String consecutivoInt;
	private String campoGenerico;  // Campo generico auxiliar para recuperar algun valor en el controlador que no formo poarte de la respuesta de un store 
	
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
	public String getRecursoOrigen() {
		return recursoOrigen;
	}
	public void setRecursoOrigen(String recursoOrigen) {
		this.recursoOrigen = recursoOrigen;
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
	public String getCampoGenerico() {
		return campoGenerico;
	}
	public void setCampoGenerico(String campoGenerico) {
		this.campoGenerico = campoGenerico;
	}
	
	
}
