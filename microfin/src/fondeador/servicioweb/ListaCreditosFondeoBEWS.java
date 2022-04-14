package fondeador.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import fondeador.beanWS.request.ListaCreditoFondeoBERequest;
import fondeador.beanWS.response.ListaCreditoFondeoBEResponse;
import fondeador.servicio.CreditoFondeoServicio;

public class ListaCreditosFondeoBEWS extends AbstractMarshallingPayloadEndpoint {
	CreditoFondeoServicio creditoFondeoServicio=null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ListaCreditosFondeoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ListaCreditoFondeoBEResponse listaCreditoBE(ListaCreditoFondeoBERequest listaCreditoFondeoBERequest){
		creditoFondeoServicio.getCreditoFondeoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaCreditoFondeoBEResponse listaCreditoFondeoBEResponse = (ListaCreditoFondeoBEResponse)
				creditoFondeoServicio.listaCreditosWS(CreditoFondeoServicio.Enum_Lis_CreditoFondeo.vigentesWS, listaCreditoFondeoBERequest);
		
		return listaCreditoFondeoBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaCreditoFondeoBERequest listaCreditoFondeoBERequest = (ListaCreditoFondeoBERequest)arg0; 							
		return listaCreditoBE(listaCreditoFondeoBERequest);
		
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
	
}
