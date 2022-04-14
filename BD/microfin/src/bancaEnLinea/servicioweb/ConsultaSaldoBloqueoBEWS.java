package bancaEnLinea.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import tesoreria.servicio.BloqueoServicio;
import bancaEnLinea.beanWS.request.ConsultaSaldoBloqueoBERequest;
import bancaEnLinea.beanWS.response.ConsultaSaldoBloqueoBEResponse;


public class ConsultaSaldoBloqueoBEWS  extends AbstractMarshallingPayloadEndpoint{
	BloqueoServicio bloqueoServicio =null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaSaldoBloqueoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	
	private ConsultaSaldoBloqueoBEResponse consultaSaldosBloqueoBE(ConsultaSaldoBloqueoBERequest consultaSaldoBloqueoBERequest){
		bloqueoServicio.getBloqueoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaSaldoBloqueoBEResponse consultaSaldoBloqueoBEResponse = (ConsultaSaldoBloqueoBEResponse)
				bloqueoServicio.listaSaldoBloqueoWS( consultaSaldoBloqueoBERequest);
		
		return consultaSaldoBloqueoBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaSaldoBloqueoBERequest consultaSaldoBloqueoBERequest = (ConsultaSaldoBloqueoBERequest)arg0; 							
		return consultaSaldosBloqueoBE(consultaSaldoBloqueoBERequest);
		
	}


	public BloqueoServicio getBloqueoServicio() {
		return bloqueoServicio;
	}


	public void setBloqueoServicio(BloqueoServicio bloqueoServicio) {
		this.bloqueoServicio = bloqueoServicio;
	}
	
	
	

}
