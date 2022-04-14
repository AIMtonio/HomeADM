package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaProdCredRequest extends BaseBeanWS {
	
	private String producCreditoID;
	private String sucursalID;
	private String empresaID;

	public String getProducCreditoID() {
		return producCreditoID;
	}

	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getEmpresaID() {
		return empresaID;
	}

	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

}
