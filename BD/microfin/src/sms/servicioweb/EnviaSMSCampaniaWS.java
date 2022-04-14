package sms.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;
import org.springframework.oxm.Marshaller;

import sms.bean.ParametrosSMSBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.beanWS.request.EnviaSMSCampaniaRequest;
import sms.beanWS.response.EnviaSMSCampaniaResponse;
import sms.servicio.ParametrosSMSServicio;
import sms.servicio.SMSEnvioMensajeServicio;
import soporte.PropiedadesSAFIBean;
 
public class EnviaSMSCampaniaWS extends AbstractMarshallingPayloadEndpoint {

	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	ParametrosSMSServicio parametrosSMSServicio = null;
	public EnviaSMSCampaniaWS(Marshaller marshaller){
		super(marshaller);
	}
	
	public static interface Enum_Tra_SMS{
		int alta = 1;
		int altaWS= 4;
	}
	public static interface Enum_Con_SMS{
		int principal = 1;
		int principalWS = 5;
	}
	public EnviaSMSCampaniaResponse enviaSMSCampania(EnviaSMSCampaniaRequest enviaSMSrequest){
		SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
		ParametrosSMSBean parametrosSMSBean = new ParametrosSMSBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		parametrosSMSServicio.getParametrosSMSDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		EnviaSMSCampaniaResponse enviaSMSResponse = new EnviaSMSCampaniaResponse();
		try{
			if (enviaSMSrequest.getTelefonoDestino().length() != 10){
				mensaje.setNumero(Integer.valueOf("01"));
				mensaje.setDescripcion("Máximo 10 caracteres para Número Telefónico.");
				throw new Exception(mensaje.getDescripcion());
			}else if (enviaSMSrequest.getMensajeDestino().length() > 160){
				mensaje.setNumero(Integer.valueOf("02"));
				mensaje.setDescripcion("Máximo 160 caracteres para Mensaje Destino.");
				throw new Exception(mensaje.getDescripcion());
			}else if(enviaSMSrequest.getDatosCliente().length() > 80){
				mensaje.setNumero(Integer.valueOf("03"));
				mensaje.setDescripcion("Máximo 80 caracteres para Datos del Cliente.");
				throw new Exception(mensaje.getDescripcion());
			}else if(enviaSMSrequest.getSistemaID().length() > 40){
				mensaje.setNumero(Integer.valueOf("04"));
				mensaje.setDescripcion("Máximo 40 caracteres para Sistema ID.");
				throw new Exception(mensaje.getDescripcion());
			}
			smsEnvioMensajeBean.setCampaniaID(enviaSMSrequest.getCampaniaID());
			smsEnvioMensajeBean.setReceptor(enviaSMSrequest.getTelefonoDestino());
			smsEnvioMensajeBean.setMsjenviar(enviaSMSrequest.getMensajeDestino());
			smsEnvioMensajeBean.setDatosCliente(enviaSMSrequest.getDatosCliente());
			smsEnvioMensajeBean.setSistemaID(enviaSMSrequest.getSistemaID());
			
			parametrosSMSBean = parametrosSMSServicio.consulta(Enum_Con_SMS.principalWS, parametrosSMSBean);
			smsEnvioMensajeBean.setRemitente(parametrosSMSBean.getNumeroInstitu1());
			smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setNombrePrograma("WS.EnviaSMSCampaniaWS");
			smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setDireccionIP("127.0.0.1");
			smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setEmpresaID(1);
			smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setSucursal(1);
			smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setUsuario(1);;
			mensaje = smsEnvioMensajeServicio.altaSmsEnvio(Enum_Tra_SMS.altaWS, smsEnvioMensajeBean);
			if (mensaje.getNumero() == Constantes.ENTERO_CERO){
				mensaje.setDescripcion("Mensaje Puesto en Cola de Envio.");
			}
		}catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Estados de Cuenta");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
		}
		enviaSMSResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
		enviaSMSResponse.setMensajeRespuesta(mensaje.getDescripcion());
		return enviaSMSResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		
		EnviaSMSCampaniaRequest clienteRequest = (EnviaSMSCampaniaRequest)arg0; 			
						
		return enviaSMSCampania(clienteRequest);
		
	}

	public SMSEnvioMensajeServicio getSmsEnvioMensajeServicio() {
		return smsEnvioMensajeServicio;
	}

	public void setSmsEnvioMensajeServicio(
			SMSEnvioMensajeServicio smsEnvioMensajeServicio) {
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}

	public ParametrosSMSServicio getParametrosSMSServicio() {
		return parametrosSMSServicio;
	}

	public void setParametrosSMSServicio(ParametrosSMSServicio parametrosSMSServicio) {
		this.parametrosSMSServicio = parametrosSMSServicio;
	}
	
}