package operacionesVBC.bean;

import general.bean.BaseBean;

public class VbcConsultaCatalogoBean extends BaseBean{	
	private String campo;
	private String ncampo;
	private String padre;
	private String codigoError;
	private String mensajeError;
	
	public String getCampo() {
		return campo;
	}
	public void setCampo(String campo) {
		this.campo = campo;
	}
	public String getNcampo() {
		return ncampo;
	}
	public void setNcampo(String ncampo) {
		this.ncampo = ncampo;
	}
	public String getPadre() {
		return padre;
	}
	public void setPadre(String padre) {
		this.padre = padre;
	}
	public String getCodigoError() {
		return codigoError;
	}
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
}