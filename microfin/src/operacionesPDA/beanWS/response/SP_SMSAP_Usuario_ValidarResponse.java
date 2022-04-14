package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

public class SP_SMSAP_Usuario_ValidarResponse extends BaseBeanWS{
		
	private String CodigoResp;
	private String CodigoDesc;
	private String EsValido;
	
	public String getCodigoResp() {
		return CodigoResp;
	}
	public void setCodigoResp(String codigoResp) {
		CodigoResp = codigoResp;
	}
	public String getCodigoDesc() {
		return CodigoDesc;
	}
	public void setCodigoDesc(String codigoDesc) {
		CodigoDesc = codigoDesc;
	}
	public String getEsValido() {
		return EsValido;
	}
	public void setEsValido(String esValido) {
		EsValido = esValido;
	}
}
