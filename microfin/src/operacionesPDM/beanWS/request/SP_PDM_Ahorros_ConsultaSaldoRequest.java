package operacionesPDM.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDM_Ahorros_ConsultaSaldoRequest extends BaseBeanWS {
	
	private String CuentaID;

	public String getCuentaID() {
		return CuentaID;
	}

	public void setCuentaID(String cuentaID) {
		CuentaID = cuentaID;
	}


}
