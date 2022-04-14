package fondeador.bean;

import general.bean.BaseBean;

public class CondicionesDesctoCteLinFonBean extends BaseBean { 
	// tabla LINFONCONDCTE
	
	private String lineaFondeoIDCte;
	private String sexo;
	private String estadoCivil;
	private String montoMinimo;
	private String montoMaximo;
	private String monedaID;
	private String diasGraIngCre;
	private String productosCre;
	private String maxDiasMora;
	private String clasificacion;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	public String getLineaFondeoIDCte() {
		return lineaFondeoIDCte;
	}
	public void setLineaFondeoIDCte(String lineaFondeoIDCte) {
		this.lineaFondeoIDCte = lineaFondeoIDCte;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getMontoMinimo() {
		return montoMinimo;
	}
	public void setMontoMinimo(String montoMinimo) {
		this.montoMinimo = montoMinimo;
	}
	public String getMontoMaximo() {
		return montoMaximo;
	}
	public void setMontoMaximo(String montoMaximo) {
		this.montoMaximo = montoMaximo;
	}
	public String getProductosCre() {
		return productosCre;
	}
	public void setProductosCre(String productosCre) {
		this.productosCre = productosCre;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getDiasGraIngCre() {
		return diasGraIngCre;
	}
	public void setDiasGraIngCre(String diasGraIngCre) {
		this.diasGraIngCre = diasGraIngCre;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getMaxDiasMora() {
		return maxDiasMora;
	}
	public void setMaxDiasMora(String maxDiasMora) {
		this.maxDiasMora = maxDiasMora;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
}
