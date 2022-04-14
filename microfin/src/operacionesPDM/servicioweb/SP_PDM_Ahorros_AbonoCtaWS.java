package operacionesPDM.servicioweb;

import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.regex.Pattern;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_AbonoCtaRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_AbonoCtaResponse;
import operacionesPDM.servicio.SP_PDM_Ahorros_AbonoCtaServicio;
import operacionesPDM.servicio.SP_PDM_Ahorros_AbonoCtaServicio.Enum_Tra_PDM_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.ParametrosCajaBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.ParametrosCajaServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

public class SP_PDM_Ahorros_AbonoCtaWS extends AbstractMarshallingPayloadEndpoint  {
	
	private SP_PDM_Ahorros_AbonoCtaServicio abonoCtaServicio = null;	
	private ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	private UsuarioServicio	usuarioServicio = null;	
	private ParametrosCajaServicio parametrosCajaServicio = null;
	
	String Valido			= "true";	
	String varYanga 		= "YANGA";
	String var3Reyes 		= "3 REYES";
	double decimal_Cero		= 0.0;
		
	public SP_PDM_Ahorros_AbonoCtaWS(Marshaller marshaller){
		super(marshaller);
	}
	
	private SP_PDM_Ahorros_AbonoCtaResponse SP_PDM_Ahorros_Abono(SP_PDM_Ahorros_AbonoCtaRequest request){
		SP_PDM_Ahorros_AbonoCtaResponse abonoCtaResponse = new SP_PDM_Ahorros_AbonoCtaResponse();
		SP_PDM_Ahorros_AbonoCtaRequest beanRequest = new SP_PDM_Ahorros_AbonoCtaRequest();
		
		UsuarioBean	usuarioBean = new UsuarioBean();
		UsuarioBean	usuarioBeanCon = new UsuarioBean();		
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		
		try{
			
			abonoCtaResponse = validaRequest(request);			
			if(abonoCtaResponse.getCodigoResp()!= 0){				
				abonoCtaResponse.setEsValido("false");
				throw new Exception(abonoCtaResponse.getCodigoDesc());					
			}else{
				
				usuarioBean.setClave(request.getId_Usuario());
				usuarioBean.setContrasenia(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
				usuarioBeanCon = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);
				
				if(usuarioBeanCon == null){
					
					abonoCtaResponse.setEsValido("false");
					abonoCtaResponse.setCodigoResp(21);
					abonoCtaResponse.setCodigoDesc("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}else if(usuarioBeanCon.getOrigenDatos().isEmpty()){
					
					abonoCtaResponse.setEsValido("false");
					abonoCtaResponse.setCodigoResp(22);
					abonoCtaResponse.setCodigoDesc("Usuario Incorrecto.");
					throw new Exception("Usuario Incorrecto.");
					
				}
				
				usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(usuarioBeanCon.getOrigenDatos());
				ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSession(Enum_Con_ParAplicacion.loginSession, usuarioBeanCon);
				estableceParametros(parametros);		
				
				usuarioBeanCon= usuarioServicio.consulta(Enum_Con_Usuario.validadUserWS,usuarioBean);
				
				if(usuarioBeanCon.getEsValido().equals(Valido)){	
					
					parametrosCajaBean.setEmpresaID("1");
					parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
					
					if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
						
						SP_PDM_Ahorros_AbonoCtaResponse procesaAbono = new SP_PDM_Ahorros_AbonoCtaResponse();
						
						String cadena = request.getDispositivo();
						
						String idservicio = "";
						String tipopera = "";
						String referencia = "";
								
						int inicio = cadena.indexOf("-");
						int fin = cadena.indexOf("-", inicio + 1);					
						
						idservicio = cadena.substring(0, inicio);
						tipopera = cadena.substring(inicio + 1, fin);
						referencia = cadena.substring(fin + 1);
						
						
						beanRequest.setNum_Socio(request.getNum_Socio());
						beanRequest.setNum_Cta(request.getNum_Cta());
						beanRequest.setMonto(request.getMonto());
						beanRequest.setFecha_Mov(request.getFecha_Mov().substring(0,10));
						beanRequest.setFolio_Pda(request.getFolio_Pda());
						beanRequest.setId_Usuario(request.getId_Usuario());
						beanRequest.setClave(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
						beanRequest.setIdServicio(idservicio);	
						beanRequest.setTipoOperacion(tipopera);	
						beanRequest.setReferencia(referencia);							
						
						
						procesaAbono = abonoCtaServicio.grabaTransaccion(beanRequest, Enum_Tra_PDM_WS.abonoCtaWSSofi);
						
						if(procesaAbono.getCodigoResp() != Constantes.ENTERO_CERO){
							
							abonoCtaResponse.setEsValido("false");
							abonoCtaResponse.setCodigoResp(procesaAbono.getCodigoResp());
							abonoCtaResponse.setCodigoDesc(procesaAbono.getCodigoDesc());
							throw new Exception(procesaAbono.getCodigoDesc());
							
						}else{
							
							abonoCtaResponse.setEsValido("true");
							abonoCtaResponse.setAutFecha(procesaAbono.getAutFecha());
							abonoCtaResponse.setFolioAut(procesaAbono.getFolioAut());
							abonoCtaResponse.setSaldoTot(procesaAbono.getSaldoTot());
							abonoCtaResponse.setSaldoDisp(procesaAbono.getSaldoDisp());							
							abonoCtaResponse.setCodigoResp(procesaAbono.getCodigoResp());
							abonoCtaResponse.setCodigoDesc(procesaAbono.getCodigoDesc());	
							
						}
						
					}
					
				}else{
					
					abonoCtaResponse.setEsValido(usuarioBeanCon.getEsValido());
					abonoCtaResponse.setCodigoResp(Utileria.convierteEntero(usuarioBeanCon.getCodigoResp()));
					abonoCtaResponse.setCodigoDesc(usuarioBeanCon.getCodigoDesc());
					throw new Exception(usuarioBeanCon.getCodigoDesc());
					
				}
				
				
			}
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(abonoCtaResponse.getCodigoResp() == 0){
				abonoCtaResponse.setEsValido("false");
				abonoCtaResponse.setCodigoResp(999);
				abonoCtaResponse.setCodigoDesc("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ABONOCTAPDMWSPRO");
			}
						
		}
		
		return abonoCtaResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception { 		
		SP_PDM_Ahorros_AbonoCtaRequest abonoCtaRequest = (SP_PDM_Ahorros_AbonoCtaRequest) arg0;		
		return SP_PDM_Ahorros_Abono(abonoCtaRequest);	
	}
	
	public SP_PDM_Ahorros_AbonoCtaResponse validaRequest(SP_PDM_Ahorros_AbonoCtaRequest requestVal){
		SP_PDM_Ahorros_AbonoCtaResponse abonoCtaBean = new SP_PDM_Ahorros_AbonoCtaResponse();
		if(requestVal.getNum_Socio().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(1);
			abonoCtaBean.setCodigoDesc("El Número de Socio Está vacío.");
		} else if(requestVal.getNum_Socio().trim().equals("?")){
			abonoCtaBean.setCodigoResp(2);
			abonoCtaBean.setCodigoDesc("El Número de Socio Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getNum_Socio().trim())){
			abonoCtaBean.setCodigoResp(3);
			abonoCtaBean.setCodigoDesc("El Número de Socio Indicado No Existe.");
		} else if(requestVal.getNum_Cta().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(4);
			abonoCtaBean.setCodigoDesc("El Número de Cuenta Está vacío.");
		} else if(requestVal.getNum_Cta().trim().equals("?")){
			abonoCtaBean.setCodigoResp(5);
			abonoCtaBean.setCodigoDesc("El Número de Cuenta Indicado No Existe.");
		} else if(!Pattern.matches("^\\d+$",requestVal.getNum_Cta().trim())){
			abonoCtaBean.setCodigoResp(6);
			abonoCtaBean.setCodigoDesc("El Número de Cuenta Indicado No Existe.");
		} else if(requestVal.getMonto().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(7);
			abonoCtaBean.setCodigoDesc("El Monto Está vacío.");
		} else if(requestVal.getMonto().trim().equals("?")){
			abonoCtaBean.setCodigoResp(8);
			abonoCtaBean.setCodigoDesc("El Monto Indicado es Incorrecto.");
		} else if(!isDouble(requestVal.getMonto().trim())){
			abonoCtaBean.setCodigoResp(9);
			abonoCtaBean.setCodigoDesc("El Monto Indicado es Incorrecto.");
		} else if(Utileria.convierteDoble(requestVal.getMonto().trim()) <= decimal_Cero){
			abonoCtaBean.setCodigoResp(10);
			abonoCtaBean.setCodigoDesc("El Monto Indicado es Incorrecto.");
		} else if(requestVal.getFecha_Mov().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(11);
			abonoCtaBean.setCodigoDesc("La Fecha del Movimiento Está Vacía.");
		} else if(requestVal.getFecha_Mov().trim().equals("?")){
			abonoCtaBean.setCodigoResp(12);
			abonoCtaBean.setCodigoDesc("La Fecha de Movimiento Proporcionada es Incorrecta.");
		} else if(requestVal.getFolio_Pda().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(13);
			abonoCtaBean.setCodigoDesc("El Folio de PDA Está Vacío.");
		} else if(requestVal.getFolio_Pda().trim().equals("?")){
			abonoCtaBean.setCodigoResp(14);
			abonoCtaBean.setCodigoDesc("El Folio de PDA indicado Es Incorrecto.");
		} else if(requestVal.getId_Usuario().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(15);
			abonoCtaBean.setCodigoDesc("El ID del Usuario Está Vacío.");
		} else if(requestVal.getId_Usuario().trim().equals("?")){
			abonoCtaBean.setCodigoResp(16);
			abonoCtaBean.setCodigoDesc("El ID del Usuario Indicado no Existe.");
		} else if(requestVal.getClave().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(17);
			abonoCtaBean.setCodigoDesc("La Clave del Usuario Está Vacía.");
		} else if(requestVal.getClave().trim().equals("?")){
			abonoCtaBean.setCodigoResp(18);
			abonoCtaBean.setCodigoDesc("La Clave del Usuario Indicada es Incorrecta.");
		} else if(requestVal.getDispositivo().trim().isEmpty()){
			abonoCtaBean.setCodigoResp(19);
			abonoCtaBean.setCodigoDesc("El Campo de Dispositivo se encuentra Vacío.");
		} else if(requestVal.getDispositivo().trim().equals("?")){
			abonoCtaBean.setCodigoResp(120);
			abonoCtaBean.setCodigoDesc("El Campo de Dispositivo no Cuenta Con el Formato Correcto.");
		} else{
			abonoCtaBean.setCodigoResp(0);
		}
		
		return abonoCtaBean;
	}
	
	public void estableceParametros(ParametrosSesionBean parametros){
		
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setOrigenDatos(parametros.getOrigenDatos());
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setEmpresaID(parametros.getEmpresaID());
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setUsuario(parametros.getNumeroUsuario());
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setFecha(parametros.getFechaAplicacion());
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setDireccionIP(parametros.getIPsesion());
		abonoCtaServicio.getSP_PDM_Ahorros_AbonoCtaDAO().getParametrosAuditoriaBean().setSucursal(parametros.getSucursal());
			
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

	public SP_PDM_Ahorros_AbonoCtaServicio getAbonoCtaServicio() {
		return abonoCtaServicio;
	}

	public void setAbonoCtaServicio(SP_PDM_Ahorros_AbonoCtaServicio abonoCtaServicio) {
		this.abonoCtaServicio = abonoCtaServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
	
	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}
	
	public void setParametrosAplicacionServicio(ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}
