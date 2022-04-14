package operacionesPDA.servicioweb;

import operacionesPDA.beanWS.request.SP_SMSAP_Usuario_ValidarRequest;
import operacionesPDA.beanWS.response.SP_SMSAP_Usuario_ValidarResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_SMSAP_Usuario_ValidarWS  extends AbstractMarshallingPayloadEndpoint {
	UsuarioServicio usuarioServicio = null;
	
	public SP_SMSAP_Usuario_ValidarWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_SMSAP_Usuario_ValidarResponse SP_SMSAP_Usuario_Validar(SP_SMSAP_Usuario_ValidarRequest sP_SMSAP_Usuario_ValidarRequest ){	
		SP_SMSAP_Usuario_ValidarResponse  sP_SMSAP_Usuario_ValidarResponse = new SP_SMSAP_Usuario_ValidarResponse();
		UsuarioBean	usuarioBean = new UsuarioBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		usuarioBean.setClave(sP_SMSAP_Usuario_ValidarRequest.getId_Usuario());
		usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(sP_SMSAP_Usuario_ValidarRequest.getId_Usuario(),sP_SMSAP_Usuario_ValidarRequest.getClave()));

		usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.smsapValidaUserWS,usuarioBean);
		
		sP_SMSAP_Usuario_ValidarResponse.setCodigoDesc(usuarioBean.getCodigoDesc());
		sP_SMSAP_Usuario_ValidarResponse.setCodigoResp(usuarioBean.getCodigoResp());
		sP_SMSAP_Usuario_ValidarResponse.setEsValido(usuarioBean.getEsValido());
		
		return sP_SMSAP_Usuario_ValidarResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_SMSAP_Usuario_ValidarRequest ValidarUsuarioSMSAPRequest = (SP_SMSAP_Usuario_ValidarRequest)arg0; 			
		return SP_SMSAP_Usuario_Validar(ValidarUsuarioSMSAPRequest);
		
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
