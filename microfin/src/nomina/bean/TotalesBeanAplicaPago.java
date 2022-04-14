package nomina.bean;

import general.bean.BaseBean;

public class TotalesBeanAplicaPago extends BaseBean{
	
	private String totalAplicaPago;
	private String totalNoAplicados;
	private String totalSumatoria;
	private String checkPagosTodos;
	private String checkImportadosTodos;
	
	public String getTotalAplicaPago() {
		return totalAplicaPago;
	}
	public void setTotalAplicaPago(String totalAplicaPago) {
		this.totalAplicaPago = totalAplicaPago;
	}
	public String getTotalNoAplicados() {
		return totalNoAplicados;
	}
	public void setTotalNoAplicados(String totalNoAplicados) {
		this.totalNoAplicados = totalNoAplicados;
	}
	public String getTotalSumatoria() {
		return totalSumatoria;
	}
	public void setTotalSumatoria(String totalSumatoria) {
		this.totalSumatoria = totalSumatoria;
	}	
	public String getCheckPagosTodos() {
		return checkPagosTodos;
	}
	public void setCheckPagosTodos(String checkPagosTodos) {
		this.checkPagosTodos = checkPagosTodos;
	}
	public String getCheckImportadosTodos() {
		return checkImportadosTodos;
	}
	public void setCheckImportadosTodos(String checkImportadosTodos) {
		this.checkImportadosTodos = checkImportadosTodos;
	}
	

}
