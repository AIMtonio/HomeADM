package nomina.bean;

import java.util.List;

import general.bean.BaseBean;

public class AplicaPagoInstBean extends BaseBean{
	private String institNominaID;
	private String fechaInicio;
	private String fechaFin;
	private String numFolio;
	private String fechaDescuento;

	private String montoTotalDesc;
	private String estatusPagoDesc;
	private String estatusPagoInst;
	private String institucionID;
	private String numCuenta;

	private String movConciliado;
	private String montoPagoInst;
	private String fechaPagoInst;
	private String totalPagos;

	private String FolioNum;
	private String creditoID;
	private String clienteID;
	private String nomEmpleado;
	private String montoPagos;
	private String productoCredito;
	private String seleccionados;

	private List listaFolioNominaID;
	private List listaCreditoID;
	private List listaClienteID;
	private List listaNomEmpleado;
	private List listaMontoPagos;
	private List listaProductoCredito;
	private List listaSeleccionadoss;
	private List listaSeleccionados2;
	private List listaMontoPagos2;

	private String borraDatos;
	private String esSeleccionado;
	private String consecutivoID;
	private List listaEsSeleccionado;
	private String controlLista;
	private String esSeleccionado2;
	private String consecutivoID2;
	private List listaEsSeleccionado2;

	private String esAplicado;
	private String aplicaTodos;

	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
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
	public String getNumFolio() {
		return numFolio;
	}
	public void setNumFolio(String numFolio) {
		this.numFolio = numFolio;
	}
	public String getFechaDescuento() {
		return fechaDescuento;
	}
	public void setFechaDescuento(String fechaDescuento) {
		this.fechaDescuento = fechaDescuento;
	}
	public String getMontoTotalDesc() {
		return montoTotalDesc;
	}
	public void setMontoTotalDesc(String montoTotalDesc) {
		this.montoTotalDesc = montoTotalDesc;
	}
	public String getEstatusPagoDesc() {
		return estatusPagoDesc;
	}
	public void setEstatusPagoDesc(String estatusPagoDesc) {
		this.estatusPagoDesc = estatusPagoDesc;
	}
	public String getEstatusPagoInst() {
		return estatusPagoInst;
	}
	public void setEstatusPagoInst(String estatusPagoInst) {
		this.estatusPagoInst = estatusPagoInst;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getMovConciliado() {
		return movConciliado;
	}
	public void setMovConciliado(String movConciliado) {
		this.movConciliado = movConciliado;
	}
	public String getMontoPagoInst() {
		return montoPagoInst;
	}
	public void setMontoPagoInst(String montoPagoInst) {
		this.montoPagoInst = montoPagoInst;
	}
	public String getFechaPagoInst() {
		return fechaPagoInst;
	}
	public void setFechaPagoInst(String fechaPagoInst) {
		this.fechaPagoInst = fechaPagoInst;
	}
	public String getTotalPagos() {
		return totalPagos;
	}
	public void setTotalPagos(String totalPagos) {
		this.totalPagos = totalPagos;
	}
	public List getListaFolioNominaID() {
		return listaFolioNominaID;
	}
	public void setListaFolioNominaID(List listaFolioNominaID) {
		this.listaFolioNominaID = listaFolioNominaID;
	}
	public List getListaCreditoID() {
		return listaCreditoID;
	}
	public void setListaCreditoID(List listaCreditoID) {
		this.listaCreditoID = listaCreditoID;
	}
	public List getListaClienteID() {
		return listaClienteID;
	}
	public void setListaClienteID(List listaClienteID) {
		this.listaClienteID = listaClienteID;
	}
	public List getListaNomEmpleado() {
		return listaNomEmpleado;
	}
	public void setListaNomEmpleado(List listaNomEmpleado) {
		this.listaNomEmpleado = listaNomEmpleado;
	}
	public List getListaMontoPagos() {
		return listaMontoPagos;
	}
	public void setListaMontoPagos(List listaMontoPagos) {
		this.listaMontoPagos = listaMontoPagos;
	}
	public List getListaProductoCredito() {
		return listaProductoCredito;
	}
	public void setListaProductoCredito(List listaProductoCredito) {
		this.listaProductoCredito = listaProductoCredito;
	}
	public String getFolioNum() {
		return FolioNum;
	}
	public void setFolioNum(String folioNum) {
		FolioNum = folioNum;
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
	public String getNomEmpleado() {
		return nomEmpleado;
	}
	public void setNomEmpleado(String nomEmpleado) {
		this.nomEmpleado = nomEmpleado;
	}
	public String getMontoPagos() {
		return montoPagos;
	}
	public void setMontoPagos(String montoPagos) {
		this.montoPagos = montoPagos;
	}
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}
	public String getSeleccionados() {
		return seleccionados;
	}
	public void setSeleccionados(String seleccionados) {
		this.seleccionados = seleccionados;
	}
	public String getBorraDatos() {
		return borraDatos;
	}
	public void setBorraDatos(String borraDatos) {
		this.borraDatos = borraDatos;
	}
	public List getListaSeleccionados2() {
		return listaSeleccionados2;
	}
	public void setListaSeleccionados2(List listaSeleccionados2) {
		this.listaSeleccionados2 = listaSeleccionados2;
	}
	public List getListaMontoPagos2() {
		return listaMontoPagos2;
	}
	public void setListaMontoPagos2(List listaMontoPagos2) {
		this.listaMontoPagos2 = listaMontoPagos2;
	}
	public List getListaSeleccionadoss() {
		return listaSeleccionadoss;
	}
	public void setListaSeleccionadoss(List listaSeleccionadoss) {
		this.listaSeleccionadoss = listaSeleccionadoss;
	}
	public String getEsSeleccionado() {
		return esSeleccionado;
	}
	public void setEsSeleccionado(String esSeleccionado) {
		this.esSeleccionado = esSeleccionado;
	}
	public List getListaEsSeleccionado() {
		return listaEsSeleccionado;
	}
	public void setListaEsSeleccionado(List listaEsSeleccionado) {
		this.listaEsSeleccionado = listaEsSeleccionado;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getControlLista() {
		return controlLista;
	}
	public void setControlLista(String controlLista) {
		this.controlLista = controlLista;
	}
	public String getEsSeleccionado2() {
		return esSeleccionado2;
	}
	public void setEsSeleccionado2(String esSeleccionado2) {
		this.esSeleccionado2 = esSeleccionado2;
	}
	public String getConsecutivoID2() {
		return consecutivoID2;
	}
	public void setConsecutivoID2(String consecutivoID2) {
		this.consecutivoID2 = consecutivoID2;
	}
	public List getListaEsSeleccionado2() {
		return listaEsSeleccionado2;
	}
	public void setListaEsSeleccionado2(List listaEsSeleccionado2) {
		this.listaEsSeleccionado2 = listaEsSeleccionado2;
	}
	public String getEsAplicado() {
		return esAplicado;
	}
	public void setEsAplicado(String esAplicado) {
		this.esAplicado = esAplicado;
	}
	public String getAplicaTodos() {
		return aplicaTodos;
	}
	public void setAplicaTodos(String aplicaTodos) {
		this.aplicaTodos = aplicaTodos;
	}
}