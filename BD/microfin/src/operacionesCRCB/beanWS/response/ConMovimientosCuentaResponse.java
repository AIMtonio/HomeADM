package operacionesCRCB.beanWS.response;

import java.util.ArrayList;

import operacionesCRCB.bean.ConMovimientosCuentaBean;

public class ConMovimientosCuentaResponse extends BaseResponseBean {

	private String saldoInicialMes;
	private String abonosMes;
	private String cargosMes;
	private String saldoDisponible;
	
	private ArrayList<ConMovimientosCuentaBean> movimientosCuenta = new ArrayList<ConMovimientosCuentaBean>();
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getSaldoInicialMes() {
		return saldoInicialMes;
	}
	public void setSaldoInicialMes(String saldoInicialMes) {
		this.saldoInicialMes = saldoInicialMes;
	}
	public String getAbonosMes() {
		return abonosMes;
	}
	public void setAbonosMes(String abonosMes) {
		this.abonosMes = abonosMes;
	}
	public String getCargosMes() {
		return cargosMes;
	}
	public void setCargosMes(String cargosMes) {
		this.cargosMes = cargosMes;
	}
	public String getSaldoDisponible() {
		return saldoDisponible;
	}
	public void setSaldoDisponible(String saldoDisponible) {
		this.saldoDisponible = saldoDisponible;
	}
	public ArrayList<ConMovimientosCuentaBean> getMovimientosCuenta() {
		return movimientosCuenta;
	}
	public void setMovimientosCuenta(
			ArrayList<ConMovimientosCuentaBean> movimientosCuenta) {
		this.movimientosCuenta = movimientosCuenta;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	
	public void addCuenta(ConMovimientosCuentaBean movimientosCuenta){  
        this.movimientosCuenta.add(movimientosCuenta);  
	}
}
