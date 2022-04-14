package psl.beanrequest;

import psl.rest.BaseBeanRequest;

public class ListaProductosBeanRequest extends BaseBeanRequest{
	private String numLista;

	
	public String getNumLista() {
		return numLista;
	}

	public void setNumLista(String numLista) {
		this.numLista = numLista;
	}
}
