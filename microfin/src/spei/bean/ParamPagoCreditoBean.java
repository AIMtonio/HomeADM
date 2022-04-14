package spei.bean;

import general.bean.BaseBean;

public class ParamPagoCreditoBean extends BaseBean{
	
	private String numEmpresaID;		// Numero de la empresa
	private String aplicaPagAutCre;		// Aplica pago automatico
	private String enCasoTieneExiCre;	// En caso de tener Exigible
	private String enCasoSobrantePagCre;// En caso de tener sobrante el pago de credito
	
	
	
	public String getNumEmpresaID() {
		return numEmpresaID;
	}
	public void setNumEmpresaID(String numEmpresaID) {
		this.numEmpresaID = numEmpresaID;
	}
	public String getAplicaPagAutCre() {
		return aplicaPagAutCre;
	}
	public void setAplicaPagAutCre(String aplicaPagAutCre) {
		this.aplicaPagAutCre = aplicaPagAutCre;
	}
	public String getEnCasoTieneExiCre() {
		return enCasoTieneExiCre;
	}
	public void setEnCasoTieneExiCre(String enCasoTieneExiCre) {
		this.enCasoTieneExiCre = enCasoTieneExiCre;
	}
	public String getEnCasoSobrantePagCre() {
		return enCasoSobrantePagCre;
	}
	public void setEnCasoSobrantePagCre(String enCasoSobrantePagCre) {
		this.enCasoSobrantePagCre = enCasoSobrantePagCre;
	}
	
	
	

}
