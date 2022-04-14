package cliente.bean;

import general.bean.BaseBean;

public class ServiFunFoliosBean extends BaseBean{
	private String serviFunFolioID;
	private String clienteID;
	private String tipoServicio;
	private String fechaRegistro;
	private String estatus;
	
	private String difunClienteID;
	private String difunPrimerNombre;
	private String difunSegundoNombre;
	private String difunTercerNombre;
	private String difunApePaterno;

	private String difunApeMaterno;
	private String difunFechaNacim;
	private String difunParentesco;
	private String tramClienteID;
	private String tramPrimerNombre;
	
	private String tramSegundoNombre;
	private String tramTercerNombre;
	private String tramApePaterno;
	private String tramApeMaterno;
	private String tramFechaNacim;
	
	private String tramParentesco;
	private String noCertificadoDefun;
	private String fechaCertiDefun;
	private String usuarioAutoriza;
	private String fechaAutoriza;
	
	private String usuarioRechaza;
	private String fechaRechazo;
	private String motivoRechazo;
	private String montoApoyo;
	private String proceso; // Indica si es Autorizar o rechazar
	private String difNombreCompleto;
	private String EstatusDescripcion;
	
	public String getServiFunFolioID() {
		return serviFunFolioID;
	}
	public void setServiFunFolioID(String serviFunFolioID) {
		this.serviFunFolioID = serviFunFolioID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getTipoServicio() {
		return tipoServicio;
	}
	public void setTipoServicio(String tipoServicio) {
		this.tipoServicio = tipoServicio;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDifunClienteID() {
		return difunClienteID;
	}
	public void setDifunClienteID(String difunClienteID) {
		this.difunClienteID = difunClienteID;
	}
	public String getDifunPrimerNombre() {
		return difunPrimerNombre;
	}
	public void setDifunPrimerNombre(String difunPrimerNombre) {
		this.difunPrimerNombre = difunPrimerNombre;
	}
	public String getDifunSegundoNombre() {
		return difunSegundoNombre;
	}
	public void setDifunSegundoNombre(String difunSegundoNombre) {
		this.difunSegundoNombre = difunSegundoNombre;
	}
	public String getDifunTercerNombre() {
		return difunTercerNombre;
	}
	public void setDifunTercerNombre(String difunTercerNombre) {
		this.difunTercerNombre = difunTercerNombre;
	}
	public String getDifunApePaterno() {
		return difunApePaterno;
	}
	public void setDifunApePaterno(String difunApePaterno) {
		this.difunApePaterno = difunApePaterno;
	}
	public String getDifunApeMaterno() {
		return difunApeMaterno;
	}
	public void setDifunApeMaterno(String difunApeMaterno) {
		this.difunApeMaterno = difunApeMaterno;
	}
	public String getDifunFechaNacim() {
		return difunFechaNacim;
	}
	public void setDifunFechaNacim(String difunFechaNacim) {
		this.difunFechaNacim = difunFechaNacim;
	}
	public String getDifunParentesco() {
		return difunParentesco;
	}
	public void setDifunParentesco(String difunParentesco) {
		this.difunParentesco = difunParentesco;
	}
	public String getTramClienteID() {
		return tramClienteID;
	}
	public void setTramClienteID(String tramClienteID) {
		this.tramClienteID = tramClienteID;
	}
	public String getTramPrimerNombre() {
		return tramPrimerNombre;
	}
	public void setTramPrimerNombre(String tramPrimerNombre) {
		this.tramPrimerNombre = tramPrimerNombre;
	}
	public String getTramSegundoNombre() {
		return tramSegundoNombre;
	}
	public void setTramSegundoNombre(String tramSegundoNombre) {
		this.tramSegundoNombre = tramSegundoNombre;
	}
	public String getTramTercerNombre() {
		return tramTercerNombre;
	}
	public void setTramTercerNombre(String tramTercerNombre) {
		this.tramTercerNombre = tramTercerNombre;
	}
	public String getTramApePaterno() {
		return tramApePaterno;
	}
	public void setTramApePaterno(String tramApePaterno) {
		this.tramApePaterno = tramApePaterno;
	}
	public String getTramApeMaterno() {
		return tramApeMaterno;
	}
	public void setTramApeMaterno(String tramApeMaterno) {
		this.tramApeMaterno = tramApeMaterno;
	}
	public String getTramFechaNacim() {
		return tramFechaNacim;
	}
	public void setTramFechaNacim(String tramFechaNacim) {
		this.tramFechaNacim = tramFechaNacim;
	}
	public String getTramParentesco() {
		return tramParentesco;
	}
	public void setTramParentesco(String tramParentesco) {
		this.tramParentesco = tramParentesco;
	}
	public String getNoCertificadoDefun() {
		return noCertificadoDefun;
	}
	public void setNoCertificadoDefun(String noCertificadoDefun) {
		this.noCertificadoDefun = noCertificadoDefun;
	}
	public String getFechaCertiDefun() {
		return fechaCertiDefun;
	}
	public void setFechaCertiDefun(String fechaCertiDefun) {
		this.fechaCertiDefun = fechaCertiDefun;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getUsuarioRechaza() {
		return usuarioRechaza;
	}
	public void setUsuarioRechaza(String usuarioRechaza) {
		this.usuarioRechaza = usuarioRechaza;
	}
	public String getFechaRechazo() {
		return fechaRechazo;
	}
	public void setFechaRechazo(String fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public String getMontoApoyo() {
		return montoApoyo;
	}
	public void setMontoApoyo(String montoApoyo) {
		this.montoApoyo = montoApoyo;
	}
	public String getProceso() {
		return proceso;
	}
	public void setProceso(String proceso) {
		this.proceso = proceso;
	}
	public String getDifNombreCompleto() {
		return difNombreCompleto;
	}
	public void setDifNombreCompleto(String difNombreCompleto) {
		this.difNombreCompleto = difNombreCompleto;
	}
	public String getEstatusDescripcion() {
		return EstatusDescripcion;
	}
	public void setEstatusDescripcion(String estatusDescripcion) {
		EstatusDescripcion = estatusDescripcion;
	}		
}
