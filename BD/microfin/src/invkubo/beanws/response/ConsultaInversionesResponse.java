package invkubo.beanws.response;

import general.bean.BaseBeanWS;

public class ConsultaInversionesResponse extends BaseBeanWS {
	
	private String gananciaAnuTot;
	private String interesCobrado;
	private String pagTotalRecib;
	private String saldoTotal;
	private String numeroEfectivoDispon;
	private String saldoEfectivoDispon;
	private String numeroInverEnProceso;
	private String saldoInverEnProceso;
	private String numeroInvActivas;
	private String saldoInvActivas;
	private String numeroIntDevengados;
	private String saldoIntDevengados;
	private String numeroTotInversiones;
	private String numeroInvActivasResumen;
	private String SaldoInvActivasResumen;
	private String numeroInvAtrasadas1a15Resumen;
	private String saldoInvAtrasadas1a15Resumen;
	private String numeroInvAtrasadas16a30Resumen;
	private String saldoInvAtrasadas16a30Resumen;
	private String numeroInvAtrasadas31a90Resumen;
	private String saldoInvAtrasadas31a90Resumen;
	private String numeroInvVencidas91a120Resumen;
	private String saldoInvVencidas91a120Resumen;
	private String numeroInvVencidas121a180Resumen;
	private String saldoInvVencidas121a180Resumen;
	private String numeroInvQuebrantadasResumen;
	private String saldoInvQuebrantadasResumen;
	private String numeroInvLiquidadasResumen;
	private String saldoInvLiquidadasResumen;
	private String numInteresCobrado;
	private String numMoraCobrado;
	private String moraCobrado;
	private String numComFalPago;
	private String comFalPago;
	private String numCapitalCobrado;
	private String CapitalCobrado;
	
	
	private String codigoRespuesta;
	private String mensajeRespuesta;

	
	
