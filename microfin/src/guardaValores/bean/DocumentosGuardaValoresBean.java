package guardaValores.bean;

import java.util.List;

import general.bean.BaseBean;

public class DocumentosGuardaValoresBean extends BaseBean {

	private String documentoID;
	private String fechaRegistro;
	private String horaRegistro;
	private String origenDocumento;
	private String grupoDocumentoID;
	
	private String tipoDocumentoID;
	private String tipoInstrumento;
	private String numeroInstrumento;
	private String catInsGrdValoresID;
	private String almacenID;
	
	private String estatus;
	private String sucursalID;
	private String ubicacion;
	private String observaciones;
	private String usuarioRegistroID;
	
	private String descripcionEstatus;
	private String numeroExpedienteID;
	private String participanteID;
	private String tipoPersona;
	private String fechaCustodia;
	
	private String usuarioBajaID;
	private String sucursalBajaID;
	private String fechaBaja;
	private String usuarioProcesaID;
	private String usuarioAutorizaID;
	
	private String usuarioPrestamoID;
	private String usuarioDevolucionID;
	private String prestamoDocGrdValoresID;
	private String seccion;
	private String contrasenia;
	
	private String claveUsuario;
	private String catMovimientoID;
	private String docSustitucionID;	
	private String nombreDocSustitucion;
	private String estatusPrevio;
	private String archivoID;

	// Reporte de Documentos
	private String nombreSucursal;
	private String fechaInicio;
	private String fechaFin;
	private String nombreUsuario;
	private String fechaEmision;
	
	private String horaEmision;
	private String nombreParticipante;
	private String nombreDocumento;
	private String nombreAlmacen;
	private String nombreUsuarioRegistroID;
	
	private String nombreUsuarioProcesa;
	private String nombreUsuarioAutorizaID;
	private String nombreUsuarioProcesaID;
	private String nombreInstitucion;
	private String nombreTipoInstrumento;
	private String nombreNumeroInstrumento;
	
	private String rangoFechas;
	private String descripcion;
	private String consecutivo;
	private String usuarioInicial;	
	private String usuarioFinal;
	private String fechaDevolucion;
	
	// Lista para los grids
	private List listaDocumentoID;
	private List listaOrigenDocumento;
	private List listaGrupoDocumentoID;
	private List listaTipoDocumentoID;
	private List listaNombreDocumento;
	private List listaArchivoID;
	
