package formularioWeb.bean;

import java.util.List;

import general.bean.BaseBean;

public class FWProductosCreditoBean extends BaseBean {
	
	private String productoCreditoFWIDs;
	private List<?> lisProductoCreditoFWID;
	private List<?> lisProducCredito;
	private List<?> lisDestinoCredito;
	private List<?> lisClasificacion;
	
	public List<?> getLisProductoCreditoFWID() {
		return lisProductoCreditoFWID;
	}

	public void setLisProductoCreditoFWID(List<?> lisProductoCreditoFWID) {
		this.lisProductoCreditoFWID = lisProductoCreditoFWID;
	}

	public String getProductoCreditoFWIDs() {
		return productoCreditoFWIDs;
	}

	public void setProductoCreditoFWIDs(String productoCreditoFWIDs) {
		this.productoCreditoFWIDs = productoCreditoFWIDs;
	}

	public List<?> getLisProducCredito() {
		return lisProducCredito;
	}

	public void setLisProducCredito(List<?> lisProducCredito) {
		this.lisProducCredito = lisProducCredito;
	}

	public List<?> getLisDestinoCredito() {
		return lisDestinoCredito;
	}

	public void setLisDestinoCredito(List<?> lisDestinoCredito) {
		this.lisDestinoCredito = lisDestinoCredito;
	}

	public List<?> getLisClasificacion() {
		return lisClasificacion;
	}

	public void setLisClasificacion(List<?> lisClasificacion) {
		this.lisClasificacion = lisClasificacion;
	}

}
