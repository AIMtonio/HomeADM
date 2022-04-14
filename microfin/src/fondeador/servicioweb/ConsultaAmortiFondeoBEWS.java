package fondeador.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import fondeador.beanWS.request.ConsultaAmortiFondeoBERequest;
import fondeador.beanWS.response.ConsultaAmortiFondeoBEResponse;
import fondeador.servicio.AmortizaFondeoServicio;


public class ConsultaAmortiFondeoBEWS extends AbstractMarshallingPayloadEndpoint {
	AmortizaFondeoServicio amortizaFondeoServicio=null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaAmortiFondeoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private ConsultaAmortiFondeoBEResponse listaAmortizacionesBE(ConsultaAmortiFondeoBERequest consultaAmortiFondeoBERequest){
		amortizaFondeoServicio.getAmortizaFondeoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaAmortiFondeoBEResponse consultaAmortiFondeoBEResponse = (ConsultaAmortiFondeoBEResponse)
				amortizaFondeoServicio.listaAmortiCreditosWS(AmortizaFondeoServicio.Enum_Lis_AmortizacionCredito.amortiCred, consultaAmortiFondeoBERequest);
		
		return consultaAmortiFondeoBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaAmortiFondeoBERequest consultaAmortiFondeoBERequest = (ConsultaAmortiFondeoBERequest)arg0; 							
		return listaAmortizacionesBE(consultaAmortiFondeoBERequest);
		
	}

	public AmortizaFondeoServicio getAmortizaFondeoServicio() {
		return amortizaFondeoServicio;
	}

	public void setAmortizaFondeoServicio(
			AmortizaFondeoServicio amortizaFondeoServicio) {
		this.amortizaFondeoServicio = amortizaFondeoServicio;
	}
	
	
	
}
