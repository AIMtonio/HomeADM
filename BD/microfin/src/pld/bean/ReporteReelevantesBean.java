package pld.bean;

import general.bean.BaseBean;

public class ReporteReelevantesBean extends BaseBean{
	
	private String  fechaGeneracion;
	private	String  periodoID;
	private String	opeReelevanteID;
	private String	periodoInicio;
	private String	periodoFin;
	private String  archivo;
	private String	sucursalID;
	private String	fecha;
	private String	hora;
	private String	localidad;
	private String	tipoOperacionID;
	private String	instrumentMonID;
	private String	clienteID;
	private String	monto;
	private String	claveMoneda;
	private String	primerNombreCliente;
	private String	segundoNombreCliente;
	private String	tercerNombreCliente;
	private String	apellidoPatCliente;
	private String	apellidoMatCliente;
	private String	RFC;
	private String	RFCpm;
	private String	calle;
	private String	coloniaCliente;
	private String	localidadCliente;
	private String	CP;
	private String	municipioID;
	private String	estadoID;
	private String	empresaID;
	private String	usuario;
	private String	fechaActual;
	private String	direccionIP;
	private String	programaID;
	private String	sucursal;
	private String	numTransaccion;
	
// Bean Auxiliares para la generacion de consultas
	private String  aux;
	private String  auxGeneraArch;
	private String rutaArchivosPLD;

	private String tipoReporte;
	
	private String operaciones;
	
	public String getFechaGeneracion() {
		return fechaGeneracion;
	}
	public void setFechaGeneracion(String fechaGeneracion) {
		this.fechaGeneracion = fechaGeneracion;
	}
	public String getPeriodoID() {
		return periodoID;
	}
	public void setPeriodoID(String periodoID) {
		this.periodoID = periodoID;
	}
	public String getPeriodoInicio() {
		return periodoInicio;
	}
	public void setPeriodoInicio(String periodoInicio) {
		this.periodoInicio = periodoInicio;
	}
	public String getPeriodoFin() {
		return periodoFin;
	}
	public void setPeriodoFin(String periodoFin) {
		this.periodoFin = periodoFin;
	}
	public String getOpeReelevanteID() {
		return opeReelevanteID;
	}
	public void setOpeReelevanteID(String opeReelevanteID) {
		this.opeReelevanteID = opeReelevanteID;
	}
	public String getArchivo() {
		return archivo;
	}
	public void setArchivo(String archivo) {
		this.archivo = archivo;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getTipoOperacionID() {
		return tipoOperacionID;
	}
	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}
	public String getInstrumentMonID() {
		return instrumentMonID;
	}
	public void setInstrumentMonID(String instrumentMonID) {
		this.instrumentMonID = instrumentMonID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getClaveMoneda() {
		return claveMoneda;
	}
	public void setClaveMoneda(String claveMoneda) {
		this.claveMoneda = claveMoneda;
	}
	public String getPrimerNombreCliente() {
		return primerNombreCliente;
	}
	public void setPrimerNombreCliente(String primerNombreCliente) {
		this.primerNombreCliente = primerNombreCliente;
	}
	public String getSegundoNombreCliente() {
		return segundoNombreCliente;
	}
	public void setSegundoNombreCliente(String segundoNombreCliente) {
		this.segundoNombreCliente = segundoNombreCliente;
	}
	public String getTercerNombreCliente() {
		return tercerNombreCliente;
	}
	public void setTercerNombreCliente(String tercerNombreCliente) {
		this.tercerNombreCliente = tercerNombreCliente;
	}
	public String getApellidoPatCliente() {
		return apellidoPatCliente;
	}
	public void setApellidoPatCliente(String apellidoPatCliente) {
		this.apellidoPatCliente = apellidoPatCliente;
	}
	public String getApellidoMatCliente() {
		return apellidoMatCliente;
	}
	public void setApellidoMatCliente(String apellidoMatCliente) {
		this.apellidoMatCliente = apellidoMatCliente;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getRFCpm() {
		return RFCpm;
	}
	public void setRFCpm(String rFCpm) {
		RFCpm = rFCpm;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getColoniaCliente() {
		return coloniaCliente;
	}
	public void setColoniaCliente(String coloniaCliente) {
		this.coloniaCliente = coloniaCliente;
	}
	public String getLocalidadCliente() {
		return localidadCliente;
	}
	public void setLocalidadCliente(String localidadCliente) {
		this.localidadCliente = localidadCliente;
	}
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
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
	public String getAux() {
		return aux;
	}
	public void setAux(String aux) {
		this.aux = aux;
	}
	public String getAuxGeneraArch() {
		return auxGeneraArch;
	}
	public void setAuxGeneraArch(String auxGeneraArch) {
		this.auxGeneraArch = auxGeneraArch;
	}

	public String getRutaArchivosPLD() {
		return rutaArchivosPLD;
	}
	public void setRutaArchivosPLD(String rutaArchivosPLD) {
		this.rutaArchivosPLD = rutaArchivosPLD;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getOperaciones() {
		return operaciones;
	}
	public void setOperaciones(String operaciones) {
		this.operaciones = operaciones;
	}	
}
