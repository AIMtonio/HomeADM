package contabilidad.bean;

import general.bean.BaseBean;

public class ReporteFinancierosBean extends BaseBean{
	
	private String ejercicio;
	private String periodo;
	private String fecha; 
	private String tipoReporteFinanciero;		
	private String saldosCero;			
	private String cifras;
	private String fechaAlCorte;
	private String estadoFinanID;
	private String fechaFin;
	
	private String gerenteGeneral;
	private String presidenteConsejo;
	private String jefeContabilidad;
	private String ccInicial;
	private String ccFinal;
	private String ccInicialDes;
	private String ccFinalDes;
	
	private String tipoConsulta;
	
	private String descripcion;
	private String participacionControladora;
	private String capitalSocial;
	private String aportacionesCapital;
	private String primaVenta;
	private String obligacionesSubordinadas;
	private String incorporacionSocFinancieras;
	private String reservaCapital;
	private String resultadoEjerAnterior;
	private String resultadoTitulosVenta;
	private String resultadoValuacionInstrumentos;
	private String efectoAcomulado;
	private String beneficioEmpleados;
	private String resultadoMonetario;
	private String resultadoActivos;
	private String participacionNoControladora;
	private String capitalContable;
	private String efectoIncorporacion;
	private String directorFinanzas;
	
