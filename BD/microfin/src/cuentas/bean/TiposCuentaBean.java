package cuentas.bean;

import general.bean.BaseBean;

public class TiposCuentaBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID = 3; 
	
	private String tipoCuentaID; 
	private String monedaID;
	private String descripcion;
	private String abreviacion;	
	private String generaInteres;
	private String tipoInteres;
	private String esServicio;
	private String esBancaria;	
	private String minimoApertura;
	private String comApertura;
	private String comManejoCta;
	private String comAniversario; 
	private String cobraBanEle; 		
	private String cobraSpei; 
	private String comFalsoCobro; 	
	private String ExPrimDispSeg;
	private String ComDispSeg;
	private String saldoMinReq;
	private String esConcentradora;
	private String tipoPersona;
	private String esBloqueoAuto;
	private String clasificacionConta;
	private String relacionadoCuenta;
	private String registroFirmas;
	private String huellasFirmante;
	private String conCuenta;
	private String gatInformativo;
	private String comSpeiPerFis;
	private String comSpeiPerMor;
	private String participaSpei;
	private String claveCNBV;
	private String claveCNBVAmpCred;
	
	// Auxiliares para PLD
	private String nivelCtaID;
	private String direccionOficial;
	private String idenOficial;
	private String checkListExpFisico;
	private String limAbonosMensuales;
	private String abonosMenHasta;	
	private String perAboAdi;
	private String aboAdiHas;
	private String limSaldoCuenta;
	private String saldoHasta;
	private String numRegistroRECA;
	private String fechaInscripcion;
	private String nombreComercial;

	private String envioSMSRetiro;
	private String montoMinSMSRetiro;
	
	//Valida Estado Civil
	private String estadoCivil;
	
	private String notificaSms;
	private String plantillaID;
	private String plantillaDes;
	private String estatus;
	private String exentaCobroSalPromOtros;
	private String saldoPromMinReq;
	private String comisionSalProm;
	private String depositoActiva;
	private String montoDepositoActiva;
		
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getAbreviacion() {
		return abreviacion;
	}
	public void setAbreviacion(String abreviacion) {
		this.abreviacion = abreviacion;
	}
	public String getGeneraInteres() {
		return generaInteres;
	}
	public void setGeneraInteres(String generaInteres) {
		this.generaInteres = generaInteres;
	}
	public String getTipoInteres() {
		return tipoInteres;
	}
	public void setTipoInteres(String tipoInteres) {
		this.tipoInteres = tipoInteres;
	}
	public String getEsServicio() {
		return esServicio;
	}
	public void setEsServicio(String esServicio) {
		this.esServicio = esServicio;
	}
	public String getEsBancaria() {
		return esBancaria;
	}
	public void setEsBancaria(String esBancaria) {
		this.esBancaria = esBancaria;
	}
	public String getMinimoApertura() {
		return minimoApertura;
	}
	public void setMinimoApertura(String minimoApertura) {
		this.minimoApertura = minimoApertura;
	}
	public String getComApertura() {
		return comApertura;
	}
	public void setComApertura(String comApertura) {
		this.comApertura = comApertura;
	}
	public String getComManejoCta() {
		return comManejoCta;
	}
	public void setComManejoCta(String comManejoCta) {
		this.comManejoCta = comManejoCta;
	}
	public String getComAniversario() {
		return comAniversario;
	}
	public void setComAniversario(String comAniversario) {
		this.comAniversario = comAniversario;
	}
	public String getCobraBanEle() {
		return cobraBanEle;
	}
	public void setCobraBanEle(String cobraBanEle) {
		this.cobraBanEle = cobraBanEle;
	}
	public String getCobraSpei() {
		return cobraSpei;
	}
	public void setCobraSpei(String cobraSpei) {
		this.cobraSpei = cobraSpei;
	}
	public String getComFalsoCobro() {
		return comFalsoCobro;
	}
	public void setComFalsoCobro(String comFalsoCobro) {
		this.comFalsoCobro = comFalsoCobro;
	}
	public String getExPrimDispSeg() {
		return ExPrimDispSeg;
	}
	public void setExPrimDispSeg(String exPrimDispSeg) {
		ExPrimDispSeg = exPrimDispSeg;
	}
	public String getComDispSeg() {
		return ComDispSeg;
	}
	public void setComDispSeg(String comDispSeg) {
		ComDispSeg = comDispSeg;
	}
	public String getSaldoMinReq() {
		return saldoMinReq;
	}
	public void setSaldoMinReq(String saldoMinReq) {
		this.saldoMinReq = saldoMinReq;
	}
	public String getEsConcentradora() {
		return esConcentradora;
	}
	public void setEsConcentradora(String esConcentradora) {
		this.esConcentradora = esConcentradora;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getEsBloqueoAuto() {
		return esBloqueoAuto;
	}
	public void setEsBloqueoAuto(String esBloqueoAuto) {
		this.esBloqueoAuto = esBloqueoAuto;
	}
	public String getClasificacionConta() {
		return clasificacionConta;
	}
	public void setClasificacionConta(String clasificacionConta) {
		this.clasificacionConta = clasificacionConta;
	}
	public String getRelacionadoCuenta() {
		return relacionadoCuenta;
	}
	public void setRelacionadoCuenta(String relacionadoCuenta) {
		this.relacionadoCuenta = relacionadoCuenta;
	}
	public String getRegistroFirmas() {
		return registroFirmas;
	}
	public void setRegistroFirmas(String registroFirmas) {
		this.registroFirmas = registroFirmas;
	}
	public String getHuellasFirmante() {
		return huellasFirmante;
	}
	public void setHuellasFirmante(String huellasFirmante) {
		this.huellasFirmante = huellasFirmante;
	}
	public String getConCuenta() {
		return conCuenta;
	}
	public void setConCuenta(String conCuenta) {
		this.conCuenta = conCuenta;
	}
	public String getGatInformativo() {
		return gatInformativo;
	}
	public void setGatInformativo(String gatInformativo) {
		this.gatInformativo = gatInformativo;
	}
	public String getComSpeiPerFis() {
		return comSpeiPerFis;
	}
	public void setComSpeiPerFis(String comSpeiPerFis) {
		this.comSpeiPerFis = comSpeiPerFis;
	}
	public String getComSpeiPerMor() {
		return comSpeiPerMor;
	}
	public void setComSpeiPerMor(String comSpeiPerMor) {
		this.comSpeiPerMor = comSpeiPerMor;
	}
	public String getParticipaSpei() {
		return participaSpei;
	}
	public void setParticipaSpei(String participaSpei) {
		this.participaSpei = participaSpei;
	}
	public String getNivelCtaID() {
		return nivelCtaID;
	}
	public void setNivelCtaID(String nivelCtaID) {
		this.nivelCtaID = nivelCtaID;
	}
	public String getDireccionOficial() {
		return direccionOficial;
	}
	public void setDireccionOficial(String direccionOficial) {
		this.direccionOficial = direccionOficial;
	}
	public String getIdenOficial() {
		return idenOficial;
	}
	public void setIdenOficial(String idenOficial) {
		this.idenOficial = idenOficial;
	}
	public String getCheckListExpFisico() {
		return checkListExpFisico;
	}
	public void setCheckListExpFisico(String checkListExpFisico) {
		this.checkListExpFisico = checkListExpFisico;
	}
	public String getLimAbonosMensuales() {
		return limAbonosMensuales;
	}
	public void setLimAbonosMensuales(String limAbonosMensuales) {
		this.limAbonosMensuales = limAbonosMensuales;
	}
	public String getAbonosMenHasta() {
		return abonosMenHasta;
	}
	public void setAbonosMenHasta(String abonosMenHasta) {
		this.abonosMenHasta = abonosMenHasta;
	}
	public String getPerAboAdi() {
		return perAboAdi;
	}
	public void setPerAboAdi(String perAboAdi) {
		this.perAboAdi = perAboAdi;
	}
	public String getAboAdiHas() {
		return aboAdiHas;
	}
	public void setAboAdiHas(String aboAdiHas) {
		this.aboAdiHas = aboAdiHas;
	}
	public String getLimSaldoCuenta() {
		return limSaldoCuenta;
	}
	public void setLimSaldoCuenta(String limSaldoCuenta) {
		this.limSaldoCuenta = limSaldoCuenta;
	}
	public String getSaldoHasta() {
		return saldoHasta;
	}
	public void setSaldoHasta(String saldoHasta) {
		this.saldoHasta = saldoHasta;
	}
	public String getNumRegistroRECA() {
		return numRegistroRECA;
	}
	public void setNumRegistroRECA(String numRegistroRECA) {
		this.numRegistroRECA = numRegistroRECA;
	}
	public String getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(String fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public String getNombreComercial() {
		return nombreComercial;
	}
	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}
	public String getClaveCNBV() {
		return claveCNBV;
	}
	public void setClaveCNBV(String claveCNBV) {
		this.claveCNBV = claveCNBV;
	}
	public String getClaveCNBVAmpCred() {
		return claveCNBVAmpCred;
	}
	public void setClaveCNBVAmpCred(String claveCNBVAmpCred) {
		this.claveCNBVAmpCred = claveCNBVAmpCred;
	}
	public String getEnvioSMSRetiro() {
		return envioSMSRetiro;
	}
	public void setEnvioSMSRetiro(String envioSMSRetiro) {
		this.envioSMSRetiro = envioSMSRetiro;
	}
	public String getMontoMinSMSRetiro() {
		return montoMinSMSRetiro;
	}
	public void setMontoMinSMSRetiro(String montoMinSMSRetiro) {
		this.montoMinSMSRetiro = montoMinSMSRetiro;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getNotificaSms() {
		return notificaSms;
	}
	public void setNotificaSms(String notificaSms) {
		this.notificaSms = notificaSms;
	}
	public String getPlantillaID() {
		return plantillaID;
	}
	public void setPlantillaID(String plantillaID) {
		this.plantillaID = plantillaID;
	}
	public String getPlantillaDes() {
		return plantillaDes;
	}
	public void setPlantillaDes(String plantillaDes) {
		this.plantillaDes = plantillaDes;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getExentaCobroSalPromOtros() {
		return exentaCobroSalPromOtros;
	}
	public void setExentaCobroSalPromOtros(String exentaCobroSalPromOtros) {
		this.exentaCobroSalPromOtros = exentaCobroSalPromOtros;
	}
	public String getSaldoPromMinReq() {
		return saldoPromMinReq;
	}
	public void setSaldoPromMinReq(String saldoPromMinReq) {
		this.saldoPromMinReq = saldoPromMinReq;
	}
	public String getComisionSalProm() {
		return comisionSalProm;
	}
	public void setComisionSalProm(String comisionSalProm) {
		this.comisionSalProm = comisionSalProm;
	}
	public String getDepositoActiva() {
		return depositoActiva;
	}
	public void setDepositoActiva(String depositoActiva) {
		this.depositoActiva = depositoActiva;
	}
	public String getMontoDepositoActiva() {
		return montoDepositoActiva;
	}
	public void setMontoDepositoActiva(String montoDepositoActiva) {
		this.montoDepositoActiva = montoDepositoActiva;
	}

	
}
