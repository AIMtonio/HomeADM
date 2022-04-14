package credito.bean;

import general.bean.BaseBean;

public class ConciliadoPagBean extends BaseBean {

	private String creditoID;
	private String transaccion;
	private String monto;
	private String fechaOperacion;
	private String claveProm;
	private String conciliado;
	private String origenPago;

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

	public String getTransaccion() {
		return transaccion;
	}

	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public String getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getClaveProm() {
		return claveProm;
	}

	public void setClaveProm(String claveProm) {
		this.claveProm = claveProm;
	}

	public String getConciliado() {
		return conciliado;
	}

	public void setConciliado(String conciliado) {
		this.conciliado = conciliado;
	}

	public String getOrigenPago() {
		return origenPago;
	}

	public void setOrigenPago(String origenPago) {
		this.origenPago = origenPago;
	}

}
