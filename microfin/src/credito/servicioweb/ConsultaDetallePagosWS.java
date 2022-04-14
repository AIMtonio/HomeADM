package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ConsultaDetallePagosRequest;
import credito.beanWS.response.ConsultaDetallePagosResponse;
import credito.servicio.AmortizacionCreditoServicio;

public class ConsultaDetallePagosWS  extends AbstractMarshallingPayloadEndpoint {
	AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaDetallePagosWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaDetallePagosResponse consultaDetallePagos(ConsultaDetallePagosRequest consultaDetallePagosRequest){
		amortizacionCreditoServicio.getAmortizacionCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaDetallePagosResponse  consultaDetallePagos = (ConsultaDetallePagosResponse) amortizacionCreditoServicio.consultaDetallePagosWS(AmortizacionCreditoServicio.Enum_Con_AmortizacionCreditoWS.detallePagosWS, consultaDetallePagosRequest);

		return consultaDetallePagos;
	}
	
	public void setAmortizacionCreditoServicio(
			AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaDetallePagosRequest consultaDetallePagosRequest = (ConsultaDetallePagosRequest)arg0; 			
		return consultaDetallePagos(consultaDetallePagosRequest);
		
	}

}
