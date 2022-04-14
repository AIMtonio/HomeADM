package tarjetas.bean;

import general.bean.BaseBean;
public class TarDebLimiteTipoBean extends BaseBean{
	
	private String tipoTarjetaDebID;
	private String descripcion;
	private String montoDisDia;
	private String montoDisMes;
	private String montoComDia;
	private String montoComMes;
	private String bloqueoATM;
	private String bloqueoPOS;
	private String bloqueoCash;
	private String operacionMoto;
	private String numeroDia;
	private String numConsultaMes;

	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getMontoDisDia() {
		return montoDisDia;
	}
	public void setMontoDisDia(String montoDisDia) {
		this.montoDisDia = montoDisDia;
	}
	public String getMontoDisMes() {
		return montoDisMes;
	}
	public void setMontoDisMes(String montoDisMes) {
		this.montoDisMes = montoDisMes;
	}
	public String getMontoComDia() {
		return montoComDia;
	}
	public void setMontoComDia(String montoComDia) {
		this.montoComDia = montoComDia;
	}
	public String getMontoComMes() {
		return montoComMes;
	}
	public void setMontoComMes(String montoComMes) {
		this.montoComMes = montoComMes;
	}
	public String getBloqueoATM() {
		return bloqueoATM;
	}
	public void setBloqueoATM(String bloqueoATM) {
		this.bloqueoATM = bloqueoATM;
	}
	public String getBloqueoPOS() {
		return bloqueoPOS;
	}
	public void setBloqueoPOS(String bloqueoPOS) {
		this.bloqueoPOS = bloqueoPOS;
	}
	public String getBloqueoCash() {
		return bloqueoCash;
	}
	public void setBloqueoCash(String bloqueoCash) {
		this.bloqueoCash = bloqueoCash;
	}
	public String getOperacionMoto() {
		return operacionMoto;
	}
	public void setOperacionMoto(String operacionMoto) {
		this.operacionMoto = operacionMoto;
	}
	public String getNumeroDia() {
		return numeroDia;
	}
	public void setNumeroDia(String numeroDia) {
		this.numeroDia = numeroDia;
	}
	public String getNumConsultaMes() {
		return numConsultaMes;
	}
	public void setNumConsultaMes(String numConsultaMes) {
		this.numConsultaMes = numConsultaMes;
	}	
}