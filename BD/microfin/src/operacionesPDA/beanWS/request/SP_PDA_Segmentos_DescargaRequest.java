package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDA_Segmentos_DescargaRequest extends BaseBeanWS{
	private String Id_Sucursal;

	public String getId_Sucursal() {
		return Id_Sucursal;
	}

	public void setId_Sucursal(String id_Sucursal) {
		Id_Sucursal = id_Sucursal;
	}	
}
