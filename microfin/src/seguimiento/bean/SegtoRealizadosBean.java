package seguimiento.bean;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class SegtoRealizadosBean extends BaseBean{
	private MultipartFile file;
	// tabla SEGTOREALIZADOS
	private String segtoPrograID;
	private String segtoRealizaID;
	private String categoriaID;
	private String usuarioSegto;
	private String fechaSegto;
	private String horaCaptura;
	private String tipoContacto;
	private String nombreContacto;
	private String clienteEnterado;
	private String fechaCaptura;
	private String comentario;
	private String resultadoSegtoID;
	private String fechaSegtoFor;
	private String horaSegtoFor;
	private String recomendacionSegtoID;
	private String segdaRecomendaSegtoID;
	private String estatus;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String tipoDocumento;
	private String observacion;
	private String recurso;
	
	// Auxiliares
	private List folioID;
	private List nombreArchivo;
	private List tipoDocID;
	private List comentaAdjunto;
	private List rutaArchivo;
	
	private String telefonFijo;
	private String telefonCel;
	
	public String getSegtoPrograID() {
		return segtoPrograID;
	}
	public void setSegtoPrograID(String segtoPrograID) {
		this.segtoPrograID = segtoPrograID;
	}
	public String getSegtoRealizaID() {
		return segtoRealizaID;
	}
	public void setSegtoRealizaID(String segtoRealizaID) {
		this.segtoRealizaID = segtoRealizaID;
	}
	public String getCategoriaID() {
		return categoriaID;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public String getUsuarioSegto() {
		return usuarioSegto;
	}
	public void setUsuarioSegto(String usuarioSegto) {
		this.usuarioSegto = usuarioSegto;
	}
	public String getFechaSegto() {
		return fechaSegto;
	}
	public void setFechaSegto(String fechaSegto) {
		this.fechaSegto = fechaSegto;
	}
	public String getHoraCaptura() {
		return horaCaptura;
	}
	public void setHoraCaptura(String horaCaptura) {
		this.horaCaptura = horaCaptura;
	}
	public String getTipoContacto() {
		return tipoContacto;
	}
	public void setTipoContacto(String tipoContacto) {
		this.tipoContacto = tipoContacto;
	}
	public String getNombreContacto() {
		return nombreContacto;
	}
	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}
	public String getClienteEnterado() {
		return clienteEnterado;
	}
	public void setClienteEnterado(String clienteEnterado) {
		this.clienteEnterado = clienteEnterado;
	}
	public String getFechaCaptura() {
		return fechaCaptura;
	}
	public void setFechaCaptura(String fechaCaptura) {
		this.fechaCaptura = fechaCaptura;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getResultadoSegtoID() {
		return resultadoSegtoID;
	}
	public void setResultadoSegtoID(String resultadoSegtoID) {
		this.resultadoSegtoID = resultadoSegtoID;
	}
	public String getFechaSegtoFor() {
		return fechaSegtoFor;
	}
	public void setFechaSegtoFor(String fechaSegtoFor) {
		this.fechaSegtoFor = fechaSegtoFor;
	}
	public String getRecomendacionSegtoID() {
		return recomendacionSegtoID;
	}
	public void setRecomendacionSegtoID(String recomendacionSegtoID) {
		this.recomendacionSegtoID = recomendacionSegtoID;
	}
	public String getSegdaRecomendaSegtoID() {
		return segdaRecomendaSegtoID;
	}
	public void setSegdaRecomendaSegtoID(String segdaRecomendaSegtoID) {
		this.segdaRecomendaSegtoID = segdaRecomendaSegtoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public String getHoraSegtoFor() {
		return horaSegtoFor;
	}
	public void setHoraSegtoFor(String horaSegtoFor) {
		this.horaSegtoFor = horaSegtoFor;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public List getFolioID() {
		return folioID;
	}
	public void setFolioID(List folioID) {
		this.folioID = folioID;
	}
	public List getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(List nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public List getTipoDocID() {
		return tipoDocID;
	}
	public void setTipoDocID(List tipoDocID) {
		this.tipoDocID = tipoDocID;
	}
	public List getComentaAdjunto() {
		return comentaAdjunto;
	}
	public void setComentaAdjunto(List comentaAdjunto) {
		this.comentaAdjunto = comentaAdjunto;
	}
	public List getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(List rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public String getTelefonFijo() {
		return telefonFijo;
	}
	public void setTelefonFijo(String telefonFijo) {
		this.telefonFijo = telefonFijo;
	}
	public String getTelefonCel() {
		return telefonCel;
	}
	public void setTelefonCel(String telefonCel) {
		this.telefonCel = telefonCel;
	}
	
}
