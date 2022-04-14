package soporte.beanWS.response;

import general.bean.BaseBeanWS;

public class ParametrosSistemaSafiResponse extends BaseBeanWS{
	private String fechaSistema;
	private String horaSistema;
	private String fechaHoraSistema;

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getHoraSistema() {
		return horaSistema;
	}

	public void setHoraSistema(String horaSistema) {
		this.horaSistema = horaSistema;
	}

	public String getFechaHoraSistema() {
		return fechaHoraSistema;
	}

	public void setFechaHoraSistema(String fechaHoraSistema) {
		this.fechaHoraSistema = fechaHoraSistema;
	}
	
}
