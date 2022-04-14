package operacionesPDM.servicioweb;

import herramientas.Utileria;

import java.util.regex.Pattern;

import operacionesPDM.beanWS.response.SP_PDM_Usuario_ValidarResponse;
import operacionesPDM.beanWS.request.SP_PDM_Usuario_ValidarRequest;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDM_Usuario_ValidarWS extends AbstractMarshallingPayloadEndpoint {
	UsuarioServicio usuarioServicio = null;
	
	public static String 	STRING_VACION	= "";
	public static String 	Activo 			= "A";
	public static String 	Bloqueado 		= "B";
	public static String 	Cancelado		= "C";
	public static String 	Inactivo		= "I";
	public static String 	Valido			= "true";		
	
	public SP_PDM_Usuario_ValidarWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDM_Usuario_ValidarResponse SP_PDM_Usuario_Validar(SP_PDM_Usuario_ValidarRequest request ){	
		SP_PDM_Usuario_ValidarResponse validarUsuarioResponse = new SP_PDM_Usuario_ValidarResponse();
		
		UsuarioBean	usuarioBean = new UsuarioBean();
		UsuarioBean	usuarioBeanCon = new UsuarioBean();
		
		try{
			
			validarUsuarioResponse = validaRequest(request);
			if(validarUsuarioResponse.getCodigoResp()!="0"){					
				
				throw new Exception(validarUsuarioResponse.getCodigoDesc());
					
			}else{			
			
				usuarioBean.setClave(request.getId_Usuario());
				usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
				usuarioBean.setSucursalUsuario(request.getId_Sucursal());
				usuarioBean.setDispositivo(request.getDispositivo());		
				
				usuarioBeanCon = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);
				
				if(usuarioBeanCon == null){
					
					validarUsuarioResponse.setEsValido("false");
					validarUsuarioResponse.setCodigoResp("06");
					validarUsuarioResponse.setCodigoResp("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}else if(usuarioBeanCon.getOrigenDatos().isEmpty()){
					
					validarUsuarioResponse.setEsValido("false");
					validarUsuarioResponse.setCodigoResp("06");
					validarUsuarioResponse.setCodigoResp("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}
				
				usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
									
				usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.pdaValidaUserWS,usuarioBean);					
				validarUsuarioResponse.setCodigoResp(usuarioBean.getCodigoResp());
				validarUsuarioResponse.setCodigoDesc(usuarioBean.getCodigoDesc());
				validarUsuarioResponse.setEsValido(usuarioBean.getEsValido());				
					
				
				
			}
			
		}catch(Exception e)	{			
			e.printStackTrace();	
			if(validarUsuarioResponse.getCodigoResp().isEmpty() || validarUsuarioResponse.getCodigoResp().equals("0")){
				validarUsuarioResponse.setEsValido("false");
				validarUsuarioResponse.setCodigoResp("999");
				validarUsuarioResponse.setCodigoDesc("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-USUARIOVAL");
			}						
		}
		
		return validarUsuarioResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDM_Usuario_ValidarRequest ValidarUsuarioRequest = (SP_PDM_Usuario_ValidarRequest)arg0; 			
		return SP_PDM_Usuario_Validar(ValidarUsuarioRequest);		
	}
	
	public SP_PDM_Usuario_ValidarResponse validaRequest(SP_PDM_Usuario_ValidarRequest request){
		SP_PDM_Usuario_ValidarResponse validaUsuarioBean = new SP_PDM_Usuario_ValidarResponse();
		if(request.getId_Usuario().trim().isEmpty()){
			validaUsuarioBean.setCodigoResp("01");
			validaUsuarioBean.setCodigoDesc("El ID del Usuario Solicitado está Vacío.");
		} else if(request.getId_Usuario().trim().equals("?")){
			validaUsuarioBean.setCodigoResp("02");
			validaUsuarioBean.setCodigoDesc("El ID del Usuario indicado No Existe.");
		} else if(request.getClave().trim().isEmpty()){
			validaUsuarioBean.setCodigoResp("03");
			validaUsuarioBean.setCodigoDesc("La Clave del Usuario Solicitado está Vacío.");
		} else if(request.getClave().trim().equals("?")){
			validaUsuarioBean.setCodigoResp("04");
			validaUsuarioBean.setCodigoDesc("La Clave del Usuario indicado No es Correcta.");
		} else if(!Pattern.matches("^\\d+$",request.getId_Sucursal().trim()) || Utileria.convierteEntero(request.getId_Sucursal().trim()) < 0){
			validaUsuarioBean.setCodigoResp("05");
			validaUsuarioBean.setCodigoDesc("El Numero de Empresa indicado No Existe.");
		}else{
			validaUsuarioBean.setCodigoResp("0");
		}
		
		return validaUsuarioBean;
	}
	
	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
