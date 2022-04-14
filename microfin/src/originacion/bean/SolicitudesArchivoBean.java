
package originacion.bean;


import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;
import herramientas.Utileria;

public class SolicitudesArchivoBean extends BaseBean{
	
	//Declaracion de atributos 
	private String digSolID;
	private String tipoDocumentoID;
	private String descripcion;
	
	private String comentario;
	private String recurso;
	private String extension;
	private String solicitudCreditoID;
	
	//Atributos de auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direcionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private MultipartFile file;
	
	//Auxiliar del Bean
	private String numeroDocumentos;

	//declaracion atributos del bean
	private String nombreusuario;
	private String nombreInstitucion;
	
	//declaracion de atributos para el reporte
	
	private String clienteID;
	private String nombreCliente;
	private String productoCreditoID;
	private String nombreProducto;
	private String estatus;
	private String prospectoID;
	private String nombreProspecto;
	private String grupoID;
	private String nombreGrupo;
	private String ciclo;

	private String parFechaEmision;
	//Documentos Analista
	private String voBoAnalista;
	private String comentarioAnalista;
	private String descTipoDoc;

	public String getDigSolID() {
		return digSolID;
	}
	public void setDigSolID(String digSolID) {
		this.digSolID = digSolID;
	}
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
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
	public String getDirecionIP() {
		return direcionIP;
	}
	public void setDirecionIP(String direcionIP) {
		this.direcionIP = direcionIP;
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
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	public String getNumeroDocumentos() {
		return numeroDocumentos;
	}
	public void setNumeroDocumentos(String numeroDocumentos) {
		this.numeroDocumentos = numeroDocumentos;
	}
	public String getNombreusuario() {
		return nombreusuario;
	}
	public void setNombreusuario(String nombreusuario) {
		this.nombreusuario = nombreusuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNombreProspecto() {
		return nombreProspecto;
	}
	public void setNombreProspecto(String nombreProspecto) {
		this.nombreProspecto = nombreProspecto;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}	
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getCiclo() {
		return ciclo;
	}
	public void setCiclo(String ciclo) {
		this.ciclo = ciclo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}	
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getVoBoAnalista() {
		return voBoAnalista;
	}
	public void setVoBoAnalista(String voBoAnalista) {
		this.voBoAnalista = voBoAnalista;
	}
	public String getComentarioAnalista() {
		return comentarioAnalista;
	}
	public void setComentarioAnalista(String comentarioAnalista) {
		this.comentarioAnalista = comentarioAnalista;
	}
	public String getDescTipoDoc() {
		return descTipoDoc;
	}
	public void setDescTipoDoc(String descTipoDoc) {
		this.descTipoDoc = descTipoDoc;
	}
	
}
