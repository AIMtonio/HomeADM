package tarjetas.bean;

import general.bean.BaseBean;

public class TarDebParamBean extends BaseBean{
	//Declaracion de Constantes
	
	private String rutaAclaracion;
	private String maxDiasAclara;
	public String getRutaAclaracion() {
		return rutaAclaracion;
	}
	public void setRutaAclaracion(String rutaAclaracion) {
		this.rutaAclaracion = rutaAclaracion;
	}
	public String getMaxDiasAclara() {
		return maxDiasAclara;
	}
	public void setMaxDiasAclara(String maxDiasAclara) {
		this.maxDiasAclara = maxDiasAclara;
	}
	
}

