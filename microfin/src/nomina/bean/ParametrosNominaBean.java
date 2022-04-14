package nomina.bean;

import general.bean.BaseBean;

public class ParametrosNominaBean extends BaseBean{
	private String empresaID;
	private String correoElectronico;
	private String ctaPagoTransito;
	private String tipoMovTesoID;
	private String nomenclaturaCR;
	private String perfilAutCalend;
	
	private String ctaTransDomicilia;
	private String tipoMovDomiciliaID;
	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getCorreoElectronico() {
		return correoElectronico;
	}
	public void setCorreoElectronico(String correoElectronico) {
		this.correoElectronico = correoElectronico;
	}
	public String getCtaPagoTransito() {
		return ctaPagoTransito;
	}
	public void setCtaPagoTransito(String ctaPagoTransito) {
		this.ctaPagoTransito = ctaPagoTransito;
	}
	public String getTipoMovTesoID() {
		return tipoMovTesoID;
	}
	public void setTipoMovTesoID(String tipoMovTesoID) {
		this.tipoMovTesoID = tipoMovTesoID;
	}
	public String getNomenclaturaCR() {
		return nomenclaturaCR;
	}
	public void setNomenclaturaCR(String nomenclaturaCR) {
		this.nomenclaturaCR = nomenclaturaCR;
	}
	public String getPerfilAutCalend() {
		return perfilAutCalend;
	}
	public void setPerfilAutCalend(String perfilAutCalend) {
		this.perfilAutCalend = perfilAutCalend;
	}

	public String getCtaTransDomicilia() {
		return ctaTransDomicilia;
	}
	public void setCtaTransDomicilia(String ctaTransDomicilia) {
		this.ctaTransDomicilia = ctaTransDomicilia;
	}
	public String getTipoMovDomiciliaID() {
		return tipoMovDomiciliaID;
	}
	public void setTipoMovDomiciliaID(String tipoMovDomiciliaID) {
		this.tipoMovDomiciliaID = tipoMovDomiciliaID;
	}

	
}
