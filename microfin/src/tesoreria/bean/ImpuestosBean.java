package tesoreria.bean;

import general.bean.BaseBean;

public class ImpuestosBean extends BaseBean{
	
	private String impuestoID; 
	private String descripcion; 
	private String descripCorta; 
	private String tasa; 
	private String gravaRetiene; 
	private String baseCalculo;
	private String impuestoCalculo;
	private String ctaEnTransito; 
	private String ctaRealizado; 
	private int numImpuestos;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	
	public String getImpuestoID() {
		return impuestoID;
	}
	public void setImpuestoID(String impuestoID) {
		this.impuestoID = impuestoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripCorta() {
		return descripCorta;
	}
	public void setDescripCorta(String descripCorta) {
		this.descripCorta = descripCorta;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getGravaRetiene() {
		return gravaRetiene;
	}
	public void setGravaRetiene(String gravaRetiene) {
		this.gravaRetiene = gravaRetiene;
	}
	public String getBaseCalculo() {
		return baseCalculo;
	}
	public void setBaseCalculo(String baseCalculo) {
		this.baseCalculo = baseCalculo;
	}
	public String getImpuestoCalculo() {
		return impuestoCalculo;
	}
	public void setImpuestoCalculo(String impuestoCalculo) {
		this.impuestoCalculo = impuestoCalculo;
	}
	public String getCtaEnTransito() {
		return ctaEnTransito;
	}
	public void setCtaEnTransito(String ctaEnTransito) {
		this.ctaEnTransito = ctaEnTransito;
	}
	public String getCtaRealizado() {
		return ctaRealizado;
	}
	public void setCtaRealizado(String ctaRealizado) {
		this.ctaRealizado = ctaRealizado;
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
	public int getNumImpuestos() {
		return numImpuestos;
	}
	public void setNumImpuestos(int numImpuestos) {
		this.numImpuestos = numImpuestos;
	}

	
	

}
