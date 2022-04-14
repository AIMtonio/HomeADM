package invkubo.beanws.response;

import general.bean.BaseBeanWS;

public class ConsultaDetalleInverResponse  extends BaseBeanWS {
	
	private String numeroInverEnProceso;
	private String saldoInverEnProceso;
	private String numeroInvActivasResum;
	private String saldoInvActivasResum;
	private String numeroTotInversiones;
	private String numeroInvAtrasadas1a15;
	private String saldoInvAtrasadas1a15;
	private String numeroInvAtrasadas16a30;
	private String saldoInvAtrasadas16a30;
	private String numeroInvAtrasadas31a90;
	private String saldoInvAtrasadas31a90;
	private String numeroInvVencidas91a120;
	private String saldoInvVencidas91a120;
	private String numeroInvVencidas121a180;
	private String saldoInvVencidas121a180;
	private String numeroInvQuebrantadas;
	private String saldoInvQuebrantadas;
	private String numeroInvLiquidadas;
	private String saldoInvLiquidadas;
	private String infoCalifPorc;
	private String infoPlazosPorc;
	private String infoTasasPonCalif;
	private String TasaPonderada;
	private String numeroIntDev;
	private String saldoIntDev;
	private String numPagosRecibidos;
	private String salPagosRecibidos;
	private String numPagosCapital;
	private String salPagosCapital;
	private String numPagosInterOrdi;
	private String SalPagosInterOrdi;
	private String numPagosInteMora;
	private String salPagosInteMora;
	private String impuestos;
	private String comisPagadas;
	private String numComisRecibidas;
	private String salComisRecibidas;
	private String numEfecDisp;
	private String salEfecDisp;
	private String numeroInvActivas;
	private String saldoInvActivas;
	private String Depositos;
	private String InverRealiz;
	private String PagCapRecib;
	private String IntOrdRec;
	private String IntMoraRec;
	private String RecupMorosos;
	private String ISRretenido;
	private String ComisCobrad;
	private String ComisPagad;
	private String Ajustes;
	private String Quebrantos;
	private String QuebranXapli;
	private String PremiosRecom;
		
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getNumeroInverEnProceso() {
		return numeroInverEnProceso;
	}
	public void setNumeroInverEnProceso(String numeroInverEnProceso) {
		this.numeroInverEnProceso = numeroInverEnProceso;
	}
	public String getSaldoInverEnProceso() {
		return saldoInverEnProceso;
	}
	public void setSaldoInverEnProceso(String saldoInverEnProceso) {
		this.saldoInverEnProceso = saldoInverEnProceso;
	}
	public String getNumeroInvActivas() {
		return numeroInvActivas;
	}
	public void setNumeroInvActivas(String numeroInvActivas) {
		this.numeroInvActivas = numeroInvActivas;
	}
	public String getSaldoInvActivas() {
		return saldoInvActivas;
	}
	public void setSaldoInvActivas(String saldoInvActivas) {
		this.saldoInvActivas = saldoInvActivas;
	}
	public String getNumeroTotInversiones() {
		return numeroTotInversiones;
	}
	public void setNumeroTotInversiones(String numeroTotInversiones) {
		this.numeroTotInversiones = numeroTotInversiones;
	}
	public String getNumeroInvAtrasadas1a15() {
		return numeroInvAtrasadas1a15;
	}
	public void setNumeroInvAtrasadas1a15(String numeroInvAtrasadas1a15) {
		this.numeroInvAtrasadas1a15 = numeroInvAtrasadas1a15;
	}
	public String getSaldoInvAtrasadas1a15() {
		return saldoInvAtrasadas1a15;
	}
	public void setSaldoInvAtrasadas1a15(String saldoInvAtrasadas1a15) {
		this.saldoInvAtrasadas1a15 = saldoInvAtrasadas1a15;
	}
	public String getNumeroInvAtrasadas16a30() {
		return numeroInvAtrasadas16a30;
	}
	public void setNumeroInvAtrasadas16a30(String numeroInvAtrasadas16a30) {
		this.numeroInvAtrasadas16a30 = numeroInvAtrasadas16a30;
	}
	public String getSaldoInvAtrasadas16a30() {
		return saldoInvAtrasadas16a30;
	}
	public void setSaldoInvAtrasadas16a30(String saldoInvAtrasadas16a30) {
		this.saldoInvAtrasadas16a30 = saldoInvAtrasadas16a30;
	}
	public String getNumeroInvAtrasadas31a90() {
		return numeroInvAtrasadas31a90;
	}
	public void setNumeroInvAtrasadas31a90(String numeroInvAtrasadas31a90) {
		this.numeroInvAtrasadas31a90 = numeroInvAtrasadas31a90;
	}
	public String getSaldoInvAtrasadas31a90() {
		return saldoInvAtrasadas31a90;
	}
	public void setSaldoInvAtrasadas31a90(String saldoInvAtrasadas31a90) {
		this.saldoInvAtrasadas31a90 = saldoInvAtrasadas31a90;
	}
	public String getNumeroInvVencidas91a120() {
		return numeroInvVencidas91a120;
	}
	public void setNumeroInvVencidas91a120(String numeroInvVencidas91a120) {
		this.numeroInvVencidas91a120 = numeroInvVencidas91a120;
	}
	public String getSaldoInvVencidas91a120() {
		return saldoInvVencidas91a120;
	}
	public void setSaldoInvVencidas91a120(String saldoInvVencidas91a120) {
		this.saldoInvVencidas91a120 = saldoInvVencidas91a120;
	}
	public String getNumeroInvVencidas121a180() {
		return numeroInvVencidas121a180;
	}
	public void setNumeroInvVencidas121a180(String numeroInvVencidas121a180) {
		this.numeroInvVencidas121a180 = numeroInvVencidas121a180;
	}
	public String getSaldoInvVencidas121a180() {
		return saldoInvVencidas121a180;
	}
	public void setSaldoInvVencidas121a180(String saldoInvVencidas121a180) {
		this.saldoInvVencidas121a180 = saldoInvVencidas121a180;
	}
	public String getNumeroInvQuebrantadas() {
		return numeroInvQuebrantadas;
	}
	public void setNumeroInvQuebrantadas(String numeroInvQuebrantadas) {
		this.numeroInvQuebrantadas = numeroInvQuebrantadas;
	}
	public String getSaldoInvQuebrantadas() {
		return saldoInvQuebrantadas;
	}
	public void setSaldoInvQuebrantadas(String saldoInvQuebrantadas) {
		this.saldoInvQuebrantadas = saldoInvQuebrantadas;
	}
	public String getNumeroInvLiquidadas() {
		return numeroInvLiquidadas;
	}
	public void setNumeroInvLiquidadas(String numeroInvLiquidadas) {
		this.numeroInvLiquidadas = numeroInvLiquidadas;
	}
	public String getSaldoInvLiquidadas() {
		return saldoInvLiquidadas;
	}
	public void setSaldoInvLiquidadas(String saldoInvLiquidadas) {
		this.saldoInvLiquidadas = saldoInvLiquidadas;
	}
	public String getInfoCalifPorc() {
		return infoCalifPorc;
	}
	public void setInfoCalifPorc(String infoCalifPorc) {
		this.infoCalifPorc = infoCalifPorc;
	}
	
