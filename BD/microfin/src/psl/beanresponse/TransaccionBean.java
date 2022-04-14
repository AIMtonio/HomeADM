package psl.beanresponse;

public class TransaccionBean {
	private String numTransaccion;
	private String numAutorizacion;
	private String fecha;
	private String monto;
	private String comision;
	private String referencia;
	private String saldoRecarga;
	private String saldoServicio;
	
	
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNumAutorizacion() {
		return numAutorizacion;
	}
	public void setNumAutorizacion(String numAutorizacion) {
		this.numAutorizacion = numAutorizacion;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getSaldoRecarga() {
		return saldoRecarga;
	}
	public void setSaldoRecarga(String saldoRecarga) {
		this.saldoRecarga = saldoRecarga;
	}
	public String getSaldoServicio() {
		return saldoServicio;
	}
	public void setSaldoServicio(String saldoServicio) {
		this.saldoServicio = saldoServicio;
	}
}
