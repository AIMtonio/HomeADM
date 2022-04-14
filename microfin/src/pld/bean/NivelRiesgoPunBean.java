package pld.bean;

import general.bean.BaseBean;

public class NivelRiesgoPunBean extends BaseBean{
	private String clienteID;
	private String nombreCompleto;
	private String fecha;
	private String hora;
	private String tipoProceso;
	private String sucursalID;
	private String nombreSucursal;
	private String fechaIncio;
	private String fechaFin;
	private String detalles;
	private String tipoPersona;
	
	private String sucursalOrigen;
	private String nombreSucurs;
	private String nivelRiesgo;
	
	private String FolioMatrizID;
	private String NivelRiesgoObt;
	private String TotalPonderado;
	private String Porc1TotalAntec;
	private String Porc2Localidad;
	private String Porc3ActividadEc;
	private String Porc4TotalOriRe;
	private String Porc5TotalDesRe;
	private String Porc6TotalPerf;
	private String Porc1TotalEBR;

	/*Reporte*/
	private String usuario;
	private String fechaInicio;
	private String fechaFinal;
	private String fechaSistema;
	private String horaEmision;
	private String tituloReporte;
	private String tipoPersonaDes;
	private String nivelRiesgoDes;
	private String sucursalDes;
	private String nombreInstitucion;
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
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
	public String getTipoProceso() {
		return tipoProceso;
	}
	public void setTipoProceso(String tipoProceso) {
		this.tipoProceso = tipoProceso;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getFechaIncio() {
		return fechaIncio;
	}
	public void setFechaIncio(String fechaIncio) {
		this.fechaIncio = fechaIncio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getDetalles() {
		return detalles;
	}
	public void setDetalles(String detalles) {
		this.detalles = detalles;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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
	public String getTipoPersonaDes() {
		return tipoPersonaDes;
	}
	public void setTipoPersonaDes(String tipoPersonaDes) {
		this.tipoPersonaDes = tipoPersonaDes;
	}
	public String getNivelRiesgoDes() {
		return nivelRiesgoDes;
	}
	public void setNivelRiesgoDes(String nivelRiesgoDes) {
		this.nivelRiesgoDes = nivelRiesgoDes;
	}
	public String getSucursalDes() {
		return sucursalDes;
	}
	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFolioMatrizID() {
		return FolioMatrizID;
	}
	public void setFolioMatrizID(String folioMatrizID) {
		FolioMatrizID = folioMatrizID;
	}
	public String getNivelRiesgoObt() {
		return NivelRiesgoObt;
	}
	public void setNivelRiesgoObt(String nivelRiesgoObt) {
		NivelRiesgoObt = nivelRiesgoObt;
	}
	public String getTotalPonderado() {
		return TotalPonderado;
	}
	public void setTotalPonderado(String totalPonderado) {
		TotalPonderado = totalPonderado;
	}
	public String getPorc1TotalAntec() {
		return Porc1TotalAntec;
	}
	public void setPorc1TotalAntec(String porc1TotalAntec) {
		Porc1TotalAntec = porc1TotalAntec;
	}
	public String getPorc2Localidad() {
		return Porc2Localidad;
	}
	public void setPorc2Localidad(String porc2Localidad) {
		Porc2Localidad = porc2Localidad;
	}
	public String getPorc3ActividadEc() {
		return Porc3ActividadEc;
	}
	public void setPorc3ActividadEc(String porc3ActividadEc) {
		Porc3ActividadEc = porc3ActividadEc;
	}
	public String getPorc4TotalOriRe() {
		return Porc4TotalOriRe;
	}
	public void setPorc4TotalOriRe(String porc4TotalOriRe) {
		Porc4TotalOriRe = porc4TotalOriRe;
	}
	public String getPorc5TotalDesRe() {
		return Porc5TotalDesRe;
	}
	public void setPorc5TotalDesRe(String porc5TotalDesRe) {
		Porc5TotalDesRe = porc5TotalDesRe;
	}
	public String getPorc6TotalPerf() {
		return Porc6TotalPerf;
	}
	public void setPorc6TotalPerf(String porc6TotalPerf) {
		Porc6TotalPerf = porc6TotalPerf;
	}
	public String getPorc1TotalEBR() {
		return Porc1TotalEBR;
	}
	public void setPorc1TotalEBR(String porc1TotalEBR) {
		Porc1TotalEBR = porc1TotalEBR;
	}
}
