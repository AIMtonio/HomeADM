package cobranza.bean;

import general.bean.BaseBean;

import java.util.List;

public class AsignaCarteraBean extends BaseBean {
	private String asignadoID;
	private String gestorID;
	private String diasAtrasoMin;
	private String diasAtrasoMax;
	private String adeudoMin;
	
	private String adeudoMax;
	private String estatusCreditos;		// Lista del campo multiple de los estatus del credito	
	private String sucursalID;
	private String estadoID;
	private String municipioID;
	
	private String localidadID;
	private String coloniaID;
	private String limiteRenglones;
	
	//Lista creditos grid 
	private String clienteID;
	private String nombreCompleto;
	private String nombreSucursal;
	private String creditoID;
			
	private String estatusCred;			// Estatus de un credito
	private String diasAtraso;
	private String montoCredito;
	private String fechaDesembolso;
	private String fechaVencimien;
			
	private String fechaProxVencim;
	private String saldoCapital;
	private String saldoInteres;
	private String saldoMoratorio;
	private String asignado;
	private String nombreInstitucion;
	private String claveUsuario;
	private String tipoGestor;
	private String nombreGestor;
	
	private String listaGridCreditos;
	private String porcentajeComision;
	private String tipoAsigCobranzaID;
	
	private String fechaSis;
	private String usuarioLogeadoID;
	private String fechaAsig;
	
	public String getDiasAtrasoMin() {
		return diasAtrasoMin;
	}
	public void setDiasAtrasoMin(String diasAtrasoMin) {
		this.diasAtrasoMin = diasAtrasoMin;
	}
	public String getDiasAtrasoMax() {
		return diasAtrasoMax;
	}
	public void setDiasAtrasoMax(String diasAtrasoMax) {
		this.diasAtrasoMax = diasAtrasoMax;
	}
	public String getAdeudoMin() {
		return adeudoMin;
	}
	public void setAdeudoMin(String adeudoMin) {
		this.adeudoMin = adeudoMin;
	}
	public String getAdeudoMax() {
		return adeudoMax;
	}
	public void setAdeudoMax(String adeudoMax) {
		this.adeudoMax = adeudoMax;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getLimiteRenglones() {
		return limiteRenglones;
	}
	public void setLimiteRenglones(String limiteRenglones) {
		this.limiteRenglones = limiteRenglones;
	}
	public String getAsignadoID() {
		return asignadoID;
	}
	public void setAsignadoID(String asignadoID) {
		this.asignadoID = asignadoID;
	}
	public String getGestorID() {
		return gestorID;
	}
	public void setGestorID(String gestorID) {
		this.gestorID = gestorID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getEstatusCred() {
		return estatusCred;
	}
	public void setEstatusCred(String estatusCred) {
		this.estatusCred = estatusCred;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getFechaDesembolso() {
		return fechaDesembolso;
	}
	public void setFechaDesembolso(String fechaDesembolso) {
		this.fechaDesembolso = fechaDesembolso;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getFechaProxVencim() {
		return fechaProxVencim;
	}
	public void setFechaProxVencim(String fechaProxVencim) {
		this.fechaProxVencim = fechaProxVencim;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public String getSaldoMoratorio() {
		return saldoMoratorio;
	}
	public void setSaldoMoratorio(String saldoMoratorio) {
		this.saldoMoratorio = saldoMoratorio;
	}
	public String getAsignado() {
		return asignado;
	}
	public void setAsignado(String asignado) {
		this.asignado = asignado;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getNombreGestor() {
		return nombreGestor;
	}
	public void setNombreGestor(String nombreGestor) {
		this.nombreGestor = nombreGestor;
	}

	public String getListaGridCreditos() {
		return listaGridCreditos;
	}
	public void setListaGridCreditos(String listaGridCreditos) {
		this.listaGridCreditos = listaGridCreditos;
	}
	public String getPorcentajeComision() {
		return porcentajeComision;
	}
	public void setPorcentajeComision(String porcentajeComision) {
		this.porcentajeComision = porcentajeComision;
	}
	public String getTipoAsigCobranzaID() {
		return tipoAsigCobranzaID;
	}
	public void setTipoAsigCobranzaID(String tipoAsigCobranzaID) {
		this.tipoAsigCobranzaID = tipoAsigCobranzaID;
	}
	public String getFechaSis() {
		return fechaSis;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public String getUsuarioLogeadoID() {
		return usuarioLogeadoID;
	}
	public void setUsuarioLogeadoID(String usuarioLogeadoID) {
		this.usuarioLogeadoID = usuarioLogeadoID;
	}
	public String getEstatusCreditos() {
		return estatusCreditos;
	}
	public void setEstatusCreditos(String estatusCreditos) {
		this.estatusCreditos = estatusCreditos;
	}
	public String getFechaAsig() {
		return fechaAsig;
	}
	public void setFechaAsig(String fechaAsig) {
		this.fechaAsig = fechaAsig;
	}
	
}
