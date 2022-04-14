package soporte.bean;

import general.bean.BaseBean;

public class ParametrosCajaBean extends BaseBean {

	/*Declaracion de atributos */

	private String programaID;
	private String ctaOrdinaria;
	private String ctaProtecCre;
	private String ctaProtecCta;
	private String haberExSocios;
	private String ctaContaPROFUN;
	private String tipoCtaProtec;
	private String montoMaxProtec;
	private String montoPROFUN;
	private String aporteMaxPROFUN;
	
	private String montoApoyoSRVFUN;
	private String monApoFamSRVFUN;
	private String perfilAutoriSRVFUN;
	private String edadMaximaSRVFUN;
	private String tiempoMinimoSRVFUN;
	private String mesesValAhoSRVFUN;
	private String saldoMinMesSRVFUN;	
	private String ctaContaSRVFUN;
	private String rolAutoApoyoEsc;
	private String tipoCtaApoyoEscMay;
	private String tipoCtaApoyoEscMen;
	private String MesInicioAhoCons;
	private String montoMinMesApoyoEsc;
	private String ctaContaApoyoEsc;
	private String porcentajeCob;
	private String coberturaMin;
	private String maxAtraPagPROFUN;
	private String perfilAutoriProtec;
	private String perfilCancelPROFUN;
	private String tipoCtaBeneCancel;
	private String cuentaVista;
	private String CCHaberesEx;													
	private String CCProtecAhorro;
	private String CCServifun;
	private String CCApoyoEscolar;
	private String ejecutivoFR;
	private String ctaContaPerdida;
	private String CCContaPerdida;
	private String gastosRural;
	private String gastosUrbana;
	private String tipoCtaProtecMen;
	private String edadMinimaCliMen;
	private String edadMaximaCliMen;
	private String IDGastoAlimenta;
	private String gastosPasivos;
	private String rolCancelaCheque;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;	
	private String sucursal;
	private String numTransaccion;
	private String compromisoAho;
	
	private String puntajeMinimo;
	private String idGastoAlimenta;
	private String catSocioEID;
	private String descripcion;
	private String versionWS;
	
	
	/*==================================================
	  =====Actas comite=====*/
	
	private String montoMinActCom;
	private String montoMaxActCom;
		
	
	/*==================================================
	  =====Axuliriares para Asocioacion de Tarjetas=====*/
	
	private String codCooperativa;
	private String codMoneda;
	private String codUsuario;
	private String permiteAdicional;

	/*==================================================================
	  =====Opciones parametrizables para convenciones seccionales=====*/
	
	private String tipoProdCap;
	private String antigueSocio;
	private String montoAhoMes;
	private String impMinParSoc;
	private String mesesEvalAho;
	private String validaCredAtras;
	private String validaGaranLiq;
	
	// Numero de meses constantes de pago del cliente PROFUN
	private String mesesConsPago;
	
