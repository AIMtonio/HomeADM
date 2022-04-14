package crowdfunding.bean;

import general.bean.BaseBean;

public class ParametrosCRWBean extends BaseBean {

	private String productoCreditoID;
	private String formulaRetencion;
	private String tasaISR;
	private String porcISRMoratorio;
	private String porcISRComision;
	private String minPorcFonProp;
	private String maxPorcPagCre;
	private String maxDiasAtraso;
	private String diasGraciaPrimVen;
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}

	public String getFormulaRetencion() {
		return formulaRetencion;
	}

	public void setFormulaRetencion(String formulaRetencion) {
		this.formulaRetencion = formulaRetencion;
	}

	public String getTasaISR() {
		return tasaISR;
	}

	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}

	public String getPorcISRMoratorio() {
		return porcISRMoratorio;
	}

	public void setPorcISRMoratorio(String porcISRMoratorio) {
		this.porcISRMoratorio = porcISRMoratorio;
	}

	public String getPorcISRComision() {
		return porcISRComision;
	}

	public void setPorcISRComision(String porcISRComision) {
		this.porcISRComision = porcISRComision;
	}

	public String getMinPorcFonProp() {
		return minPorcFonProp;
	}

	public void setMinPorcFonProp(String minPorcFonProp) {
		this.minPorcFonProp = minPorcFonProp;
	}

	public String getMaxPorcPagCre() {
		return maxPorcPagCre;
	}

	public void setMaxPorcPagCre(String maxPorcPagCre) {
		this.maxPorcPagCre = maxPorcPagCre;
	}

	public String getMaxDiasAtraso() {
		return maxDiasAtraso;
	}

	public void setMaxDiasAtraso(String maxDiasAtraso) {
		this.maxDiasAtraso = maxDiasAtraso;
	}

	public String getDiasGraciaPrimVen() {
		return diasGraciaPrimVen;
	}

	public void setDiasGraciaPrimVen(String diasGraciaPrimVen) {
		this.diasGraciaPrimVen = diasGraciaPrimVen;
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

}
