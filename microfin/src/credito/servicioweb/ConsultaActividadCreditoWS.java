package credito.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ConsultaActividadCreditoRequest;
import credito.beanWS.response.ConsultaActividadCreditoResponse;
import credito.servicio.CreditosServicio;

public class ConsultaActividadCreditoWS extends AbstractMarshallingPayloadEndpoint {
	CreditosServicio creditosServicio  = null;
	
	public ConsultaActividadCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaActividadCreditoResponse consultaActividadCredito(ConsultaActividadCreditoRequest consultaActividadCreditoRequest){
		Object objActCredRequest=(Object)consultaActividadCreditoRequest;
		Object obj = null;
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");		
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		obj = creditosServicio.consultaActividad(CreditosServicio.Enum_Con_CreditosWS.actividadCredito,objActCredRequest);

		ConsultaActividadCreditoResponse consultaActividadCreditoResp =(ConsultaActividadCreditoResponse)obj;
		ConsultaActividadCreditoResponse consultaActividadCredito = new ConsultaActividadCreditoResponse();

		if (Integer.parseInt(consultaActividadCreditoResp.getCodigoRespuesta())== 0) {
			consultaActividadCredito.setActivosTotal(consultaActividadCreditoResp.getActivosTotal());
			consultaActividadCredito.setTotalPrestado(consultaActividadCreditoResp.getTotalPrestado());
			consultaActividadCredito.setSaldoActual(consultaActividadCreditoResp.getSaldoActual());
			consultaActividadCredito.setPesosenMora(consultaActividadCreditoResp.getPesosenMora());
			consultaActividadCredito.setMoraMayor(consultaActividadCreditoResp.getMoraMayor());
			consultaActividadCredito.setQuebrantos(consultaActividadCreditoResp.getQuebrantos());
			consultaActividadCredito.setPagosPuntuales(consultaActividadCreditoResp.getPagosPuntuales());
			consultaActividadCredito.setPagosRealizados(consultaActividadCreditoResp.getPagosRealizados());
			consultaActividadCredito.setMoraMenorTreintaDias(consultaActividadCreditoResp.getMoraMenorTreintaDias());
			consultaActividadCredito.setMoraMayorTreintaDias(consultaActividadCreditoResp.getMoraMayorTreintaDias());	
			consultaActividadCredito.setCodigoRespuesta(consultaActividadCreditoResp.getCodigoRespuesta());
			consultaActividadCredito.setMensajeRespuesta(consultaActividadCreditoResp.getMensajeRespuesta());
			}else
				if (Integer.parseInt(consultaActividadCreditoResp.getCodigoRespuesta())!= 0){
					consultaActividadCredito.setActivosTotal(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setTotalPrestado(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setSaldoActual(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setPesosenMora(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setMoraMayor(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setQuebrantos(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setPagosPuntuales(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setPagosRealizados(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setMoraMenorTreintaDias(String.valueOf(Constantes.ENTERO_CERO));
					consultaActividadCredito.setMoraMayorTreintaDias(String.valueOf(Constantes.ENTERO_CERO));	
					consultaActividadCredito.setCodigoRespuesta(consultaActividadCreditoResp.getCodigoRespuesta());
					consultaActividadCredito.setMensajeRespuesta(consultaActividadCreditoResp.getMensajeRespuesta());
		}
		return consultaActividadCreditoResp;	
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaActividadCreditoRequest consultaActividadCredito = (ConsultaActividadCreditoRequest)arg0; 			
		return consultaActividadCredito(consultaActividadCredito);
		
	}
	
}