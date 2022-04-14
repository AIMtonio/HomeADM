package credito.bean;

import java.util.List;

import general.bean.BaseBean;

public class ProductosCreditoBean  extends BaseBean {
	private String producCreditoID;
	private String descripcion;
	private String caracteristicas;
	private String cobraIVAInteres;
	private String cobraIVAMora;
	private String cobraFaltaPago;
	private String cobraMora;
	private String factorMora;
	private String tipoPersona;
	private String manejaLinea;
	private String esRevolvente;
	private String esGrupal;
	private String requiereGarantia;
	private String requiereAvales;
	private String graciaFaltaPago;
	private String graciaMoratorios;
	private String garantizado;
	private String montoMinimo;
	private String montoMaximo;
	private String diasSuspesion;
	private String esReestructura;
	private String esAutomatico;
	private String clasificacion;
	private String margenPagIgual;
	private String requiereObligadosSolidarios;
	private String permObligadosCruzados;
	private String reqConsultaSIC;
	private String tipoComXapert;
	private String montoComXapert;
	private String tipo;
	private String porcGarLiq;
	private String relGarantCred;
	private String perAvaCruzados;
	private String perGarCruzadas;
	private String criterioComFalPag;
	private String montoMinComFalPag;
	
	private String tipoContratoCCID;
	//datos de RECA condusef en tabla ProductosCredito
	private String registroRECA;		
	private String fechaInscripcion;		
	private String nombreComercial;		
	private String tipoCredito;
	//datos de grupales
	private String minMujeresSol;			
	private String maxMujeresSol;		
	private String minMujeres;			
	private String maxMujeres;			
	private String minHombres;
	private String maxHombres;			
	private String tasaPonderaGru;

	private String perRompimGrup;

	private String raIniCicloGrup;
	private String raFinCicloGrup;

	private String maxIntegrantes;
	private String minIntegrantes;
	
	// variables Seguro de Vida;
	private String tipoPagoSeguro;
	private String reqSeguroVida;
	private String factorRiesgoSeguro;
	private String montoPolSegVida;
	private String descuentoSeguro;
	
	//variables para Capital contable
	private String validaCapConta;
	private String porcMaxCapConta;


	private String tipCobComMorato;
	private String diasPasoAtraso;
	private String proyInteresPagAde;
	private String perCobComFalPag;
	private String tipCobComFalPago;
	private String prorrateoComFalPag;
	private String prorrateoPago;
	private String permitePrepago;
	private String perfilID;
	private String destinoCredID;
	
	private String liberarGaranLiq;
	
	//Nivel de Riesgo PLD
	private String claveRiesgo;
	
	//datos de auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String ahoVoluntario;
	private String porAhoVol;
	private String formaComApertura;
	private String calcInteres;
	private String tipoContratoBCID;
	private String tipoCalInteres;
	private String tipoGeneraInteres;
	private String institutFondID;
	
	private String productoNomina;
	private String modificarPrepago;
	private String tipoPrepago;
	private String autorizaComite;
	private String calculoRatios;
	private String afectacionContable;
	
	//modalidad de pago de seguro de vida
	private String modalidad;
	private String esquemaSeguroID;

	
	private String inicioAfuturo;
	private String diasMaximo;
	private String tipoPagoComFalPago;
	
	//Ajuste Proceso Validación Avales
	private String cantidadAvales;
	private String intercambioAvalesRatio;
	
	private String permiteAutSolPros;
	private String requiereReferencias;
	private String minReferencias;
	private String cobraSeguroCuota;
	private String cobraIVASeguroCuota;
	private String requiereAnalisiCre;
	
	private List lesquemaSeguroID;
	private List lproducCreditoID;
	private List ltipoPagoSeguro;
	private List lfactorRiesgoSeguro;
	private List ldescuentoSeguro;
	private List lmontoPolSegVida;
	
	private String cobraAccesorios;
	
	// Auxiliares en la consulta WS para ZAFY
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String tasaFija;
	private String frecuencias;
	private String plazoID;
	
	//Identificador del producto ante la CNBV
	private String claveCNBV;
	
	// Requiere CkeckList
	private String requiereCheckList;
	
