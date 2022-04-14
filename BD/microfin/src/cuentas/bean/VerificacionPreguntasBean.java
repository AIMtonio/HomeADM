package cuentas.bean;

import general.bean.BaseBean;

public class VerificacionPreguntasBean extends BaseBean{

	private String clienteID;
	private String numeroTelefono;
	private String fechaNacimiento;
	private String tipoSoporteID;
	
	private String preguntaID;
	private String respuestas;
	private String numPreguntas;
	private String comentarios;
	private String descripcion;
	
	private String usuarioID;

	//seccion de seguimiento
	private String seguimientoID;
	private String consecutivoID;
	private String nombreCompleto;
	private String comentarioUsuario;
	private String comentarioCliente;
	private String estatus;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNumeroTelefono() {
		return numeroTelefono;
	}
	public void setNumeroTelefono(String numeroTelefono) {
		this.numeroTelefono = numeroTelefono;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getTipoSoporteID() {
		return tipoSoporteID;
	}
	public void setTipoSoporteID(String tipoSoporteID) {
		this.tipoSoporteID = tipoSoporteID;
	}
	public String getPreguntaID() {
		return preguntaID;
	}
	public void setPreguntaID(String preguntaID) {
		this.preguntaID = preguntaID;
	}
	public String getRespuestas() {
		return respuestas;
	}
	public void setRespuestas(String respuestas) {
		this.respuestas = respuestas;
	}
	public String getNumPreguntas() {
		return numPreguntas;
	}
	public void setNumPreguntas(String numPreguntas) {
		this.numPreguntas = numPreguntas;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	//seccion de seguimiento
	public String getSeguimientoID() {
		return seguimientoID;
	}
	public void setSeguimientoID(String seguimientoID) {
		this.seguimientoID = seguimientoID;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getComentarioUsuario() {
		return comentarioUsuario;
	}
	public void setComentarioUsuario(String comentarioUsuario) {
		this.comentarioUsuario = comentarioUsuario;
	}
	public String getComentarioCliente() {
		return comentarioCliente;
	}
	public void setComentarioCliente(String comentarioCliente) {
		this.comentarioCliente = comentarioCliente;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}
