package operacionesPDM.servicioweb;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.Constantes;

import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import operacionesPDM.servicio.SP_PDM_Ahorros_ConsultaCtaDestinoServicio;
import operacionesPDM.bean.CuentasDestinoBean;
import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaCtaDestinoRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaCtaDestinoResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDM_Ahorros_ConsultaCtaDestinoWS extends AbstractMarshallingPayloadEndpoint  {
	
	private SP_PDM_Ahorros_ConsultaCtaDestinoServicio consultaCtaDestinoServicio=null;	
	private UsuarioServicio	usuarioServicio = null;	
	
	
	public static String 	STRING_VACION	= "";
	public static String 	Activo 			= "A";
	public static String 	Bloqueado 		= "B";
	public static String 	Cancelado		= "C";
	public static String 	Inactivo		= "I";
	public static String 	Valido			= "true";		
	public static final String NAMESPACE 	= "http://safisrv/ws/schemas";
	
	
	public SP_PDM_Ahorros_ConsultaCtaDestinoWS(Marshaller marshaller){
		super(marshaller);
	}
	
	private SP_PDM_Ahorros_ConsultaCtaDestinoResponse SP_PDM_Ahorros_ConsultaCtaDestino(SP_PDM_Ahorros_ConsultaCtaDestinoRequest request){
		
		SP_PDM_Ahorros_ConsultaCtaDestinoResponse consultaCtaDestinoResponse = new SP_PDM_Ahorros_ConsultaCtaDestinoResponse();
		
		UsuarioBean	usuarioBean = new UsuarioBean();
		UsuarioBean	usuarioBeanCon = new UsuarioBean();
			
		try{
			
			consultaCtaDestinoResponse = validaRequest(request);
			//Validar que no este vacio el Campo
			if(consultaCtaDestinoResponse.getCodigoRespuesta()!="0"){					
				
				consultaCtaDestinoResponse.setEsValido("false");
				throw new Exception(consultaCtaDestinoResponse.getMensajeRespuesta());
					
			}else{
				
				usuarioBean.setClave(request.getIdUsuario());
				usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(request.getIdUsuario(),request.getClave()));
				usuarioBeanCon = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);

				if(usuarioBeanCon == null){
					
					consultaCtaDestinoResponse.setEsValido("false");
					consultaCtaDestinoResponse.setCodigoRespuesta("07");
					consultaCtaDestinoResponse.setMensajeRespuesta("Usuario y/o contraseña incorrecto");
					throw new Exception("Usuario Incorrecto.");
					
				}else if(usuarioBeanCon.getOrigenDatos().isEmpty()){
					
					consultaCtaDestinoResponse.setEsValido("false");
					consultaCtaDestinoResponse.setCodigoRespuesta("07");
					consultaCtaDestinoResponse.setMensajeRespuesta("Usuario y/o contraseña incorrecto");
					throw new Exception("Usuario Incorrecto.");
					
				}
				usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
				consultaCtaDestinoServicio.getsP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
												
				usuarioBeanCon= usuarioServicio.consulta(Enum_Con_Usuario.validadUserWS,usuarioBean);
				
				if(usuarioBeanCon.getEsValido().equals(Valido)){
					
					MensajeTransaccionBean validacionCtaTransfer = new MensajeTransaccionBean();						
					validacionCtaTransfer = consultaCtaDestinoServicio.cuentasTrasnfersVal(request);			
					
					if(validacionCtaTransfer.getNumero() != Constantes.ENTERO_CERO ){
						
						consultaCtaDestinoResponse.setEsValido("false");
						consultaCtaDestinoResponse.setCodigoRespuesta(Integer.toString(validacionCtaTransfer.getNumero()));
						consultaCtaDestinoResponse.setMensajeRespuesta(validacionCtaTransfer.getDescripcion());
						
						throw new Exception(validacionCtaTransfer.getDescripcion());
						
						
					}else{
						
						SP_PDM_Ahorros_ConsultaCtaDestinoResponse consultaCtaDestinoResponseCons = new SP_PDM_Ahorros_ConsultaCtaDestinoResponse();
						consultaCtaDestinoResponseCons = consultaCtaDestinoServicio.listaCtaDestinoWS(request);
						
						consultaCtaDestinoResponse.setEsValido("true");
						consultaCtaDestinoResponse.setCodigoRespuesta("0");
						consultaCtaDestinoResponse.setConCtaDestino(consultaCtaDestinoResponseCons.getConCtaDestino());
						consultaCtaDestinoResponse.setMensajeRespuesta("Consulta Exitosa");
						
					}	
					
				}else{
					consultaCtaDestinoResponse.setEsValido(usuarioBeanCon.getEsValido());
					consultaCtaDestinoResponse.setCodigoRespuesta(usuarioBeanCon.getCodigoResp());
					consultaCtaDestinoResponse.setMensajeRespuesta(usuarioBeanCon.getCodigoDesc());

				}				
			}
			
			
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(consultaCtaDestinoResponse.getCodigoRespuesta().isEmpty() || consultaCtaDestinoResponse.getCodigoRespuesta().equals("0")){
				consultaCtaDestinoResponse.setEsValido("false");
				consultaCtaDestinoResponse.setCodigoRespuesta("999");
				consultaCtaDestinoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CUENTASTRANSFERLIS");
			}
						
		}
		
		return consultaCtaDestinoResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception { 		
		SP_PDM_Ahorros_ConsultaCtaDestinoRequest consultaCtaDestinoRequest = (SP_PDM_Ahorros_ConsultaCtaDestinoRequest) arg0;		
		return SP_PDM_Ahorros_ConsultaCtaDestino(consultaCtaDestinoRequest);	
	}
	 
	public SP_PDM_Ahorros_ConsultaCtaDestinoResponse validaRequest(SP_PDM_Ahorros_ConsultaCtaDestinoRequest request){
		SP_PDM_Ahorros_ConsultaCtaDestinoResponse consultaCtaDestinosBean = new SP_PDM_Ahorros_ConsultaCtaDestinoResponse();
		if(request.getClienteID().trim().isEmpty()){
			consultaCtaDestinosBean.setCodigoRespuesta("01");
			consultaCtaDestinosBean.setMensajeRespuesta("El Número del Cliente Solicitado está vacío.");
		} else if(request.getClienteID().trim().equals("?")){
			consultaCtaDestinosBean.setCodigoRespuesta("02");
			consultaCtaDestinosBean.setMensajeRespuesta("El Número del Cliente indicado No Existe.");
		} else if(request.getIdUsuario().trim().isEmpty()){
			consultaCtaDestinosBean.setCodigoRespuesta("03");
			consultaCtaDestinosBean.setMensajeRespuesta("El ID del Usuario Solicitado está Vacío.");
		} else if(request.getIdUsuario().trim().equals("?")){
			consultaCtaDestinosBean.setCodigoRespuesta("04");
			consultaCtaDestinosBean.setMensajeRespuesta("El ID del Usuario indicado No Existe.");
		} else if(request.getClave().trim().isEmpty()){
			consultaCtaDestinosBean.setCodigoRespuesta("05");
			consultaCtaDestinosBean.setMensajeRespuesta("La Clave del Usuario Solicitado está Vacío.");
		} else if(request.getClave().trim().equals("?")){
			consultaCtaDestinosBean.setCodigoRespuesta("06");
			consultaCtaDestinosBean.setMensajeRespuesta("La Clave del Usuario indicado No es Correcta.");
		} else if(!Pattern.matches("^\\d+$",request.getClienteID().trim())){
			consultaCtaDestinosBean.setCodigoRespuesta("07");
			consultaCtaDestinosBean.setMensajeRespuesta("El Número del Cliente indicado No Existe.");
		}else{
			consultaCtaDestinosBean.setCodigoRespuesta("0");
		}
		
		return consultaCtaDestinosBean;
	}
		
	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}
	public void setUsuarioServicio(
			UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}	
	public SP_PDM_Ahorros_ConsultaCtaDestinoServicio getConsultaCtaDestinoServicio() {
		return consultaCtaDestinoServicio;
	}
	public void setConsultaCtaDestinoServicio(
			SP_PDM_Ahorros_ConsultaCtaDestinoServicio consultaCtaDestinoServicio) {
		this.consultaCtaDestinoServicio = consultaCtaDestinoServicio;
	}
	

}
