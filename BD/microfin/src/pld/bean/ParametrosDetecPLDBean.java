package pld.bean;

import general.bean.BaseBean;

public class ParametrosDetecPLDBean extends BaseBean {
	private String	TipoProceso;
	private String	descripccion;
	private String	enListasBloq;
	private String	enGAFI;
	private String	enListasNeg;

	public String getTipoProceso() {
		return TipoProceso;
	}

	public void setTipoProceso(String tipoProceso) {
		TipoProceso = tipoProceso;
	}

	public String getDescripccion() {
		return descripccion;
	}

	public void setDescripccion(String descripccion) {
		this.descripccion = descripccion;
	}

	public String getEnListasBloq() {
		return enListasBloq;
	}

	public void setEnListasBloq(String enListasBloq) {
		this.enListasBloq = enListasBloq;
	}

	public String getEnGAFI() {
		return enGAFI;
	}

	public void setEnGAFI(String enGAFI) {
		this.enGAFI = enGAFI;
	}

	public String getEnListasNeg() {
		return enListasNeg;
	}

	public void setEnListasNeg(String enListasNeg) {
		this.enListasNeg = enListasNeg;
	}
}
