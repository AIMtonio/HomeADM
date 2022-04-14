package bancaMovil.bean;

import general.bean.BaseBean;

public class BAMPerfilBean extends BaseBean {

	private String identificador;
	private String perfilID;
	private String nombrePerfil;
	private String descripcion;
	private String accesoConToken;
	private String transacConToken;
	private String costoPrimeraVez;
	private String costoMensual;
//CAMPOS DE AUDITORIA
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	public String getIdentificador() {
		return identificador;
	}

	public void setIdentificador(String identificador) {
		this.identificador = identificador;
	}

	public String getPerfilID() {
		return perfilID;
	}

	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}

	public String getNombrePerfil() {
		return nombrePerfil;
	}

	public void setNombrePerfil(String nombrePerfil) {
		this.nombrePerfil = nombrePerfil;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getAccesoConToken() {
		return accesoConToken;
	}

	public void setAccesoConToken(String accesoConToken) {
		this.accesoConToken = accesoConToken;
	}

	public String getTransacConToken() {
		return transacConToken;
	}

	public void setTransacConToken(String transacConToken) {
		this.transacConToken = transacConToken;
	}

	public String getCostoPrimeraVez() {
		return costoPrimeraVez;
	}

	public void setCostoPrimeraVez(String costoPrimeraVez) {
		this.costoPrimeraVez = costoPrimeraVez;
	}

	public String getCostoMensual() {
		return costoMensual;
	}

	public void setCostoMensual(String costoMensual) {
		this.costoMensual = costoMensual;
	}

	public String getEmpresaID() {
		return empresaID;
	}

	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
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

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

}
