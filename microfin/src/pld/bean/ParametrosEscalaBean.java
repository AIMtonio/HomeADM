package pld.bean;

import general.bean.BaseBean;

public class ParametrosEscalaBean extends BaseBean {

	private String folioID;
	private String tipoPersona;
	private String tipoInstrumento;
	private String nacMoneda;
	private String limiteInferior;
	private String monedaComp;
	private String rolTitular;
	private String rolSuplente;
	
	// Auxiliar para mostrar el reporte del historico
	private String tipoReporte;

	public String getFolioID() {
		return folioID;
	}

	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getTipoInstrumento() {
		return tipoInstrumento;
	}

	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}

	public String getNacMoneda() {
		return nacMoneda;
	}

	public void setNacMoneda(String nacMoneda) {
		this.nacMoneda = nacMoneda;
	}

	public String getLimiteInferior() {
		return limiteInferior;
	}

	public void setLimiteInferior(String limiteInferior) {
		this.limiteInferior = limiteInferior;
	}

	public String getMonedaComp() {
		return monedaComp;
	}

	public void setMonedaComp(String monedaComp) {
		this.monedaComp = monedaComp;
	}

	public String getRolTitular() {
		return rolTitular;
	}

	public void setRolTitular(String rolTitular) {
		this.rolTitular = rolTitular;
	}

	public String getRolSuplente() {
		return rolSuplente;
	}

	public void setRolSuplente(String rolSuplente) {
		this.rolSuplente = rolSuplente;
	}

	public String getTipoReporte() {
		return tipoReporte;
	}

	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}

}
