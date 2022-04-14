package bancaEnLinea.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.servicio.CobrosPendServicio;
import bancaEnLinea.beanWS.request.ConsultaCargosPendientesBERequest;
import bancaEnLinea.beanWS.response.ConsultaCargosPendientesBEResponse;



public class ConsultaCargosPendientesBEWS  extends AbstractMarshallingPayloadEndpoint {
	 CobrosPendServicio cobrosPendServicio = null;
	 String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	 
	public ConsultaCargosPendientesBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaCargosPendientesBEResponse consultaCargosPendBE(ConsultaCargosPendientesBERequest consultaCargosPendientesBERequest){
		cobrosPendServicio.getCobrosPendDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaCargosPendientesBEResponse consultaCargosPendientesBEResponse = (ConsultaCargosPendientesBEResponse)
				cobrosPendServicio.listaCobrosPendWS( CobrosPendServicio.Enum_Lis_CobrosPend.porClienteYCuenta, consultaCargosPendientesBERequest);
		
		return consultaCargosPendientesBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCargosPendientesBERequest consultaCargosPendientesBERequest = (ConsultaCargosPendientesBERequest)arg0; 							
		return consultaCargosPendBE(consultaCargosPendientesBERequest);
		
	}

	public CobrosPendServicio getCobrosPendServicio() {
		return cobrosPendServicio;
	}

	public void setCobrosPendServicio(CobrosPendServicio cobrosPendServicio) {
		this.cobrosPendServicio = cobrosPendServicio;
	}

}
