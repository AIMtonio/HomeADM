package soporte.beanWS.request;

import general.bean.BaseBeanWS;

public class ParametrosSistemaSafiRequest extends BaseBeanWS{
	private String empresaID;

	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
}
