package fondeador.bean;

import general.bean.BaseBean;

public class LineaFondeadorBean extends BaseBean { 
	private String lineaFondeoID;
	private String institutFondID;
	private String descripLinea;
	private String fechInicLinea;
	private String fechaFinLinea;
	private String tipoLinFondeaID;
	private String montoOtorgado;
	private String saldoLinea;
	private String tasaPasiva;
	private String factorMora;
	private String diasGraciaMora;
	private String pagoAutoVenci;
	private String fechaMaxVenci;
	
	private String cobraMoratorios;
	private String cobraFaltaPago;
	private String diasGraFaltaPag;
	private String esRevolvente;
	private String tipoRevolvencia;
	private String institucionID;
	private String numCtaInstit;
	private String cuentaClabe;
	private String montoComFaltaPag;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	private String nomInstitFon;
	private String nombreInstitucion;
	private String creditoFondeoID;
	private String montoAumentar;
	private String afectacionConta;
	private String reqIntegra;
	private String reqIntegracion;
	private String tipCobComMorato;
	private String folioFondeo;
	
	private String calcInteresID;
	private String tasaBase;
	private String refinanciamiento;
	private String monedaID;
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getDescripLinea() {
		return descripLinea;
	}
	public void setDescripLinea(String descripLinea) {
		this.descripLinea = descripLinea;
	}
	public String getFechInicLinea() {
		return fechInicLinea;
	}
	public void setFechInicLinea(String fechInicLinea) {
		this.fechInicLinea = fechInicLinea;
	}
	public String getFechaFinLinea() {
		return fechaFinLinea;
	}
	public void setFechaFinLinea(String fechaFinLinea) {
		this.fechaFinLinea = fechaFinLinea;
	}
	public String getTipoLinFondeaID() {
		return tipoLinFondeaID;
	}
	public void setTipoLinFondeaID(String tipoLinFondeaID) {
		this.tipoLinFondeaID = tipoLinFondeaID;
	}
	public String getMontoOtorgado() {
		return montoOtorgado;
	}
	public void setMontoOtorgado(String montoOtorgado) {
		this.montoOtorgado = montoOtorgado;
	}
	public String getSaldoLinea() {
		return saldoLinea;
	}
	public void setSaldoLinea(String saldoLinea) {
		this.saldoLinea = saldoLinea;
	}
	public String getTasaPasiva() {
		return tasaPasiva;
	}
	public void setTasaPasiva(String tasaPasiva) {
		this.tasaPasiva = tasaPasiva;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getDiasGraciaMora() {
		return diasGraciaMora;
	}
	public void setDiasGraciaMora(String diasGraciaMora) {
		this.diasGraciaMora = diasGraciaMora;
	}
	public String getPagoAutoVenci() {
		return pagoAutoVenci;
	}
	public void setPagoAutoVenci(String pagoAutoVenci) {
		this.pagoAutoVenci = pagoAutoVenci;
	}
	public String getFechaMaxVenci() {
		return fechaMaxVenci;
	}
	public void setFechaMaxVenci(String fechaMaxVenci) {
		this.fechaMaxVenci = fechaMaxVenci;
	}
	public String getCobraMoratorios() {
		return cobraMoratorios;
	}
	public void setCobraMoratorios(String cobraMoratorios) {
		this.cobraMoratorios = cobraMoratorios;
	}
	public String getCobraFaltaPago() {
		return cobraFaltaPago;
	}
	public void setCobraFaltaPago(String cobraFaltaPago) {
		this.cobraFaltaPago = cobraFaltaPago;
	}
	public String getDiasGraFaltaPag() {
		return diasGraFaltaPag;
	}
	public void setDiasGraFaltaPag(String diasGraFaltaPag) {
		this.diasGraFaltaPag = diasGraFaltaPag;
	}
	public String getEsRevolvente() {
		return esRevolvente;
	}
	public void setEsRevolvente(String esRevolvente) {
		this.esRevolvente = esRevolvente;
	}
	public String getTipoRevolvencia() {
		return tipoRevolvencia;
	}
	public void setTipoRevolvencia(String tipoRevolvencia) {
		this.tipoRevolvencia = tipoRevolvencia;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
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
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getMontoComFaltaPag() {
		return montoComFaltaPag;
	}
	public void setMontoComFaltaPag(String montoComFaltaPag) {
		this.montoComFaltaPag = montoComFaltaPag;
	}
	public String getNomInstitFon() {
		return nomInstitFon;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public void setNomInstitFon(String nomInstitFon) {
		this.nomInstitFon = nomInstitFon;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public String getMontoAumentar() {
		return montoAumentar;
	}
	public void setMontoAumentar(String montoAumentar) {
		this.montoAumentar = montoAumentar;
	}
	public String getAfectacionConta() {
		return afectacionConta;
	}
	public void setAfectacionConta(String afectacionConta) {
		this.afectacionConta = afectacionConta;
	}
	public String getReqIntegra() {
		return reqIntegra;
	}
	public void setReqIntegra(String reqIntegra) {
		this.reqIntegra = reqIntegra;
	}
	public String getReqIntegracion() {
		return reqIntegracion;
	}
	public void setReqIntegracion(String reqIntegracion) {
		this.reqIntegracion = reqIntegracion;
	}
	public String getTipCobComMorato() {
		return tipCobComMorato;
	}
	public void setTipCobComMorato(String tipCobComMorato) {
		this.tipCobComMorato = tipCobComMorato;
	}
	public String getFolioFondeo() {
		return folioFondeo;
	}
	public void setFolioFondeo(String folioFondeo) {
		this.folioFondeo = folioFondeo;
	}
	public String getCalcInteresID() {
		return calcInteresID;
	}
	public void setCalcInteresID(String calcInteresID) {
		this.calcInteresID = calcInteresID;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public String getRefinanciamiento() {
		return refinanciamiento;
	}
	public void setRefinanciamiento(String refinanciamiento) {
		this.refinanciamiento = refinanciamiento;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
}