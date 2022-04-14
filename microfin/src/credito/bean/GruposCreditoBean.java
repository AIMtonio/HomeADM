package credito.bean;

import general.bean.BaseBean;

public class GruposCreditoBean extends BaseBean {
	
	private String grupoID;
	private String nombreGrupo;
	private String fechaRegistro;
	private String sucursalID;
	private String cicloActual;
	private String estatusCiclo;
	private String fechaUltCiclo;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// auxiliares del Bean
	private String montoTotDeuda;
	private String creditoID;
	private String productoCre;
	private String validaInt;
	private String nombreSucursal;
	private String estatusSol;
	private String sucursalPromotor;
	private String promAtiendeSuc;
	
	//auxiliares del bean para consulta de integrantes
	private String tInt;//total de integrantes
	private String tMS;//total de mujeres solteras
	private String tM;//total de mujeres
	private String tH;//total de hombres
	
	private double totalCuotaAdelantada;
	private double totalExigibleDia;
	
	private String pagareImpreso;
	private String tipoOperacion;
	private String esAgropecuario;
	private String numCreditos;
	private String prorrateaPago;
	private String refPayCash;

	
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
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getCicloActual() {
		return cicloActual;
	}
	public void setCicloActual(String cicloActual) {
		this.cicloActual = cicloActual;
	}
	public String getEstatusCiclo() {
		return estatusCiclo;
	}
	public void setEstatusCiclo(String estatusCiclo) {
		this.estatusCiclo = estatusCiclo;
	}
	public String getFechaUltCiclo() {
		return fechaUltCiclo;
	}
	public void setFechaUltCiclo(String fechaUltCiclo) {
		this.fechaUltCiclo = fechaUltCiclo;
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
	public String getMontoTotDeuda() {
		return montoTotDeuda;
	}
	public void setMontoTotDeuda(String montoTotDeuda) {
		this.montoTotDeuda = montoTotDeuda;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProductoCre() {
		return productoCre;
	}
	public void setProductoCre(String productoCre) {
		this.productoCre = productoCre;
	}
	public String getValidaInt() {
		return validaInt;
	}
	public void setValidaInt(String validaInt) {
		this.validaInt = validaInt;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	/**
	 * @return the tInt
	 */
	public String gettInt() {
		return tInt;
	}
	/**
	 * @param tInt the tInt to set
	 */
	public void settInt(String tInt) {
		this.tInt = tInt;
	}
	/**
	 * @return the tMS
	 */
	public String gettMS() {
		return tMS;
	}
	/**
	 * @param tMS the tMS to set
	 */
	public void settMS(String tMS) {
		this.tMS = tMS;
	}
	/**
	 * @return the tM
	 */
	public String gettM() {
		return tM;
	}
	/**
	 * @param tM the tM to set
	 */
	public void settM(String tM) {
		this.tM = tM;
	}
	/**
	 * @return the tH
	 */
	public String gettH() {
		return tH;
	}
	/**
	 * @param tH the tH to set
	 */
	public void settH(String tH) {
		this.tH = tH;
	}
	public double getTotalCuotaAdelantada() {
		return totalCuotaAdelantada;
	}
	public void setTotalCuotaAdelantada(double totalCuotaAdelantada) {
		this.totalCuotaAdelantada = totalCuotaAdelantada;
	}
	public double getTotalExigibleDia() {
		return totalExigibleDia;
	}
	public void setTotalExigibleDia(double totalExigibleDia) {
		this.totalExigibleDia = totalExigibleDia;
	}
	public String getEstatusSol() {
		return estatusSol;
	}
	public void setEstatusSol(String estatusSol) {
		this.estatusSol = estatusSol;
	}
	public String getSucursalPromotor() {
		return sucursalPromotor;
	}
	public void setSucursalPromotor(String sucursalPromotor) {
		this.sucursalPromotor = sucursalPromotor;
	}
	public String getPromAtiendeSuc() {
		return promAtiendeSuc;
	}
	public void setPromAtiendeSuc(String promAtiendeSuc) {
		this.promAtiendeSuc = promAtiendeSuc;
	}
	public String getPagareImpreso() {
		return pagareImpreso;
	}
	public void setPagareImpreso(String pagareImpreso) {
		this.pagareImpreso = pagareImpreso;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getEsAgropecuario() {
		return esAgropecuario;
	}
	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	public String getNumCreditos() {
		return numCreditos;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}
	public String getProrrateaPago() {
		return prorrateaPago;
	}
	public void setProrrateaPago(String prorrateaPago) {
		this.prorrateaPago = prorrateaPago;
	}
	public String getRefPayCash() {
		return refPayCash;
	}
	public void setRefPayCash(String refPayCash) {
		this.refPayCash = refPayCash;
	}	
}
