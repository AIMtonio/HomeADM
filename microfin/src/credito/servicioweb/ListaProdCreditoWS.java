package credito.servicioweb;

import herramientas.Utileria;

import java.util.List;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ListaProdCreditoRequest;
import credito.beanWS.response.ConsultaDetallePagosResponse;
import credito.beanWS.response.ListaProdCreditoResponse;
import credito.servicio.AmortizacionCreditoServicio;
import credito.servicio.ProductosCreditoServicio;
import credito.servicio.ProductosCreditoServicio.Enum_Lis_ProductosCredito;

public class ListaProdCreditoWS extends AbstractMarshallingPayloadEndpoint{
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ListaProdCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// 	TODO Auto-generated constructor stub
	}

	ProductosCreditoServicio productosServicio= null;

	private ListaProdCreditoResponse listaProducto(ListaProdCreditoRequest productoRequest){
		productosServicio.getProductosCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		int tipoConsulta=0;
		tipoConsulta = Utileria.convierteEntero(productoRequest.getNumeroLista());
		
		ListaProdCreditoResponse  listaProductoResponse = (ListaProdCreditoResponse) productosServicio.listaProdCredWS(tipoConsulta, productoRequest);
		
		return listaProductoResponse;
	}

	public ProductosCreditoServicio getProductosServicio() {
		return productosServicio;
	}
	
	public void setProductosServicio(ProductosCreditoServicio productosServicio) {
		this.productosServicio = productosServicio;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaProdCreditoRequest listaProdRequest = (ListaProdCreditoRequest)arg0; 							
		return listaProducto(listaProdRequest);
	
	}
	
	
}
