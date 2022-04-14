package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ConsultaDescuentosNominaRequest;
import credito.beanWS.response.ConsultaDescuentosNominaResponse;
import credito.servicio.CreditosServicio;

public class ConsultaDescuentosNominaWS extends AbstractMarshallingPayloadEndpoint{
	CreditosServicio creditosServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaDescuentosNominaWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaDescuentosNominaResponse consultaDescuentosNomina (ConsultaDescuentosNominaRequest consultaDescuentosNominaRequest){
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaDescuentosNominaResponse consultaDescuentosNominaResponse = (ConsultaDescuentosNominaResponse)
				creditosServicio.listaDescuentoNominaWS(CreditosServicio.Enum_Lis_DescuentosWS.listaDescuentoNominaWS, consultaDescuentosNominaRequest);
		return consultaDescuentosNominaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaDescuentosNominaRequest consultaDescuentosNominaRequest = (ConsultaDescuentosNominaRequest)arg0;
		return consultaDescuentosNomina(consultaDescuentosNominaRequest);
	}

	// ---------- Getter y Setter -----------------
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