	public String getDocumentoID() {
		return documentoID;
	}
	public void setDocumentoID(String documentoID) {
		this.documentoID = documentoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getHoraRegistro() {
		return horaRegistro;
	}
	public void setHoraRegistro(String horaRegistro) {
		this.horaRegistro = horaRegistro;
	}
	public String getOrigenDocumento() {
		return origenDocumento;
	}
	public void setOrigenDocumento(String origenDocumento) {
		this.origenDocumento = origenDocumento;
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
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getNumeroInstrumento() {
		return numeroInstrumento;
	}
	public void setNumeroInstrumento(String numeroInstrumento) {
		this.numeroInstrumento = numeroInstrumento;
	}
	public String getCatInsGrdValoresID() {
		return catInsGrdValoresID;
	}
	public void setCatInsGrdValoresID(String catInsGrdValoresID) {
		this.catInsGrdValoresID = catInsGrdValoresID;
	}
	public String getAlmacenID() {
		return almacenID;
	}
	public void setAlmacenID(String almacenID) {
		this.almacenID = almacenID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getUbicacion() {
		return ubicacion;
	}
	public void setUbicacion(String ubicacion) {
		this.ubicacion = ubicacion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getUsuarioRegistroID() {
		return usuarioRegistroID;
	}
	public void setUsuarioRegistroID(String usuarioRegistroID) {
		this.usuarioRegistroID = usuarioRegistroID;
	}
	public String getDescripcionEstatus() {
		return descripcionEstatus;
	}
	public void setDescripcionEstatus(String descripcionEstatus) {
		this.descripcionEstatus = descripcionEstatus;
	}
	public String getNumeroExpedienteID() {
		return numeroExpedienteID;
	}
	public void setNumeroExpedienteID(String numeroExpedienteID) {
		this.numeroExpedienteID = numeroExpedienteID;
	}
	public String getParticipanteID() {
		return participanteID;
	}
	public void setParticipanteID(String participanteID) {
		this.participanteID = participanteID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getFechaCustodia() {
		return fechaCustodia;
	}
	public void setFechaCustodia(String fechaCustodia) {
		this.fechaCustodia = fechaCustodia;
	}
	public String getUsuarioBajaID() {
		return usuarioBajaID;
	}
	public void setUsuarioBajaID(String usuarioBajaID) {
		this.usuarioBajaID = usuarioBajaID;
	}
	public String getSucursalBajaID() {
		return sucursalBajaID;
	}
	public void setSucursalBajaID(String sucursalBajaID) {
		this.sucursalBajaID = sucursalBajaID;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getUsuarioProcesaID() {
		return usuarioProcesaID;
	}
	public void setUsuarioProcesaID(String usuarioProcesaID) {
		this.usuarioProcesaID = usuarioProcesaID;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public String getUsuarioPrestamoID() {
		return usuarioPrestamoID;
	}
	public void setUsuarioPrestamoID(String usuarioPrestamoID) {
		this.usuarioPrestamoID = usuarioPrestamoID;
	}
	public String getUsuarioDevolucionID() {
		return usuarioDevolucionID;
	}
	public void setUsuarioDevolucionID(String usuarioDevolucionID) {
		this.usuarioDevolucionID = usuarioDevolucionID;
	}
	public String getPrestamoDocGrdValoresID() {
		return prestamoDocGrdValoresID;
	}
	public void setPrestamoDocGrdValoresID(String prestamoDocGrdValoresID) {
		this.prestamoDocGrdValoresID = prestamoDocGrdValoresID;
	}
	public String getSeccion() {
		return seccion;
	}
	public void setSeccion(String seccion) {
		this.seccion = seccion;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getCatMovimientoID() {
		return catMovimientoID;
	}
	public void setCatMovimientoID(String catMovimientoID) {
		this.catMovimientoID = catMovimientoID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNombreParticipante() {
		return nombreParticipante;
	}
	public void setNombreParticipante(String nombreParticipante) {
		this.nombreParticipante = nombreParticipante;
	}
	public String getNombreDocumento() {
		return nombreDocumento;
	}
	public void setNombreDocumento(String nombreDocumento) {
		this.nombreDocumento = nombreDocumento;
	}
	public String getNombreAlmacen() {
		return nombreAlmacen;
	}
	public void setNombreAlmacen(String nombreAlmacen) {
		this.nombreAlmacen = nombreAlmacen;
	}
	public String getNombreUsuarioRegistroID() {
		return nombreUsuarioRegistroID;
	}
	public void setNombreUsuarioRegistroID(String nombreUsuarioRegistroID) {
		this.nombreUsuarioRegistroID = nombreUsuarioRegistroID;
	}
	public String getNombreUsuarioProcesa() {
		return nombreUsuarioProcesa;
	}
	public void setNombreUsuarioProcesa(String nombreUsuarioProcesa) {
		this.nombreUsuarioProcesa = nombreUsuarioProcesa;
	}
	public String getNombreUsuarioAutorizaID() {
		return nombreUsuarioAutorizaID;
	}
	public void setNombreUsuarioAutorizaID(String nombreUsuarioAutorizaID) {
		this.nombreUsuarioAutorizaID = nombreUsuarioAutorizaID;
	}
	public String getNombreUsuarioProcesaID() {
		return nombreUsuarioProcesaID;
	}
	public void setNombreUsuarioProcesaID(String nombreUsuarioProcesaID) {
		this.nombreUsuarioProcesaID = nombreUsuarioProcesaID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreTipoInstrumento() {
		return nombreTipoInstrumento;
	}
	public void setNombreTipoInstrumento(String nombreTipoInstrumento) {
		this.nombreTipoInstrumento = nombreTipoInstrumento;
	}
	public String getNombreNumeroInstrumento() {
		return nombreNumeroInstrumento;
	}
	public void setNombreNumeroInstrumento(String nombreNumeroInstrumento) {
		this.nombreNumeroInstrumento = nombreNumeroInstrumento;
	}
	public String getRangoFechas() {
		return rangoFechas;
	}
	public void setRangoFechas(String rangoFechas) {
		this.rangoFechas = rangoFechas;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getUsuarioInicial() {
		return usuarioInicial;
	}
	public void setUsuarioInicial(String usuarioInicial) {
		this.usuarioInicial = usuarioInicial;
	}
	public String getUsuarioFinal() {
		return usuarioFinal;
	}
	public void setUsuarioFinal(String usuarioFinal) {
		this.usuarioFinal = usuarioFinal;
	}
	public String getFechaDevolucion() {
		return fechaDevolucion;
	}
	public void setFechaDevolucion(String fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}
	public String getDocSustitucionID() {
		return docSustitucionID;
	}
	public void setDocSustitucionID(String docSustitucionID) {
		this.docSustitucionID = docSustitucionID;
	}
	public String getNombreDocSustitucion() {
		return nombreDocSustitucion;
	}
	public String getEstatusPrevio() {
		return estatusPrevio;
	}
	public void setEstatusPrevio(String estatusPrevio) {
		this.estatusPrevio = estatusPrevio;
	}
	public String getArchivoID() {
		return archivoID;
	}
	public void setArchivoID(String archivoID) {
		this.archivoID = archivoID;
	}
	public void setNombreDocSustitucion(String nombreDocSustitucion) {
		this.nombreDocSustitucion = nombreDocSustitucion;
	}
	public List getListaDocumentoID() {
		return listaDocumentoID;
	}
	public void setListaDocumentoID(List listaDocumentoID) {
		this.listaDocumentoID = listaDocumentoID;
	}
	public List getListaOrigenDocumento() {
		return listaOrigenDocumento;
	}
	public void setListaOrigenDocumento(List listaOrigenDocumento) {
		this.listaOrigenDocumento = listaOrigenDocumento;
	}
	public List getListaGrupoDocumentoID() {
		return listaGrupoDocumentoID;
	}
	public void setListaGrupoDocumentoID(List listaGrupoDocumentoID) {
		this.listaGrupoDocumentoID = listaGrupoDocumentoID;
	}
	public List getListaTipoDocumentoID() {
		return listaTipoDocumentoID;
	}
	public void setListaTipoDocumentoID(List listaTipoDocumentoID) {
		this.listaTipoDocumentoID = listaTipoDocumentoID;
	}
	public List getListaNombreDocumento() {
		return listaNombreDocumento;
	}
	public void setListaNombreDocumento(List listaNombreDocumento) {
		this.listaNombreDocumento = listaNombreDocumento;
	}
	public List getListaArchivoID() {
		return listaArchivoID;
	}
	public void setListaArchivoID(List listaArchivoID) {
		this.listaArchivoID = listaArchivoID;
	}
}