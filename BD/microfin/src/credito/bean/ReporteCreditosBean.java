package credito.bean;

import general.bean.BaseBean;
       
public class ReporteCreditosBean extends BaseBean{
	
	private String creditoID;
	private String clienteID;
	private String nombreCompleto;
	private String productoCreditoID;
	private String productoCreDescri;
	private String montoCredito;
	private String fechaInicio;
	private String fechaVencimiento;
	private String capitalVigente;
	private String interesesVigente;
	private String moraVigente;
	private String cargosVigente;
	private String ivaVigente;
	private String totalVigente;
	private String capitalVencido;
	private String interesesVencido;
	private String moraVencido;
	private String cargosVencido;
	private String ivaVencido;
	private String totalVencido;
	private String diasAtraso;
	private String grupoID;
	private String nombreGrupo;
	private String capitalAtrasado;
	private String tasaFija;
		
	// Reporte Pagos Realizados
	private String fechaPago;
	private String capital;	
	private String intereses;	
	private String moratorios;	
	private String comisiones;	
	private String IVA;	
	private String totalPagado;
	private String NombreSucursal;
	private String refPago;
	private String accesorios;
	private String interesAccesorios;
	private String ivaInteresAccesorios;
	
	// fin Pagos realizados
	
	
	public String getAccesorios() {
		return accesorios;
	}
	public void setAccesorios(String accesorios) {
		this.accesorios = accesorios;
	}
	public String getInteresAccesorios() {
		return interesAccesorios;
	}
	public void setInteresAccesorios(String interesAccesorios) {
		this.interesAccesorios = interesAccesorios;
	}
	public String getIvaInteresAccesorios() {
		return ivaInteresAccesorios;
	}
	public void setIvaInteresAccesorios(String ivaInteresAccesorios) {
		this.ivaInteresAccesorios = ivaInteresAccesorios;
	}
	// auxiliares del bean
	private String fecha;
	private String hora;
	
	private String modalidadPagoID;
	private String modalidadPago;
	private String nombreInstit;
	private String desConvenio;

	private String cuentaAhoID;
	private String fuenteFondeo;
	private String lineaFondeo;
	private String folioFondeo;

	//Reporte Pagos de Accesorios
	private String ivacomisiones;
	private String amortizacionId;
	private String accesoriosId;
	private String descripcionAccesorios;
	private String montoIntereses;
	private String ivaMontoIntereses;

