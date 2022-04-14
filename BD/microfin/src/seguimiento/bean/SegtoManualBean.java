package seguimiento.bean;

import general.bean.BaseBean;

public class SegtoManualBean extends BaseBean{
	private String segtoPrograID;
	private String creditoID;
	private String grupoID;
	private String fechaProgramada;
	private String horaProgramada;
	private String categoriaID;
	private String puestoResponsableID;
	private String puestoSupervisorID;
	private String tipoGeneracion;
	private String secSegtoForzado;
	private String fechaRegistro;
	private String estatus;
	private String esForzado;
	private String fechaProxForzado;
	private String fechaInicioSegto;
	private String fechaFinalSegto;
	private String resultadoSegtoID;
	private String recomendacionSegtoID;
	
	private String nombreResponsable;
	
	private String nombreCliente;
	private String solCred;
	private String prodCred;
	private String descripcion;
	private String montoSoli;
	private String montoAutor;
	private String fechaSol;
	private String fechaDesem;
	private String estatusCred;
	private String saldoCapVig;
	private String diasFaltaPago;
	private String saldoCapAtrasa;
	private String saldoCapVencido;	
	private String alcance;	
	private String clienteIDPre;
	private String telefonoCasa;
	private String extTelefonoPart;
	private String telefonoCelular;
	
	
	public String getSegtoPrograID() {
		return segtoPrograID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getFechaProgramada() {
		return fechaProgramada;
	}
	public String getHoraProgramada() {
		return horaProgramada;
	}
	public String getCategoriaID() {
		return categoriaID;
	}
	public String getPuestoResponsableID() {
		return puestoResponsableID;
	}
	public String getPuestoSupervisorID() {
		return puestoSupervisorID;
	}
	public String getTipoGeneracion() {
		return tipoGeneracion;
	}
	public String getSecSegtoForzado() {
		return secSegtoForzado;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public String getFechaInicioSegto() {
		return fechaInicioSegto;
	}
	public String getFechaFinalSegto() {
		return fechaFinalSegto;
	}
	public String getResultadoSegtoID() {
		return resultadoSegtoID;
	}
	public String getRecomendacionSegtoID() {
		return recomendacionSegtoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getFechaProxForzado() {
		return fechaProxForzado;
	}
	public void setFechaProxForzado(String fechaProxForzado) {
		this.fechaProxForzado = fechaProxForzado;
	}
	public void setSegtoPrograID(String segtoPrograID) {
		this.segtoPrograID = segtoPrograID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setFechaProgramada(String fechaProgramada) {
		this.fechaProgramada = fechaProgramada;
	}
	public void setHoraProgramada(String horaProgramada) {
		this.horaProgramada = horaProgramada;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public void setPuestoResponsableID(String puestoResponsableID) {
		this.puestoResponsableID = puestoResponsableID;
	}
	public void setPuestoSupervisorID(String puestoSupervisorID) {
		this.puestoSupervisorID = puestoSupervisorID;
	}
	public void setTipoGeneracion(String tipoGeneracion) {
		this.tipoGeneracion = tipoGeneracion;
	}
	public void setSecSegtoForzado(String secSegtoForzado) {
		this.secSegtoForzado = secSegtoForzado;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public void setFechaInicioSegto(String fechaInicioSegto) {
		this.fechaInicioSegto = fechaInicioSegto;
	}
	public void setFechaFinalSegto(String fechaFinalSegto) {
		this.fechaFinalSegto = fechaFinalSegto;
	}
	public void setResultadoSegtoID(String resultadoSegtoID) {
		this.resultadoSegtoID = resultadoSegtoID;
	}
	public void setRecomendacionSegtoID(String recomendacionSegtoID) {
		this.recomendacionSegtoID = recomendacionSegtoID;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public String getSolCred() {
		return solCred;
	}
	public String getProdCred() {
		return prodCred;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getMontoSoli() {
		return montoSoli;
	}
	public String getMontoAutor() {
		return montoAutor;
	}
	public String getFechaSol() {
		return fechaSol;
	}
	public String getFechaDesem() {
		return fechaDesem;
	}
	public String getEstatusCred() {
		return estatusCred;
	}
	public String getSaldoCapVig() {
		return saldoCapVig;
	}
	public String getDiasFaltaPago() {
		return diasFaltaPago;
	}
	public String getSaldoCapAtrasa() {
		return saldoCapAtrasa;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public void setSolCred(String solCred) {
		this.solCred = solCred;
	}
	public void setProdCred(String prodCred) {
		this.prodCred = prodCred;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setMontoSoli(String montoSoli) {
		this.montoSoli = montoSoli;
	}
	public void setMontoAutor(String montoAutor) {
		this.montoAutor = montoAutor;
	}
	public void setFechaSol(String fechaSol) {
		this.fechaSol = fechaSol;
	}
	public void setFechaDesem(String fechaDesem) {
		this.fechaDesem = fechaDesem;
	}
	public void setEstatusCred(String estatusCred) {
		this.estatusCred = estatusCred;
	}
	public void setSaldoCapVig(String saldoCapVig) {
		this.saldoCapVig = saldoCapVig;
	}
	public void setDiasFaltaPago(String diasFaltaPago) {
		this.diasFaltaPago = diasFaltaPago;
	}
	public void setSaldoCapAtrasa(String saldoCapAtrasa) {
		this.saldoCapAtrasa = saldoCapAtrasa;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getEsForzado() {
		return esForzado;
	}
	public void setEsForzado(String esForzado) {
		this.esForzado = esForzado;
	}
	public String getNombreResponsable() {
		return nombreResponsable;
	}
	public void setNombreResponsable(String nombreResponsable) {
		this.nombreResponsable = nombreResponsable;
	}
	public String getAlcance() {
		return alcance;
	}
	public void setAlcance(String alcance) {
		this.alcance = alcance;
	}
	public String getClienteIDPre() {
		return clienteIDPre;
	}
	public void setClienteIDPre(String clienteIDPre) {
		this.clienteIDPre = clienteIDPre;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	
}