package credito.bean;

import credito.dao.ProductosCreditoDAO;
import general.bean.BaseBean;

public class EsquemaComPrepagoCreditoBean extends BaseBean{


//Declaracion de Variables o Atributos
	private String cobraComision;
	private String permiteLiqAntici;
	private String tipoComision;
	private String comision;
	private	String diasGracia;
	private	String productoID;
	private	String descripcion;
	private	String productoCreditoID;
	private	String cobraComLiqAntici;
	private	String comisionLiqAntici;
	private	String diasGraciaLiqAntici;
	public String getTipComLiqAntici() {
		return TipComLiqAntici;
	}
	public void setTipComLiqAntici(String tipComLiqAntici) {
		TipComLiqAntici = tipComLiqAntici;
	}
	private String TipComLiqAntici;
	
	

	public String getCobraComLiqAntici() {
		return cobraComLiqAntici;
	}
	public void setCobraComLiqAntici(String cobraComLiqAntici) {
		this.cobraComLiqAntici = cobraComLiqAntici;
	}
	public String getComisionLiqAntici() {
		return comisionLiqAntici;
	}
	public void setComisionLiqAntici(String comisionLiqAntici) {
		this.comisionLiqAntici = comisionLiqAntici;
	}
	public String getDiasGraciaLiqAntici() {
		return diasGraciaLiqAntici;
	}
	public void setDiasGraciaLiqAntici(String diasGraciaLiqAntici) {
		this.diasGraciaLiqAntici = diasGraciaLiqAntici;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}


	public String getCobraComision() {
		return cobraComision;
	}
	public void setCobraComision(String cobraComision) {
		this.cobraComision = cobraComision;
	}
	public String getPermiteLiqAntici() {
		return permiteLiqAntici;
	}
	public void setPermiteLiqAntici(String permiteLiqAntici) {
		this.permiteLiqAntici = permiteLiqAntici;
	}
	public String getTipoComision() {
		return tipoComision;
	}
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getDiasGracia() {
		return diasGracia;
	}
	public void setDiasGracia(String diasGracia) {
		this.diasGracia = diasGracia;
	}
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}	
}