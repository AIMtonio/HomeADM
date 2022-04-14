package ventanilla.bean;

import general.bean.BaseBean;

public class CajasVentanillaBean extends BaseBean {
	private String tipoCajaID;
	private String sucursalID;
	private String cajaID;
	private String tipoCaja;
	private String usuarioID;
	private String descripcionCaja;
	private String estatus;
	private String estatusOpera;
	private String saldoEfecMN;
	private String saldoEfecME;
	private String limiteEfectivoMN;
	private String limiteDesembolsoMN;
	private String maximoRetiroMN;
	private String nomImpresora;
	private String nomImpresoraCheq;
	private String fechaCan;
	private String motivoCan;
	private String fechaInac;
	private String motivoInac;
	private String fechaAct;
	private String motivoAct;
	private String cajaIDOrigen;
	//Variables para el reporte de Tira Auditoria
	private String monedaID;
	private String fecha;
	private String movimiento;
	private String noMovimiento;
	private String montoTotal;
	private String naturaleza;
	private String numeroNat;
    private String descCorta;
	private String tipoOperacion;
//	auxiliares
	private String denominacionID;
	private String cantidadDenominacion;
	private String tipo;
	private String estilo;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;	
	private String institucionID;
	private String numCtaInstit;
	
	//repOpVentanilla
	private String fechaIni;
	private String fechaFin;
	private String referencia;
	private String efectivo;
	private String montoSBC;
	private String polizaID;
	private String clienteID;
	private String grupoCred;
	private String numCuenta;
	private String nombreCliente;
	private String nombreInstitucion;
	private String horaEmision;
	private String nombreSucursal;
	private String diferenciaMontos;
	private String huellaDigital;	

	
	private String instrumento;
	private String tipoInstrumentoID;
	private String montoOperacion;
	private String montoDeposito;
	private String montoCambio;
	
	
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getTipoCaja() {
		return tipoCaja;
	}
	public void setTipoCaja(String tipoCaja) {
		this.tipoCaja = tipoCaja;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getDescripcionCaja() {
		return descripcionCaja;
	}
	public void setDescripcionCaja(String descripcionCaja) {
		this.descripcionCaja = descripcionCaja;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus= estatus;
	}
	public String getSaldoEfecMN() {
		return saldoEfecMN;
	}
	public void setSaldoEfecMN(String saldoEfecMN) {
		this.saldoEfecMN = saldoEfecMN;
	}
	public String getSaldoEfecME() {
		return saldoEfecME;
	}
	public void setSaldoEfecME(String saldoEfecME) {
		this.saldoEfecME = saldoEfecME;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getFechaCan() {
		return fechaCan;
	}
	public void setFechaCan(String fechaCan) {
		this.fechaCan = fechaCan;
	}
	public String getMotivoCan() {
		return motivoCan;
	}
	public void setMotivoCan(String motivoCan) {
		this.motivoCan = motivoCan;
	}
	public String getFechaInac() {
		return fechaInac;
	}
	public void setFechaInac(String fechaInac) {
		this.fechaInac = fechaInac;
	}
	public String getMotivoInac() {
		return motivoInac;
	}
	public void setMotivoInac(String motivoInac) {
		this.motivoInac = motivoInac;
	}
	public String getFechaAct() {
		return fechaAct;
	}
	public void setFechaAct(String fechaAct) {
		this.fechaAct = fechaAct;
	}
	public String getMotivoAct() {
		return motivoAct;
	}
	public void setMotivoAct(String motivoAct) {
		this.motivoAct = motivoAct;
	}
	public String getMovimiento() {
		return movimiento;
	}
	public void setMovimiento(String movimiento) {
		this.movimiento = movimiento;
	}
	public String getNoMovimiento() {
		return noMovimiento;
	}
	public void setNoMovimiento(String noMovimiento) {
		this.noMovimiento = noMovimiento;
	}
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}
	public String getNaturaleza() {
		return naturaleza;
	}
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}
	public String getNumeroNat() {
		return numeroNat;
	}
	public void setNumeroNat(String numeroNat) {
		this.numeroNat = numeroNat;
	}
	public String getDescCorta(){
	    return descCorta;
	}
	public void setDescCorta(String descCorta) {
		this.descCorta = descCorta;
	}

	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getEstilo() {
		return estilo;
	}
	public void setEstilo(String estilo) {
		this.estilo = estilo;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
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
	public String getLimiteEfectivoMN() {
		return limiteEfectivoMN;
	}
	public void setLimiteEfectivoMN(String limiteEfectivoMN) {
		this.limiteEfectivoMN = limiteEfectivoMN;
	}
	/**
	 * @return the estatusOpera
	 */
	public String getEstatusOpera() {
		return estatusOpera;
	}
	/**
	 * @param estatusOpera the estatusOpera to set
	 */
	public void setEstatusOpera(String estatusOpera) {
		this.estatusOpera = estatusOpera;
	}
	public String getLimiteDesembolsoMN() {
		return limiteDesembolsoMN;
	}
	public void setLimiteDesembolsoMN(String limiteDesembolsoMN) {
		this.limiteDesembolsoMN = limiteDesembolsoMN;
	}
	public String getMaximoRetiroMN() {
		return maximoRetiroMN;
	}
	public void setMaximoRetiroMN(String maximoRetiroMN) {
		this.maximoRetiroMN = maximoRetiroMN;
	}
	public String getDenominacionID() {
		return denominacionID;
	}
	public void setDenominacionID(String denominacionID) {
		this.denominacionID = denominacionID;
	}
	public String getCantidadDenominacion() {
		return cantidadDenominacion;
	}
	public void setCantidadDenominacion(String cantidadDenominacion) {
		this.cantidadDenominacion = cantidadDenominacion;
	}
	public String getTipoCajaID() {
		return tipoCajaID;
	}
	public void setTipoCajaID(String tipoCajaID) {
		this.tipoCajaID = tipoCajaID;
	}
	public String getNomImpresora() {
		return nomImpresora;
	}
	public void setNomImpresora(String nomImpresora) {
		this.nomImpresora = nomImpresora;
	}
	public String getNomImpresoraCheq() {
		return nomImpresoraCheq;
	}
	public void setNomImpresoraCheq(String nomImpresoraCheq) {
		this.nomImpresoraCheq = nomImpresoraCheq;
	}
	public String getFechaIni() {
		return fechaIni;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getReferencia() {
		return referencia;
	}
	public String getEfectivo() {
		return efectivo;
	}
	public String getMontoSBC() {
		return montoSBC;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public void setEfectivo(String efectivo) {
		this.efectivo = efectivo;
	}
	public void setMontoSBC(String montoSBC) {
		this.montoSBC = montoSBC;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getGrupoCred() {
		return grupoCred;
	}
	public void setGrupoCred(String grupoCred) {
		this.grupoCred = grupoCred;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInsitucion) {
		this.nombreInstitucion = nombreInsitucion;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
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

	public String getHuellaDigital() {
		return huellaDigital;
	}
	public void setHuellaDigital(String huellaDigital) {
		this.huellaDigital = huellaDigital;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getMontoDeposito() {
		return montoDeposito;
	}
	public void setMontoDeposito(String montoDeposito) {
		this.montoDeposito = montoDeposito;
	}
	public String getMontoCambio() {
		return montoCambio;
	}
	public void setMontoCambio(String montoCambio) {
		this.montoCambio = montoCambio;
	}
	public String getDiferenciaMontos() {
		return diferenciaMontos;
	}
	public void setDiferenciaMontos(String diferenciaMontos) {
		this.diferenciaMontos = diferenciaMontos;
	}
	public String getCajaIDOrigen() {
		return cajaIDOrigen;
	}
	public void setCajaIDOrigen(String cajaIDOrigen) {
		this.cajaIDOrigen = cajaIDOrigen;
	}
	
	
}
