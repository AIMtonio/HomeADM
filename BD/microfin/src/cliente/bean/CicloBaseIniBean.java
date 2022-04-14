package cliente.bean;

import general.bean.BaseBean;

public class CicloBaseIniBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID = 10;
	public static String  PER_FISICA="F" ;
	public static String  PER_MORAL="M" ;
	public static String  NO_PAGA_IVA="N" ;
	public static String  SI_PAGA_IVA="S" ;
	
	
	private String clienteID;
	private String prospectoID;
	private String productoCreditoID;
	private String cicloBaseIni;
	
	private String outclienteID;
	private String outNumErr;
	private String outErrMen;
	private String salida;

	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;


	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getOutclienteID() {
		return outclienteID;
	}
	public void setOutclienteID(String outclienteID) {
		this.outclienteID = outclienteID;
	}
	public String getOutNumErr() {
		return outNumErr;
	}
	public void setOutNumErr(String outNumErr) {
		this.outNumErr = outNumErr;
	}
	public String getOutErrMen() {
		return outErrMen;
	}
	public void setOutErrMen(String outErrMen) {
		this.outErrMen = outErrMen;
	}
	public String getSalida() {
		return salida;
	}
	public void setSalida(String salida) {
		this.salida = salida;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getCicloBaseIni() {
		return this.cicloBaseIni;
	}
	public void setCicloBaseIni(String cicloBaseIni) {
		this.cicloBaseIni = cicloBaseIni;
	}
	
	
}
