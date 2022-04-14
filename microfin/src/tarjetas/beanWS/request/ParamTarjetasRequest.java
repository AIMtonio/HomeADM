package tarjetas.beanWS.request;

import general.bean.BaseBeanWS;

public class ParamTarjetasRequest extends BaseBeanWS {

	private String rutaConWSAutoriza;
	private String timeOutConWSAutoriza;
	private String usuarioConWSAutoriza;

	public String getRutaConWSAutoriza() {
		return rutaConWSAutoriza;
	}
	public void setRutaConWSAutoriza(String rutaConWSAutoriza) {
		this.rutaConWSAutoriza = rutaConWSAutoriza;
	}
	public String getTimeOutConWSAutoriza() {
		return timeOutConWSAutoriza;
	}
	public void setTimeOutConWSAutoriza(String timeOutConWSAutoriza) {
		this.timeOutConWSAutoriza = timeOutConWSAutoriza;
	}
	public String getUsuarioConWSAutoriza() {
		return usuarioConWSAutoriza;
	}
	public void setUsuarioConWSAutoriza(String usuarioConWSAutoriza) {
		this.usuarioConWSAutoriza = usuarioConWSAutoriza;
	}
}
