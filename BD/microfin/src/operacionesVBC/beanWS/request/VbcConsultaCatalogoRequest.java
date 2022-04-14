package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcConsultaCatalogoRequest extends BaseBeanWS{
	private String nomCatalogo;

	private String usuario;
	private String clave;
	
	public String getNomCatalogo() {
		return nomCatalogo;
	}

	public void setNomCatalogo(String nomCatalogo) {
		this.nomCatalogo = nomCatalogo;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String clave) {
		this.clave = clave;
	}	
}