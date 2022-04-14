package tarjetas.bean;

import java.util.List;

import general.bean.BaseBean;

public class ParamTarjetasBean extends BaseBean {

	private String autorizaTerceroTranTD;
	private String rutaConWSAutoriza;
	private String timeOutConWSAutoriza;
	private String usuarioConWSAutoriza;
	private String idEmisor;
	
	private String prefijoEmisor;
	private String rutaConSAFIWS;
	private String timeOutConSAFIWS;
	private String usuarioConSAFIWS;
	
	private String llaveParametro;
	private String valorParametro;
	private List<String> listaLlaveParametro;	
	private List<String> listaValorParametro;

	public String getAutorizaTerceroTranTD() {
		return autorizaTerceroTranTD;
	}
	public void setAutorizaTerceroTranTD(String autorizaTerceroTranTD) {
		this.autorizaTerceroTranTD = autorizaTerceroTranTD;
	}
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
	public String getIDEmisor() {
		return idEmisor;
	}
	public void setIDEmisor(String idEmisor) {
		this.idEmisor = idEmisor;
	}
	public String getPrefijoEmisor() {
		return prefijoEmisor;
	}
	public void setPrefijoEmisor(String prefijoEmisor) {
		this.prefijoEmisor = prefijoEmisor;
	}
	public String getRutaConSAFIWS() {
		return rutaConSAFIWS;
	}
	public void setRutaConSAFIWS(String rutaConSAFIWS) {
		this.rutaConSAFIWS = rutaConSAFIWS;
	}
	public String getTimeOutConSAFIWS() {
		return timeOutConSAFIWS;
	}
	public void setTimeOutConSAFIWS(String timeOutConSAFIWS) {
		this.timeOutConSAFIWS = timeOutConSAFIWS;
	}
	public String getUsuarioConSAFIWS() {
		return usuarioConSAFIWS;
	}
	public void setUsuarioConSAFIWS(String usuarioConSAFIWS) {
		this.usuarioConSAFIWS = usuarioConSAFIWS;
	}
	public String getLlaveParametro() {
		return llaveParametro;
	}
	public void setLlaveParametro(String llaveParametro) {
		this.llaveParametro = llaveParametro;
	}
	public String getValorParametro() {
		return valorParametro;
	}
	public void setValorParametro(String valorParametro) {
		this.valorParametro = valorParametro;
	}
	public List<String> getListaLlaveParametro() {
		return listaLlaveParametro;
	}
	public void setListaLlaveParametro(List<String> listaLlaveParametro) {
		this.listaLlaveParametro = listaLlaveParametro;
	}
	public List<String> getListaValorParametro() {
		return listaValorParametro;
	}
	public void setListaValorParametro(List<String> listaValorParametro) {
		this.listaValorParametro = listaValorParametro;
	}
}
