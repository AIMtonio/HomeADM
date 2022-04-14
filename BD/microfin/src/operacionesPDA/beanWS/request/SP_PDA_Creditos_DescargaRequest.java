package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDA_Creditos_DescargaRequest extends BaseBeanWS{
	private String Id_Segmento;

	public String getId_Segmento() {
		return Id_Segmento;
	}

	public void setId_Segmento(String id_Segmento) {
		Id_Segmento = id_Segmento;
	}
	
}