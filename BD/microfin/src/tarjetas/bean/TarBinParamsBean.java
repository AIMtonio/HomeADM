package tarjetas.bean;

import general.bean.BaseBean;

public class TarBinParamsBean extends BaseBean{
	
	private String tarBinParamsID;
	private String numBIN;
	private String esSubBin;
	private String esBinMulEmp;
	private String catMarcaTarjetaID;
	private String clabeMarca;
	private String descMarcaTar;
	private String descripcion;
	
	public String getTarBinParamsID() {
		return tarBinParamsID;
	}
	public void setTarBinParamsID(String tarBinParamsID) {
		this.tarBinParamsID = tarBinParamsID;
	}
	public String getNumBIN() {
		return numBIN;
	}
	public void setNumBIN(String numBIN) {
		this.numBIN = numBIN;
	}
	public String getEsSubBin() {
		return esSubBin;
	}
	public void setEsSubBin(String esSubBin) {
		this.esSubBin = esSubBin;
	}
	public String getEsBinMulEmp() {
		return esBinMulEmp;
	}
	public void setEsBinMulEmp(String esBinMulEmp) {
		this.esBinMulEmp = esBinMulEmp;
	}
	public String getCatMarcaTarjetaID() {
		return catMarcaTarjetaID;
	}
	public String getClabeMarca() {
		return clabeMarca;
	}
	public void setClabeMarca(String clabeMarca) {
		this.clabeMarca = clabeMarca;
	}
	public String getDescMarcaTar() {
		return descMarcaTar;
	}
	public void setDescMarcaTar(String descMarcaTar) {
		this.descMarcaTar = descMarcaTar;
	}
	public void setCatMarcaTarjetaID(String catMarcaTarjetaID) {
		this.catMarcaTarjetaID = catMarcaTarjetaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
