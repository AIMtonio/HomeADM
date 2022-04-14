package nomina.bean;

import general.bean.BaseBean;

import java.util.List;

public class ReversaPagoNominaBean extends BaseBean{
	private String institNominaID;
	private String nombreInstitucion;
	private String folioCargaID;
	private String motivo;
	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String estatus;
	private String regPendientes;
	private String fechaApliPago;

	private String consecutivo;
	private String creditoID;
	private String noEmpleadoID;
	private String fechaPago;
	private String montoAplicado;
	private String productoCredito;
	
	private List listaFolioNominaID;
	private List listaCredito;
	private List listanoEmpleado;
	private List listaFechaPago;
	private List listaMontoPago;
	private List listaProductoCred;
	
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}
	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getRegPendientes() {
		return regPendientes;
	}
	public void setRegPendientes(String regPendientes) {
		this.regPendientes = regPendientes;
	}
	public String getFechaApliPago() {
		return fechaApliPago;
	}
	public void setFechaApliPago(String fechaApliPago) {
		this.fechaApliPago = fechaApliPago;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNoEmpleadoID() {
		return noEmpleadoID;
	}
	public void setNoEmpleadoID(String noEmpleadoID) {
		this.noEmpleadoID = noEmpleadoID;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoAplicado() {
		return montoAplicado;
	}
	public void setMontoAplicado(String montoAplicado) {
		this.montoAplicado = montoAplicado;
	}
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}	
	public List getListaFolioNominaID() {
		return listaFolioNominaID;
	}
	public void setListaFolioNominaID(List listaFolioNominaID) {
		this.listaFolioNominaID = listaFolioNominaID;
	}
	public List getListaCredito() {
		return listaCredito;
	}
	public void setListaCredito(List listaCredito) {
		this.listaCredito = listaCredito;
	}
	public List getListanoEmpleado() {
		return listanoEmpleado;
	}
	public void setListanoEmpleado(List listanoEmpleado) {
		this.listanoEmpleado = listanoEmpleado;
	}
	public List getListaFechaPago() {
		return listaFechaPago;
	}
	public void setListaFechaPago(List listaFechaPago) {
		this.listaFechaPago = listaFechaPago;
	}
	public List getListaMontoPago() {
		return listaMontoPago;
	}
	public void setListaMontoPago(List listaMontoPago) {
		this.listaMontoPago = listaMontoPago;
	}
	public List getListaProductoCred() {
		return listaProductoCred;
	}
	public void setListaProductoCred(List listaProductoCred) {
		this.listaProductoCred = listaProductoCred;
	}
	
	
	
}
