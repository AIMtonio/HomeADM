package credito.bean;

import java.util.List;

import general.bean.BaseBean;

public class NotasCargoBean extends BaseBean {

	private String notaCargoID;
	private String creditoID;
	private String clienteID;
	private String tipoNotaCargoID;
	private String monto;
	private String amortizacionID;
	private String iva;
	private String motivo;
	private String estatus;
	private String tranPagoCredito;
	private String amortizacionPago;

	private String fechaExigible;
	private String capital;
	private String interesOrd;
	private String ivaInteres;
	private String moratorio;
	private String ivaMoratorio;
	private String otrasComisiones;
	private String ivaComisiones;
	private String notasCargo;
	private String ivaNotasCargo;
	private String totalPago;
	private String tieneNotas;

	private List<String> listaAmortizacionID;
	private List<String> listaCapital;
	private List<String> listaInteresOrd;
	private List<String> listaIvaInteres;
	private List<String> listaMoratorio;
	private List<String> listaIvaMoratorio;
	private List<String> listaOtrasComisiones;
	private List<String> listaIvaComisiones;
	private List<String> listaTotalPago;
	private List<String> listaCheck;
	private List<String> listaTranPagoCredito;

	private String fechaInicio;
	private String fechaFin;
	private String productoCreditoID;
	private String institucionNominaID;
	private String convenioNominaID;
	private String productoCredito;
	private String institucionNomina;
	private String convenioNomina;

	public String getNotaCargoID() {
		return notaCargoID;
	}
	public void setNotaCargoID(String notaCargoID) {
		this.notaCargoID = notaCargoID;
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
	public String getTipoNotaCargoID() {
		return tipoNotaCargoID;
	}
	public void setTipoNotaCargoID(String tipoNotaCargoID) {
		this.tipoNotaCargoID = tipoNotaCargoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getIva() {
		return iva;
	}
	public void setIva(String iva) {
		this.iva = iva;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTranPagoCredito() {
		return tranPagoCredito;
	}
	public void setTranPagoCredito(String tranPagoCredito) {
		this.tranPagoCredito = tranPagoCredito;
	}
	public String getAmortizacionPago() {
		return amortizacionPago;
	}
	public void setAmortizacionPago(String amortizacionPago) {
		this.amortizacionPago = amortizacionPago;
	}
	public String getFechaExigible() {
		return fechaExigible;
	}
	public void setFechaExigible(String fechaExigible) {
		this.fechaExigible = fechaExigible;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteresOrd() {
		return interesOrd;
	}
	public void setInteresOrd(String interesOrd) {
		this.interesOrd = interesOrd;
	}
	public String getIvaInteres() {
		return ivaInteres;
	}
	public void setIvaInteres(String ivaInteres) {
		this.ivaInteres = ivaInteres;
	}
	public String getMoratorio() {
		return moratorio;
	}
	public void setMoratorio(String moratorio) {
		this.moratorio = moratorio;
	}
	public String getIvaMoratorio() {
		return ivaMoratorio;
	}
	public void setIvaMoratorio(String ivaMoratorio) {
		this.ivaMoratorio = ivaMoratorio;
	}
	public String getOtrasComisiones() {
		return otrasComisiones;
	}
	public void setOtrasComisiones(String otrasComisiones) {
		this.otrasComisiones = otrasComisiones;
	}
	public String getIvaComisiones() {
		return ivaComisiones;
	}
	public void setIvaComisiones(String ivaComisiones) {
		this.ivaComisiones = ivaComisiones;
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
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getTieneNotas() {
		return tieneNotas;
	}
	public void setTieneNotas(String tieneNotas) {
		this.tieneNotas = tieneNotas;
	}
	public List<String> getListaAmortizacionID() {
		return listaAmortizacionID;
	}
	public void setListaAmortizacionID(List<String> listaAmortizacionID) {
		this.listaAmortizacionID = listaAmortizacionID;
	}
	public List<String> getListaCapital() {
		return listaCapital;
	}
	public void setListaCapital(List<String> listaCapital) {
		this.listaCapital = listaCapital;
	}
	public List<String> getListaInteresOrd() {
		return listaInteresOrd;
	}
	public void setListaInteresOrd(List<String> listaInteresOrd) {
		this.listaInteresOrd = listaInteresOrd;
	}
	public List<String> getListaIvaInteres() {
		return listaIvaInteres;
	}
	public void setListaIvaInteres(List<String> listaIvaInteres) {
		this.listaIvaInteres = listaIvaInteres;
	}
	public List<String> getListaMoratorio() {
		return listaMoratorio;
	}
	public void setListaMoratorio(List<String> listaMoratorio) {
		this.listaMoratorio = listaMoratorio;
	}
	public List<String> getListaIvaMoratorio() {
		return listaIvaMoratorio;
	}
	public void setListaIvaMoratorio(List<String> listaIvaMoratorio) {
		this.listaIvaMoratorio = listaIvaMoratorio;
	}
	public List<String> getListaOtrasComisiones() {
		return listaOtrasComisiones;
	}
	public void setListaOtrasComisiones(List<String> listaOtrasComisiones) {
		this.listaOtrasComisiones = listaOtrasComisiones;
	}
	public List<String> getListaIvaComisiones() {
		return listaIvaComisiones;
	}
	public void setListaIvaComisiones(List<String> listaIvaComisiones) {
		this.listaIvaComisiones = listaIvaComisiones;
	}
	public List<String> getListaTotalPago() {
		return listaTotalPago;
	}
	public void setListaTotalPago(List<String> listaTotalPago) {
		this.listaTotalPago = listaTotalPago;
	}
	public List<String> getListaCheck() {
		return listaCheck;
	}
	public void setListaCheck(List<String> listaCheck) {
		this.listaCheck = listaCheck;
	}
	public List<String> getListaTranPagoCredito() {
		return listaTranPagoCredito;
	}
	public void setListaTranPagoCredito(List<String> listaTranPagoCredito) {
		this.listaTranPagoCredito = listaTranPagoCredito;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}
	public String getInstitucionNomina() {
		return institucionNomina;
	}
	public void setInstitucionNomina(String institucionNomina) {
		this.institucionNomina = institucionNomina;
	}
	public String getConvenioNomina() {
		return convenioNomina;
	}
	public void setConvenioNomina(String convenioNomina) {
		this.convenioNomina = convenioNomina;
	}
}