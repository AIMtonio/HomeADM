package tesoreria.bean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class TesoMovsArchConciliaBean {
	 
	private String folioCargaID;
	private String cuentaAhoID;
	private String numeroMov;
	private String institucionID;
	private String numCtaInstit;
	private String fechaCarga;
	private String fechaCargaInicial;
	private String fechaCargaFinal;
	private String fechaValor;
	private String fechaOperacion;
	private String natMovimiento;
	private String montoMov;
	private String tipoMov;
	private String descripcionMov;
	private String deferenciaMov;
	private String status;
	private String referencia;
	
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private int tamanioListaCarga;
	private String versionFormato;
	
	//auxiliar para obtener el nombre de la sucursal para la lista de cuentas bancarias en transferencia cuentas propias/tesoreria
	private String sucursalInstit;
	
	public int getTamanioListaCarga() {
		return tamanioListaCarga;
	}

	public void setTamanioListaCarga(int tamanioListaCarga) {
		this.tamanioListaCarga = tamanioListaCarga;
	}

	private CommonsMultipartFile file = null;

	public String getFolioCargaID() {
		return folioCargaID;
	}

	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
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

	public String getDeferenciaMov() {
		return deferenciaMov;
	}

	public void setDeferenciaMov(String deferenciaMov) {
		this.deferenciaMov = deferenciaMov;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public CommonsMultipartFile getFile() {
		return file;
	}

	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}

	public String getReferencia() {
		return referencia;
	}

	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}

	/**
	 * @return the sucursalInstit
	 */
	public String getSucursalInstit() {
		return sucursalInstit;
	}

	/**
	 * @param sucursalInstit the sucursalInstit to set
	 */
	public void setSucursalInstit(String sucursalInstit) {
		this.sucursalInstit = sucursalInstit;
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

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getVersionFormato() {
		return versionFormato;
	}

	public void setVersionFormato(String versionFormato) {
		this.versionFormato = versionFormato;
	}
}