	/* ============ SETTER's Y GETTER's =============== */
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getCtaOrdinaria() {
		return ctaOrdinaria;
	}
	public void setCtaOrdinaria(String ctaOrdinaria) {
		this.ctaOrdinaria = ctaOrdinaria;
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
	public String getMontoApoyoSRVFUN() {
		return montoApoyoSRVFUN;
	}
	public void setMontoApoyoSRVFUN(String montoApoyoSRVFUN) {
		this.montoApoyoSRVFUN = montoApoyoSRVFUN;
	}
	
	public String getMonApoFamSRVFUN() {
		return monApoFamSRVFUN;
	}
	public void setMonApoFamSRVFUN(String monApoFamSRVFUN) {
		this.monApoFamSRVFUN = monApoFamSRVFUN;
	}
	
	public String getPerfilAutoriSRVFUN() {
		return perfilAutoriSRVFUN;
	}
	public void setPerfilAutoriSRVFUN(String perfilAutoriSRVFUN) {
		this.perfilAutoriSRVFUN = perfilAutoriSRVFUN;
	}
	public String getEdadMaximaSRVFUN() {
		return edadMaximaSRVFUN;
	}
	public void setEdadMaximaSRVFUN(String edadMaximaSRVFUN) {
		this.edadMaximaSRVFUN = edadMaximaSRVFUN;
	}
	public String getTiempoMinimoSRVFUN() {
		return tiempoMinimoSRVFUN;
	}
	public void setTiempoMinimoSRVFUN(String tiempoMinimoSRVFUN) {
		this.tiempoMinimoSRVFUN = tiempoMinimoSRVFUN;
	}
	public String getMesesValAhoSRVFUN() {
		return mesesValAhoSRVFUN;
	}
	public void setMesesValAhoSRVFUN(String mesesValAhoSRVFUN) {
		this.mesesValAhoSRVFUN = mesesValAhoSRVFUN;
	}
	public String getSaldoMinMesSRVFUN() {
		return saldoMinMesSRVFUN;
	}
	public void setSaldoMinMesSRVFUN(String saldoMinMesSRVFUN) {
		this.saldoMinMesSRVFUN = saldoMinMesSRVFUN;
	}
	public String getCtaContaSRVFUN() {
		return ctaContaSRVFUN;
	}
	public void setCtaContaSRVFUN(String ctaContaSRVFUN) {
		this.ctaContaSRVFUN = ctaContaSRVFUN;
	}
	public String getRolAutoApoyoEsc() {
		return rolAutoApoyoEsc;
	}
	public void setRolAutoApoyoEsc(String rolAutoApoyoEsc) {
		this.rolAutoApoyoEsc = rolAutoApoyoEsc;
	}
	public String getTipoCtaApoyoEscMay() {
		return tipoCtaApoyoEscMay;
	}
	public void setTipoCtaApoyoEscMay(String tipoCtaApoyoEscMay) {
		this.tipoCtaApoyoEscMay = tipoCtaApoyoEscMay;
	}
	public String getTipoCtaApoyoEscMen() {
		return tipoCtaApoyoEscMen;
	}
	public void setTipoCtaApoyoEscMen(String tipoCtaApoyoEscMen) {
		this.tipoCtaApoyoEscMen = tipoCtaApoyoEscMen;
	}
	public String getMesInicioAhoCons() {
		return MesInicioAhoCons;
	}
	public void setMesInicioAhoCons(String mesInicioAhoCons) {
		MesInicioAhoCons = mesInicioAhoCons;
	}
	public String getMontoMinMesApoyoEsc() {
		return montoMinMesApoyoEsc;
	}
	public void setMontoMinMesApoyoEsc(String montoMinMesApoyoEsc) {
		this.montoMinMesApoyoEsc = montoMinMesApoyoEsc;
	}
	public String getCtaContaApoyoEsc() {
		return ctaContaApoyoEsc;
	}
	public void setCtaContaApoyoEsc(String ctaContaApoyoEsc) {
		this.ctaContaApoyoEsc = ctaContaApoyoEsc;
	}
	public String getPorcentajeCob() {
		return porcentajeCob;
	}
	public void setPorcentajeCob(String porcentajeCob) {
		this.porcentajeCob = porcentajeCob;
	}
	public String getCoberturaMin() {
		return coberturaMin;
	}
	public void setCoberturaMin(String coberturaMin) {
		this.coberturaMin = coberturaMin;
	}
	public String getMaxAtraPagPROFUN() {
		return maxAtraPagPROFUN;
	}
	public void setMaxAtraPagPROFUN(String maxAtraPagPROFUN) {
		this.maxAtraPagPROFUN = maxAtraPagPROFUN;
	}
	public String getPerfilAutoriProtec() {
		return perfilAutoriProtec;
	}
	public void setPerfilAutoriProtec(String perfilAutoriProtec) {
		this.perfilAutoriProtec = perfilAutoriProtec;
	}
	public String getPerfilCancelPROFUN() {
		return perfilCancelPROFUN;
	}
	public void setPerfilCancelPROFUN(String perfilCancelPROFUN) {
		this.perfilCancelPROFUN = perfilCancelPROFUN;
	}
	public String getTipoCtaBeneCancel() {
		return tipoCtaBeneCancel;
	}
	public void setTipoCtaBeneCancel(String tipoCtaBeneCancel) {
		this.tipoCtaBeneCancel = tipoCtaBeneCancel;
	}
	public String getCuentaVista() {
		return cuentaVista;
	}
	public void setCuentaVista(String cuentaVista) {
		this.cuentaVista = cuentaVista;
	}
	public String getCCHaberesEx() {
		return CCHaberesEx;
	}
	public void setCCHaberesEx(String cCHaberesEx) {
		CCHaberesEx = cCHaberesEx;
	}
	public String getCCProtecAhorro() {
		return CCProtecAhorro;
	}
	public void setCCProtecAhorro(String cCProtecAhorro) {
		CCProtecAhorro = cCProtecAhorro;
	}
	public String getCCServifun() {
		return CCServifun;
	}
	public void setCCServifun(String cCServifun) {
		CCServifun = cCServifun;
	}
	public String getCCApoyoEscolar() {
		return CCApoyoEscolar;
	}
	public void setCCApoyoEscolar(String cCApoyoEscolar) {
		CCApoyoEscolar = cCApoyoEscolar;
	}
	public String getEjecutivoFR() {
		return ejecutivoFR;
	}
	public void setEjecutivoFR(String ejecutivoFR) {
		this.ejecutivoFR = ejecutivoFR;
	}
	public String getCtaContaPerdida() {
		return ctaContaPerdida;
	}
	public void setCtaContaPerdida(String ctaContaPerdida) {
		this.ctaContaPerdida = ctaContaPerdida;
	}
	public String getCCContaPerdida() {
		return CCContaPerdida;
	}
	public void setCCContaPerdida(String cCContaPerdida) {
		CCContaPerdida = cCContaPerdida;
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
	public String getCompromisoAho() {
		return compromisoAho;
	}
	public void setCompromisoAho(String compromisoAho) {
		this.compromisoAho = compromisoAho;
	}

	public String getGastosRural() {
		return gastosRural;
	}
	public void setGastosRural(String gastosRural) {
		this.gastosRural = gastosRural;
	}
	public String getGastosUrbana() {
		return gastosUrbana;
	}
	public void setGastosUrbana(String gastosUrbana) {
		this.gastosUrbana = gastosUrbana;
	}
	public String getIDGastoAlimenta() {
		return IDGastoAlimenta;
	}
	public String getGastosPasivos() {
		return gastosPasivos;
	}
	public void setIDGastoAlimenta(String iDGastoAlimenta) {
		IDGastoAlimenta = iDGastoAlimenta;
	}
	public void setGastosPasivos(String gastosPasivos) {
		this.gastosPasivos = gastosPasivos;
	}
	
	public String getTipoCtaProtecMen() {
		return tipoCtaProtecMen;
	}
	public void setTipoCtaProtecMen(String tipoCtaProtecMen) {
		this.tipoCtaProtecMen = tipoCtaProtecMen;
	}
	public String getEdadMinimaCliMen() {
		return edadMinimaCliMen;
	}
	public String getEdadMaximaCliMen() {
		return edadMaximaCliMen;
	}
	public void setEdadMinimaCliMen(String edadMinimaCliMen) {
		this.edadMinimaCliMen = edadMinimaCliMen;
	}
	public void setEdadMaximaCliMen(String edadMaximaCliMen) {
		this.edadMaximaCliMen = edadMaximaCliMen;
	}
	
	public String getPuntajeMinimo() {
		return puntajeMinimo;
	}
	public void setPuntajeMinimo (String puntajeMinimo) {
		this.puntajeMinimo = puntajeMinimo;
	}
	
	public String getIdGastoAlimenta() {
		return idGastoAlimenta;
	}
	public void setIdGastoAlimenta(String idGastoAlimenta) {
		this.idGastoAlimenta = idGastoAlimenta;
	}
	
	
	public String getCatSocioEID(){
		return catSocioEID;
	}
	public void setCatSocioEID(String catSocioEID) {
		this.catSocioEID = catSocioEID;
	}
	
	public String getDescripcion(){
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getVersionWS() {
		return versionWS;
	}
	public void setVersionWS(String versionWS) {
		this.versionWS = versionWS;
	}
	public String getRolCancelaCheque() {
		return rolCancelaCheque;
	}
	public void setRolCancelaCheque(String rolCancelaCheque) {
		this.rolCancelaCheque = rolCancelaCheque;
	}
	public String getCodCooperativa() {
		return codCooperativa;
	}
	public void setCodCooperativa(String codCooperativa) {
		this.codCooperativa = codCooperativa;
	}
	public String getCodMoneda() {
		return codMoneda;
	}
	public void setCodMoneda(String codMoneda) {
		this.codMoneda = codMoneda;
	}
	public String getCodUsuario() {
		return codUsuario;
	}
	public void setCodUsuario(String codUsuario) {
		this.codUsuario = codUsuario;
	}
	public String getPermiteAdicional() {
		return permiteAdicional;
	}
	public void setPermiteAdicional(String permiteAdicional) {
		this.permiteAdicional = permiteAdicional;
	}
	

	
	public String getTipoProdCap() {
		return tipoProdCap;
	}
	
	public void setTipoProdCap(String tipoProdCap) {
		this.tipoProdCap = tipoProdCap;
	}
	
	public String getAntigueSocio() {
		return antigueSocio;
	}
	public void setAntigueSocio(String antigueSocio) {
		this.antigueSocio = antigueSocio;
	}
	
	public String getMontoAhoMes() {
		return montoAhoMes;
	}
	public void setMontoAhoMes(String montoAhoMes) {
		this.montoAhoMes = montoAhoMes;
	}
	
	public String getImpMinParSoc() {
		return impMinParSoc;
	}
	public void setImpMinParSoc(String impMinParSoc) {
		this.impMinParSoc = impMinParSoc;
	}
	
	public String getMesesEvalAho() {
		return mesesEvalAho;
	}
	public void setMesesEvalAho(String mesesEvalAho) {
		this.mesesEvalAho = mesesEvalAho;
	}
	
	public String getValidaCredAtras() {
		return validaCredAtras;
	}
	public void setValidaCredAtras(String validaCredAtras) {
		this.validaCredAtras = validaCredAtras;
	}
	
	public String getValidaGaranLiq() {
		return validaGaranLiq;
	}
	public void setValidaGaranLiq(String validaGaranLiq) {
		this.validaGaranLiq = validaGaranLiq;
	}

	public String getMesesConsPago() {
		return mesesConsPago;
	}
	public void setMesesConsPago(String mesesConsPago) {
		this.mesesConsPago = mesesConsPago;
	}
	public String getMontoMinActCom() {
		return montoMinActCom;
	}
	public void setMontoMinActCom(String montoMinActCom) {
		this.montoMinActCom = montoMinActCom;
	}
	public String getMontoMaxActCom() {
		return montoMaxActCom;
	}
	public void setMontoMaxActCom(String montoMaxActCom) {
		this.montoMaxActCom = montoMaxActCom;
	}
	
	

}