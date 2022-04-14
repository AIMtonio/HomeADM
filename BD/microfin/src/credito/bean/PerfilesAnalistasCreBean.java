package credito.bean;

import java.util.List;

import general.bean.BaseBean;



public class PerfilesAnalistasCreBean extends BaseBean {

	private String hisPerfilID;
	private String tipoLista;
	private String detalleAnalistas;
	private String detalleEjecutivos;
	private List listaAnalistas;
	private String perfilExpediente;


	private String perfilID;
	private String rolID;
	private String tipoPerfil;
	private String nombreRol;
	
	//datos de auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	
	
	

	public String getHisPerfilID() {
		return hisPerfilID;
	}
	public void setHisPerfilID(String hisPerfilID) {
		this.hisPerfilID = hisPerfilID;
	}
	public String getPerfilExpediente() {
		return perfilExpediente;
	}
	public void setPerfilExpediente(String perfilExpediente) {
		this.perfilExpediente = perfilExpediente;
	}
	public String getTipoLista() {
		return tipoLista;
	}
	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}
	public String getDetalleAnalistas() {
		return detalleAnalistas;
	}
	public void setDetalleAnalistas(String detalleAnalistas) {
		this.detalleAnalistas = detalleAnalistas;
	}
	public String getDetalleEjecutivos() {
		return detalleEjecutivos;
	}
	public void setDetalleEjecutivos(String detalleEjecutivos) {
		this.detalleEjecutivos = detalleEjecutivos;
	}
	public List getListaAnalistas() {
		return listaAnalistas;
	}
	public void setListaAnalistas(List listaAnalistas) {
		this.listaAnalistas = listaAnalistas;
	}
	public String getPerfilID() {
		return perfilID;
	}
	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}
	public String getRolID() {
		return rolID;
	}
	public void setRolID(String rolID) {
		this.rolID = rolID;
	}
	public String getTipoPerfil() {
		return tipoPerfil;
	}
	public void setTipoPerfil(String tipoPerfil) {
		this.tipoPerfil = tipoPerfil;
	}
	public String getNombreRol() {
		return nombreRol;
	}
	public void setNombreRol(String nombreRol) {
		this.nombreRol = nombreRol;
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
