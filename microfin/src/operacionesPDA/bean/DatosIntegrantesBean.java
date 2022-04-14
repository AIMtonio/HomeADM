package operacionesPDA.bean;

import general.bean.BaseBeanWS;

public class DatosIntegrantesBean extends BaseBeanWS {
	/* Clase Bean ocupada para los datos de los integrantes en el
	 * Alta de Solicitud de Credito Grupal WS
	 * para Sana Tus Finanzas
	*/
	private String prospectoID;
	private String clienteID;
	private String destinoCredito;
	private String proyecto;
	private String montoSolici;
	private String tipoIntegrante;

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

	public String getMontoSolici() {
		return montoSolici;
	}

	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}

	public String getTipoIntegrante() {
		return tipoIntegrante;
	}

	public void setTipoIntegrante(String tipoIntegrante) {
		this.tipoIntegrante = tipoIntegrante;
	}

}
