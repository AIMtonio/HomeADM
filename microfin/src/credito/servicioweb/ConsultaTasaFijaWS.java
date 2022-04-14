package credito.servicioweb;

import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.CreditosBean;
import credito.beanWS.request.ConsultaTasaFijaRequest;
import credito.beanWS.response.ConsultaTasaFijaResponse;
import credito.servicio.CreditosServicio;
import cliente.bean.CicloCreditoBean;

public class ConsultaTasaFijaWS extends AbstractMarshallingPayloadEndpoint {
	CreditosServicio creditosServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ConsultaTasaFijaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaTasaFijaResponse consultaTasaFija(ConsultaTasaFijaRequest consultaTasaFijaRequest){
		int numCreditos=0;
		ConsultaTasaFijaResponse consultaTasaFijaResponse= new ConsultaTasaFijaResponse();
		CicloCreditoBean cicloCreditoBean = new CicloCreditoBean();
		CreditosBean creditoBean= new CreditosBean();
		
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		creditoBean.setSucursal(consultaTasaFijaRequest.getSucursalID());
		creditoBean.setProducCreditoID(consultaTasaFijaRequest.getProdCreID());
		numCreditos=(Utileria.convierteEntero(consultaTasaFijaRequest.getNumCreditos()));
		creditoBean.setMontoCredito(consultaTasaFijaRequest.getMonto());
		creditoBean.setCalificaCliente(consultaTasaFijaRequest.getCalificacion());
		
		cicloCreditoBean = creditosServicio.consultaTasa(numCreditos, creditoBean);
			
		consultaTasaFijaResponse.setTasaFija(cicloCreditoBean.getValorTasa());
		
		return consultaTasaFijaResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaTasaFijaRequest consultaTasaFijaRequest = (ConsultaTasaFijaRequest)arg0; 							
		return consultaTasaFija(consultaTasaFijaRequest);	
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
