package contabilidad.bean;

public class TipoInstrumentosBean {
	
	private String tipoInstrumentoID;
	private String tipoInstrumento;
	private String primerRango;
	private String segundoRango;
	private String descripcion;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;	
	
	
	
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getPrimerRango() {
		return primerRango;
	}
	public void setPrimerRango(String primerRango) {
		this.primerRango = primerRango;
	}
	public String getSegundoRango() {
		return segundoRango;
	}
	public void setSegundoRango(String segundoRango) {
		this.segundoRango = segundoRango;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}	
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	

}
