package originacion.bean;

import general.bean.BaseBean;

public class CapacidadPagoBean extends BaseBean {
	
	/*ATRIBUTOS DE LA TABLA */
	private String capacidadPagoID;
	private String clienteID;
	private String usuarioID;
	private String sucursalID;
	private String producCredito1;
	private String producCredito2;
	private String producCredito3;
	private String tasaInteres1;
	private String tasaInteres2;
	private String tasaInteres3;
	private String ingresoMensual;
	private String gastoMensual;
	private String montoSolicitado;
	private String abonoPropuesto;
	private String plazo;
	private String abonoEstimado;
	private String ingresosGastos;
	private String cobertura;
	private String cobSinPrestamo;
	private String cobConPrestamo;
	private String fecha;
	private String porcentajeCob;
	private String coberturaMin;
	
	/* para reporte */
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String fechaInicio;
	private String fechaFin;
	private String nombreCliente;
	private String nombreSucursal;

	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private int numero;//Numero de error
	private String descripcion;//Mensaje de errror
	

	
	/*=========== SETTER'S Y GETTER'S ============== */
	
	public String getCapacidadPagoID() {
		return capacidadPagoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getProducCredito1() {
		return producCredito1;
	}
	public String getProducCredito2() {
		return producCredito2;
	}
	public String getProducCredito3() {
		return producCredito3;
	}
	public String getTasaInteres1() {
		return tasaInteres1;
	}
	public String getTasaInteres2() {
		return tasaInteres2;
	}
	public String getTasaInteres3() {
		return tasaInteres3;
	}
	public String getIngresoMensual() {
		return ingresoMensual;
	}
	public String getGastoMensual() {
		return gastoMensual;
	}
	public String getMontoSolicitado() {
		return montoSolicitado;
	}
	public String getAbonoPropuesto() {
		return abonoPropuesto;
	}
	public String getPlazo() {
		return plazo;
	}
	public String getAbonoEstimado() {
		return abonoEstimado;
	}
	public String getIngresosGastos() {
		return ingresosGastos;
	}
	public String getCobertura() {
		return cobertura;
	}
	public String getCobSinPrestamo() {
		return cobSinPrestamo;
	}
	public String getCobConPrestamo() {
		return cobConPrestamo;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setCapacidadPagoID(String capacidadPagoID) {
		this.capacidadPagoID = capacidadPagoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setProducCredito1(String producCredito1) {
		this.producCredito1 = producCredito1;
	}
	public void setProducCredito2(String producCredito2) {
		this.producCredito2 = producCredito2;
	}
	public void setProducCredito3(String producCredito3) {
		this.producCredito3 = producCredito3;
	}
	public void setTasaInteres1(String tasaInteres1) {
		this.tasaInteres1 = tasaInteres1;
	}
	public void setTasaInteres2(String tasaInteres2) {
		this.tasaInteres2 = tasaInteres2;
	}
	public void setTasaInteres3(String tasaInteres3) {
		this.tasaInteres3 = tasaInteres3;
	}
	public void setIngresoMensual(String ingresoMensual) {
		this.ingresoMensual = ingresoMensual;
	}
	public void setGastoMensual(String gastoMensual) {
		this.gastoMensual = gastoMensual;
	}
	public void setMontoSolicitado(String montoSolicitado) {
		this.montoSolicitado = montoSolicitado;
	}
	public void setAbonoPropuesto(String abonoPropuesto) {
		this.abonoPropuesto = abonoPropuesto;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public void setAbonoEstimado(String abonoEstimado) {
		this.abonoEstimado = abonoEstimado;
	}
	public void setIngresosGastos(String ingresosGastos) {
		this.ingresosGastos = ingresosGastos;
	}
	public void setCobertura(String cobertura) {
		this.cobertura = cobertura;
	}
	public void setCobSinPrestamo(String cobSinPrestamo) {
		this.cobSinPrestamo = cobSinPrestamo;
	}
	public void setCobConPrestamo(String cobConPrestamo) {
		this.cobConPrestamo = cobConPrestamo;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getPorcentajeCob() {
		return porcentajeCob;
	}
	public String getCoberturaMin() {
		return coberturaMin;
	}
	public void setPorcentajeCob(String porcentajeCob) {
		this.porcentajeCob = porcentajeCob;
	}
	public void setCoberturaMin(String coberturaMin) {
		this.coberturaMin = coberturaMin;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public int getNumero() {
		return numero;
	}
	public void setNumero(int numero) {
		this.numero = numero;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	
	
}
