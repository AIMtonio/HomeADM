package operacionesPDM.servicioweb;

import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.regex.Pattern;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_OrdenPagoSpeiRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_OrdenPagoSpeiResponse;
import operacionesPDM.servicio.SP_PDM_Ahorros_OrdenPagoSpeiServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDM_Ahorros_OrdenPagoSpeiWS extends AbstractMarshallingPayloadEndpoint{
	
	private SP_PDM_Ahorros_OrdenPagoSpeiServicio ordenPagoSpeiServicio=null;
	private ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	private UsuarioServicio	usuarioServicio = null;	
		
	String 	Valido			= "true";
	double	decimal_Cero	= 0.0;
	
	public SP_PDM_Ahorros_OrdenPagoSpeiWS(Marshaller marshaller){
		super(marshaller);
	}
	
	private	SP_PDM_Ahorros_OrdenPagoSpeiResponse SP_PDM_Ahorros_OrdenPagoSpei(SP_PDM_Ahorros_OrdenPagoSpeiRequest request){
		SP_PDM_Ahorros_OrdenPagoSpeiResponse ordenPagoSpeiResponse  = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
		
		UsuarioBean	usuarioBean = new UsuarioBean();
		UsuarioBean	usuarioBeanCon = new UsuarioBean();
			
		try{
			
			ordenPagoSpeiResponse = validaRequest(request);					
			if(ordenPagoSpeiResponse.getCodigoRespuesta()!= 0){					
				ordenPagoSpeiResponse.setEsValido("false");
				throw new Exception(ordenPagoSpeiResponse.getMensajeRespuesta());
					
			}else{
				
				usuarioBean.setClave(request.getIdUsuario());
				usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(request.getIdUsuario(),request.getClave()));
				usuarioBeanCon = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);

				if(usuarioBeanCon == null){
					
					ordenPagoSpeiResponse.setEsValido("false");
					ordenPagoSpeiResponse.setCodigoRespuesta(28);
					ordenPagoSpeiResponse.setMensajeRespuesta("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}else if(usuarioBeanCon.getOrigenDatos().isEmpty()){
					
					ordenPagoSpeiResponse.setEsValido("false");
					ordenPagoSpeiResponse.setCodigoRespuesta(29);
					ordenPagoSpeiResponse.setMensajeRespuesta("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}
				usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
				ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSession(Enum_Con_ParAplicacion.loginSession, usuarioBeanCon);				
				estableceParametros(parametros);				
							
				usuarioBeanCon= usuarioServicio.consulta(Enum_Con_Usuario.validadUserWS,usuarioBean);
				
				if(usuarioBeanCon.getEsValido().equals(Valido)){						
					
					SP_PDM_Ahorros_OrdenPagoSpeiResponse procesaSpeiEnvios = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
					request.setUsuarioEnvio(parametros.getNombreUsuario());
					procesaSpeiEnvios = ordenPagoSpeiServicio.grabaTransaccion(request);
					
					if(procesaSpeiEnvios.getCodigoRespuesta() != Constantes.ENTERO_CERO ){
						
						ordenPagoSpeiResponse.setEsValido("false");
						ordenPagoSpeiResponse.setCodigoRespuesta(procesaSpeiEnvios.getCodigoRespuesta());
						ordenPagoSpeiResponse.setMensajeRespuesta(procesaSpeiEnvios.getMensajeRespuesta());
						throw new Exception(procesaSpeiEnvios.getMensajeRespuesta());
						
					}else{
						ordenPagoSpeiResponse.setEsValido("true");
						ordenPagoSpeiResponse.setAutFecha(procesaSpeiEnvios.getAutFecha());
						ordenPagoSpeiResponse.setFolioAut(procesaSpeiEnvios.getFolioAut());
						ordenPagoSpeiResponse.setFolioSpei(procesaSpeiEnvios.getFolioSpei());
						ordenPagoSpeiResponse.setClaveRastreo(procesaSpeiEnvios.getClaveRastreo());
						ordenPagoSpeiResponse.setFechaOperacion(procesaSpeiEnvios.getFechaOperacion());
						ordenPagoSpeiResponse.setCodigoRespuesta(procesaSpeiEnvios.getCodigoRespuesta());
						ordenPagoSpeiResponse.setMensajeRespuesta(procesaSpeiEnvios.getMensajeRespuesta());									
					}
					
				}else{
					ordenPagoSpeiResponse.setEsValido(usuarioBeanCon.getEsValido());
					ordenPagoSpeiResponse.setCodigoRespuesta(Utileria.convierteEntero(usuarioBeanCon.getCodigoResp()));
					ordenPagoSpeiResponse.setMensajeRespuesta(usuarioBeanCon.getCodigoDesc());
					throw new Exception(usuarioBeanCon.getCodigoDesc());

				}				
			}
		
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(ordenPagoSpeiResponse.getCodigoRespuesta() == 0){
				ordenPagoSpeiResponse.setEsValido("false");
				ordenPagoSpeiResponse.setCodigoRespuesta(999);
				ordenPagoSpeiResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-SPEIENVIOSWSPRO");
			}
						
		}
		
		return ordenPagoSpeiResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception { 		
		SP_PDM_Ahorros_OrdenPagoSpeiRequest ordenPagoSpeiRequest= (SP_PDM_Ahorros_OrdenPagoSpeiRequest)arg0;		
		return SP_PDM_Ahorros_OrdenPagoSpei(ordenPagoSpeiRequest);	
	}
	
	public SP_PDM_Ahorros_OrdenPagoSpeiResponse validaRequest(SP_PDM_Ahorros_OrdenPagoSpeiRequest requestVal){
		SP_PDM_Ahorros_OrdenPagoSpeiResponse ordenPagoSpeiBean = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
		if(requestVal.getClienteID().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(1);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cliente Está vacío.");
		} else if(requestVal.getClienteID().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(2);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cliente Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getClienteID().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(3);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cliente Indicado No Existe.");
		}else if(requestVal.getCuentaID().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(4);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cuenta Está vacío.");
		} else if(requestVal.getCuentaID().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(5);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cuenta Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getCuentaID().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(6);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de Cuenta Indicado No Existe.");
		} else if(requestVal.getMonto().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(7);
			ordenPagoSpeiBean.setMensajeRespuesta("El Monto Indicado Está vacío.");
		} else if(requestVal.getMonto().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(8);
			ordenPagoSpeiBean.setMensajeRespuesta("El Monto Indicado es Incorrecto.");
		} else if(!isDouble(requestVal.getMonto().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(9);
			ordenPagoSpeiBean.setMensajeRespuesta("El Monto Indicado es Incorrecto.");
		} else if(Utileria.convierteDoble(requestVal.getMonto().trim()) <= decimal_Cero){		
			ordenPagoSpeiBean.setCodigoRespuesta(10);
			ordenPagoSpeiBean.setMensajeRespuesta("El Monto Indicado es Incorrecto.");					
		} else if(requestVal.getIdInstitucion().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(11);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de la Institución Está Vacío.");
		} else if(requestVal.getIdInstitucion().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(12);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de la Institución Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getIdInstitucion().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(13);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de la Institución Indicado Es Incorrecto.");
		} else if(requestVal.getTipoCuenta().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(14);
			ordenPagoSpeiBean.setMensajeRespuesta("El Tipo de Cuenta Indicado Está Vacío.");
		} else if(requestVal.getTipoCuenta().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(15);
			ordenPagoSpeiBean.setMensajeRespuesta("El Tipo de Cuenta Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getTipoCuenta().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(16);
			ordenPagoSpeiBean.setMensajeRespuesta("El Tipo de Cuenta Indicado No Existe.");
		} else if(requestVal.getCuentaBeneficiario().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(17);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de la Cuenta del Beneficiario Está Vacío.");
		} else if(requestVal.getCuentaBeneficiario().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(18);
			ordenPagoSpeiBean.setMensajeRespuesta("El Número de la Cuenta del Beneficiario No Existe.");
		} else if(requestVal.getNombreBeneficiario().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(19);
			ordenPagoSpeiBean.setMensajeRespuesta("El Nombre del Beneficiario Esta Vacío.");
		} else if(requestVal.getNombreBeneficiario().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(20);
			ordenPagoSpeiBean.setMensajeRespuesta("El Nombre del Beneficiario Esta Vacío.");
		} else if(requestVal.getRFCBeneficiario().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(21);
			ordenPagoSpeiBean.setMensajeRespuesta("El RFC del Beneficiario Indicado es Incorrecto.");
		} else if(requestVal.getReferenciaNumerica().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(22);
			ordenPagoSpeiBean.setMensajeRespuesta("La Referencia Indicada es Incorrecta..");
		} else if(!requestVal.getIvaXpagar().trim().isEmpty() && !valIvaxPagar(requestVal.getIvaXpagar().trim())){
			ordenPagoSpeiBean.setCodigoRespuesta(23);
			ordenPagoSpeiBean.setMensajeRespuesta("El Monto del Iva Indicado es Incorrecto.");			
		} else if(requestVal.getIdUsuario().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(24);
			ordenPagoSpeiBean.setMensajeRespuesta("El ID del Usuario Está Vacío.");
		} else if(requestVal.getIdUsuario().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(25);
			ordenPagoSpeiBean.setMensajeRespuesta("El ID del Usuario no Existe.");
		} else if(requestVal.getClave().trim().isEmpty()){
			ordenPagoSpeiBean.setCodigoRespuesta(26);
			ordenPagoSpeiBean.setMensajeRespuesta("La Clave del Usuario Está Vacía.");
		} else if(requestVal.getClave().trim().equals("?")){
			ordenPagoSpeiBean.setCodigoRespuesta(27);
			ordenPagoSpeiBean.setMensajeRespuesta("La Clave del Usuario Indicada es Incorrecta.");
		} else{
			ordenPagoSpeiBean.setCodigoRespuesta(0);
		}
		
		return ordenPagoSpeiBean;
	}
	

	public void estableceParametros(ParametrosSesionBean parametros){
		
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setOrigenDatos(parametros.getOrigenDatos());
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setEmpresaID(parametros.getEmpresaID());
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setUsuario(parametros.getNumeroUsuario());
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setFecha(parametros.getFechaAplicacion());
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setDireccionIP(parametros.getIPsesion());
		ordenPagoSpeiServicio.getSP_PDM_Ahorros_ConsultaCtaDestinoDAO().getParametrosAuditoriaBean().setSucursal(parametros.getSucursal());
			
	}
	
	public boolean valIvaxPagar(String valorStr){
		double valorDoble = 0.0;
		
		if(valorStr.trim().equals("?") || !isDouble(valorStr.trim()) || Utileria.convierteDoble(valorStr) < valorDoble){
			return false;
		}
		
		return true; 
		
	}
	
	public boolean isDouble(String valorStr){
		double valorDoble = 0.0;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
				valorDoble = Double.parseDouble(valorStr);
			}			
		}catch(Exception error){
			return false;
		}
		
		return true; 
		
	}	
	
	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}
	
	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
		
	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}
	public void setUsuarioServicio(
			UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
	public SP_PDM_Ahorros_OrdenPagoSpeiServicio getOrdenPagoSpeiServicio() {
		return ordenPagoSpeiServicio;
	}
	public void setOrdenPagoSpeiServicio(
			SP_PDM_Ahorros_OrdenPagoSpeiServicio ordenPagoSpeiServicio) {
		this.ordenPagoSpeiServicio = ordenPagoSpeiServicio;
	}
	

}
