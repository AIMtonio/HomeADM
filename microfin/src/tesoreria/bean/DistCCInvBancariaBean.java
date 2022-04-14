package tesoreria.bean;

import general.bean.BaseBean;

public class DistCCInvBancariaBean extends BaseBean {
	private String inversionID;
    private String centroCosto;
    private String nombre_centroCosto;
    private String monto;
    private String interesGenerado;
    private String iSR;
    private String totalRecibir;
    private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	// Atributos por parte de la inversion bancaria
	private String montoOriginalInv;
	private String tipoInversion;
	private String monedaID;
	private String institucionID;
	private String fechaInicio;
	private String numCtaInstit;
	private String polizaID;
	public final String ConceptoInvBan="1";
	public final String ConceptoInvBanReporto="5";
	public final String ConceptoContable="73";
	public final String tipoMovimientoTesoreria="7";
	public final String naturalezaCargo="C";
	public final String alta_poliza_no="N";
	public final String descripcionContable="REGISTRO DE INV.BANCARIA";
	public final String descripcionMovimiento="CARGO PARA INV.BANCARIA";
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	public String getCentroCosto() {
		return centroCosto;
	}
	public void setCentroCosto(String centroCosto) {
		this.centroCosto = centroCosto;
	}
	public String getNombre_centroCosto() {
		return nombre_centroCosto;
	}
	public void setNombre_centroCosto(String nombre_centroCosto) {
		this.nombre_centroCosto = nombre_centroCosto;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}
	public String getiSR() {
		return iSR;
	}
	public void setiSR(String iSR) {
		this.iSR = iSR;
	}
	public String getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
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
	public String getMontoOriginalInv() {
		return montoOriginalInv;
	}
	public void setMontoOriginalInv(String montoOriginalInv) {
		this.montoOriginalInv = montoOriginalInv;
	}
	public String getTipoInversion() {
		return tipoInversion;
	}
	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}

}
