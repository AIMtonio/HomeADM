package credito.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;
import credito.bean.CreditosBean;
import credito.beanWS.request.ConsultaCreditoRequest;
import credito.beanWS.response.ConsultaCreditoResponse;
import credito.servicio.CreditosServicio;

public class ConsultaCreditoWS extends AbstractMarshallingPayloadEndpoint{
	CreditosServicio creditosServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	private ConsultaCreditoResponse ConsultaCredito(ConsultaCreditoRequest consultaCreditoRequest){	
		ConsultaCreditoResponse consultaCreditoResponse= new ConsultaCreditoResponse();
		CreditosBean creditosBean = new CreditosBean();
				
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		creditosBean.setCreditoID(consultaCreditoRequest.getCreditoID());
		
		try{
			if(Utileria.convierteLong(creditosBean.getCreditoID())!=0){
				creditosBean = creditosServicio.consulta(Enum_Con_Creditos.conCreditoWS,creditosBean);
				if(creditosBean != null){
					consultaCreditoResponse.setCodigoRespuesta("00");
					consultaCreditoResponse.setMensajeRespuesta("Consulta Exitosa");
					consultaCreditoResponse.setCreditoID(creditosBean.getCreditoID());
					consultaCreditoResponse.setClienteID(creditosBean.getClienteID());
					consultaCreditoResponse.setNombreCliente(creditosBean.getNombreCliente());
				}else{
					consultaCreditoResponse.setCodigoRespuesta("03");
					consultaCreditoResponse.setMensajeRespuesta("El Número de Crédito no Existe");
					consultaCreditoResponse.setCreditoID(Constantes.STRING_CERO);
					consultaCreditoResponse.setClienteID(Constantes.STRING_CERO);
					consultaCreditoResponse.setNombreCliente(Constantes.STRING_VACIO);
				}
			}else{
				consultaCreditoResponse.setCodigoRespuesta("01");
				consultaCreditoResponse.setMensajeRespuesta("El Número de Crédito es Requerido");
				consultaCreditoResponse.setCreditoID(Constantes.STRING_CERO);
				consultaCreditoResponse.setClienteID(Constantes.STRING_CERO);
				consultaCreditoResponse.setNombreCliente(Constantes.STRING_VACIO);
				}
			}catch(NumberFormatException e)	{
				consultaCreditoResponse.setCodigoRespuesta("02");
				consultaCreditoResponse.setMensajeRespuesta("Ingresar Sólo Números");
				consultaCreditoResponse.setCreditoID(Constantes.STRING_CERO);
				consultaCreditoResponse.setClienteID(Constantes.STRING_CERO);
				consultaCreditoResponse.setNombreCliente(Constantes.STRING_VACIO);
			}
		return consultaCreditoResponse;
		}
		
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCreditoRequest consultaCreditoRequest = (ConsultaCreditoRequest)arg0;
		return ConsultaCredito(consultaCreditoRequest);
	}
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
