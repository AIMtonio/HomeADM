package operacionesPDM.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDM_Ahorros_OrdenPagoSpeiRequest extends BaseBeanWS{
	
	private String clienteID;
	private String cuentaID;
	private String monto;
	private String conceptoPago;
	private String idInstitucion;
	private String tipoCuenta;
	private String cuentaBeneficiario;
	private String nombreBeneficiario;
	private String referenciaNumerica;
	private String RFCBeneficiario;
	private String ivaXpagar;
	private String idUsuario;
	private String clave;
	private String usuarioEnvio;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getConceptoPago() {
		return conceptoPago;
	}
	public void setConceptoPago(String conceptoPago) {
		this.conceptoPago = conceptoPago;
	}
	public String getIdInstitucion() {
		return idInstitucion;
	}
	public void setIdInstitucion(String idInstitucion) {
		this.idInstitucion = idInstitucion;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getCuentaBeneficiario() {
		return cuentaBeneficiario;
	}
	public void setCuentaBeneficiario(String cuentaBeneficiario) {
		this.cuentaBeneficiario = cuentaBeneficiario;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getReferenciaNumerica() {
		return referenciaNumerica;
	}
	public void setReferenciaNumerica(String referenciaNumerica) {
		this.referenciaNumerica = referenciaNumerica;
	}
	public String getRFCBeneficiario() {
		return RFCBeneficiario;
	}
	public void setRFCBeneficiario(String rFCBeneficiario) {
		RFCBeneficiario = rFCBeneficiario;
	}
	public String getIvaXpagar() {
		return ivaXpagar;
	}
	public void setIvaXpagar(String ivaXpagar) {
		this.ivaXpagar = ivaXpagar;
	}
	public String getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(String idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	
	public String getUsuarioEnvio() {
		return usuarioEnvio;
	}
	public void setUsuarioEnvio(String usuarioEnvio) {
		this.usuarioEnvio = usuarioEnvio;
	}
	
}
