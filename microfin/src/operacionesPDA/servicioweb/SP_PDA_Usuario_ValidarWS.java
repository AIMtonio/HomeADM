package operacionesPDA.servicioweb;

import operacionesPDA.beanWS.request.SP_PDA_Usuario_ValidarRequest;
import operacionesPDA.beanWS.response.SP_PDA_Usuario_ValidarResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDA_Usuario_ValidarWS  extends AbstractMarshallingPayloadEndpoint {
	UsuarioServicio usuarioServicio = null;
	
	public SP_PDA_Usuario_ValidarWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDA_Usuario_ValidarResponse SP_PDA_Usuario_Validar(SP_PDA_Usuario_ValidarRequest sP_PDA_Usuario_ValidarRequest ){	
		SP_PDA_Usuario_ValidarResponse  sP_PDA_Usuario_ValidarResponse = new SP_PDA_Usuario_ValidarResponse();
		UsuarioBean	usuarioBean = new UsuarioBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		usuarioBean.setClave(sP_PDA_Usuario_ValidarRequest.getId_Usuario());
		usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(sP_PDA_Usuario_ValidarRequest.getId_Usuario(),sP_PDA_Usuario_ValidarRequest.getClave()));
		usuarioBean.setSucursalUsuario(sP_PDA_Usuario_ValidarRequest.getId_Sucursal());
		usuarioBean.setDispositivo(sP_PDA_Usuario_ValidarRequest.getDispositivo());
		//isEmpty(
		
		try{
			if(Integer.parseInt(sP_PDA_Usuario_ValidarRequest.getId_Sucursal())>0){
				
				usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.pdaValidaUserWS,usuarioBean);
				sP_PDA_Usuario_ValidarResponse.setCodigoDesc(usuarioBean.getCodigoDesc());
				sP_PDA_Usuario_ValidarResponse.setCodigoResp(usuarioBean.getCodigoResp());
				sP_PDA_Usuario_ValidarResponse.setEsValido(usuarioBean.getEsValido());					
				
			}else{
				sP_PDA_Usuario_ValidarResponse.setCodigoDesc("Usuario y/o contraseña incorrecto");
				sP_PDA_Usuario_ValidarResponse.setCodigoResp("2");
				sP_PDA_Usuario_ValidarResponse.setEsValido("false");
			}
		}catch(NumberFormatException e)	{
			sP_PDA_Usuario_ValidarResponse.setCodigoDesc("Usuario y/o contraseña incorrecto");
			sP_PDA_Usuario_ValidarResponse.setCodigoResp("2");
			sP_PDA_Usuario_ValidarResponse.setEsValido("false");
			return sP_PDA_Usuario_ValidarResponse;
		}
		return sP_PDA_Usuario_ValidarResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Usuario_ValidarRequest ValidarUsuarioRequest = (SP_PDA_Usuario_ValidarRequest)arg0; 			
		return SP_PDA_Usuario_Validar(ValidarUsuarioRequest);
		
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
