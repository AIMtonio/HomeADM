package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ConsultaAmortiCreditoBERequest;
import credito.beanWS.response.ConsultaAmortiCreditoBEResponse;
import credito.servicio.AmortizacionCreditoServicio;


public class ConsultaAmortiCreditoBEWS  extends AbstractMarshallingPayloadEndpoint  {
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaAmortiCreditoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	
	AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	
	private ConsultaAmortiCreditoBEResponse consultaAmorti(ConsultaAmortiCreditoBERequest consultaAmortiCreditoBERequest){
		amortizacionCreditoServicio.getAmortizacionCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaAmortiCreditoBEResponse consultaAmortiCreditoBEResponse = (ConsultaAmortiCreditoBEResponse)					
					amortizacionCreditoServicio.listaAmort(AmortizacionCreditoServicio.Enum_Lis_AmortizacionCredito.amortPagare, consultaAmortiCreditoBERequest);
		
		return consultaAmortiCreditoBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaAmortiCreditoBERequest consultaAmortiCreditoBERequest = (ConsultaAmortiCreditoBERequest)arg0; 							
		return consultaAmorti(consultaAmortiCreditoBERequest);
		
	}

	public AmortizacionCreditoServicio getAmortizacionCreditoServicio() {
		return amortizacionCreditoServicio;
	}

	public void setAmortizacionCreditoServicio(
			AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}

	
}
