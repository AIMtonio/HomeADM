package operacionesPDM.servicioweb;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Pattern;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaEstatusSpeiRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaEstatusSpeiResponse;
import operacionesPDM.servicio.SP_PDM_Ahorros_ConsultaEstatusSpeiServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDM_Ahorros_ConsultaEstatusSpeiWS extends AbstractMarshallingPayloadEndpoint{
	
	private SP_PDM_Ahorros_ConsultaEstatusSpeiServicio consultaEstatusSpeiServicio=null;	
	private UsuarioServicio	usuarioServicio = null;	
		
	public static String 	Valido			= "true";
	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiWS(Marshaller marshaller){
		super(marshaller);
	}
	
	private SP_PDM_Ahorros_ConsultaEstatusSpeiResponse SP_PDM_Ahorros_ConsultaEstatus(SP_PDM_Ahorros_ConsultaEstatusSpeiRequest request){
		
		SP_PDM_Ahorros_ConsultaEstatusSpeiResponse consultaEstatusResponse = new SP_PDM_Ahorros_ConsultaEstatusSpeiResponse();
		
		UsuarioBean	usuarioBean = new UsuarioBean();
		UsuarioBean	usuarioBeanCon = new UsuarioBean();
		
		try{
			
			consultaEstatusResponse = validaRequest(request);
			//Validar que no este vacio el Campo
			if(consultaEstatusResponse.getCodigoRespuesta()!="0"){					
			
				throw new Exception(consultaEstatusResponse.getMensajeRespuesta());
					
			}else{
				
				usuarioBean.setClave(request.getIdUsuario());
				usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(request.getIdUsuario(),request.getClave()));
				usuarioBeanCon = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);
				
				if(usuarioBeanCon == null){
					
					consultaEstatusResponse.setEsValido("false");
					consultaEstatusResponse.setCodigoRespuesta("15");
					consultaEstatusResponse.setMensajeRespuesta("Usuario y/o contraseña incorrecto.");
					throw new Exception("Usuario y/o contraseña incorrecto.");
					
				}else if(usuarioBeanCon.getOrigenDatos().isEmpty()){
					
					consultaEstatusResponse.setEsValido("false");
					consultaEstatusResponse.setCodigoRespuesta("16");
					consultaEstatusResponse.setMensajeRespuesta("Usuario y/o contraseña incorrecto.");
					throw new Exception("Usuario y/o contraseña incorrecto.");
					
				}
				
				usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
				consultaEstatusSpeiServicio.getSP_PDM_Ahorros_ConsultaEstatusSpeiDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
													
				usuarioBeanCon= usuarioServicio.consulta(Enum_Con_Usuario.validadUserWS,usuarioBean);
				
				if(usuarioBeanCon.getEsValido().equals(Valido)){
					
					SP_PDM_Ahorros_ConsultaEstatusSpeiResponse listaEstatusSpei = new SP_PDM_Ahorros_ConsultaEstatusSpeiResponse();
					listaEstatusSpei = consultaEstatusSpeiServicio.listaSpeiEnviosWS(request);
					
					consultaEstatusResponse.setEsValido("true");
					consultaEstatusResponse.setCodigoRespuesta("0");
					consultaEstatusResponse.setConEstatusSpei(listaEstatusSpei.getConEstatusSpei());
					consultaEstatusResponse.setMensajeRespuesta("Consulta Exitosa");
					
				}else{
					consultaEstatusResponse.setEsValido(usuarioBeanCon.getEsValido());
					consultaEstatusResponse.setCodigoRespuesta(usuarioBeanCon.getCodigoResp());
					consultaEstatusResponse.setMensajeRespuesta(usuarioBeanCon.getCodigoDesc());
				}
				
				
			}				
				
						
		}catch (Exception e) {
			e.printStackTrace();	
			if(consultaEstatusResponse.getCodigoRespuesta().isEmpty() || consultaEstatusResponse.getCodigoRespuesta().equals("0")){
				consultaEstatusResponse.setEsValido("false");
				consultaEstatusResponse.setCodigoRespuesta("999");
				consultaEstatusResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ESTATUSSPEILIS");
			}
						
		}
		
		return consultaEstatusResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception { 		
		SP_PDM_Ahorros_ConsultaEstatusSpeiRequest consultaEstatusDestinoRequest = (SP_PDM_Ahorros_ConsultaEstatusSpeiRequest) arg0;		
		return SP_PDM_Ahorros_ConsultaEstatus(consultaEstatusDestinoRequest);	
	}
	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiResponse validaRequest(SP_PDM_Ahorros_ConsultaEstatusSpeiRequest request){
		SP_PDM_Ahorros_ConsultaEstatusSpeiResponse consultaEstatusBean = new SP_PDM_Ahorros_ConsultaEstatusSpeiResponse();
		if(request.getClienteID().trim().isEmpty()){
			consultaEstatusBean.setCodigoRespuesta("01");
			consultaEstatusBean.setMensajeRespuesta("El Número del Cliente Solicitado está vacío.");
		} else if(request.getClienteID().trim().equals("?")){
			consultaEstatusBean.setCodigoRespuesta("02");
			consultaEstatusBean.setMensajeRespuesta("El Número del Cliente indicado No Existe.");
		} else if(request.getFechaInicial().trim().isEmpty()){
			consultaEstatusBean.setCodigoRespuesta("03");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Incial Está Vacía.");
		} else if(request.getFechaInicial().trim().equals("?")){
			consultaEstatusBean.setCodigoRespuesta("04");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Incial Indicada es Incorrecta.");
		} else if(!isFechaValida(request.getFechaInicial().trim())){
			consultaEstatusBean.setCodigoRespuesta("05");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Incial Indicada es Incorrecta.");
		} else if(request.getFechaFinal().trim().isEmpty()){
			consultaEstatusBean.setCodigoRespuesta("06");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Final Está Vacía.");
		} else if(request.getFechaFinal().trim().equals("?")){
			consultaEstatusBean.setCodigoRespuesta("07");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Final Indicada es Incorrecta.");
		} else if(!isFechaValida(request.getFechaFinal().trim())){
			consultaEstatusBean.setCodigoRespuesta("08");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Final Indicada es Incorrecta.");
		} else if(copararFecha(request.getFechaInicial().trim(),request.getFechaFinal().trim()).equals("false")){
			consultaEstatusBean.setCodigoRespuesta("09");
			consultaEstatusBean.setMensajeRespuesta("La Fecha Final No puede ser Menor a la Fecha Incial.");
		} else if(request.getIdUsuario().trim().isEmpty()){
			consultaEstatusBean.setCodigoRespuesta("10");
			consultaEstatusBean.setMensajeRespuesta("El ID del Usuario Solicitado está Vacío.");
		} else if(request.getIdUsuario().trim().equals("?")){
			consultaEstatusBean.setCodigoRespuesta("11");
			consultaEstatusBean.setMensajeRespuesta("El ID del Usuario indicado No Existe.");
		} else if(request.getClave().trim().isEmpty()){
			consultaEstatusBean.setCodigoRespuesta("12");
			consultaEstatusBean.setMensajeRespuesta("La Clave del Usuario Solicitado está Vacío.");
		} else if(request.getClave().trim().equals("?")){
			consultaEstatusBean.setCodigoRespuesta("13");
			consultaEstatusBean.setMensajeRespuesta("La Clave del Usuario indicado No es Correcta.");
		} else if(!Pattern.matches("^\\d+$",request.getClienteID().trim())){
			consultaEstatusBean.setCodigoRespuesta("14");
			consultaEstatusBean.setMensajeRespuesta("El Numero del Cliente indicado No Existe.");
		}else{
			consultaEstatusBean.setCodigoRespuesta("0");
		}
		
		return consultaEstatusBean;
	}
	
	public boolean isFechaValida(String fecha) {
        try {
        	
        	SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
            
        } catch (ParseException e) {
            return false;
        }
        return true;
    }
	
	public String copararFecha(String fechaIncial, String fechaFinal) {
		String validacion ="";
        try {
        	
        	SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
        	Date fechaIni = formatoFecha.parse(fechaIncial);
        	Date fechaFin = formatoFecha.parse(fechaFinal);
        	
        	if (fechaFin.before(fechaIni)){
        	    
        		validacion ="false";
        		
        	}else{
        		
        	    validacion ="true";
        	    
        	}        	
            
        } catch (ParseException e) {
        	e.printStackTrace();
        	System.out.println("Se Produjo un error al Comparar las Fechas");
        }
        
        return validacion;
		
    }
	
	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}
	public void setUsuarioServicio(
			UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiServicio getConsultaEstatusSpeiServicio() {
		return consultaEstatusSpeiServicio;
	}
	public void setConsultaEstatusSpeiServicio(
			SP_PDM_Ahorros_ConsultaEstatusSpeiServicio consultaEstatusSpeiServicio) {
		this.consultaEstatusSpeiServicio = consultaEstatusSpeiServicio;
	}
	

}
