package originacion.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cliente.bean.CicloCreditoBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.beanWS.request.ConsultaCicloClienteRequest;
import originacion.beanWS.response.ConsultaCicloClienteResponse;
import originacion.servicio.SolicitudCreditoServicio;
import soporte.PropiedadesSAFIBean;

public class ConsultaCicloClienteWS extends AbstractMarshallingPayloadEndpoint {
	SolicitudCreditoServicio solicitudCreditoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaCicloClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaCicloClienteResponse consultaCicloCliente(ConsultaCicloClienteRequest consultaCicloRequest){
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaCicloClienteResponse consultaCicloresponse= new ConsultaCicloClienteResponse();
		SolicitudCreditoBean solicitud= new SolicitudCreditoBean();
		CicloCreditoBean cicloCredito= new CicloCreditoBean();
		
		
		solicitud.setClienteID(consultaCicloRequest.getClienteID());
		solicitud.setProspectoID(consultaCicloRequest.getProspectoID());
		
		cicloCredito = solicitudCreditoServicio.consultaCiclo(solicitud);
		
		consultaCicloresponse.setCicloCliente(cicloCredito.getCicloCliente());	
		
		return consultaCicloresponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCicloClienteRequest consultaCicloRequest = (ConsultaCicloClienteRequest)arg0; 							
		return consultaCicloCliente(consultaCicloRequest);
		
	}
// Set y get de solicitud Credito Servicio

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}	
	
}