	private String notasCargo;
	private String ivaNotasCargo;
	private String totalNotasCargo;
	
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
	public String getComisiones() {
		return comisiones;
	}
	public void setComisiones(String comisiones) {
		this.comisiones = comisiones;
	}	
	public String getTotalVencido() {
		return totalVencido;
	}
	public String getNombreSucursal() {
		return NombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		NombreSucursal = nombreSucursal;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getIntereses() {
		return intereses;
	}
	public void setIntereses(String intereses) {
		this.intereses = intereses;
	}
	public String getMoratorios() {
		return moratorios;
	}
	public void setMoratorios(String moratorios) {
		this.moratorios = moratorios;
	}
	public String getIVA() {
		return IVA;
	}
	public void setIVA(String iVA) {
		IVA = iVA;
	}
	public String getTotalPagado() {
		return totalPagado;
	}
	public void setTotalPagado(String totalPagado) {
		this.totalPagado = totalPagado;
	}
	public void setTotalVencido(String totalVencido) {
		this.totalVencido = totalVencido;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
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
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getProductoCreDescri() {
		return productoCreDescri;
	}
	public void setProductoCreDescri(String productoCreDescri) {
		this.productoCreDescri = productoCreDescri;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getCapitalVigente() {
		return capitalVigente;
	}
	public void setCapitalVigente(String capitalVigente) {
		this.capitalVigente = capitalVigente;
	}
	public String getInteresesVigente() {
		return interesesVigente;
	}
	public void setInteresesVigente(String interesesVigente) {
		this.interesesVigente = interesesVigente;
	}
	public String getMoraVigente() {
		return moraVigente;
	}
	public void setMoraVigente(String moraVigente) {
		this.moraVigente = moraVigente;
	}
	public String getCargosVigente() {
		return cargosVigente;
	}
	public void setCargosVigente(String cargosVigente) {
		this.cargosVigente = cargosVigente;
	}
	public String getIvaVigente() {
		return ivaVigente;
	}
	public void setIvaVigente(String ivaVigente) {
		this.ivaVigente = ivaVigente;
	}
	public String getTotalVigente() {
		return totalVigente;
	}
	public void setTotalVigente(String totalVigente) {
		this.totalVigente = totalVigente;
	}
	public String getCapitalVencido() {
		return capitalVencido;
	}
	public void setCapitalVencido(String capitalVencido) {
		this.capitalVencido = capitalVencido;
	}
	public String getInteresesVencido() {
		return interesesVencido;
	}
	public void setInteresesVencido(String interesesVencido) {
		this.interesesVencido = interesesVencido;
	}
	public String getMoraVencido() {
		return moraVencido;
	}
	public void setMoraVencido(String moraVencido) {
		this.moraVencido = moraVencido;
	}
	public String getCargosVencido() {
		return cargosVencido;
	}
	public void setCargosVencido(String cargosVencido) {
		this.cargosVencido = cargosVencido;
	}
	public String getIvaVencido() {
		return ivaVencido;
	}
	public void setIvaVencido(String ivaVencido) {
		this.ivaVencido = ivaVencido;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	
	public String getRefPago() {
		return refPago;
	}
	public void setRefPago(String refPago) {
		this.refPago = refPago;
	}
	public String getModalidadPagoID() {
		return modalidadPagoID;
	}
	public void setModalidadPagoID(String modalidadPagoID) {
		this.modalidadPagoID = modalidadPagoID;
	}
	public String getModalidadPago() {
		return modalidadPago;
	}
	public void setModalidadPago(String modalidadPago) {
		this.modalidadPago = modalidadPago;
	}
	public String getCapitalAtrasado() {
		return capitalAtrasado;
	}
	public void setCapitalAtrasado(String capitalAtrasado) {
		this.capitalAtrasado = capitalAtrasado;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getDesConvenio() {
		return desConvenio;
	}
	public void setDesConvenio(String desConvenio) {
		this.desConvenio = desConvenio;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFuenteFondeo() {
		return fuenteFondeo;
	}
	public void setFuenteFondeo(String fuenteFondeo) {
		this.fuenteFondeo = fuenteFondeo;
	}
	public String getLineaFondeo() {
		return lineaFondeo;
	}
	public void setLineaFondeo(String lineaFondeo) {
		this.lineaFondeo = lineaFondeo;
	}
	public String getFolioFondeo() {
		return folioFondeo;
	}
	public void setFolioFondeo(String folioFondeo) {
		this.folioFondeo = folioFondeo;
	}	
	public String getIvaComisiones() {
		return ivacomisiones;
	}
	public void setIvaComisiones(String ivacomisiones) {
		this.ivacomisiones = ivacomisiones;
	}
	
	public String getAmortizacionId() {
		return amortizacionId;
	}
	public void setAmortizacionId(String amortizacionId) {
		this.amortizacionId = amortizacionId;
	}
	public String getAccesoriosId() {
		return accesoriosId;
	}
	public void setAccesoriosId(String accesoriosId) {
		this.accesoriosId = accesoriosId;
	}
	public String getDescripcionAccesorios() {
		return descripcionAccesorios;
	}
	public void setDescripcionAccesorios(String descripcionAccesorios) {
		this.descripcionAccesorios = descripcionAccesorios;
	}
	public String getIvacomisiones() {
		return ivacomisiones;
	}
	public void setIvacomisiones(String ivacomisiones) {
		this.ivacomisiones = ivacomisiones;
	}
	public String getNotasCargo() {
		return notasCargo;
	}
	public void setNotasCargo(String notasCargo) {
		this.notasCargo = notasCargo;
	}
	public String getIvaNotasCargo() {
		return ivaNotasCargo;
	}
	public void setIvaNotasCargo(String ivaNotasCargo) {
		this.ivaNotasCargo = ivaNotasCargo;
	}
	public String getTotalNotasCargo() {
		return totalNotasCargo;
	}
	public void setTotalNotasCargo(String totalNotasCargo) {
		this.totalNotasCargo = totalNotasCargo;
	}
	public String getMontoIntereses() {
		return montoIntereses;
	}
	public void setMontoIntereses(String montoIntereses) {
		this.montoIntereses = montoIntereses;
	}
	public String getIvaMontoIntereses() {
		return ivaMontoIntereses;
	}
	public void setIvaMontoIntereses(String ivaMontoIntereses) {
		this.ivaMontoIntereses = ivaMontoIntereses;
	}
	
	
	
	
}