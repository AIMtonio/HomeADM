package arrendamiento.bean;

import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import general.bean.BaseBean;

public class DepositoRefereArrendaBean extends BaseBean{
	
	public final String concAplica = "36";
	public final String descAplica = "Aplicacion Deposito Referenciado";
	
	// ATRIBUTOS DE LA TABLA 
	private String arrendaID;
	private String clienteID;
	private CommonsMultipartFile file = null;
	
	private String depRefereID;
	private String folioCargaID;
	private String numeroMov;
	private String institucionID;
	private String numCtaInstit;
	private String fechaCarga;
	private String fechaValor;
	private String fechaAplica;
	private String fechaOperacion;
	private String natMovimiento;
	private String montoMov;
	private String tipoMov;
	private String descripcionMov;
	private String referenciaMov;
	private String estatus;
	private String montoPendApli;
	private String tipoCanal;
	private String tipoDeposito;
	private String tipoMoneda;
	private String descrMoneda;
	private String referenNoIden;
	private String descripNoIden;
	private String bancoEstandar;
	private String nombreCorto;
	private String poliza;

	private String seleccionado;
	
	//auxiliares de fechas
	private String fechaCargaInicial;
	private String fechaCargaFinal;
	
	
	private String numError;
	private String descError;
	private int LineaError;
	
	private List lDepRefereID;
	private List lFolioCargaID;
	private List lFechaCarga;
	private List lReferenciaMov;
	private List lCliente;
	private List lMontoMov;
	private List lSeleccionado;

	// CAMPOS DE AUDITORIA 
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	public String getSeleccionado() {
		return seleccionado;
	}
	public void setSeleccionado(String seleccionado) {
		this.seleccionado = seleccionado;
	}
	public List getlSeleccionado() {
		return lSeleccionado;
	}
	public void setlSeleccionado(List lSeleccionado) {
		this.lSeleccionado = lSeleccionado;
	}
	public List getlDepRefereID() {
		return lDepRefereID;
	}
	public void setlDepRefereID(List lDepRefereID) {
		this.lDepRefereID = lDepRefereID;
	}
	public List getlFolioCargaID() {
		return lFolioCargaID;
	}
	public void setlFolioCargaID(List lFolioCargaID) {
		this.lFolioCargaID = lFolioCargaID;
	}
	public List getlFechaCarga() {
		return lFechaCarga;
	}
	public void setlFechaCarga(List lFechaCarga) {
		this.lFechaCarga = lFechaCarga;
	}
	public List getlReferenciaMov() {
		return lReferenciaMov;
	}
	public void setlReferenciaMov(List lReferenciaMov) {
		this.lReferenciaMov = lReferenciaMov;
	}
	public List getlCliente() {
		return lCliente;
	}
	public void setlCliente(List lCliente) {
		this.lCliente = lCliente;
	}
	public List getlMontoMov() {
		return lMontoMov;
	}
	public void setlMontoMov(List lMontoMov) {
		this.lMontoMov = lMontoMov;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getFechaAplica() {
		return fechaAplica;
	}
	public void setFechaAplica(String fechaAplica) {
		this.fechaAplica = fechaAplica;
	}
	public String getDepRefereID() {
		return depRefereID;
	}
	public void setDepRefereID(String depRefereID) {
		this.depRefereID = depRefereID;
	}
	public String getArrendaID() {
		return arrendaID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public CommonsMultipartFile getFile() {
		return file;
	}
	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}
	public String getNumeroMov() {
		return numeroMov;
	}
	public void setNumeroMov(String numeroMov) {
		this.numeroMov = numeroMov;
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
	public String getFechaCarga() {
		return fechaCarga;
	}
	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}
	public String getFechaValor() {
		return fechaValor;
	}
	public void setFechaValor(String fechaValor) {
		this.fechaValor = fechaValor;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getMontoMov() {
		return montoMov;
	}
	public void setMontoMov(String montoMov) {
		this.montoMov = montoMov;
	}
	public String getTipoMov() {
		return tipoMov;
	}
	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public String getReferenciaMov() {
		return referenciaMov;
	}
	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMontoPendApli() {
		return montoPendApli;
	}
	public void setMontoPendApli(String montoPendApli) {
		this.montoPendApli = montoPendApli;
	}
	public String getTipoCanal() {
		return tipoCanal;
	}
	public void setTipoCanal(String tipoCanal) {
		this.tipoCanal = tipoCanal;
	}
	public String getTipoDeposito() {
		return tipoDeposito;
	}
	public void setTipoDeposito(String tipoDeposito) {
		this.tipoDeposito = tipoDeposito;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getDescrMoneda() {
		return descrMoneda;
	}
	public void setDescrMoneda(String descrMoneda) {
		this.descrMoneda = descrMoneda;
	}
	public String getReferenNoIden() {
		return referenNoIden;
	}
	public void setReferenNoIden(String referenNoIden) {
		this.referenNoIden = referenNoIden;
	}
	public String getDescripNoIden() {
		return descripNoIden;
	}
	public void setDescripNoIden(String descripNoIden) {
		this.descripNoIden = descripNoIden;
	}
	public String getBancoEstandar() {
		return bancoEstandar;
	}
	public void setBancoEstandar(String bancoEstandar) {
		this.bancoEstandar = bancoEstandar;
	}
	public String getFechaCargaInicial() {
		return fechaCargaInicial;
	}
	public void setFechaCargaInicial(String fechaCargaInicial) {
		this.fechaCargaInicial = fechaCargaInicial;
	}
	public String getFechaCargaFinal() {
		return fechaCargaFinal;
	}
	public void setFechaCargaFinal(String fechaCargaFinal) {
		this.fechaCargaFinal = fechaCargaFinal;
	}
	

	public String getPoliza() {
		return poliza;
	}
	public void setPoliza(String poliza) {
		this.poliza = poliza;
	}
	public String getNumError() {
		return numError;
	}
	public void setNumError(String numError) {
		this.numError = numError;
	}
	public String getDescError() {
		return descError;
	}
	public void setDescError(String descError) {
		this.descError = descError;
	}
	public int getLineaError() {
		return LineaError;
	}
	public void setLineaError(int lineaError) {
		LineaError = lineaError;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
}
