package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ListaSolicitudCreditoRequest extends BaseBeanWS{
	
	private String negocioAfiliadoID;
	private String institNominaID;
	private String clienteID;
	private String prospectoID;
	private String estatus;
	private String tipoCon;
	
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}

	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoCon() {
		return tipoCon;
	}
	public void setTipoCon(String tipoCon) {
		this.tipoCon = tipoCon;
	}

}
