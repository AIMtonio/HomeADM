package ventanilla.bean;

import general.bean.BaseBean;

public class RemesasPagadasRepBean extends BaseBean{
	
	//Parametros SP
	private String remesadoraID;
	private String sucursalID;
	private String usuarioID;
	private String presentacion;
	private String fechaInicial;
	private String fechaFinal;
	
	//Respuesta SP
	private String fechaDePago;
	private String remesadora;
	private String referencia;
	private String sucursal;
	private String cliente;
	private String monto;
	private String cajero;
	private String formaDePago;
	private String billetesMil;
	private String billetesQuinientos;
	private String billetesDoscientos;
	private String billetesCien;
	private String billetesCincuenta;
	private String billetesVeinte;
	private String monedas;
	private String NoImpresiones;
	
	//Reporte
	private String nombreUsuario;
	private String fechaSistema;
	private String nombreInstitucion;
	private String usuarioSistema;
	
	public String getRemesadoraID() {
		return remesadoraID;
	}
	public void setRemesadoraID(String remesadoraID) {
		this.remesadoraID = remesadoraID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getPresentacion() {
		return presentacion;
	}
	public void setPresentacion(String presentacion) {
		this.presentacion = presentacion;
	}
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getFechaDePago() {
		return fechaDePago;
	}
	public void setFechaDePago(String fechaDePago) {
		this.fechaDePago = fechaDePago;
	}
	public String getRemesadora() {
		return remesadora;
	}
	public void setRemesadora(String remesadora) {
		this.remesadora = remesadora;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getCliente() {
		return cliente;
	}
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getCajero() {
		return cajero;
	}
	public void setCajero(String cajero) {
		this.cajero = cajero;
	}
	public String getFormaDePago() {
		return formaDePago;
	}
	public void setFormaDePago(String formaDePago) {
		this.formaDePago = formaDePago;
	}
	public String getBilletesMil() {
		return billetesMil;
	}
	public void setBilletesMil(String billetesMil) {
		this.billetesMil = billetesMil;
	}
	public String getBilletesQuinientos() {
		return billetesQuinientos;
	}
	public void setBilletesQuinientos(String billetesQuinientos) {
		this.billetesQuinientos = billetesQuinientos;
	}
	public String getBilletesDoscientos() {
		return billetesDoscientos;
	}
	public void setBilletesDoscientos(String billetesDoscientos) {
		this.billetesDoscientos = billetesDoscientos;
	}
	public String getBilletesCien() {
		return billetesCien;
	}
	public void setBilletesCien(String billetesCien) {
		this.billetesCien = billetesCien;
	}
	public String getBilletesCincuenta() {
		return billetesCincuenta;
	}
	public void setBilletesCincuenta(String billetesCincuenta) {
		this.billetesCincuenta = billetesCincuenta;
	}
	public String getBilletesVeinte() {
		return billetesVeinte;
	}
	public void setBilletesVeinte(String billetesVeinte) {
		this.billetesVeinte = billetesVeinte;
	}
	public String getMonedas() {
		return monedas;
	}
	public void setMonedas(String monedas) {
		this.monedas = monedas;
	}
	public String getNoImpresiones() {
		return NoImpresiones;
	}
	public void setNoImpresiones(String noImpresiones) {
		NoImpresiones = noImpresiones;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getUsuarioSistema() {
		return usuarioSistema;
	}
	public void setUsuarioSistema(String usuarioSistema) {
		this.usuarioSistema = usuarioSistema;
	}
	
}
