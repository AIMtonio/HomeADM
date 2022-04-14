package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaEmpleadoNomRequest;
import cliente.BeanWS.Response.ListaEmpleadoNomResponse;
import cliente.servicio.EmpleadoNominaServicio;
import credito.bean.CreditosBean;
import credito.beanWS.request.SimuladorCreditoRequest;
import credito.beanWS.response.SimuladorCreditoResponse;
import credito.servicio.CreditosServicio;

public class SimuladorCreditoWS extends AbstractMarshallingPayloadEndpoint {
	CreditosServicio creditosServicio=null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public SimuladorCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SimuladorCreditoResponse simularCredito(SimuladorCreditoRequest simuladorCreditoRequest){
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		SimuladorCreditoResponse  listaSimuladorResponse = (SimuladorCreditoResponse) 
														    creditosServicio.listaSimuladorWS(simuladorCreditoRequest);
		
		return listaSimuladorResponse;
	}
	

	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		SimuladorCreditoRequest simuladorCreditoRequest = (SimuladorCreditoRequest)arg0; 			
		return simularCredito(simuladorCreditoRequest);
	}
// Getters y Setters de Creditos Servicio
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
