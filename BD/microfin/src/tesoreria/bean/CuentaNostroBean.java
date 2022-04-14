package tesoreria.bean;

import general.bean.BaseBean;

public class CuentaNostroBean extends BaseBean{

	private String cuentaAhoID;
	private String institucionID;
	private String sucursalInstit;
	private String numCtaInstit;
	private String cuentaClabe;
	private String chequera;
	private String cuentaCompletaID;
	private String centroCostoID;
	private String saldo;
	private String principal;
	private String estatus;
	private String folioUtilizar;
	private String rutaCheque;
	private String folioEmitido;
	private String sobregirarSaldo;
	private String tipoChequera;
	private String DescripTipoChe;
	private String folioUtilizarEstan;
	private String rutaChequeEstan;
	

	//parametros de auditoria  
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	private String beneficiarioCan;
	private String monto;
	private String concepto;
	private String fechaEmision;
	private String emitidoEn;
	
	//parametros para convenio
	private String numConvenio;
	private String descConvenio;
	
	//parametro para proteccion ordenes de pago
	private String protecOrdenPago;
	
	private String algClaveRetiro;
	private String vigClaveRetiro;

	public String getPrincipal() {
		return principal;
	}
	public void setPrincipal(String principal) {
		this.principal = principal;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getSucursalInstit() {
		return sucursalInstit;
	}
	public void setSucursalInstit(String sucursalInstit) {
		this.sucursalInstit = sucursalInstit;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getChequera() {
		return chequera;
	}
	public void setChequera(String chequera) {
		this.chequera = chequera;
	}
	public String getCuentaCompletaID() {
		return cuentaCompletaID;
	}
	public void setCuentaCompletaID(String cuentaCompletaID) {
		this.cuentaCompletaID = cuentaCompletaID;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getFolioUtilizar() {
		return folioUtilizar;
	}
	public void setFolioUtilizar(String folioUtilizar) {
		this.folioUtilizar = folioUtilizar;
	}
	public String getRutaCheque() {
		return rutaCheque;
	}
	public void setRutaCheque(String rutaCheque) {
		this.rutaCheque = rutaCheque;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getFolioEmitido() {
		return folioEmitido;
	}
	public void setFolioEmitido(String folioEmitido) {
		this.folioEmitido = folioEmitido;
	}

	public String getSobregirarSaldo() {
		return sobregirarSaldo;
	}
	public void setSobregirarSaldo(String sobregirarSaldo) {
		this.sobregirarSaldo = sobregirarSaldo;
	}
	public String getTipoChequera() {
		return tipoChequera;
	}
	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}
	public String getDescripTipoChe() {
		return DescripTipoChe;
	}
	public void setDescripTipoChe(String descripTipoChe) {
		DescripTipoChe = descripTipoChe;
	}
	public String getFolioUtilizarEstan() {
		return folioUtilizarEstan;
	}
	public void setFolioUtilizarEstan(String folioUtilizarEstan) {
		this.folioUtilizarEstan = folioUtilizarEstan;
	}
	public String getRutaChequeEstan() {
		return rutaChequeEstan;
	}
	public void setRutaChequeEstan(String rutaChequeEstan) {
		this.rutaChequeEstan = rutaChequeEstan;
	}
	public String getBeneficiarioCan() {
		return beneficiarioCan;
	}
	public void setBeneficiarioCan(String beneficiarioCan) {
		this.beneficiarioCan = beneficiarioCan;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getEmitidoEn() {
		return emitidoEn;
	}
	public void setEmitidoEn(String emitidoEn) {
		this.emitidoEn = emitidoEn;
	}
	public String getNumConvenio() {
		return numConvenio;
	}
	public void setNumConvenio(String numConvenio) {
		this.numConvenio = numConvenio;
	}
	public String getDescConvenio() {
		return descConvenio;
	}
	public void setDescConvenio(String descConvenio) {
		this.descConvenio = descConvenio;
	}
	public String getProtecOrdenPago() {
		return protecOrdenPago;
	}
	public void setProtecOrdenPago(String protecOrdenPago) {
		this.protecOrdenPago = protecOrdenPago;
	}
	public String getAlgClaveRetiro() {
		return algClaveRetiro;
	}
	public void setAlgClaveRetiro(String algClaveRetiro) {
		this.algClaveRetiro = algClaveRetiro;
	}
	public String getVigClaveRetiro() {
		return vigClaveRetiro;
	}
	public void setVigClaveRetiro(String vigClaveRetiro) {
		this.vigClaveRetiro = vigClaveRetiro;
	}
	
	
	
	
}
