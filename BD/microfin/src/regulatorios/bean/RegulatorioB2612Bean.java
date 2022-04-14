package regulatorios.bean;

import general.bean.BaseBean;

public class RegulatorioB2612Bean extends BaseBean{
	
	private String anio;
	private String mes;
	private String periodo;
	private String claveEntidad;
	private String numReporte;
	private String numSecuencia;
	private String idenComisionista;
	private String rFCCOmisionista;
	private String tipoMovimiento;
	private String claveModulo;
	private String localidadModulo;
	private String causaBajaModulo;
	private String municipio;
	private String estado;

	private String valor;


	 
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getNumReporte() {
		return numReporte;
	}
	public void setNumReporte(String numReporte) {
		this.numReporte = numReporte;
	}
	public String getNumSecuencia() {
		return numSecuencia;
	}
	public void setNumSecuencia(String numSecuencia) {
		this.numSecuencia = numSecuencia;
	}
	public String getIdenComisionista() {
		return idenComisionista;
	}
	public void setIdenComisionista(String idenComisionista) {
		this.idenComisionista = idenComisionista;
	}
	public String getrFCCOmisionista() {
		return rFCCOmisionista;
	}
	public void setrFCCOmisionista(String rFCCOmisionista) {
		this.rFCCOmisionista = rFCCOmisionista;
	}
	public String getTipoMovimiento() {
		return tipoMovimiento;
	}
	public void setTipoMovimiento(String tipoMovimiento) {
		this.tipoMovimiento = tipoMovimiento;
	}
	public String getClaveModulo() {
		return claveModulo;
	}
	public void setClaveModulo(String claveModulo) {
		this.claveModulo = claveModulo;
	}
	public String getLocalidadModulo() {
		return localidadModulo;
	}
	public void setLocalidadModulo(String localidadModulo) {
		this.localidadModulo = localidadModulo;
	}
	public String getCausaBajaModulo() {
		return causaBajaModulo;
	}
	public void setCausaBajaModulo(String causaBajaModulo) {
		this.causaBajaModulo = causaBajaModulo;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
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

	
}
