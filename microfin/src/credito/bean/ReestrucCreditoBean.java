package credito.bean;

import general.bean.BaseBean;

public class ReestrucCreditoBean extends BaseBean {	
	//Atributos
	private String fechaRegistro;
	private String usuarioID;
	private String creditoOrigenID;
	private String creditoDestinoID;
	private String saldoCredAnteri;
	private String estatusCredAnt;
	private String estatusCreacion;
	private String numDiasAtraOri;
	private String numPagoSoste;
	private String numPagoActual;
	private String regularizado;
	private String fechaRegula;
	private String numeroReest;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	//variables para el reporte
	private String EstadoID;
	private String fechaInicio;
	private String fechaVencimien;
	private String monedaID;
	private String producCreditoID;
	private String municipioID;
	private String nomInstitucion;
	private String nomUsuario;
	private String nomMunicipio;
	private String nomEstado;
	private String nomProductoCreOrig;
	private String nomMoneda;
	private String nomSucursal;
	private String productoCreOrig;
	private String nivelDetalle;
	private String fechaEmision;
	private String nomProductoCreDest;
	private String productoCreDest;
	private String nomUsuarioReest;
			
	
	public String getNomInstitucion() {
		return nomInstitucion;
	}
	public void setNomInstitucion(String nomInstitucion) {
		this.nomInstitucion = nomInstitucion;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public String getNomMunicipio() {
		return nomMunicipio;
	}
	public void setNomMunicipio(String nomMunicipio) {
		this.nomMunicipio = nomMunicipio;
	}
	public String getNomEstado() {
		return nomEstado;
	}
	public void setNomEstado(String nomEstado) {
		this.nomEstado = nomEstado;
	}
	public String getNomProductoCreOrig() {
		return nomProductoCreOrig;
	}
	public void setNomProductoCreOrig(String nomProductoCreOrig) {
		this.nomProductoCreOrig = nomProductoCreOrig;
	}
	public String getNomMoneda() {
		return nomMoneda;
	}
	public void setNomMoneda(String nomMoneda) {
		this.nomMoneda = nomMoneda;
	}
	public String getNomSucursal() {
		return nomSucursal;
	}
	public void setNomSucursal(String nomSucursal) {
		this.nomSucursal = nomSucursal;
	}
	public String getProductoCreOrig() {
		return productoCreOrig;
	}
	public void setProductoCreOrig(String productoCreOrig) {
		this.productoCreOrig = productoCreOrig;
	}
	public String getNivelDetalle() {
		return nivelDetalle;
	}
	public void setNivelDetalle(String nivelDetalle) {
		this.nivelDetalle = nivelDetalle;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNomProductoCreDest() {
		return nomProductoCreDest;
	}
	public void setNomProductoCreDest(String nomProductoCreDest) {
		this.nomProductoCreDest = nomProductoCreDest;
	}
	public String getProductoCreDest() {
		return productoCreDest;
	}
	public void setProductoCreDest(String productoCreDest) {
		this.productoCreDest = productoCreDest;
	}
	public String getNomUsuarioReest() {
		return nomUsuarioReest;
	}
	public void setNomUsuarioReest(String nomUsuarioReest) {
		this.nomUsuarioReest = nomUsuarioReest;
	}
	public String getEstadoID() {
		return EstadoID;
	}
	public void setEstadoID(String estadoID) {
		EstadoID = estadoID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getCreditoOrigenID() {
		return creditoOrigenID;
	}
	public void setCreditoOrigenID(String creditoOrigenID) {
		this.creditoOrigenID = creditoOrigenID;
	}
	public String getCreditoDestinoID() {
		return creditoDestinoID;
	}
	public void setCreditoDestinoID(String creditoDestinoID) {
		this.creditoDestinoID = creditoDestinoID;
	}
	public String getSaldoCredAnteri() {
		return saldoCredAnteri;
	}
	public void setSaldoCredAnteri(String saldoCredAnteri) {
		this.saldoCredAnteri = saldoCredAnteri;
	}
	public String getEstatusCredAnt() {
		return estatusCredAnt;
	}
	public void setEstatusCredAnt(String estatusCredAnt) {
		this.estatusCredAnt = estatusCredAnt;
	}
	public String getEstatusCreacion() {
		return estatusCreacion;
	}
	public void setEstatusCreacion(String estatusCreacion) {
		this.estatusCreacion = estatusCreacion;
	}
	public String getNumDiasAtraOri() {
		return numDiasAtraOri;
	}
	public void setNumDiasAtraOri(String numDiasAtraOri) {
		this.numDiasAtraOri = numDiasAtraOri;
	}
	public String getNumPagoSoste() {
		return numPagoSoste;
	}
	public void setNumPagoSoste(String numPagoSoste) {
		this.numPagoSoste = numPagoSoste;
	}
	public String getNumPagoActual() {
		return numPagoActual;
	}
	public void setNumPagoActual(String numPagoActual) {
		this.numPagoActual = numPagoActual;
	}
	public String getRegularizado() {
		return regularizado;
	}
	public void setRegularizado(String regularizado) {
		this.regularizado = regularizado;
	}
	public String getFechaRegula() {
		return fechaRegula;
	}
	public void setFechaRegula(String fechaRegula) {
		this.fechaRegula = fechaRegula;
	}
	public String getNumeroReest() {
		return numeroReest;
	}
	public void setNumeroReest(String numeroReest) {
		this.numeroReest = numeroReest;
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