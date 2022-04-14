package aportaciones.bean;

import general.bean.BaseBean;

public class GruposFamiliarBean extends BaseBean {

	private String clienteID;
	private String nomCliente;
	private String famClienteID;
	private String nomFamiliar;
	private String tipoRelacionID;
	private String descRelacion;
	private String existe;
	private String mensaje;
	private String detalle;

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getNomCliente() {
		return nomCliente;
	}

	public void setNomCliente(String nomCliente) {
		this.nomCliente = nomCliente;
	}

	public String getFamClienteID() {
		return famClienteID;
	}

	public void setFamClienteID(String famClienteID) {
		this.famClienteID = famClienteID;
	}

	public String getNomFamiliar() {
		return nomFamiliar;
	}

	public void setNomFamiliar(String nomFamiliar) {
		this.nomFamiliar = nomFamiliar;
	}

	public String getTipoRelacionID() {
		return tipoRelacionID;
	}

	public void setTipoRelacionID(String tipoRelacionID) {
		this.tipoRelacionID = tipoRelacionID;
	}

	public String getDescRelacion() {
		return descRelacion;
	}

	public void setDescRelacion(String descRelacion) {
		this.descRelacion = descRelacion;
	}

	public String getExiste() {
		return existe;
	}

	public void setExiste(String existe) {
		this.existe = existe;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	public String getDetalle() {
		return detalle;
	}

	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}

}