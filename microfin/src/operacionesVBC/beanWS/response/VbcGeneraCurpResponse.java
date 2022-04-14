package operacionesVBC.beanWS.response;

import general.bean.BaseBeanWS;

public class VbcGeneraCurpResponse extends BaseBeanWS{

	private String curp;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getCurp() {
		return curp;
	}
	public void setCurp(String curp) {
		this.curp = curp;
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
