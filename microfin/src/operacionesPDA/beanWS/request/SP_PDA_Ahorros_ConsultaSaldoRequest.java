package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDA_Ahorros_ConsultaSaldoRequest extends BaseBeanWS{
  private 	String CuentaAltaID;

public String getCuentaAltaID() {
	return CuentaAltaID;
}

public void setCuentaAltaID(String cuentaAltaID) {
	CuentaAltaID = cuentaAltaID;
}
	
}
