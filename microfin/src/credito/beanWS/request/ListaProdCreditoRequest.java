package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ListaProdCreditoRequest extends BaseBeanWS{

	private String perfilID;
	private String numeroLista;


	public String getNumeroLista() {
		return numeroLista;
	}
	public void setNumeroLista(String numeroLista) {
		this.numeroLista = numeroLista;
	}
	public String getPerfilID() {
		return perfilID;
	}
	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}

	


}
