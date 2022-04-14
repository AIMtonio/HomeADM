package operacionesCRCB.beanWS.request;

public class DesembolsoCreditoRequest extends BaseRequestBean {

	private String creditoID;
	private String grupoID;
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	
	
}
