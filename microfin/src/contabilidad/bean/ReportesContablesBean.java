package contabilidad.bean;

import general.bean.BaseBean;

public class ReportesContablesBean extends BaseBean {
	private String empresaID;
	private String polizaID;
	private String fecha;
	private String centroCostoID;
	private String cuentaCompleta;
	private String nombreCuenta;
	private String descripcion;
	private String cargos;
	private String abonos;
	private String instrumentos;// variable para el reporte en excel de mov. por cta. contables
	private String primerRango; // Primer rango para tipo de instrumento
	private String segundoRango; // Segundo rango para tipo de instrumento
	private String primerCentroCostos; // Primer rango para centro de costos
	private String segundoCentroCostos; // Segundo rango para centro de costos
	private String tipoInstrumentoID; // tipo de instrumento
	private String descTipoInstrumento; // tipo de instrumento;
	private String saldos;
	private String saldoInicial;
	private String saldoFinal;
	
	
	//Atributos auxiliares
	private String fechaIni;
	private String fechaFin;
	private int  numRep;
	private String desCuentaCompleta;
	private String nombreusuario;
	private String nombreInstitucion;
	private String fechaEmision;
	private String cuentaCompletaFin;
	private String desCuentaCompletaF;
	private String HoraEmision;
	
	public int getNumRep() {
		return numRep;
	}
	public void setNumRep(int numRep) {
		this.numRep = numRep;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getNombreCuenta() {
		return nombreCuenta;
	}
	public void setNombreCuenta(String nombreCuenta) {
		this.nombreCuenta = nombreCuenta;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAbonos() {
		return abonos;
	}
	public void setAbonos(String abonos) {
		this.abonos = abonos;
	}
	public String getFechaIni() {
		return fechaIni;
	}
	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getDesCuentaCompleta() {
		return desCuentaCompleta;
	}
	public void setDesCuentaCompleta(String desCuentaCompleta) {
		this.desCuentaCompleta = desCuentaCompleta;
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
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getCuentaCompletaFin() {
		return cuentaCompletaFin;
	}
	public void setCuentaCompletaFin(String cuentaCompletaFin) {
		this.cuentaCompletaFin = cuentaCompletaFin;
	}
	public String getDesCuentaCompletaF() {
		return desCuentaCompletaF;
	}
	public void setDesCuentaCompletaF(String desCuentaCompletaF) {
		this.desCuentaCompletaF = desCuentaCompletaF;
	}
	public String getInstrumentos() {
		return instrumentos;
	}
	public void setInstrumentos(String instrumentos) {
		this.instrumentos = instrumentos;
	}
	public String getPrimerRango() {
		return primerRango;
	}
	public void setPrimerRango(String primerRango) {
		this.primerRango = primerRango;
	}
	public String getSegundoRango() {
		return segundoRango;
	}
	public void setSegundoRango(String segundoRango) {
		this.segundoRango = segundoRango;
	}
	
	public String getPrimerCentroCostos() {
		return primerCentroCostos;
	}
	public void setPrimerCentroCostos(String primerCentroCostos) {
		this.primerCentroCostos = primerCentroCostos;
	}
	public String getSegundoCentroCostos() {
		return segundoCentroCostos;
	}
	public void setSegundoCentroCostos(String segundoCentroCostos) {
		this.segundoCentroCostos = segundoCentroCostos;
	}
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getDescTipoInstrumento() {
		return descTipoInstrumento;
	}
	public void setDescTipoInstrumento(String descTipoInstrumento) {
		this.descTipoInstrumento = descTipoInstrumento;
	}
	public String getHoraEmision() {
		return HoraEmision;
	}
	public void setHoraEmision(String horaEmision) {
		HoraEmision = horaEmision;
	}
	public String getSaldos() {
		return saldos;
	}
	public void setSaldos(String saldos) {
		this.saldos = saldos;
	}
	public String getSaldoInicial() {
		return saldoInicial;
	}
	public void setSaldoInicial(String saldoInicial) {
		this.saldoInicial = saldoInicial;
	}
	public String getSaldoFinal() {
		return saldoFinal;
	}
	public void setSaldoFinal(String saldoFinal) {
		this.saldoFinal = saldoFinal;
	}
		
}
