package soporte.bean;

import general.bean.BaseBean;

public class ParametrosYangaBean extends BaseBean {

	/*Declaracion de atributos */

	private String programaID;
	private String ctaProtecCre;
	private String ctaProtecCta;
	private String haberExSocios;
	private String ctaContaPROFUN;
	private String tipoCtaProtec;
	private String montoMaxProtec;
	private String montoPROFUN;
	private String aporteMaxPROFUN;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;	
	private String sucursal;
	private String numTransaccion;



	/* ============ SETTER's Y GETTER's =============== */

	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}	
	
	public String getCtaProtecCre() {
		return ctaProtecCre;
	}
	public void setCtaProtecCre(String ctaProtecCre) {
		this.ctaProtecCre = ctaProtecCre;
	}

	public String getCtaProtecCta() {
		return ctaProtecCta;
	}
	public void setCtaProtecCta(String ctaProtecCta) {
		this.ctaProtecCta = ctaProtecCta;
	}

	public String getHaberExSocios() {
		return haberExSocios;
	}
	public void setHaberExSocios(String haberExSocios) {
		this.haberExSocios = haberExSocios;
	}

	public String getCtaContaPROFUN() {
		return ctaContaPROFUN;
	}
	public void setCtaContaPROFUN(String ctaContaPROFUN) {
		this.ctaContaPROFUN = ctaContaPROFUN;
	}
	
	public String getTipoCtaProtec() {
		return tipoCtaProtec;
	}
	public void setTipoCtaProtec(String tipoCtaProtec) {
		this.tipoCtaProtec = tipoCtaProtec;
	}
	
	public String getMontoMaxProtec() {
		return montoMaxProtec;
	}
	public void setMontoMaxProtec(String montoMaxProtec) {
		this.montoMaxProtec = montoMaxProtec;
	}
	
	public String getMontoPROFUN() {
		return montoPROFUN;
	}
	public void setMontoPROFUN(String montoPROFUN) {
		this.montoPROFUN = montoPROFUN;
	}
	
	public String getAporteMaxPROFUN() {
		return aporteMaxPROFUN;
	}
	public void setAporteMaxPROFUN(String aporteMaxPROFUN) {
		this.aporteMaxPROFUN = aporteMaxPROFUN;
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