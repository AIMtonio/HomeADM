package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

public class SP_PDA_Server_FechaHoraResponse extends BaseBeanWS{
	private String FechaHora;

	public String getFechaHora() {
		return FechaHora;
	}

	public void setFechaHora(String fechaHora) {
		FechaHora = fechaHora;
	}
}