package sms.bean;

import java.util.Date;

import general.bean.BaseBean;

public class SMSIngresosOpsBean extends BaseBean {

	private String clienteID;
	private String cuentaOrigenID;
	private String cuentaDestinoID;
	private String monto;
	private String comision;
	private String iva;
	private String montoTotal;
	private String claveRastreo;
	private String numTransaccion;
	private String fechaActual;
	private String sucursal;
	private String descServicio;
	
	private int numAlerta;

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getCuentaOrigenID() {
		return cuentaOrigenID;
	}

	public void setCuentaOrigenID(String cuentaOrigenID) {
		this.cuentaOrigenID = cuentaOrigenID;
	}

	public String getCuentaDestinoID() {
		return cuentaDestinoID;
	}

	public void setCuentaDestinoID(String cuentaDestinoID) {
		this.cuentaDestinoID = cuentaDestinoID;
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

	public String getIva() {
		return iva;
	}

	public void setIva(String iva) {
		this.iva = iva;
	}

	public String getMontoTotal() {
		return montoTotal;
	}

	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}

	public String getClaveRastreo() {
		return claveRastreo;
	}

	public void setClaveRastreo(String claveRastreo) {
		this.claveRastreo = claveRastreo;
	}

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	public String getFechaActual() {
		return fechaActual;
	}

	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public int getNumAlerta() {
		return numAlerta;
	}

	public void setNumAlerta(int numAlerta) {
		this.numAlerta = numAlerta;
	}

	public String getDescServicio() {
		return descServicio;
	}

	public void setDescServicio(String descServicio) {
		this.descServicio = descServicio;
	}

	public String toJson()
	{
		String json = "";
		json += "{";
		if(clienteID!=null)
		json += "\"ClienteID\":\""+clienteID+"\",";
		if(cuentaOrigenID!=null)
		json += "\"CuentaOrigenID\":\""+cuentaOrigenID+"\",";
		if(cuentaDestinoID!=null)
		json += "\"CuentaDestinoID\":\""+cuentaDestinoID+"\",";
		if(monto!=null)
		json += "\"Monto\":"+monto+",";
		if(comision!=null)
		json += "\"Comision\":"+comision+",";
		if(iva!=null)
		json += "\"IVA\":"+iva+",";
		if(montoTotal!=null)
		json += "\"MontoTotal\":"+montoTotal+",";
		if(claveRastreo!=null)
		json += "\"ClaveRastreo\":\""+claveRastreo+"\",";
		if(numTransaccion!=null)
		json += "\"NumTransaccion\":\""+numTransaccion+"\",";
		if(fechaActual!=null)
		json += "\"FechaActual\":\""+fechaActual+"\",";
		if(sucursal!=null)
		json += "\"Sucursal\":\""+sucursal+"\",";
		if(descServicio!=null)
		json += "\"DescServicio\":\""+descServicio+"\",";
		json += "}";
		return json;
	}
}
