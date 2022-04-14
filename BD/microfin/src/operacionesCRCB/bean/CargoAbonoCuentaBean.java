package operacionesCRCB.bean;

import general.bean.BaseBean;

public class CargoAbonoCuentaBean extends BaseBean{
	
	private String cuentaAhoID;
	private String monto;
	private String polizaID;
	private String naturalezaMov;
	private String referencia;
	private String codigoRastreo;
	private String NumeroError;
	private String MensajeError;


	public static String conceptoAbonoCuenta	 = "45";
	public static String conceptoCargoCuenta 	 = "46";
	public static String desRetiroCuenta 		= "RETIRO REALIZADO A CUENTA";
	public static String desAbonoCuenta 		= "ABONO  REALIZADO A CUENTA";
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public static String getDesRetiroCuenta() {
		return desRetiroCuenta;
	}
	public static void setDesRetiroCuenta(String desRetiroCuenta) {
		CargoAbonoCuentaBean.desRetiroCuenta = desRetiroCuenta;
	}
	public static String getDesAbonoCuenta() {
		return desAbonoCuenta;
	}
	public static void setDesAbonoCuenta(String desAbonoCuenta) {
		CargoAbonoCuentaBean.desAbonoCuenta = desAbonoCuenta;
	}
	public static String getConceptoAbonoCuenta() {
		return conceptoAbonoCuenta;
	}
	public static void setConceptoAbonoCuenta(String conceptoAbonoCuenta) {
		CargoAbonoCuentaBean.conceptoAbonoCuenta = conceptoAbonoCuenta;
	}
	public static String getConceptoCargoCuenta() {
		return conceptoCargoCuenta;
	}
	public static void setConceptoCargoCuenta(String conceptoCargoCuenta) {
		CargoAbonoCuentaBean.conceptoCargoCuenta = conceptoCargoCuenta;
	}
	public String getNaturalezaMov() {
		return naturalezaMov;
	}
	public void setNaturalezaMov(String naturalezaMov) {
		this.naturalezaMov = naturalezaMov;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getCodigoRastreo() {
		return codigoRastreo;
	}
	public void setCodigoRastreo(String codigoRastreo) {
		this.codigoRastreo = codigoRastreo;
	}
	public String getNumeroError() {
		return NumeroError;
	}
	public void setNumeroError(String numeroError) {
		NumeroError = numeroError;
	}
	public String getMensajeError() {
		return MensajeError;
	}
	public void setMensajeError(String mensajeError) {
		MensajeError = mensajeError;
	}

}
