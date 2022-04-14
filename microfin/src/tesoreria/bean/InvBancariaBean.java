package tesoreria.bean;

import general.bean.BaseBean;

public class InvBancariaBean extends BaseBean{
	
	private String inversionID;
	private String institucionID;
	private String nombreInstitucion;
	private String numCtaInstit;
	private String tipoInversion;
	private String saldoCuenta;
	private String fechaInicio;
	private String fechaVencimiento;
	private String diasBase;
	private String monto;
	private String plazo;
	private String monedaID;
	private String tasa;
	private String tasaISR;
	private String tasaNeta;
	private String interesGenerado;
	private String interesRecibir;
	private String interesRetener;
	private String totalRecibir;
	
	private String ClasificacionInver;
	private String TipoTitulo;
	private String TipoRestriccion;
	private String TipoDeuda;
	
	//Variables para Reporte
	private String estatus;
	private String interesProvisionado;
	private String nombreCorto;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String fechaSistema;
	
	private String salarioMinimo;
	private String numeroSalarios;
	private String montoBaseInversion;
	
	public final String ConceptoInvBan="1";
	public final String ConceptoContable="73";
	public final String tipoMovimientoTesoreria="7";
	public final String naturalezaCargo="C";
	public final String alta_poliza_no="N";
	public final String descripcionContable="REGISTRO DE INV.BANCARIA";
	public final String descripcionMovimiento="CARGO PARA INV.BANCARIA";
	
	
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getTipoInversion() {
		return tipoInversion;
	}
	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}
	public String getSaldoCuenta() {
		return saldoCuenta;
	}
	public void setSaldoCuenta(String saldoCuenta) {
		this.saldoCuenta = saldoCuenta;
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
	public String getDiasBase() {
		return diasBase;
	}
	public void setDiasBase(String diasBase) {
		this.diasBase = diasBase;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getTasaNeta() {
		return tasaNeta;
	}
	public void setTasaNeta(String tasaNeta) {
		this.tasaNeta = tasaNeta;
	}
	public String getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}
	public String getInteresRecibir() {
		return interesRecibir;
	}
	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}
	public String getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}
	public String getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getInteresProvisionado() {
		return interesProvisionado;
	}
	public void setInteresProvisionado(String interesProvisionado) {
		this.interesProvisionado = interesProvisionado;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getClasificacionInver() {
		return ClasificacionInver;
	}
	public void setClasificacionInver(String clasificacionInver) {
		ClasificacionInver = clasificacionInver;
	}
	public String getTipoTitulo() {
		return TipoTitulo;
	}
	public void setTipoTitulo(String tipoTitulo) {
		TipoTitulo = tipoTitulo;
	}
	public String getTipoRestriccion() {
		return TipoRestriccion;
	}
	public void setTipoRestriccion(String tipoRestriccion) {
		TipoRestriccion = tipoRestriccion;
	}
	public String getTipoDeuda() {
		return TipoDeuda;
	}
	public void setTipoDeuda(String tipoDeuda) {
		TipoDeuda = tipoDeuda;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNumeroSalarios() {
		return numeroSalarios;
	}
	public void setNumeroSalarios(String numeroSalarios) {
		this.numeroSalarios = numeroSalarios;
	}
	public String getSalarioMinimo() {
		return salarioMinimo;
	}
	public void setSalarioMinimo(String salarioMinimo) {
		this.salarioMinimo = salarioMinimo;
	}
	public String getMontoBaseInversion() {
		return montoBaseInversion;
	}
	public void setMontoBaseInversion(String montoBaseInversion) {
		this.montoBaseInversion = montoBaseInversion;
	}
}
