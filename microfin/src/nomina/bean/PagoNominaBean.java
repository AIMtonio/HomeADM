package nomina.bean;

import java.util.List;

import general.bean.BaseBean;

public class PagoNominaBean extends BaseBean{

	private String folioNominaID;
	private String folioCargaID;
	private String folioCargaIDBE;
	private String folioCargaTeso;
	private String institNominaID;
	private String fechaCarga;
	private String creditoID;
	private String clienteID;
	private String montoPagos;
	private String institucionID;
	private String numCuenta;
	private String motivoCancela;
	private String correoElectronico;
	private String fechaAplica;
	private String fechaInicio;
	private String fechaFin;
	private String fechaEmision;
	private String verificaBancos;
	private String depositoBancos;
	private String centroCostoID;

	private String claveUsuario;
	private String nombreInstitucion;
	private String borraDatos;
	private String nombreInstitFin;
	private String nombreInstitNomina;
	private String tipoReporte;
	private String fechaPago;
	private String montoPagar;
	private String ProducCreditoID;
	private String nombreUsuario;
	private String hora;
	private String cuentaAhoID;
	private String montoAplicado;
	private String montoNoAplicado;
	private String montoRecibido;

	private String convenio;
	private String consecutivoID;
	private String esSeleccionado;
	private String polizaID;
	private String folioPendienteID;
	private String estatus;

	private List listaFolioNominaID;
	private List listaFechaCarga;
	private List listaMontoPagos;
	private List listaSeleccionados;
	private List listaClienteID;
	private List listaCreditoID;
	private List<String> listaEsSeleccionado;
	private List<String> listaConsecutivoID;

	public String getFolioNominaID() {
		return folioNominaID;
	}
	public void setFolioNominaID(String folioNominaID) {
		this.folioNominaID = folioNominaID;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}
	public String getFolioCargaIDBE() {
		return folioCargaIDBE;
	}
	public void setFolioCargaIDBE(String folioCargaIDBE) {
		this.folioCargaIDBE = folioCargaIDBE;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getFechaCarga() {
		return fechaCarga;
	}
	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
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
	public String getMontoPagos() {
		return montoPagos;
	}
	public void setMontoPagos(String montoPagos) {
		this.montoPagos = montoPagos;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public List getListaFolioNominaID() {
		return listaFolioNominaID;
	}
	public void setListaFolioNominaID(List listaFolioNominaID) {
		this.listaFolioNominaID = listaFolioNominaID;
	}
	public List getListaFechaCarga() {
		return listaFechaCarga;
	}
	public void setListaFechaCarga(List listaFechaCarga) {
		this.listaFechaCarga = listaFechaCarga;
	}
	public List getListaMontoPagos() {
		return listaMontoPagos;
	}
	public void setListaMontoPagos(List listaMontoPagos) {
		this.listaMontoPagos = listaMontoPagos;
	}
	public List getListaSeleccionados() {
		return listaSeleccionados;
	}
	public void setListaSeleccionados(List listaSeleccionados) {
		this.listaSeleccionados = listaSeleccionados;
	}
	public String getMotivoCancela() {
		return motivoCancela;
	}
	public void setMotivoCancela(String motivoCancela) {
		this.motivoCancela = motivoCancela;
	}
	public String getCorreoElectronico() {
		return correoElectronico;
	}
	public void setCorreoElectronico(String correoElectronico) {
		this.correoElectronico = correoElectronico;
	}
	public String getVerificaBancos() {
		return verificaBancos;
	}
	public void setVerificaBancos(String verificaBancos) {
		this.verificaBancos = verificaBancos;
	}
	public String getFechaAplica() {
		return fechaAplica;
	}
	public void setFechaAplica(String fechaAplica) {
		this.fechaAplica = fechaAplica;
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
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
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
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getDepositoBancos() {
		return depositoBancos;
	}
	public void setDepositoBancos(String depositoBancos) {
		this.depositoBancos = depositoBancos;
	}
	public String getFolioCargaTeso() {
		return folioCargaTeso;
	}
	public void setFolioCargaTeso(String folioCargaTeso) {
		this.folioCargaTeso = folioCargaTeso;
	}
	public String getBorraDatos() {
		return borraDatos;
	}
	public void setBorraDatos(String borraDatos) {
		this.borraDatos = borraDatos;
	}
	public String getNombreInstitFin() {
		return nombreInstitFin;
	}
	public void setNombreInstitFin(String nombreInstitFin) {
		this.nombreInstitFin = nombreInstitFin;
	}
	public String getNombreInstitNomina() {
		return nombreInstitNomina;
	}
	public void setNombreInstitNomina(String nombreInstitNomina) {
		this.nombreInstitNomina = nombreInstitNomina;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public List getListaClienteID() {
		return listaClienteID;
	}
	public void setListaClienteID(List listaClienteID) {
		this.listaClienteID = listaClienteID;
	}
	public List getListaCreditoID() {
		return listaCreditoID;
	}
	public void setListaCreditoID(List listaCreditoID) {
		this.listaCreditoID = listaCreditoID;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoPagar() {
		return montoPagar;
	}
	public void setMontoPagar(String montoPagar) {
		this.montoPagar = montoPagar;
	}
	public String getProducCreditoID() {
		return ProducCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		ProducCreditoID = producCreditoID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMontoAplicado() {
		return montoAplicado;
	}
	public void setMontoAplicado(String montoAplicado) {
		this.montoAplicado = montoAplicado;
	}
	public String getMontoNoAplicado() {
		return montoNoAplicado;
	}
	public void setMontoNoAplicado(String montoNoAplicado) {
		this.montoNoAplicado = montoNoAplicado;
	}
	public String getMontoRecibido() {
		return montoRecibido;
	}
	public void setMontoRecibido(String montoRecibido) {
		this.montoRecibido = montoRecibido;
	}
	public String getConvenio() {
		return convenio;
	}
	public void setConvenio(String convenio) {
		this.convenio = convenio;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getEsSeleccionado() {
		return esSeleccionado;
	}
	public void setEsSeleccionado(String esSeleccionado) {
		this.esSeleccionado = esSeleccionado;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public List<String> getListaEsSeleccionado() {
		return listaEsSeleccionado;
	}
	public void setListaEsSeleccionado(List<String> listaEsSeleccionado) {
		this.listaEsSeleccionado = listaEsSeleccionado;
	}
	public List<String> getListaConsecutivoID() {
		return listaConsecutivoID;
	}
	public void setListaConsecutivoID(List<String> listaConsecutivoID) {
		this.listaConsecutivoID = listaConsecutivoID;
	}
	public String getFolioPendienteID() {
		return folioPendienteID;
	}
	public void setFolioPendienteID(String folioPendienteID) {
		this.folioPendienteID = folioPendienteID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

}