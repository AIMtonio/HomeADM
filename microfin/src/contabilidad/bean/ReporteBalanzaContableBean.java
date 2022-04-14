package contabilidad.bean;

import general.bean.BaseBean;


public class ReporteBalanzaContableBean extends BaseBean{
	
	private String fecha;
	private String ejercicio; 
	private String periodo; 
	private String saldoCero; 
	private String tipoConsulta; 
	private String cuentaContable;
	private String saldoInicial;
	private String saldoIniAcreed;
	private String cargos;
	private String abonos;
	private String saldoDeudor;
	private String saldoAcreedor;
	private String cifras;
	private String concepto;
	private String inicioPeriodo;
	private String finPeriodo;
	private String fechaFin;
	private String ccInicial;
	private String ccFinal;
	private String cuentaIni;
	private String cuentaFin;
	private String nivelDetalle;
	
	//Variables auxiliares del Bean
	private String nombreUsuario;
	private String claveUsuario;
	private String nombreInstitucion;
	private String fechaEmision;
	private String ccInicialDes;
	private String ccFinalDes;
	// Auxiliares de excel 
	private Double SumaSalIni;
	private Double SumaSalIniAcre;
	private Double SumaCargos;
	private Double SumaAbonos;
	private Double SumaSalDeu;
	private Double SumaSalAcr;
	
	private String tipoBalanza;
	private String centroCosto;
	private String grupo;
	private String horaEmision;
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
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
	public String getSaldoCero() {
		return saldoCero;
	}
	public void setSaldoCero(String saldoCero) {
		this.saldoCero = saldoCero;
	}
	public String getTipoConsulta() {
		return tipoConsulta;
	}
	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}
	public String getCuentaContable() {
		return cuentaContable;
	}
	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
	public String getSaldoInicial() {
		return saldoInicial;
	}
	public void setSaldoInicial(String saldoInicial) {
		this.saldoInicial = saldoInicial;
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
	public String getSaldoDeudor() {
		return saldoDeudor;
	}
	public void setSaldoDeudor(String saldoDeudor) {
		this.saldoDeudor = saldoDeudor;
	}
	public String getSaldoAcreedor() {
		return saldoAcreedor;
	}
	public void setSaldoAcreedor(String saldoAcreedor) {
		this.saldoAcreedor = saldoAcreedor;
	}
	public String getCifras() {
		return cifras;
	}
	public void setCifras(String cifras) {
		this.cifras = cifras;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getInicioPeriodo() {
		return inicioPeriodo;
	}
	public void setInicioPeriodo(String inicioPeriodo) {
		this.inicioPeriodo = inicioPeriodo;
	}
	public String getFinPeriodo() {
		return finPeriodo;
	}
	public void setFinPeriodo(String finPeriodo) {
		this.finPeriodo = finPeriodo;
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
	public Double getSumaSalIni() {
		return SumaSalIni;
	}
	public void setSumaSalIni(Double sumaSalIni) {
		SumaSalIni = sumaSalIni;
	}
	public Double getSumaCargos() {
		return SumaCargos;
	}
	public void setSumaCargos(Double sumaCargos) {
		SumaCargos = sumaCargos;
	}
	public Double getSumaAbonos() {
		return SumaAbonos;
	}
	public void setSumaAbonos(Double sumaAbonos) {
		SumaAbonos = sumaAbonos;
	}
	public Double getSumaSalDeu() {
		return SumaSalDeu;
	}
	public void setSumaSalDeu(Double sumaSalDeu) {
		SumaSalDeu = sumaSalDeu;
	}
	public Double getSumaSalAcr() {
		return SumaSalAcr;
	}
	public void setSumaSalAcr(Double sumaSalAcr) {
		SumaSalAcr = sumaSalAcr;
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
	public String getCuentaIni() {
		return cuentaIni;
	}
	public void setCuentaIni(String cuentaIni) {
		this.cuentaIni = cuentaIni;
	}
	public String getCuentaFin() {
		return cuentaFin;
	}
	public void setCuentaFin(String cuentaFin) {
		this.cuentaFin = cuentaFin;
	}
	public String getNivelDetalle() {
		return nivelDetalle;
	}
	public void setNivelDetalle(String nivelDetalle) {
		this.nivelDetalle = nivelDetalle;
	}
	public String getSaldoIniAcreed() {
		return saldoIniAcreed;
	}
	public void setSaldoIniAcreed(String saldoIniAcreed) {
		this.saldoIniAcreed = saldoIniAcreed;
	}
	public Double getSumaSalIniAcre() {
		return SumaSalIniAcre;
	}
	public void setSumaSalIniAcre(Double sumaSalIniAcre) {
		SumaSalIniAcre = sumaSalIniAcre;
	}
	public String getTipoBalanza() {
		return tipoBalanza;
	}
	public void setTipoBalanza(String tipoBalanza) {
		this.tipoBalanza = tipoBalanza;
	}
	
	public String getCentroCosto() {
		return centroCosto;
	}
	public void setCentroCosto(String centroCosto) {
		this.centroCosto = centroCosto;
	}
	public String getGrupo() {
		return grupo;
	}
	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
}