	// Permite Consolidacion
	private String permiteConsolidacion;
	
	// Instrucciones Dispersión
	private String instruDispersion;

	private String esAgropecuario;
	private String refinanciamiento;
	
	/* CREDITOS AUTOMÁTICOS */
	private String tipoAutomatico;
	private String porcMaximo;
	
	private String financiamientoRural;
	
	/* PARAMETROS PARA SPEI*/
	private String participaSpei;
	private String productoClabe;
	/*CASTIGO MASIVO*/
	private String diasAtrasoMin;
	
	// FOGA - FOGAFI
	private String bonificacionFOGA;
	private String desbloqAutFOGA;
	private String garantiaFOGAFI;
	private String modalidadFOGAFI;
	private String bonificacionFOGAFI;

	/* Comisión Anual Linea */
	private String cobraComAnual;
	private String tipoComAnual;
	private String valorComAnual;

	
	private String desbloqAutFOGAFI;
	private String reqConsolidacionAgro;
	private String fechaDesembolso;
	private String validacionConyuge;
	private String estatus;
	
	public String getRequiereAnalisiCre() {
		return requiereAnalisiCre;
	}
	public void setRequiereAnalisiCre(String requiereAnalisiCre) {
		this.requiereAnalisiCre = requiereAnalisiCre;
	}
	public String getReqConsultaSIC() {
		return reqConsultaSIC;
	}
	public void setReqConsultaSIC(String reqConsultaSIC) {
		this.reqConsultaSIC = reqConsultaSIC;
	}
	public String getPermObligadosCruzados() {
		return permObligadosCruzados;
	}
	public void setPermObligadosCruzados(String permObligadosCruzados) {
		this.permObligadosCruzados = permObligadosCruzados;
	}
	public String getInicioAfuturo() {
		return inicioAfuturo;
	}
	public void setInicioAfuturo(String inicioAfuturo) {
		this.inicioAfuturo = inicioAfuturo;
	}
	public String getDiasMaximo() {
		return diasMaximo;
	}
	public void setDiasMaximo(String diasMaximo) {
		this.diasMaximo = diasMaximo;
	}
	public String getDestinoCredID() {
		return destinoCredID;
	}
	public void setDestinoCredID(String destinoCredID) {
		this.destinoCredID = destinoCredID;
	}
	public String getPerfilID() {
		return perfilID;
	}
	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}
	public String getRegistroRECA() {
		return registroRECA;
	}
	public void setRegistroRECA(String registroRECA) {
		this.registroRECA = registroRECA;
	}
	public String getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(String fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public String getNombreComercial() {
		return nombreComercial;
	}
	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public String getMinMujeresSol() {
		return this.minMujeresSol;
	}
	public void setMinMujeresSol(String minMujeresSol) {
		this.minMujeresSol = minMujeresSol;
	}
	public String getMaxMujeresSol() {
		return maxMujeresSol;
	}
	public void setMaxMujeresSol(String maxMujeresSol) {
		this.maxMujeresSol = maxMujeresSol;
	}
	public String getMinMujeres() {
		return minMujeres;
	}
	public void setMinMujeres(String minMujeres) {
		this.minMujeres = minMujeres;
	}
	public String getMaxMujeres() {
		return maxMujeres;
	}
	public void setMaxMujeres(String maxMujeres) {
		this.maxMujeres = maxMujeres;
	}
	public String getMinHombres() {
		return minHombres;
	}
	public void setMinHombres(String minHombres) {
		this.minHombres = minHombres;
	}
	public String getMaxHombres() {
		return maxHombres;
	}
	public void setMaxHombres(String maxHombres) {
		this.maxHombres = maxHombres;
	}
	public String getTasaPonderaGru() {
		return this.tasaPonderaGru;
	}
	public void setTasaPonderaGru(String tasaPonderaGru) {
		this.tasaPonderaGru = tasaPonderaGru;
	}

	
	
	
	
	public String getRelGarantCred() {
		return relGarantCred;
	}
	public void setRelGarantCred(String relGarantCred) {
		this.relGarantCred = relGarantCred;
	}
	public String getPerAvaCruzados() {
		return perAvaCruzados;
	}
	public void setPerAvaCruzados(String perAvaCruzados) {
		this.perAvaCruzados = perAvaCruzados;
	}
	public String getPerRompimGrup() {
		return perRompimGrup;
	}
	public void setPerRompimGrup(String perRompimGrup) {
		this.perRompimGrup = perRompimGrup;
	}
	public String getRaIniCicloGrup() {
		return raIniCicloGrup;
	}
	public void setRaIniCicloGrup(String raIniCicloGrup) {
		this.raIniCicloGrup = raIniCicloGrup;
	}
	public String getRaFinCicloGrup() {
		return raFinCicloGrup;
	}
	public void setRaFinCicloGrup(String raFinCicloGrup) {
		this.raFinCicloGrup = raFinCicloGrup;
	}
	public String getPorcGarLiq() {
		return porcGarLiq;
	}
	public void setPorcGarLiq(String porcGarLiq) {
		this.porcGarLiq = porcGarLiq;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getTipoCalInteres() {
		return tipoCalInteres;
	}
	public void setTipoCalInteres(String tipoCalInteres) {
		this.tipoCalInteres = tipoCalInteres;
	}
	public String getCalcInteres() {
		return calcInteres;
	}
	public void setCalcInteres(String calcInteres) {
		this.calcInteres = calcInteres;
	}
	

	public String getFormaComApertura() {
		return formaComApertura;
	}
	public void setFormaComApertura(String formaComApertura) {
		this.formaComApertura = formaComApertura;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getAhoVoluntario() {
		return ahoVoluntario;
	}
	public void setAhoVoluntario(String ahoVoluntario) {
		this.ahoVoluntario = ahoVoluntario;
	}
	public String getPorAhoVol() {
		return porAhoVol;
	}
	public void setPorAhoVol(String porAhoVol) {
		this.porAhoVol = porAhoVol;
	}
	public String getMargenPagIgual() {
		return margenPagIgual;
	}
	public void setMargenPagIgual(String margenPagIgual) {
		this.margenPagIgual = margenPagIgual;
	}
	public String getCaracteristicas() {
		return caracteristicas;
	}
	public void setCaracteristicas(String caracteristicas) {
		this.caracteristicas = caracteristicas;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getCobraIVAInteres() {
		return cobraIVAInteres;
	}
	public void setCobraIVAInteres(String cobraIVAInteres) {
		this.cobraIVAInteres = cobraIVAInteres;
	}
	public String getCobraIVAMora() {
		return cobraIVAMora;
	}
	public void setCobraIVAMora(String cobraIVAMora) {
		this.cobraIVAMora = cobraIVAMora;
	}
	public String getCobraFaltaPago() {
		return cobraFaltaPago;
	}
	public void setCobraFaltaPago(String cobraFaltaPago) {
		this.cobraFaltaPago = cobraFaltaPago;
	}
	public String getCobraMora() {
		return cobraMora;
	}
	public void setCobraMora(String cobraMora) {
		this.cobraMora = cobraMora;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	
	public String getRequiereObligadosSolidarios() {
		return requiereObligadosSolidarios;
	}
	public void setRequiereObligadosSolidarios(String requiereObligadosSolidarios) {
		this.requiereObligadosSolidarios = requiereObligadosSolidarios;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getManejaLinea() {
		return manejaLinea;
	}
	public void setManejaLinea(String manejaLinea) {
		this.manejaLinea = manejaLinea;
	}
	public String getEsRevolvente() {
		return esRevolvente;
	}
	public void setEsRevolvente(String esRevolvente) {
		this.esRevolvente = esRevolvente;
	}
	public String getEsGrupal() {
		return esGrupal;
	}
	public void setEsGrupal(String esGrupal) {
		this.esGrupal = esGrupal;
	}
	public String getRequiereGarantia() {
		return requiereGarantia;
	}
	public void setRequiereGarantia(String requiereGarantia) {
		this.requiereGarantia = requiereGarantia;
	}
	public String getRequiereAvales() {
		return requiereAvales;
	}
	public void setRequiereAvales(String requiereAvale) {
		this.requiereAvales = requiereAvale;
	}
	public String getGraciaFaltaPago() {
		return graciaFaltaPago;
	}
	public void setGraciaFaltaPago(String graciaFaltaPago) {
		this.graciaFaltaPago = graciaFaltaPago;
	}
	public String getGraciaMoratorios() {
		return graciaMoratorios;
	}
	public void setGraciaMoratorios(String graciaMoratorios) {
		this.graciaMoratorios = graciaMoratorios;
	}
	public String getGarantizado() {
		return garantizado;
	}
	public void setGarantizado(String garantizado) {
		this.garantizado = garantizado;
	}
	public String getMontoMinimo() {
		return montoMinimo;
	}
	public void setMontoMinimo(String montoMinimo) {
		this.montoMinimo = montoMinimo;
	}
	public String getMontoMaximo() {
		return montoMaximo;
	}
	public void setMontoMaximo(String montoMaximo) {
		this.montoMaximo = montoMaximo;
	}
	public String getDiasSuspesion() {
		return diasSuspesion;
	}
	public void setDiasSuspesion(String diasSuspesion) {
		this.diasSuspesion = diasSuspesion;
	}

	public String getEsReestructura() {
		return esReestructura;
	}
	public void setEsReestructura(String esReestructura) {
		this.esReestructura = esReestructura;
	}
	public String getEsAutomatico() {
		return esAutomatico;
	}
	public void setEsAutomatico(String esAutomatico) {
		this.esAutomatico = esAutomatico;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}

	public String getTipoComXapert() {
		return tipoComXapert;
	}
	public void setTipoComXapert(String tipoComXapert) {
		this.tipoComXapert = tipoComXapert;
	}
	public String getMontoComXapert() {
		return montoComXapert;
	}
	public void setMontoComXapert(String montoComXapert) {
		this.montoComXapert = montoComXapert;
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
	public String getTipoContratoBCID() {
		return tipoContratoBCID;
	}
	public void setTipoContratoBCID(String tipoContratoBCID) {
		this.tipoContratoBCID = tipoContratoBCID;
	}
	public String getMaxIntegrantes() {
		return maxIntegrantes;
	}
	public void setMaxIntegrantes(String maxIntegrantes) {
		this.maxIntegrantes = maxIntegrantes;
	}
	public String getMinIntegrantes() {
		return minIntegrantes;
	}
	public void setMinIntegrantes(String minIntegrantes) {
		this.minIntegrantes = minIntegrantes;
	}
	public String getPerGarCruzadas() {
		return perGarCruzadas;
	}
	public void setPerGarCruzadas(String perGarCruzadas) {
		this.perGarCruzadas = perGarCruzadas;
	}
	public String getCriterioComFalPag() {
		return criterioComFalPag;
	}
	public void setCriterioComFalPag(String criterioComFalPag) {
		this.criterioComFalPag = criterioComFalPag;
	}
	public String getMontoMinComFalPag() {
		return montoMinComFalPag;
	}
	public void setMontoMinComFalPag(String montoMinComFalPag) {
		this.montoMinComFalPag = montoMinComFalPag;
	}
	public String getTipoPagoSeguro() {
		return tipoPagoSeguro;
	}
	public void setTipoPagoSeguro(String tipoPagoSeguro) {
		this.tipoPagoSeguro = tipoPagoSeguro;
	}
	public String getReqSeguroVida() {
		return reqSeguroVida;
	}
	public void setReqSeguroVida(String reqSeguroVida) {
		this.reqSeguroVida = reqSeguroVida;
	}
	public String getFactorRiesgoSeguro() {
		return factorRiesgoSeguro;
	}
	public void setFactorRiesgoSeguro(String factorRiesgoSeguro) {
		this.factorRiesgoSeguro = factorRiesgoSeguro;
	}
	public String getMontoPolSegVida() {
		return montoPolSegVida;
	}
	public void setMontoPolSegVida(String montoPolSegVida) {
		this.montoPolSegVida = montoPolSegVida;
	}
	public String getDescuentoSeguro() {
		return descuentoSeguro;
	}
	public void setDescuentoSeguro(String descuentoSeguro) {
		this.descuentoSeguro = descuentoSeguro;
	}
	public String getTipCobComMorato() {
		return tipCobComMorato;
	}
	public void setTipCobComMorato(String tipCobComMorato) {
		this.tipCobComMorato = tipCobComMorato;
	}
	public String getDiasPasoAtraso() {
		return diasPasoAtraso;
	}
	public void setDiasPasoAtraso(String diasPasoAtraso) {
		this.diasPasoAtraso = diasPasoAtraso;
	}
	public String getProyInteresPagAde() {
		return proyInteresPagAde;
	}
	public void setProyInteresPagAde(String proyInteresPagAde) {
		this.proyInteresPagAde = proyInteresPagAde;
	}
	public String getPerCobComFalPag() {
		return perCobComFalPag;
	}
	public void setPerCobComFalPag(String perCobComFalPag) {
		this.perCobComFalPag = perCobComFalPag;
	}
	public String getTipCobComFalPago() {
		return tipCobComFalPago;
	}
	public void setTipCobComFalPago(String tipCobComFalPago) {
		this.tipCobComFalPago = tipCobComFalPago;
	}
	public String getProrrateoComFalPag() {
		return prorrateoComFalPag;
	}
	public void setProrrateoComFalPag(String prorrateoComFalPag) {
		this.prorrateoComFalPag = prorrateoComFalPag;
	}
	public String getValidaCapConta() {
		return validaCapConta;
	}
	public void setValidaCapConta(String validaCapConta) {
		this.validaCapConta = validaCapConta;
	}
	public String getPorcMaxCapConta() {
		return porcMaxCapConta;
	}
	public void setPorcMaxCapConta(String porcMaxCapConta) {
		this.porcMaxCapConta = porcMaxCapConta;
	}


	public String getProrrateoPago() {
		return prorrateoPago;
	}
	public void setProrrateoPago(String prorrateoPago) {
		this.prorrateoPago = prorrateoPago;
	}
	public String getPermitePrepago() {
		return permitePrepago;
	}
	public void setPermitePrepago(String permitePrepago) {
		this.permitePrepago = permitePrepago;
	}
	public String getProductoNomina() {
		return productoNomina;
	}
	public void setProductoNomina(String productoNomina) {
		this.productoNomina = productoNomina;
	}
	public String getModificarPrepago() {
		return modificarPrepago;
	}
	public void setModificarPrepago(String modificarPrepago) {
		this.modificarPrepago = modificarPrepago;
	}
	public String getTipoPrepago() {
		return tipoPrepago;
	}
	public void setTipoPrepago(String tipoPrepago) {
		this.tipoPrepago = tipoPrepago;
	}
	public String getLiberarGaranLiq() {
		return liberarGaranLiq;
	}
	public void setLiberarGaranLiq(String liberarGaranLiq) {
		this.liberarGaranLiq = liberarGaranLiq;
	}
	public String getAutorizaComite() {
		return autorizaComite;
	}
	public void setAutorizaComite(String autorizaComite) {
		this.autorizaComite = autorizaComite;
	}
	public String getTipoContratoCCID() {
		return tipoContratoCCID;
	}
	public void setTipoContratoCCID(String tipoContratoCCID) {
		this.tipoContratoCCID = tipoContratoCCID;
	}
	public String getCalculoRatios() {
		return calculoRatios;
	}
	public void setCalculoRatios(String calculoRatios) {
		this.calculoRatios = calculoRatios;
	}
	public String getAfectacionContable() {
		return afectacionContable;
	}
	public void setAfectacionContable(String afectacionContable) {
		this.afectacionContable = afectacionContable;
	}
	public String getModalidad() {
		return modalidad;
	}
	public void setModalidad(String modalidad) {
		this.modalidad = modalidad;
	}
	public String getEsquemaSeguroID() {
		return esquemaSeguroID;
	}
	public void setEsquemaSeguroID(String esquemaSeguroID) {
		this.esquemaSeguroID = esquemaSeguroID;
	}
	public List getLesquemaSeguroID() {
		return lesquemaSeguroID;
	}
	public void setLesquemaSeguroID(List lesquemaSeguroID) {
		this.lesquemaSeguroID = lesquemaSeguroID;
	}
	public List getLproducCreditoID() {
		return lproducCreditoID;
	}
	public void setLproducCreditoID(List lproducCreditoID) {
		this.lproducCreditoID = lproducCreditoID;
	}
	public List getLtipoPagoSeguro() {
		return ltipoPagoSeguro;
	}
	public void setLtipoPagoSeguro(List ltipoPagoSeguro) {
		this.ltipoPagoSeguro = ltipoPagoSeguro;
	}
	public List getLfactorRiesgoSeguro() {
		return lfactorRiesgoSeguro;
	}
	public void setLfactorRiesgoSeguro(List lfactorRiesgoSeguro) {
		this.lfactorRiesgoSeguro = lfactorRiesgoSeguro;
	}
	public List getLdescuentoSeguro() {
		return ldescuentoSeguro;
	}
	public void setLdescuentoSeguro(List ldescuentoSeguro) {
		this.ldescuentoSeguro = ldescuentoSeguro;
	}
	public List getLmontoPolSegVida() {
		return lmontoPolSegVida;
	}
	public void setLmontoPolSegVida(List lmontoPolSegVida) {
		this.lmontoPolSegVida = lmontoPolSegVida;
	}
		
	public String getCobraAccesorios() {
		return cobraAccesorios;
	}
	public void setCobraAccesorios(String cobraAccesorios) {
		this.cobraAccesorios = cobraAccesorios;
	}
	
	public String getTipoPagoComFalPago() {
		return tipoPagoComFalPago;
	}
	public void setTipoPagoComFalPago(String tipoPagoComFalPago) {
		this.tipoPagoComFalPago = tipoPagoComFalPago;
	}
	public String getCantidadAvales() {
		return cantidadAvales;
	}
	public void setCantidadAvales(String cantidadAvales) {
		this.cantidadAvales = cantidadAvales;
	}
	public String getIntercambioAvalesRatio() {
		return intercambioAvalesRatio;
	}
	public void setIntercambioAvalesRatio(String intercambioAvalesRatio) {
		this.intercambioAvalesRatio = intercambioAvalesRatio;
	}
	public String getPermiteAutSolPros() {
		return permiteAutSolPros;
	}
	public void setPermiteAutSolPros(String permiteAutSolPros) {
		this.permiteAutSolPros = permiteAutSolPros;
	}
	public String getRequiereReferencias() {
		return requiereReferencias;
	}
	public void setRequiereReferencias(String requiereReferencias) {
		this.requiereReferencias = requiereReferencias;
	}
	public String getMinReferencias() {
		return minReferencias;
	}
	public void setMinReferencias(String minReferencias) {
		this.minReferencias = minReferencias;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getFrecuencias() {
		return frecuencias;
	}
	public void setFrecuencias(String frecuencias) {
		this.frecuencias = frecuencias;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}

	public String getCobraIVASeguroCuota() {
		return cobraIVASeguroCuota;
	}
	public void setCobraIVASeguroCuota(String cobraIVASeguroCuota) {
		this.cobraIVASeguroCuota = cobraIVASeguroCuota;
	}
	public String getClaveRiesgo() {
		return claveRiesgo;
	}
	public void setClaveRiesgo(String claveRiesgo) {
		this.claveRiesgo = claveRiesgo;
	}
	public String getClaveCNBV() {
		return claveCNBV;
	}
	public void setClaveCNBV(String claveCNBV) {
		this.claveCNBV = claveCNBV;
	}
	public String getPermiteConsolidacion() {
		return permiteConsolidacion;
	}
	public void setPermiteConsolidacion(String permiteConsolidacion) {
		this.permiteConsolidacion = permiteConsolidacion;
	}
	public String getInstruDispersion() {
		return instruDispersion;
	}
	public void setInstruDispersion(String instruDispersion) {
		this.instruDispersion = instruDispersion;
	}
	public String getRequiereCheckList() {
		return requiereCheckList;
	}
	public void setRequiereCheckList(String requiereCheckList) {
		this.requiereCheckList = requiereCheckList;
	}
	public String getEsAgropecuario() {
		return esAgropecuario;
	}
	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	public String getRefinanciamiento() {
		return refinanciamiento;
	}
	public void setRefinanciamiento(String refinanciamiento) {
		this.refinanciamiento = refinanciamiento;
	}
	public String getTipoAutomatico() {
		return tipoAutomatico;
	}
	public void setTipoAutomatico(String tipoAutomatico) {
		this.tipoAutomatico = tipoAutomatico;
	}
	public String getPorcMaximo() {
		return porcMaximo;
	}
	public void setPorcMaximo(String porcMaximo) {
		this.porcMaximo = porcMaximo;
	}
	public String getFinanciamientoRural() {
		return financiamientoRural;
	}
	public void setFinanciamientoRural(String financiamientoRural) {
		this.financiamientoRural = financiamientoRural;
	}
	public String getParticipaSpei() {
		return participaSpei;
	}
	public void setParticipaSpei(String participaSpei) {
		this.participaSpei = participaSpei;
	}
	public String getProductoClabe() {
		return productoClabe;
	}
	public void setProductoClabe(String productoClabe) {
		this.productoClabe = productoClabe;
	}
	public String getDiasAtrasoMin() {
		return diasAtrasoMin;
	}
	public void setDiasAtrasoMin(String diasAtrasoMin) {
		this.diasAtrasoMin = diasAtrasoMin;
	}
	public String getBonificacionFOGA() {
		return bonificacionFOGA;
	}
	public void setBonificacionFOGA(String bonificacionFOGA) {
		this.bonificacionFOGA = bonificacionFOGA;
	}
	public String getDesbloqAutFOGA() {
		return desbloqAutFOGA;
	}
	public void setDesbloqAutFOGA(String desbloqAutFOGA) {
		this.desbloqAutFOGA = desbloqAutFOGA;
	}
	public String getGarantiaFOGAFI() {
		return garantiaFOGAFI;
	}
	public void setGarantiaFOGAFI(String garantiaFOGAFI) {
		this.garantiaFOGAFI = garantiaFOGAFI;
	}
	public String getModalidadFOGAFI() {
		return modalidadFOGAFI;
	}
	public void setModalidadFOGAFI(String modalidadFOGAFI) {
		this.modalidadFOGAFI = modalidadFOGAFI;
	}
	public String getBonificacionFOGAFI() {
		return bonificacionFOGAFI;
	}
	public void setBonificacionFOGAFI(String bonificacionFOGAFI) {
		this.bonificacionFOGAFI = bonificacionFOGAFI;
	}
	public String getDesbloqAutFOGAFI() {
		return desbloqAutFOGAFI;
	}
	public void setDesbloqAutFOGAFI(String desbloqAutFOGAFI) {
		this.desbloqAutFOGAFI = desbloqAutFOGAFI;
	}
	public String getCobraComAnual() {
		return cobraComAnual;
	}
	public void setCobraComAnual(String cobraComAnual) {
		this.cobraComAnual = cobraComAnual;
	}
	public String getTipoComAnual() {
		return tipoComAnual;
	}
	public void setTipoComAnual(String tipoComAnual) {
		this.tipoComAnual = tipoComAnual;
	}
	public String getValorComAnual() {
		return valorComAnual;
	}
	public void setValorComAnual(String valorComAnual) {
		this.valorComAnual = valorComAnual;
	}
	public String getTipoGeneraInteres() {
		return tipoGeneraInteres;
	}
	public void setTipoGeneraInteres(String tipoGeneraInteres) {
		this.tipoGeneraInteres = tipoGeneraInteres;
	}
	public String getReqConsolidacionAgro() {
		return reqConsolidacionAgro;
	}
	public void setReqConsolidacionAgro(String reqConsolidacionAgro) {
		this.reqConsolidacionAgro = reqConsolidacionAgro;
	}
	public String getFechaDesembolso() {
		return fechaDesembolso;
	}
	public void setFechaDesembolso(String fechaDesembolso) {
		this.fechaDesembolso = fechaDesembolso;
	}
	public String getValidacionConyuge() {
		return validacionConyuge;
	}
	public void setValidacionConyuge(String validacionConyuge) {
		this.validacionConyuge = validacionConyuge;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}