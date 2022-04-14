package cliente.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.MultipartFile;

public class ClienteArchivosBean extends BaseBean{

	private MultipartFile file;

	private String clienteArchivosID;
	private String clienteID;
	private String prospectoID;
	private String empresaID;
	private String tipoDocumento;
	private String consecutivo;
	private String observacion;
	private String recurso;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String instrumento;
	private String fechaRegistro;
	private String fechaExpira;
	
	
	// auxiliares del bean
	private String extension;
	private String numeroDocumentos;
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String nombreCompleto;
	private String nombreCliente; //nombre completo del cliente
	private String nombreProspecto; //nombre completo del prospecto
	private String hora;			
	private String descTipDoc;		//Descripción del tipo de documento
	/******* Reporte******/
	private String fechaInicio;
	private String fechaFinal;
	private String fechaSistema;
	private String horaEmision;
	private String tituloReporte;
	private String nivelRiesgo;
	private String nivelRiesgoDes;
	private String estatus;
	private String estatusDes;
	private String sucursalDes;
	private String comentario;
	private String descTipoDoc;

	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreProspecto() {
		return nombreProspecto;
	}
	public void setNombreProspecto(String nombreProspecto) {
		this.nombreProspecto = nombreProspecto;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
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
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
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
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNumeroDocumentos() {
		return numeroDocumentos;
	}
	public void setNumeroDocumentos(String numeroDocumentos) {
		this.numeroDocumentos = numeroDocumentos;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getClienteArchivosID() {
		return clienteArchivosID;
	}
	public void setClienteArchivosID(String clienteArchivosID) {
		this.clienteArchivosID = clienteArchivosID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getDescTipDoc() {
		return descTipDoc;
	}
	public void setDescTipDoc(String descTipDoc) {
		this.descTipDoc = descTipDoc;
	}
	public String getFechaExpira() {
		return fechaExpira;
	}
	public void setFechaExpira(String fechaExpira) {
		this.fechaExpira = fechaExpira;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getTituloReporte() {
		return tituloReporte;
	}
	public void setTituloReporte(String tituloReporte) {
		this.tituloReporte = tituloReporte;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNivelRiesgoDes() {
		return nivelRiesgoDes;
	}
	public void setNivelRiesgoDes(String nivelRiesgoDes) {
		this.nivelRiesgoDes = nivelRiesgoDes;
	}
	public String getEstatusDes() {
		return estatusDes;
	}
	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
	}
	public String getSucursalDes() {
		return sucursalDes;
	}
	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getDescTipoDoc() {
		return descTipoDoc;
	}
	public void setDescTipoDoc(String descTipoDoc) {
		this.descTipoDoc = descTipoDoc;
	}

}
