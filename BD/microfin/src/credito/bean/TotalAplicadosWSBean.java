package credito.bean;

import general.bean.BaseBean;

public class TotalAplicadosWSBean extends BaseBean{

	private String fechaInicial;
	private String fechaFin;
	private String institNominaID;
	private String institNomina;
	private String convenioNominaID;
	private String nombreConvenio;
	
	
	/*Valores del reporte*/
	private String fechaPago;
	private String descProducto;
	private String movimientoID;
	private String creditoID;
	private String descInstNomina;
	private String convNominaDesc; 
	private String clienteID;
	private String nombreCliente;
	private String RFC;
	private String cuentaAhoID;
	private double saldoDisp;
	private double saldoBloq;
	private double saldoTotal;
	private String nombreInst;
	private String cuentaCLABE;
	private String fechaAplicacion;
	private double capital;
	private double interes;
	private double ivaInteres;
	private double accesorios;
	private double iVAAccesorios;
	private double notasCargo;
	private double iVANotaCargo;
	private double totalPagado;
	private double importePenApli;
	private double totalOperacion;
	private String nombreInstPago;
	private String cuentaPago;
	private String origenPago;
	private String conceptoPago;
	
	
	
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getInstitNomina() {
		return institNomina;
	}
	public void setInstitNomina(String institNomina) {
		this.institNomina = institNomina;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getNombreConvenio() {
		return nombreConvenio;
	}
	public void setNombreConvenio(String nombreConvenio) {
		this.nombreConvenio = nombreConvenio;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getDescProducto() {
		return descProducto;
	}
	public void setDescProducto(String descProducto) {
		this.descProducto = descProducto;
	}
	public String getMovimientoID() {
		return movimientoID;
	}
	public void setMovimientoID(String movimientoID) {
		this.movimientoID = movimientoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getDescInstNomina() {
		return descInstNomina;
	}
	public void setDescInstNomina(String descInstNomina) {
		this.descInstNomina = descInstNomina;
	}
	public String getConvNominaDesc() {
		return convNominaDesc;
	}
	public void setConvNominaDesc(String convNominaDesc) {
		this.convNominaDesc = convNominaDesc;
	}
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
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	
	public String getNombreInst() {
		return nombreInst;
	}
	public void setNombreInst(String nombreInst) {
		this.nombreInst = nombreInst;
	}
	public String getCuentaCLABE() {
		return cuentaCLABE;
	}
	public void setCuentaCLABE(String cuentaCLABE) {
		this.cuentaCLABE = cuentaCLABE;
	}
	public String getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(String fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	
	public double getSaldoDisp() {
		return saldoDisp;
	}
	public void setSaldoDisp(double saldoDisp) {
		this.saldoDisp = saldoDisp;
	}
	public double getSaldoBloq() {
		return saldoBloq;
	}
	public void setSaldoBloq(double saldoBloq) {
		this.saldoBloq = saldoBloq;
	}
	public double getSaldoTotal() {
		return saldoTotal;
	}
	public void setSaldoTotal(double saldoTotal) {
		this.saldoTotal = saldoTotal;
	}
	public double getCapital() {
		return capital;
	}
	public void setCapital(double capital) {
		this.capital = capital;
	}
	public double getInteres() {
		return interes;
	}
	public void setInteres(double interes) {
		this.interes = interes;
	}
	public double getIvaInteres() {
		return ivaInteres;
	}
	public void setIvaInteres(double ivaInteres) {
		this.ivaInteres = ivaInteres;
	}
	public double getAccesorios() {
		return accesorios;
	}
	public void setAccesorios(double accesorios) {
		this.accesorios = accesorios;
	}
	public double getiVAAccesorios() {
		return iVAAccesorios;
	}
	public void setiVAAccesorios(double iVAAccesorios) {
		this.iVAAccesorios = iVAAccesorios;
	}
	public double getNotasCargo() {
		return notasCargo;
	}
	public void setNotasCargo(double notasCargo) {
		this.notasCargo = notasCargo;
	}
	public double getiVANotaCargo() {
		return iVANotaCargo;
	}
	public void setiVANotaCargo(double iVANotaCargo) {
		this.iVANotaCargo = iVANotaCargo;
	}
	public double getTotalPagado() {
		return totalPagado;
	}
	public void setTotalPagado(double totalPagado) {
		this.totalPagado = totalPagado;
	}
	public double getImportePenApli() {
		return importePenApli;
	}
	public void setImportePenApli(double importePenApli) {
		this.importePenApli = importePenApli;
	}
	public double getTotalOperacion() {
		return totalOperacion;
	}
	public void setTotalOperacion(double totalOperacion) {
		this.totalOperacion = totalOperacion;
	}
	public String getNombreInstPago() {
		return nombreInstPago;
	}
	public void setNombreInstPago(String nombreInstPago) {
		this.nombreInstPago = nombreInstPago;
	}
	public String getCuentaPago() {
		return cuentaPago;
	}
	public void setCuentaPago(String cuentaPago) {
		this.cuentaPago = cuentaPago;
	}
	public String getOrigenPago() {
		return origenPago;
	}
	public void setOrigenPago(String origenPago) {
		this.origenPago = origenPago;
	}
	public String getConceptoPago() {
		return conceptoPago;
	}
	public void setConceptoPago(String conceptoPago) {
		this.conceptoPago = conceptoPago;
	}
	
	
	
	/*SECCCION DEL REPORTE*/
	
	
}
