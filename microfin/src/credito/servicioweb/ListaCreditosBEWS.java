package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import bancaEnLinea.beanWS.request.ConsultaSaldoDetalleBERequest;
import credito.beanWS.request.ListaCreditosBERequest;
import credito.beanWS.response.ListaCreditosBEResponse;
import credito.servicio.CreditosServicio;

public class ListaCreditosBEWS extends AbstractMarshallingPayloadEndpoint {
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ListaCreditosBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	CreditosServicio creditosServicio = null;
	
	private ListaCreditosBEResponse listaCreditoBE(ListaCreditosBERequest listaCreditosBERequest){
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaCreditosBEResponse listaCreditosBEResponse = (ListaCreditosBEResponse)
				creditosServicio.listaCreditosWS(CreditosServicio.Enum_Lis_Creditos.credCliente, listaCreditosBERequest);
		
		return listaCreditosBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaCreditosBERequest listaCreditoBERequest = (ListaCreditosBERequest)arg0; 							
		return listaCreditoBE(listaCreditoBERequest);
		
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
	

}
