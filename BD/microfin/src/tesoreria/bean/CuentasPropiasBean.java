package tesoreria.bean;

import general.bean.BaseBean;

public class CuentasPropiasBean extends BaseBean {

	private String institucionEnvioID;
	private String institucionRecibeID;
	private String numCtaInstitEnvio;
	private String numCtaInstitRecibe;
	private String monto;
	private String referencia;
	private String cCostosEnvio;
	private String cCostosRecibe;
	
	public String getInstitucionEnvioID() {
		return institucionEnvioID;
	}
	public void setInstitucionEnvioID(String institucionEnvioID) {
		this.institucionEnvioID = institucionEnvioID;
	}
	public String getInstitucionRecibeID() {
		return institucionRecibeID;
	}
	public void setInstitucionRecibeID(String institucionRecibeID) {
		this.institucionRecibeID = institucionRecibeID;
	}
	public String getNumCtaInstitEnvio() {
		return numCtaInstitEnvio;
	}
	public void setNumCtaInstitEnvio(String numCtaInstitEnvio) {
		this.numCtaInstitEnvio = numCtaInstitEnvio;
	}
	public String getNumCtaInstitRecibe() {
		return numCtaInstitRecibe;
	}
	public void setNumCtaInstitRecibe(String numCtaInstitRecibe) {
		this.numCtaInstitRecibe = numCtaInstitRecibe;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getcCostosEnvio() {
		return cCostosEnvio;
	}
	public void setcCostosEnvio(String cCostosEnvio) {
		this.cCostosEnvio = cCostosEnvio;
	}
	public String getcCostosRecibe() {
		return cCostosRecibe;
	}
	public void setcCostosRecibe(String cCostosRecibe) {
		this.cCostosRecibe = cCostosRecibe;
	}
	
}
