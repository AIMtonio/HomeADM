package tesoreria.bean;

import general.bean.BaseBean;

public class ReporteChequesSBCBean extends BaseBean{
		
	private String clienteID;
	private String nombreCliente;
	private String bancoEmisor;
	private String nomInsitucion;
	private String cuentaEmisor;
	private String cuentaAplica;
	private String nombreEmisor ;
	private String monto;
	private String estatus;
	private String fechaRecepcion;
	private String fechaAplicacion;
	private String sucursalID;
	private String instAplica;
	private String nombInsAplica;
	private String formaAplica;
	private String numCheque;
	private String cuentaAhoID;
	
	
		
	private String nombreUsuario;
	private String nombreInstitucion;
	private String fechaSistema;
	
	/* Atributos de para alamecenar los filtros de la pantalla*/
	private String institucionIDIni;
	private String nombInstitucionIni;
	private String institucionIDFin;
	private String nombinstitucionIDFin;
	private String noCuentaInstituIni;	
	private String noCuentaInstituIniFin;
	private String sucursalIni;
	private String nombreSucursal;
	private String nombSucursalFin;
	private String sucursalFin;
	private String clienteIDIni;
	private String nombreClienteIni;
	private String clienteIDFin;
	private String nombreClienteFin;
	private String estatusCheque;
	
	private String fechaInicial;
	private String fechaFinal;
	
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getBancoEmisor() {
		return bancoEmisor;
	}
	public void setBancoEmisor(String bancoEmisor) {
		this.bancoEmisor = bancoEmisor;
	}
	public String getNomInsitucion() {
		return nomInsitucion;
	}
	public void setNomInsitucion(String nomInsitucion) {
		this.nomInsitucion = nomInsitucion;
	}
	public String getCuentaEmisor() {
		return cuentaEmisor;
	}
	public void setCuentaEmisor(String cuentaEmisor) {
		this.cuentaEmisor = cuentaEmisor;
	}
	public String getCuentaAplica() {
		return cuentaAplica;
	}
	public void setCuentaAplica(String cuentaAplica) {
		this.cuentaAplica = cuentaAplica;
	}
	public String getNombreEmisor() {
		return nombreEmisor;
	}
	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(String fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public String getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(String fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getInstitucionIDIni() {
		return institucionIDIni;
	}
	public void setInstitucionIDIni(String institucionIDIni) {
		this.institucionIDIni = institucionIDIni;
	}
	public String getNombInstitucionIni() {
		return nombInstitucionIni;
	}
	public void setNombInstitucionIni(String nombInstitucionIni) {
		this.nombInstitucionIni = nombInstitucionIni;
	}
	public String getInstitucionIDFin() {
		return institucionIDFin;
	}
	public void setInstitucionIDFin(String institucionIDFin) {
		this.institucionIDFin = institucionIDFin;
	}
	public String getNombinstitucionIDFin() {
		return nombinstitucionIDFin;
	}
	public void setNombinstitucionIDFin(String nombinstitucionIDFin) {
		this.nombinstitucionIDFin = nombinstitucionIDFin;
	}
	public String getNoCuentaInstituIni() {
		return noCuentaInstituIni;
	}
	public void setNoCuentaInstituIni(String noCuentaInstituIni) {
		this.noCuentaInstituIni = noCuentaInstituIni;
	}
	public String getNoCuentaInstituIniFin() {
		return noCuentaInstituIniFin;
	}
	public void setNoCuentaInstituIniFin(String noCuentaInstituIniFin) {
		this.noCuentaInstituIniFin = noCuentaInstituIniFin;
	}
	public String getSucursalIni() {
		return sucursalIni;
	}
	public void setSucursalIni(String sucursalIni) {
		this.sucursalIni = sucursalIni;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombSucursalFin() {
		return nombSucursalFin;
	}
	public void setNombSucursalFin(String nombSucursalFin) {
		this.nombSucursalFin = nombSucursalFin;
	}
	public String getSucursalFin() {
		return sucursalFin;
	}
	public void setSucursalFin(String sucursalFin) {
		this.sucursalFin = sucursalFin;
	}
	public String getClienteIDIni() {
		return clienteIDIni;
	}
	public void setClienteIDIni(String clienteIDIni) {
		this.clienteIDIni = clienteIDIni;
	}
	public String getNombreClienteIni() {
		return nombreClienteIni;
	}
	public void setNombreClienteIni(String nombreClienteIni) {
		this.nombreClienteIni = nombreClienteIni;
	}
	public String getClienteIDFin() {
		return clienteIDFin;
	}
	public void setClienteIDFin(String clienteIDFin) {
		this.clienteIDFin = clienteIDFin;
	}
	public String getNombreClienteFin() {
		return nombreClienteFin;
	}
	public void setNombreClienteFin(String nombreClienteFin) {
		this.nombreClienteFin = nombreClienteFin;
	}
	public String getEstatusCheque() {
		return estatusCheque;
	}
	public void setEstatusCheque(String estatusCheque) {
		this.estatusCheque = estatusCheque;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getInstAplica() {
		return instAplica;
	}
	public void setInstAplica(String instAplica) {
		this.instAplica = instAplica;
	}
	public String getNombInsAplica() {
		return nombInsAplica;
	}
	public void setNombInsAplica(String nombInsAplica) {
		this.nombInsAplica = nombInsAplica;
	}
	public String getFormaAplica() {
		return formaAplica;
	}
	public void setFormaAplica(String formaAplica) {
		this.formaAplica = formaAplica;
	}
	public String getNumCheque() {
		return numCheque;
	}
	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}	
	
	
}
