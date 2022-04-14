package credito.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ConsultaProdCreditoRequest;
import credito.beanWS.response.ConsultaProdCreditoResponse;
import credito.servicio.ProductosCreditoServicio;
import credito.servicio.ProductosCreditoServicio.Enum_Con_ProdCreditoWS;

public class ConsultaProdCreditoWS extends AbstractMarshallingPayloadEndpoint{
	ProductosCreditoServicio productosServicio= null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaProdCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaProdCreditoResponse consultaProducto(ConsultaProdCreditoRequest productoRequest){	
		ConsultaProdCreditoResponse consultaProductoResponse= new ConsultaProdCreditoResponse();
		ProductosCreditoBean productosCredBean= new ProductosCreditoBean();
		
		productosServicio.getProductosCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		productosCredBean.setProducCreditoID(productoRequest.getProducCreditoID());
		productosCredBean.setPerfilID(productoRequest.getPerfilID());
		
		productosCredBean= productosServicio.consultaBE(Enum_Con_ProdCreditoWS.principal, productosCredBean);
		
		if(productosCredBean==null){
			consultaProductoResponse.setDescripcion(Constantes.STRING_VACIO);
			consultaProductoResponse.setFormaCobroComAper(Constantes.STRING_VACIO);
			consultaProductoResponse.setMontoComision(Constantes.STRING_VACIO);
			consultaProductoResponse.setPorcentajeGarLiquida(Constantes.STRING_VACIO);
			consultaProductoResponse.setFactorMora(Constantes.STRING_VACIO);
			consultaProductoResponse.setDestinoCredito(Constantes.STRING_VACIO);
			consultaProductoResponse.setClasificacionDestino(Constantes.STRING_VACIO);
		}else {	
			consultaProductoResponse.setDescripcion(productosCredBean.getDescripcion());
			consultaProductoResponse.setFormaCobroComAper(productosCredBean.getFormaComApertura());
			consultaProductoResponse.setMontoComision(productosCredBean.getMontoComXapert());
			consultaProductoResponse.setPorcentajeGarLiquida(productosCredBean.getPorcGarLiq());
			consultaProductoResponse.setFactorMora(productosCredBean.getFactorMora());
			consultaProductoResponse.setDestinoCredito(productosCredBean.getDestinoCredID());
			consultaProductoResponse.setClasificacionDestino(productosCredBean.getClasificacion());
		}
		
		return consultaProductoResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaProdCreditoRequest consultaProdRequest = (ConsultaProdCreditoRequest)arg0; 							
		return consultaProducto(consultaProdRequest);
		
	}

	public ProductosCreditoServicio getProductosServicio() {
		return productosServicio;
	}

	public void setProductosServicio(ProductosCreditoServicio productosServicio) {
		this.productosServicio = productosServicio;
	}


}