	public String getNumCapitalCobrado() {
		return numCapitalCobrado;
	}
	public void setNumCapitalCobrado(String numCapitalCobrado) {
		this.numCapitalCobrado = numCapitalCobrado;
	}
	public String getCapitalCobrado() {
		return CapitalCobrado;
	}
	public void setCapitalCobrado(String capitalCobrado) {
		CapitalCobrado = capitalCobrado;
	}
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public String getNumInteresCobrado() {
		return numInteresCobrado;
	}
	public void setNumInteresCobrado(String numInteresCobrado) {
		this.numInteresCobrado = numInteresCobrado;
	}
	public String getNumMoraCobrado() {
		return numMoraCobrado;
	}
	public void setNumMoraCobrado(String numMoraCobrado) {
		this.numMoraCobrado = numMoraCobrado;
	}
	public String getMoraCobrado() {
		return moraCobrado;
	}
	public void setMoraCobrado(String moraCobrado) {
		this.moraCobrado = moraCobrado;
	}
	public String getNumComFalPago() {
		return numComFalPago;
	}
	public void setNumComFalPago(String numComFalPago) {
		this.numComFalPago = numComFalPago;
	}
	public String getComFalPago() {
		return comFalPago;
	}
	public void setComFalPago(String comFalPago) {
		this.comFalPago = comFalPago;
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
	public String getGananciaAnuTot() {
		return gananciaAnuTot;
	}
	public void setGananciaAnuTot(String gananciaAnuTot) {
		this.gananciaAnuTot = gananciaAnuTot;
	}
	public String getInteresCobrado() {
		return interesCobrado;
	}
	public void setInteresCobrado(String interesCobrado) {
		this.interesCobrado = interesCobrado;
	}
	public String getPagTotalRecib() {
		return pagTotalRecib;
	}
	public void setPagTotalRecib(String pagTotalRecib) {
		this.pagTotalRecib = pagTotalRecib;
	}
	public String getSaldoTotal() {
		return saldoTotal;
	}
	public void setSaldoTotal(String saldoTotal) {
		this.saldoTotal = saldoTotal;
	}
	public String getNumeroEfectivoDispon() {
		return numeroEfectivoDispon;
	}
	public void setNumeroEfectivoDispon(String numeroEfectivoDispon) {
		this.numeroEfectivoDispon = numeroEfectivoDispon;
	}
	public String getSaldoEfectivoDispon() {
		return saldoEfectivoDispon;
	}
	public void setSaldoEfectivoDispon(String saldoEfectivoDispon) {
		this.saldoEfectivoDispon = saldoEfectivoDispon;
	}
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
	public String getNumeroIntDevengados() {
		return numeroIntDevengados;
	}
	public void setNumeroIntDevengados(String numeroIntDevengados) {
		this.numeroIntDevengados = numeroIntDevengados;
	}
	public String getSaldoIntDevengados() {
		return saldoIntDevengados;
	}
	public void setSaldoIntDevengados(String saldoIntDevengados) {
		this.saldoIntDevengados = saldoIntDevengados;
	}
	public String getNumeroTotInversiones() {
		return numeroTotInversiones;
	}
	public void setNumeroTotInversiones(String numeroTotInversiones) {
		this.numeroTotInversiones = numeroTotInversiones;
	}
	public String getNumeroInvActivasResumen() {
		return numeroInvActivasResumen;
	}
	public void setNumeroInvActivasResumen(String numeroInvActivasResumen) {
		this.numeroInvActivasResumen = numeroInvActivasResumen;
	}
	public String getSaldoInvActivasResumen() {
		return SaldoInvActivasResumen;
	}
	public void setSaldoInvActivasResumen(String saldoInvActivasResumen) {
		SaldoInvActivasResumen = saldoInvActivasResumen;
	}
	public String getNumeroInvAtrasadas1a15Resumen() {
		return numeroInvAtrasadas1a15Resumen;
	}
	public void setNumeroInvAtrasadas1a15Resumen(
			String numeroInvAtrasadas1a15Resumen) {
		this.numeroInvAtrasadas1a15Resumen = numeroInvAtrasadas1a15Resumen;
	}
	public String getSaldoInvAtrasadas1a15Resumen() {
		return saldoInvAtrasadas1a15Resumen;
	}
	public void setSaldoInvAtrasadas1a15Resumen(String saldoInvAtrasadas1a15Resumen) {
		this.saldoInvAtrasadas1a15Resumen = saldoInvAtrasadas1a15Resumen;
	}
	public String getNumeroInvAtrasadas16a30Resumen() {
		return numeroInvAtrasadas16a30Resumen;
	}
	public void setNumeroInvAtrasadas16a30Resumen(
			String numeroInvAtrasadas16a30Resumen) {
		this.numeroInvAtrasadas16a30Resumen = numeroInvAtrasadas16a30Resumen;
	}
	public String getSaldoInvAtrasadas16a30Resumen() {
		return saldoInvAtrasadas16a30Resumen;
	}
	public void setSaldoInvAtrasadas16a30Resumen(
			String saldoInvAtrasadas16a30Resumen) {
		this.saldoInvAtrasadas16a30Resumen = saldoInvAtrasadas16a30Resumen;
	}
	public String getNumeroInvAtrasadas31a90Resumen() {
		return numeroInvAtrasadas31a90Resumen;
	}
	public void setNumeroInvAtrasadas31a90Resumen(
			String numeroInvAtrasadas31a90Resumen) {
		this.numeroInvAtrasadas31a90Resumen = numeroInvAtrasadas31a90Resumen;
	}
	public String getSaldoInvAtrasadas31a90Resumen() {
		return saldoInvAtrasadas31a90Resumen;
	}
	public void setSaldoInvAtrasadas31a90Resumen(
			String saldoInvAtrasadas31a90Resumen) {
		this.saldoInvAtrasadas31a90Resumen = saldoInvAtrasadas31a90Resumen;
	}
	public String getNumeroInvVencidas91a120Resumen() {
		return numeroInvVencidas91a120Resumen;
	}
	public void setNumeroInvVencidas91a120Resumen(
			String numeroInvVencidas91a120Resumen) {
		this.numeroInvVencidas91a120Resumen = numeroInvVencidas91a120Resumen;
	}
	public String getSaldoInvVencidas91a120Resumen() {
		return saldoInvVencidas91a120Resumen;
	}
	public void setSaldoInvVencidas91a120Resumen(
			String saldoInvVencidas91a120Resumen) {
		this.saldoInvVencidas91a120Resumen = saldoInvVencidas91a120Resumen;
	}
	public String getNumeroInvVencidas121a180Resumen() {
		return numeroInvVencidas121a180Resumen;
	}
	public void setNumeroInvVencidas121a180Resumen(
			String numeroInvVencidas121a180Resumen) {
		this.numeroInvVencidas121a180Resumen = numeroInvVencidas121a180Resumen;
	}
	public String getSaldoInvVencidas121a180Resumen() {
		return saldoInvVencidas121a180Resumen;
	}
	public void setSaldoInvVencidas121a180Resumen(
			String saldoInvVencidas121a180Resumen) {
		this.saldoInvVencidas121a180Resumen = saldoInvVencidas121a180Resumen;
	}
	public String getNumeroInvQuebrantadasResumen() {
		return numeroInvQuebrantadasResumen;
	}
	public void setNumeroInvQuebrantadasResumen(String numeroInvQuebrantadasResumen) {
		this.numeroInvQuebrantadasResumen = numeroInvQuebrantadasResumen;
	}
	public String getSaldoInvQuebrantadasResumen() {
		return saldoInvQuebrantadasResumen;
	}
	public void setSaldoInvQuebrantadasResumen(String saldoInvQuebrantadasResumen) {
		this.saldoInvQuebrantadasResumen = saldoInvQuebrantadasResumen;
	}
	public String getNumeroInvLiquidadasResumen() {
		return numeroInvLiquidadasResumen;
	}
	public void setNumeroInvLiquidadasResumen(String numeroInvLiquidadasResumen) {
		this.numeroInvLiquidadasResumen = numeroInvLiquidadasResumen;
	}
	public String getSaldoInvLiquidadasResumen() {
		return saldoInvLiquidadasResumen;
	}
	public void setSaldoInvLiquidadasResumen(String saldoInvLiquidadasResumen) {
		this.saldoInvLiquidadasResumen = saldoInvLiquidadasResumen;
	}
	
	
	

}
