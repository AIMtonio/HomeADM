package psl.beanresponse;

import java.util.List;

import psl.rest.BaseBeanResponse;

public class ListaProductosBeanResponse extends BaseBeanResponse {
	private List<ProductoBean> productos;

	
	public List<ProductoBean> getProductos() {
		return productos;
	}

	public void setProductos(List<ProductoBean> productos) {
		this.productos = productos;
	}
}
