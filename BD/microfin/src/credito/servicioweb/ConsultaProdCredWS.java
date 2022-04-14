package credito.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ConsultaProdCredRequest;
import credito.beanWS.response.ConsultaProdCredResponse;
import credito.servicio.ProductosCreditoServicio;
import credito.servicio.ProductosCreditoServicio.Enum_Con_ProdCreditoWS;

public class ConsultaProdCredWS extends AbstractMarshallingPayloadEndpoint{

	// CONSULTA PRODUCTOS DE CREDITO PARA EL CLIENTE ZAFY
	ProductosCreditoServicio productosServicio= null;
	String nombreOrigenDatos = "OrigenDatosWS";
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty(nombreOrigenDatos);
	
	public ConsultaProdCredWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaProdCredResponse consultaProducto(ConsultaProdCredRequest productoRequest){	
		ConsultaProdCredResponse consultaProductoResponse= new ConsultaProdCredResponse();
		ProductosCreditoBean productosCredBean= new ProductosCreditoBean();
		System.out.println("origenDatosWS: "+origenDatosWS);
		productosServicio.getProductosCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		productosCredBean.setProducCreditoID(productoRequest.getProducCreditoID());
		productosCredBean.setSucursal(productoRequest.getSucursalID());
		productosCredBean.setEmpresaID(productoRequest.getEmpresaID());
		
		try{
			productosCredBean= productosServicio.consultaBE(Enum_Con_ProdCreditoWS.foranea, productosCredBean);
			if(productosCredBean==null){
				consultaProductoResponse.setCodigoRespuesta("998");
				consultaProductoResponse.setMensajeRespuesta("El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que esto le ocasiona. Ref: SP-PRODCREDITOWSCON");
			} else {
				consultaProductoResponse.setProducCreditoID(productosCredBean.getProducCreditoID());
				consultaProductoResponse.setTasaFija(productosCredBean.getTasaFija());
				consultaProductoResponse.setTipoComXapert(productosCredBean.getTipoComXapert());
				consultaProductoResponse.setMontoComXapert(productosCredBean.getMontoComXapert());
				consultaProductoResponse.setMontoInferior(productosCredBean.getMontoMinimo());
				consultaProductoResponse.setMontoSuperior(productosCredBean.getMontoMaximo());
				consultaProductoResponse.setFrecuencias(productosCredBean.getFrecuencias());
				consultaProductoResponse.setPlazoID(productosCredBean.getPlazoID());
				consultaProductoResponse.setCodigoRespuesta(productosCredBean.getCodigoRespuesta());
				consultaProductoResponse.setMensajeRespuesta(productosCredBean.getMensajeRespuesta());
			}
		} catch (Exception e){
			consultaProductoResponse.setProducCreditoID(Constantes.STRING_CERO);
			consultaProductoResponse.setTasaFija(Constantes.STRING_CERO);
			consultaProductoResponse.setTipoComXapert(Constantes.STRING_VACIO);
			consultaProductoResponse.setMontoComXapert(Constantes.STRING_CERO);
			consultaProductoResponse.setMontoInferior(Constantes.STRING_CERO);
			consultaProductoResponse.setMontoSuperior(Constantes.STRING_CERO);
			consultaProductoResponse.setFrecuencias(Constantes.STRING_VACIO);
			consultaProductoResponse.setPlazoID(Constantes.STRING_VACIO);
		}
		return consultaProductoResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaProdCredRequest consultaProdRequest = (ConsultaProdCredRequest)arg0; 							
		return consultaProducto(consultaProdRequest);
		
	}

	public ProductosCreditoServicio getProductosServicio() {
		return productosServicio;
	}

	public void setProductosServicio(ProductosCreditoServicio productosServicio) {
		this.productosServicio = productosServicio;
	}
}
