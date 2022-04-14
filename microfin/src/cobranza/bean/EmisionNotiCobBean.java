package cobranza.bean;

import general.bean.BaseBean;
import java.util.List;

public class EmisionNotiCobBean extends BaseBean {
	private String sucursalID;
	private String estCredBusq;
	private String estadoID;
	private String diasAtrasoIni;
	private String municipioID;
	private String diasAtrasoFin;
	
	private String localidadID;
	private String limiteRenglones;
	private String coloniaID;
	private String fechaSis;
	private String usuarioID;
	private String claveUsuario;
	private String sucursalUsuID;
	
	private List lisCreditoID;
	private List lisFechaCita;
	private List lisHoraCita;
	private List lisEtiquetaEtapa;
	private List lisFormatoID;
	private List lisEmitirCheck;
	private List lisSoliCredito;

	//Lista creditos grid 
	private String clienteID;
	private String nombreCompleto;
	private String nombreSucursal;
	private String nombreLocalidad;
	private String creditoID;
	
	private String productoCred;
	private String saldoTotalCap;
	private String diasAtraso;	
	private String estatusCredito;
	private String frecuenPagoCap;
	
	private String fechaCita;
	private String horaCita;
	private String etiquetaEtapa;
	private String formatoID;
	private String nombreFormato;
	
	private String reporte;
	private String emitirCheck;
	private String nombreInsti;
	private String tipoNoti;
	private String solicitudCreditoID;
	
	public String getSucursalID() { 
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEstCredBusq() {
		return estCredBusq;
	}
	public void setEstCredBusq(String estCredBusq) {
		this.estCredBusq = estCredBusq;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getDiasAtrasoIni() {
		return diasAtrasoIni;
	}
	public void setDiasAtrasoIni(String diasAtrasoIni) {
		this.diasAtrasoIni = diasAtrasoIni;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getDiasAtrasoFin() {
		return diasAtrasoFin;
	}
	public void setDiasAtrasoFin(String diasAtrasoFin) {
		this.diasAtrasoFin = diasAtrasoFin;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getLimiteRenglones() {
		return limiteRenglones;
	}
	public void setLimiteRenglones(String limiteRenglones) {
		this.limiteRenglones = limiteRenglones;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
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
	public String getNombreLocalidad() {
		return nombreLocalidad;
	}
	public void setNombreLocalidad(String nombreLocalidad) {
		this.nombreLocalidad = nombreLocalidad;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProductoCred() {
		return productoCred;
	}
	public void setProductoCred(String productoCred) {
		this.productoCred = productoCred;
	}
	public String getSaldoTotalCap() {
		return saldoTotalCap;
	}
	public void setSaldoTotalCap(String saldoTotalCap) {
		this.saldoTotalCap = saldoTotalCap;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getEstatusCredito() {
		return estatusCredito;
	}
	public void setEstatusCredito(String estatusCredito) {
		this.estatusCredito = estatusCredito;
	}
	public String getFrecuenPagoCap() {
		return frecuenPagoCap;
	}
	public void setFrecuenPagoCap(String frecuenPagoCap) {
		this.frecuenPagoCap = frecuenPagoCap;
	}
	public String getFechaCita() {
		return fechaCita;
	}
	public void setFechaCita(String fechaCita) {
		this.fechaCita = fechaCita;
	}
	public String getHoraCita() {
		return horaCita;
	}
	public void setHoraCita(String horaCita) {
		this.horaCita = horaCita;
	}
	public String getEtiquetaEtapa() {
		return etiquetaEtapa;
	}
	public void setEtiquetaEtapa(String etiquetaEtapa) {
		this.etiquetaEtapa = etiquetaEtapa;
	}
	public String getFormatoID() {
		return formatoID;
	}
	public void setFormatoID(String formatoID) {
		this.formatoID = formatoID;
	}
	public String getEmitirCheck() {
		return emitirCheck;
	}
	public void setEmitirCheck(String emitirCheck) {
		this.emitirCheck = emitirCheck;
	}
	public String getFechaSis() {
		return fechaSis;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getSucursalUsuID() {
		return sucursalUsuID;
	}
	public void setSucursalUsuID(String sucursalUsuID) {
		this.sucursalUsuID = sucursalUsuID;
	}
	public List getLisCreditoID() {
		return lisCreditoID;
	}
	public void setLisCreditoID(List lisCreditoID) {
		this.lisCreditoID = lisCreditoID;
	}
	public List getLisFechaCita() {
		return lisFechaCita;
	}
	public void setLisFechaCita(List lisFechaCita) {
		this.lisFechaCita = lisFechaCita;
	}
	public String getNombreFormato() {
		return nombreFormato;
	}
	public void setNombreFormato(String nombreFormato) {
		this.nombreFormato = nombreFormato;
	}
	public List getLisHoraCita() {
		return lisHoraCita;
	}
	public void setLisHoraCita(List lisHoraCita) {
		this.lisHoraCita = lisHoraCita;
	}
	public List getLisFormatoID() {
		return lisFormatoID;
	}
	public void setLisFormatoID(List lisFormatoID) {
		this.lisFormatoID = lisFormatoID;
	}
	public String getReporte() {
		return reporte;
	}
	public void setReporte(String reporte) {
		this.reporte = reporte;
	}
	public List getLisEmitirCheck() {
		return lisEmitirCheck;
	}
	public void setLisEmitirCheck(List lisEmitirCheck) {
		this.lisEmitirCheck = lisEmitirCheck;
	}
	public List getLisEtiquetaEtapa() {
		return lisEtiquetaEtapa;
	}
	public void setLisEtiquetaEtapa(List lisEtiquetaEtapa) {
		this.lisEtiquetaEtapa = lisEtiquetaEtapa;
	}
	public String getNombreInsti() {
		return nombreInsti;
	}
	public void setNombreInsti(String nombreInsti) {
		this.nombreInsti = nombreInsti;
	}
	public String getTipoNoti() {
		return tipoNoti;
	}
	public void setTipoNoti(String tipoNoti) {
		this.tipoNoti = tipoNoti;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public List getLisSoliCredito() {
		return lisSoliCredito;
	}
	public void setLisSoliCredito(List lisSoliCredito) {
		this.lisSoliCredito = lisSoliCredito;
	}
	
}
