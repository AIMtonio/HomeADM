package bancaMovil.bean;

import general.bean.BaseBean;

public class BAMPregutaSecretaBean extends BaseBean {

	private String preguntaSecretaID;
	private String redaccion;

	public String getPreguntaSecretaID() {
		return preguntaSecretaID;
	}

	public void setPreguntaSecretaID(String preguntaSecretaID) {
		this.preguntaSecretaID = preguntaSecretaID;
	}

	public String getRedaccion() {
		return redaccion;
	}

	public void setRedaccion(String redaccion) {
		this.redaccion = redaccion;
	}

}
