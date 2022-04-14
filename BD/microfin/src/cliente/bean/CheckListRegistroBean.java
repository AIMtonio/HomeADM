
package cliente.bean;

import java.util.List;

import general.bean.BaseBean;
public class CheckListRegistroBean extends BaseBean{
	//Declaracion de Constantes
	
	private String empresaID;
	private String tipoPersona;
	private String comentarios;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String clienteID;	
	private String grupoDocumentoID;
	private String tipoDocumentoID;
	private String datosGridDocEnt;
	private String docAceptado;
	private String instrumento;
	private String tipoInstrumento;
	
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
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
	public String getGrupoDocumentoID() {
		return grupoDocumentoID;
	}
	public void setGrupoDocumentoID(String grupoDocumentoID) {
		this.grupoDocumentoID = grupoDocumentoID;
	}
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}

	public String getDatosGridDocEnt() {
		return datosGridDocEnt;
	}
	public void setDatosGridDocEnt(String datosGridDocEnt) {
		this.datosGridDocEnt = datosGridDocEnt;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getDocAceptado() {
		return docAceptado;
	}
	public void setDocAceptado(String docAceptado) {
		this.docAceptado = docAceptado;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	

	

}
