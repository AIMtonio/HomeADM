package cobranza.bean;

import general.bean.BaseBean;

public class LiberaCarteraBean extends BaseBean  {
	private String asignadoID;
	private String gestorID;
	private String estatusCredLib;
	private String diasAtrasoLib;
	private String saldoCapitalLib;
	private String nombreInstitucion;
	private String claveUsuario;
	private String fechaSis;
	private String tipoGestor;
	private String sucursalID;
	
	private String saldoInteresLib;
	private String saldoMoratorioLib;
	private String motivoLiberacion;
	private String liberado;	
	private String listaGridCredLib;
	
	private String usuarioLogeadoID;
	private String creditoID;
	private String nombreSucursal;
	private String nombreGestor;
	
	//Lista creditos grid 
	private String clienteID;
	private String nombreCompleto;
			
	private String estatusCred;
	private String diasAtraso;
	private String montoCredito;
	private String fechaDesembolso;
	private String fechaVencimien;
				
	private String fechaProxVencim;
	private String saldoCapital;
	private String saldoInteres;
	private String saldoMoratorio;
	private String asignado;
	
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
	public String getEstatusCredLib() {
		return estatusCredLib;
	}
	public void setEstatusCredLib(String estatusCredLib) {
		this.estatusCredLib = estatusCredLib;
	}
	public String getDiasAtrasoLib() {
		return diasAtrasoLib;
	}
	public void setDiasAtrasoLib(String diasAtrasoLib) {
		this.diasAtrasoLib = diasAtrasoLib;
	}
	public String getSaldoCapitalLib() {
		return saldoCapitalLib;
	}
	public void setSaldoCapitalLib(String saldoCapitalLib) {
		this.saldoCapitalLib = saldoCapitalLib;
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
	public String getFechaSis() {
		return fechaSis;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getSaldoInteresLib() {
		return saldoInteresLib;
	}
	public void setSaldoInteresLib(String saldoInteresLib) {
		this.saldoInteresLib = saldoInteresLib;
	}
	public String getSaldoMoratorioLib() {
		return saldoMoratorioLib;
	}
	public void setSaldoMoratorioLib(String saldoMoratorioLib) {
		this.saldoMoratorioLib = saldoMoratorioLib;
	}
	public String getMotivoLiberacion() {
		return motivoLiberacion;
	}
	public void setMotivoLiberacion(String motivoLiberacion) {
		this.motivoLiberacion = motivoLiberacion;
	}
	public String getLiberado() {
		return liberado;
	}
	public void setLiberado(String liberado) {
		this.liberado = liberado;
	}
	public String getListaGridCredLib() {
		return listaGridCredLib;
	}
	public void setListaGridCredLib(String listaGridCredLib) {
		this.listaGridCredLib = listaGridCredLib;
	}
	public String getUsuarioLogeadoID() {
		return usuarioLogeadoID;
	}
	public void setUsuarioLogeadoID(String usuarioLogeadoID) {
		this.usuarioLogeadoID = usuarioLogeadoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreGestor() {
		return nombreGestor;
	}
	public void setNombreGestor(String nombreGestor) {
		this.nombreGestor = nombreGestor;
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
	
	
}
