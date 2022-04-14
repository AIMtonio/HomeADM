package ventanilla.bean;

import general.bean.BaseBean;

public class ChequesEmitidosBean extends BaseBean{	
	private String institucionID;
	private String cuentaInstitucion;
	private String numeroCheque;
	private String fechaEmision;
	private String monto;
	private String sucursalID;
	private String cajaID;
	private String usuarioID;
	private String concepto;
	private String beneficiario;
	private String estatus;
	private String clienteID;
	private String referencia;
	private String institucionIDCan;
	private String numCtaBancariaCan;
	private String numChequeCan;
	private String beneficiarioCan;
	private String emitidoEn;
	private String fechaInicio;
	private String fechaFinal;
	
	private String numReqGasID;
	private String proveedorID;
	private String nombreSucurs;
	private String nombreProv;
	private String estatusMov;
	private String estatusDisp;
	private String anticipoFact;
    private String facturaProvID;
    private String tipoChequera;
    private String motivoCancela;
    private String motivoCanDes;
    private String comentario;

	
	public String getInstitucionID() {
		return institucionID;
	}
	public String getCuentaInstitucion() {
		return cuentaInstitucion;
	}
	public String getNumeroCheque() {
		return numeroCheque;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public String getMonto() {
		return monto;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getConcepto() {
		return concepto;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public void setCuentaInstitucion(String cuentaInstitucion) {
		this.cuentaInstitucion = cuentaInstitucion;
	}
	public void setNumeroCheque(String numeroCheque) {
		this.numeroCheque = numeroCheque;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getInstitucionIDCan() {
		return institucionIDCan;
	}
	public void setInstitucionIDCan(String institucionIDCan) {
		this.institucionIDCan = institucionIDCan;
	}
	public String getNumCtaBancariaCan() {
		return numCtaBancariaCan;
	}
	public void setNumCtaBancariaCan(String numCtaBancariaCan) {
		this.numCtaBancariaCan = numCtaBancariaCan;
	}
	public String getNumChequeCan() {
		return numChequeCan;
	}
	public void setNumChequeCan(String numChequeCan) {
		this.numChequeCan = numChequeCan;
	}
	public String getBeneficiarioCan() {
		return beneficiarioCan;
	}
	public void setBeneficiarioCan(String beneficiarioCan) {
		this.beneficiarioCan = beneficiarioCan;
	}
	public String getEmitidoEn() {
		return emitidoEn;
	}
	public void setEmitidoEn(String emitidoEn) {
		this.emitidoEn = emitidoEn;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getNumReqGasID() {
		return numReqGasID;
	}
	public void setNumReqGasID(String numReqGasID) {
		this.numReqGasID = numReqGasID;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getNombreProv() {
		return nombreProv;
	}
	public void setNombreProv(String nombreProv) {
		this.nombreProv = nombreProv;
	}
	public String getEstatusMov() {
		return estatusMov;
	}
	public void setEstatusMov(String estatusMov) {
		this.estatusMov = estatusMov;
	}
	public String getEstatusDisp() {
		return estatusDisp;
	}
	public void setEstatusDisp(String estatusDisp) {
		this.estatusDisp = estatusDisp;
	}
	public String getAnticipoFact() {
		return anticipoFact;
	}
	public void setAnticipoFact(String anticipoFact) {
		this.anticipoFact = anticipoFact;
	}
	public String getFacturaProvID() {
		return facturaProvID;
	}
	public void setFacturaProvID(String facturaProvID) {
		this.facturaProvID = facturaProvID;
	}
	public String getTipoChequera() {
		return tipoChequera;
	}
	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}
	public String getMotivoCancela() {
		return motivoCancela;
	}
	public void setMotivoCancela(String motivoCancela) {
		this.motivoCancela = motivoCancela;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getMotivoCanDes() {
		return motivoCanDes;
	}
	public void setMotivoCanDes(String motivoCanDes) {
		this.motivoCanDes = motivoCanDes;
	}
	
}