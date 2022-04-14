package cliente.bean;

import general.bean.BaseBean;

public class SectoresBean extends BaseBean{
	
	private String sectorID;
	private String empresaID;
	private String descripcion;
	private String pagaIVA;
	private String pagaISR;
	
	public String getSectorID() {
		return sectorID;
	}
	public void setSectorID(String sectorID) {
		this.sectorID = sectorID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPagaIVA() {
		return pagaIVA;
	}
	public void setPagaIVA(String pagaIVA) {
		this.pagaIVA = pagaIVA;
	}
	public String getPagaISR() {
		return pagaISR;
	}
	public void setPagaISR(String pagaISR) {
		this.pagaISR = pagaISR;
	}
	

}
