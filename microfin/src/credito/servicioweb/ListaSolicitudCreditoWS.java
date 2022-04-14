package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ListaSolicitudCreditoRequest;
import credito.beanWS.response.ListaSolicitudCreditoResponse;
import credito.servicio.CreditosServicio;

public class ListaSolicitudCreditoWS  extends AbstractMarshallingPayloadEndpoint{
	CreditosServicio creditosServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ListaSolicitudCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private ListaSolicitudCreditoResponse listaCreditoBE(ListaSolicitudCreditoRequest listaSolicitudCreditoRequest){
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		ListaSolicitudCreditoResponse listaSolicitudCreditoResponse = (ListaSolicitudCreditoResponse)
				creditosServicio.listaSolCreditosWS(listaSolicitudCreditoRequest);
		
		return listaSolicitudCreditoResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaSolicitudCreditoRequest listaSolicitudCreditoRequest = (ListaSolicitudCreditoRequest)arg0; 							
		return listaCreditoBE(listaSolicitudCreditoRequest);
		
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}


}
