package activos.bean;

import general.bean.BaseBean;

public class CuentaMayorActivosBean extends BaseBean {
	private String conceptoActivoID;
	private String cuenta;
	private String nomenclatura;
	private String nomenclaturaCC;
	private String tipoActivoID;

	private String subCuenta;
	private String descripcion;

	public String getConceptoActivoID() {
		return conceptoActivoID;
	}

	public String getCuenta() {
		return cuenta;
	}

	public String getNomenclatura() {
		return nomenclatura;
	}

	public String getNomenclaturaCC() {
		return nomenclaturaCC;
	}

	public String getTipoActivoID() {
		return tipoActivoID;
	}

	public String getSubCuenta() {
		return subCuenta;
	}

	public void setConceptoActivoID(String conceptoActivoID) {
		this.conceptoActivoID = conceptoActivoID;
	}

	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}

	public void setNomenclatura(String nomenclatura) {
		this.nomenclatura = nomenclatura;
	}

	public void setNomenclaturaCC(String nomenclaturaCC) {
		this.nomenclaturaCC = nomenclaturaCC;
	}

	public void setTipoActivoID(String tipoActivoID) {
		this.tipoActivoID = tipoActivoID;
	}

	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