	public String getInfoPlazosPorc() {
		return infoPlazosPorc;
	}
	public void setInfoPlazosPorc(String infoPlazosPorc) {
		this.infoPlazosPorc = infoPlazosPorc;
	}
	public String getInfoTasasPonCalif() {
		return infoTasasPonCalif;
	}
	public void setInfoTasasPonCalif(String infoTasasPonCalif) {
		this.infoTasasPonCalif = infoTasasPonCalif;
	}
	public String getTasaPonderada() {
		return TasaPonderada;
	}
	public void setTasaPonderada(String tasaPonderada) {
		TasaPonderada = tasaPonderada;
	}
	public String getNumeroIntDev() {
		return numeroIntDev;
	}
	public void setNumeroIntDev(String numeroIntDev) {
		this.numeroIntDev = numeroIntDev;
	}
	public String getSaldoIntDev() {
		return saldoIntDev;
	}
	public void setSaldoIntDev(String saldoIntDev) {
		this.saldoIntDev = saldoIntDev;
	}
	public String getNumPagosRecibidos() {
		return numPagosRecibidos;
	}
	public void setNumPagosRecibidos(String numPagosRecibidos) {
		this.numPagosRecibidos = numPagosRecibidos;
	}
	public String getSalPagosRecibidos() {
		return salPagosRecibidos;
	}
	public void setSalPagosRecibidos(String salPagosRecibidos) {
		this.salPagosRecibidos = salPagosRecibidos;
	}
	public String getNumPagosCapital() {
		return numPagosCapital;
	}
	public void setNumPagosCapital(String numPagosCapital) {
		this.numPagosCapital = numPagosCapital;
	}
	public String getSalPagosCapital() {
		return salPagosCapital;
	}
	public void setSalPagosCapital(String salPagosCapital) {
		this.salPagosCapital = salPagosCapital;
	}
	public String getNumPagosInterOrdi() {
		return numPagosInterOrdi;
	}
	public void setNumPagosInterOrdi(String numPagosInterOrdi) {
		this.numPagosInterOrdi = numPagosInterOrdi;
	}
	public String getSalPagosInterOrdi() {
		return SalPagosInterOrdi;
	}
	public void setSalPagosInterOrdi(String salPagosInterOrdi) {
		SalPagosInterOrdi = salPagosInterOrdi;
	}
	public String getNumPagosInteMora() {
		return numPagosInteMora;
	}
	public void setNumPagosInteMora(String numPagosInteMora) {
		this.numPagosInteMora = numPagosInteMora;
	}
	public String getSalPagosInteMora() {
		return salPagosInteMora;
	}
	public void setSalPagosInteMora(String salPagosInteMora) {
		this.salPagosInteMora = salPagosInteMora;
	}
	public String getImpuestos() {
		return impuestos;
	}
	public void setImpuestos(String impuestos) {
		this.impuestos = impuestos;
	}
	public String getComisPagadas() {
		return comisPagadas;
	}
	public void setComisPagadas(String comisPagadas) {
		this.comisPagadas = comisPagadas;
	}
	
