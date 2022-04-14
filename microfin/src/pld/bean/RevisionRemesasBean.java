package pld.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class RevisionRemesasBean extends BaseBean{
	private String remesaFolioID;
	private String remesadora;
	private String clienteID;
	private String usuarioServicioID;
	private String monto;
	
	private String direccion;
	private String motivoRevision;
	private String formaPago;
	private String identificacion;
	private String permiteOperacion;
	
	private String comentario;
	private String checkListRemWSID;
	private String tipoDocumentoID;
	private String descripcion;
	private String descripcionDoc;
	
	private String recurso;
	private String extension;
	private String nombreCompleto;
	private String estatus;
	private String numeroDocumentos;
	
	private String nombreCliente;
	private String nombreUsuario;
	private String usuario;
	private String fechaEmision;

	private String nombreInstitucion;
	private String hora;
	
	private MultipartFile file;
	private String clabeCobroRemesa;
	private String numTelefonico;
	private String nombreCompletoRemit;
	private String paisIDRemitente;
	private String estadoIDRemitente;
	private String ciudadIDRemitente;
	private String coloniaIDRemitente;
	private String codigoPostalRemitente;
	private String direcRemitente;
	private String folioIdentificRemit;
	private String tipoIdentiIDRemit;
	private String folioIdentific;
	private String tipoIdentiID;
	
	private String origenDoc;

	public String getRemesaFolioID() {
		return remesaFolioID;
	}

	public void setRemesaFolioID(String remesaFolioID) {
		this.remesaFolioID = remesaFolioID;
	}

	public String getRemesadora() {
		return remesadora;
	}

	public void setRemesadora(String remesadora) {
		this.remesadora = remesadora;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getUsuarioServicioID() {
		return usuarioServicioID;
	}

	public void setUsuarioServicioID(String usuarioServicioID) {
		this.usuarioServicioID = usuarioServicioID;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getMotivoRevision() {
		return motivoRevision;
	}

	public void setMotivoRevision(String motivoRevision) {
		this.motivoRevision = motivoRevision;
	}

	public String getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}

	public String getIdentificacion() {
		return identificacion;
	}

	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}

	public String getPermiteOperacion() {
		return permiteOperacion;
	}

	public void setPermiteOperacion(String permiteOperacion) {
		this.permiteOperacion = permiteOperacion;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public String getCheckListRemWSID() {
		return checkListRemWSID;
	}

	public void setCheckListRemWSID(String checkListRemWSID) {
		this.checkListRemWSID = checkListRemWSID;
	}

	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}

	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionDoc() {
		return descripcionDoc;
	}

	public void setDescripcionDoc(String descripcionDoc) {
		this.descripcionDoc = descripcionDoc;
	}

	public String getRecurso() {
		return recurso;
	}

	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}

	public String getExtension() {
		return extension;
	}

	public void setExtension(String extension) {
		this.extension = extension;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	
	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getNumeroDocumentos() {
		return numeroDocumentos;
	}

	public void setNumeroDocumentos(String numeroDocumentos) {
		this.numeroDocumentos = numeroDocumentos;
	}

	public String getNombreCliente() {
		return nombreCliente;
	}

	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getHora() {
		return hora;
	}

	public void setHora(String hora) {
		this.hora = hora;
	}

	public String getClabeCobroRemesa() {
		return clabeCobroRemesa;
	}

	public void setClabeCobroRemesa(String clabeCobroRemesa) {
		this.clabeCobroRemesa = clabeCobroRemesa;
	}


	public String getNumTelefonico() {
		return numTelefonico;
	}

	public void setNumTelefonico(String numTelefonico) {
		this.numTelefonico = numTelefonico;
	}

	public String getNombreCompletoRemit() {
		return nombreCompletoRemit;
	}

	public void setNombreCompletoRemit(String nombreCompletoRemit) {
		this.nombreCompletoRemit = nombreCompletoRemit;
	}

	public String getPaisIDRemitente() {
		return paisIDRemitente;
	}

	public void setPaisIDRemitente(String paisIDRemitente) {
		this.paisIDRemitente = paisIDRemitente;
	}

	public String getEstadoIDRemitente() {
		return estadoIDRemitente;
	}

	public void setEstadoIDRemitente(String estadoIDRemitente) {
		this.estadoIDRemitente = estadoIDRemitente;
	}

	public String getCiudadIDRemitente() {
		return ciudadIDRemitente;
	}

	public void setCiudadIDRemitente(String ciudadIDRemitente) {
		this.ciudadIDRemitente = ciudadIDRemitente;
	}

	public String getColoniaIDRemitente() {
		return coloniaIDRemitente;
	}

	public void setColoniaIDRemitente(String coloniaIDRemitente) {
		this.coloniaIDRemitente = coloniaIDRemitente;
	}

	public String getCodigoPostalRemitente() {
		return codigoPostalRemitente;
	}

	public void setCodigoPostalRemitente(String codigoPostalRemitente) {
		this.codigoPostalRemitente = codigoPostalRemitente;
	}

	public String getDirecRemitente() {
		return direcRemitente;
	}

	public void setDirecRemitente(String direcRemitente) {
		this.direcRemitente = direcRemitente;
	}

	public String getFolioIdentificRemit() {
		return folioIdentificRemit;
	}

	public void setFolioIdentificRemit(String folioIdentificRemit) {
		this.folioIdentificRemit = folioIdentificRemit;
	}

	public String getTipoIdentiIDRemit() {
		return tipoIdentiIDRemit;
	}

	public void setTipoIdentiIDRemit(String tipoIdentiIDRemit) {
		this.tipoIdentiIDRemit = tipoIdentiIDRemit;
	}

	public String getFolioIdentific() {
		return folioIdentific;
	}

	public void setFolioIdentific(String folioIdentific) {
		this.folioIdentific = folioIdentific;
	}

	public String getTipoIdentiID() {
		return tipoIdentiID;
	}

	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}

	public String getOrigenDoc() {
		return origenDoc;
	}

	public void setOrigenDoc(String origenDoc) {
		this.origenDoc = origenDoc;
	}
	
	
}
