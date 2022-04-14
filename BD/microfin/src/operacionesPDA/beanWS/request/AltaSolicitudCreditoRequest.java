package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class AltaSolicitudCreditoRequest extends BaseBeanWS {
	
	private String prospectoID;
	private String clienteID;
	private String productoCreditoID;
	private String montoSolici;
	private String periodicidad;
	private String plazo;
	private String destinoCredito;
	private String proyecto;
	private String tipoDispersion;
	private String cuentaCLABE;
	private String tipoPagoCapital;
	private String tipoCredito;
	private String numeroCredito;
	private String folio;
	private String claveUsuario;
	private String dispositivo;

	public String getProspectoID() {
		return prospectoID;
	}

	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}

	public String getMontoSolici() {
		return montoSolici;
	}

	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}

	public String getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	public String getPlazo() {
		return plazo;
	}

	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}

	public String getDestinoCredito() {
		return destinoCredito;
	}

	public void setDestinoCredito(String destinoCredito) {
		this.destinoCredito = destinoCredito;
	}

	public String getProyecto() {
		return proyecto;
	}

	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}

	public String getTipoDispersion() {
		return tipoDispersion;
	}

	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}

	public String getCuentaCLABE() {
		return cuentaCLABE;
	}

	public void setCuentaCLABE(String cuentaCLABE) {
		this.cuentaCLABE = cuentaCLABE;
	}

	public String getTipoPagoCapital() {
		return tipoPagoCapital;
	}

	public void setTipoPagoCapital(String tipoPagoCapital) {
		this.tipoPagoCapital = tipoPagoCapital;
	}

	public String getTipoCredito() {
		return tipoCredito;
	}

	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}

	public String getNumeroCredito() {
		return numeroCredito;
	}

	public void setNumeroCredito(String numeroCredito) {
		this.numeroCredito = numeroCredito;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getClaveUsuario() {
		return claveUsuario;
	}

	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}

	public String getDispositivo() {
		return dispositivo;
	}

	public void setDispositivo(String dispositivo) {
		this.dispositivo = dispositivo;
	}

}