	public String getNumComisRecibidas() {
		return numComisRecibidas;
	}
	public void setNumComisRecibidas(String numComisRecibidas) {
		this.numComisRecibidas = numComisRecibidas;
	}
	public String getSalComisRecibidas() {
		return salComisRecibidas;
	}
	public void setSalComisRecibidas(String salComisRecibidas) {
		this.salComisRecibidas = salComisRecibidas;
	}
	public String getNumeroInvActivasResum() {
		return numeroInvActivasResum;
	}
	public void setNumeroInvActivasResum(String numeroInvActivasResum) {
		this.numeroInvActivasResum = numeroInvActivasResum;
	}
	public String getSaldoInvActivasResum() {
		return saldoInvActivasResum;
	}
	public void setSaldoInvActivasResum(String saldoInvActivasResum) {
		this.saldoInvActivasResum = saldoInvActivasResum;
	}
	public String getNumEfecDisp() {
		return numEfecDisp;
	}
	public void setNumEfecDisp(String numEfecDisp) {
		this.numEfecDisp = numEfecDisp;
	}
	public String getSalEfecDisp() {
		return salEfecDisp;
	}
	public void setSalEfecDisp(String salEfecDisp) {
		this.salEfecDisp = salEfecDisp;
	}
	public String getDepositos() {
		return Depositos;
	}
	public void setDepositos(String depositos) {
		Depositos = depositos;
	}
	public String getInverRealiz() {
		return InverRealiz;
	}
	public void setInverRealiz(String inverRealiz) {
		InverRealiz = inverRealiz;
	}
	public String getPagCapRecib() {
		return PagCapRecib;
	}
	public void setPagCapRecib(String pagCapRecib) {
		PagCapRecib = pagCapRecib;
	}
	public String getIntOrdRec() {
		return IntOrdRec;
	}
	public void setIntOrdRec(String intOrdRec) {
		IntOrdRec = intOrdRec;
	}
	public String getIntMoraRec() {
		return IntMoraRec;
	}
	public void setIntMoraRec(String intMoraRec) {
		IntMoraRec = intMoraRec;
	}
	public String getRecupMorosos() {
		return RecupMorosos;
	}
	public void setRecupMorosos(String recupMorosos) {
		RecupMorosos = recupMorosos;
	}
	public String getISRretenido() {
		return ISRretenido;
	}
	public void setISRretenido(String iSRretenido) {
		ISRretenido = iSRretenido;
	}
	public String getComisCobrad() {
		return ComisCobrad;
	}
	public void setComisCobrad(String comisCobrad) {
		ComisCobrad = comisCobrad;
	}
	public String getComisPagad() {
		return ComisPagad;
	}
	public void setComisPagad(String comisPagad) {
		ComisPagad = comisPagad;
	}
	public String getAjustes() {
		return Ajustes;
	}
	public void setAjustes(String ajustes) {
		Ajustes = ajustes;
	}
	public String getQuebrantos() {
		return Quebrantos;
	}
	public void setQuebrantos(String quebrantos) {
		Quebrantos = quebrantos;
	}
	public String getQuebranXapli() {
		return QuebranXapli;
	}
	public void setQuebranXapli(String quebranXapli) {
		QuebranXapli = quebranXapli;
	}
	public String getPremiosRecom() {
		return PremiosRecom;
	}
	public void setPremiosRecom(String premiosRecom) {
		PremiosRecom = premiosRecom;
	}
	
	
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	
	
}