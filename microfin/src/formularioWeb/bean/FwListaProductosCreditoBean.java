package formularioWeb.bean;

import general.bean.BaseBean;

public class FwListaProductosCreditoBean extends BaseBean {

	private String productoCreditoID;
	private String descripcion;
	private String perfilID;
	private String numLis;

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getPerfilID() {
		return perfilID;
	}

	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}

	public String getNumLis() {
		return numLis;
	}

	public void setNumLis(String numLis) {
		this.numLis = numLis;
	}

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	
}
