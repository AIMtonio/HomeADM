package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ConsultaPagosAplicadosRequest;
import credito.beanWS.response.ConsultaPagosAplicadosResponse;
import credito.servicio.CreditosServicio;

public class ConsultaPagosAplicadosWS extends AbstractMarshallingPayloadEndpoint{
	CreditosServicio creditosServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ConsultaPagosAplicadosWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaPagosAplicadosResponse consultaPagosAplicados(ConsultaPagosAplicadosRequest consultaPagosAplicadosRequest){		
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaPagosAplicadosResponse consultaPagosAplicadosResponse = (ConsultaPagosAplicadosResponse)
				creditosServicio.listaPagosAplicadosWS(consultaPagosAplicadosRequest);
		return consultaPagosAplicadosResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaPagosAplicadosRequest consultaPagosAplicadosRequest = (ConsultaPagosAplicadosRequest)arg0;
		return consultaPagosAplicados(consultaPagosAplicadosRequest);
	}
	// ---------- Getter y Setter -----------------

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
