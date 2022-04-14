package credito.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;
import herramientas.Utileria;

public class CreditosArchivoBean extends BaseBean{
	
	//Declaracion de atributos 
	private String digCreaID;
	private String creditoID;
	private String tipoDocumentoID;
	private String comentario;
	private String recurso;
	private String extension;

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
	private String estatus;
	private String cuentaID;
	private String productoCreditoID;
	private String nombreCliente;
	private String nombreProducto;
	private String grupoID;
	private String nombreGrupo;
	private String ciclo;
	private String clienteID;
	private String descripcionCta;
	private String parFechaEmision;
	
	private String tipoDocumento;
	private String descTipoDoc;
	

	public String getDigCreaID() {
		return digCreaID;
	}
	public void setDigCreaID(String digCreaID) {
		this.digCreaID = digCreaID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
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
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
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
	public String getDescripcionCta() {
		return descripcionCta;
	}
	public void setDescripcionCta(String descripcionCta) {
		this.descripcionCta = descripcionCta;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getDescTipoDoc() {
		return descTipoDoc;
	}
	public void setDescTipoDoc(String descTipoDoc) {
		this.descTipoDoc = descTipoDoc;
	}
	
}