	public String getTipoConsulta() {
		return tipoConsulta;
	}
	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	private String nombreInstitucion;
	private String DirecInstitucion;
	private String rfc;
	private String usuario;
	private String fechaSistema;
	
	
	public String getEjercicio() {
		return ejercicio;
	}
	public void setEjercicio(String ejercicio) {
		this.ejercicio = ejercicio;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getTipoReporteFinanciero() {
		return tipoReporteFinanciero;
	}
	public void setTipoReporteFinanciero(String tipoReporteFinanciero) {
		this.tipoReporteFinanciero = tipoReporteFinanciero;
	}
	public String getSaldosCero() {
		return saldosCero;
	}
	public void setSaldosCero(String saldosCero) {
		this.saldosCero = saldosCero;
	}
	public String getCifras() {
		return cifras;
	}
	public void setCifras(String cifras) {
		this.cifras = cifras;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getFechaAlCorte() {
		return fechaAlCorte;
	}
	public void setFechaAlCorte(String fechaAlCorte) {
		this.fechaAlCorte = fechaAlCorte;
	}
	public String getDirecInstitucion() {
		return DirecInstitucion;
	}
	public void setDirecInstitucion(String direcInstitucion) {
		DirecInstitucion = direcInstitucion;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getEstadoFinanID() {
		return estadoFinanID;
	}
	public void setEstadoFinanID(String estadoFinanID) {
		this.estadoFinanID = estadoFinanID;
	}
	public String getGerenteGeneral() {
		return gerenteGeneral;
	}
	public void setGerenteGeneral(String gerenteGeneral) {
		this.gerenteGeneral = gerenteGeneral;
	}
	public String getPresidenteConsejo() {
		return presidenteConsejo;
	}
	public void setPresidenteConsejo(String presidenteConsejo) {
		this.presidenteConsejo = presidenteConsejo;
	}
	public String getJefeContabilidad() {
		return jefeContabilidad;
	}
	public void setJefeContabilidad(String jefeContabilidad) {
		this.jefeContabilidad = jefeContabilidad;
	}
	public String getCcInicial() {
		return ccInicial;
	}
	public void setCcInicial(String ccInicial) {
		this.ccInicial = ccInicial;
	}
	public String getCcFinal() {
		return ccFinal;
	}
	public void setCcFinal(String ccFinal) {
		this.ccFinal = ccFinal;
	}
	public String getCcInicialDes() {
		return ccInicialDes;
	}
	public void setCcInicialDes(String ccInicialDes) {
		this.ccInicialDes = ccInicialDes;
	}
	public String getCcFinalDes() {
		return ccFinalDes;
	}
	public void setCcFinalDes(String ccFinalDes) {
		this.ccFinalDes = ccFinalDes;
	}
	public String getParticipacionControladora() {
		return participacionControladora;
	}
	public void setParticipacionControladora(String participacionControladora) {
		this.participacionControladora = participacionControladora;
	}
	public String getCapitalSocial() {
		return capitalSocial;
	}
	public void setCapitalSocial(String capitalSocial) {
		this.capitalSocial = capitalSocial;
	}
	public String getAportacionesCapital() {
		return aportacionesCapital;
	}
	public void setAportacionesCapital(String aportacionesCapital) {
		this.aportacionesCapital = aportacionesCapital;
	}
	public String getPrimaVenta() {
		return primaVenta;
	}
	public void setPrimaVenta(String primaVenta) {
		this.primaVenta = primaVenta;
	}
	public String getObligacionesSubordinadas() {
		return obligacionesSubordinadas;
	}
	public void setObligacionesSubordinadas(String obligacionesSubordinadas) {
		this.obligacionesSubordinadas = obligacionesSubordinadas;
	}
	public String getIncorporacionSocFinancieras() {
		return incorporacionSocFinancieras;
	}
	public void setIncorporacionSocFinancieras(String incorporacionSocFinancieras) {
		this.incorporacionSocFinancieras = incorporacionSocFinancieras;
	}
	public String getReservaCapital() {
		return reservaCapital;
	}
	public void setReservaCapital(String reservaCapital) {
		this.reservaCapital = reservaCapital;
	}
	public String getResultadoEjerAnterior() {
		return resultadoEjerAnterior;
	}
	public void setResultadoEjerAnterior(String resultadoEjerAnterior) {
		this.resultadoEjerAnterior = resultadoEjerAnterior;
	}
	public String getResultadoTitulosVenta() {
		return resultadoTitulosVenta;
	}
	public void setResultadoTitulosVenta(String resultadoTitulosVenta) {
		this.resultadoTitulosVenta = resultadoTitulosVenta;
	}
	public String getResultadoValuacionInstrumentos() {
		return resultadoValuacionInstrumentos;
	}
	public void setResultadoValuacionInstrumentos(
			String resultadoValuacionInstrumentos) {
		this.resultadoValuacionInstrumentos = resultadoValuacionInstrumentos;
	}
	public String getEfectoAcomulado() {
		return efectoAcomulado;
	}
	public void setEfectoAcomulado(String efectoAcomulado) {
		this.efectoAcomulado = efectoAcomulado;
	}
	public String getBeneficioEmpleados() {
		return beneficioEmpleados;
	}
	public void setBeneficioEmpleados(String beneficioEmpleados) {
		this.beneficioEmpleados = beneficioEmpleados;
	}
	public String getResultadoMonetario() {
		return resultadoMonetario;
	}
	public void setResultadoMonetario(String resultadoMonetario) {
		this.resultadoMonetario = resultadoMonetario;
	}
	public String getResultadoActivos() {
		return resultadoActivos;
	}
	public void setResultadoActivos(String resultadoActivos) {
		this.resultadoActivos = resultadoActivos;
	}
	public String getParticipacionNoControladora() {
		return participacionNoControladora;
	}
	public void setParticipacionNoControladora(String participacionNoControladora) {
		this.participacionNoControladora = participacionNoControladora;
	}
	public String getCapitalContable() {
		return capitalContable;
	}
	public void setCapitalContable(String capitalContable) {
		this.capitalContable = capitalContable;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDirectorFinanzas() {
		return directorFinanzas;
	}
	public void setDirectorFinanzas(String directorFinanzas) {
		this.directorFinanzas = directorFinanzas;
	}
	public String getEfectoIncorporacion() {
		return efectoIncorporacion;
	}
	public void setEfectoIncorporacion(String efectoIncorporacion) {
		this.efectoIncorporacion = efectoIncorporacion;
	}
}
