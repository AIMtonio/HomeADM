package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Socio_Alta3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Socios_Alta3ReyesResponse;
import operacionesPDA.servicio.SP_PDA_Socio_Alta3ReyesServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class SP_PDA_Socio_Alta3ReyesWS extends AbstractMarshallingPayloadEndpoint{
	SP_PDA_Socio_Alta3ReyesServicio sp_PDA_Socio_Alta3ReyesServicio = null;	
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	
	
	public SP_PDA_Socio_Alta3ReyesWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDA_Socios_Alta3ReyesResponse SP_PDA_Socios_Alta(SP_PDA_Socio_Alta3ReyesRequest request ){	
		SP_PDA_Socios_Alta3ReyesResponse  sp_PDA_Socios_AltaResponse = new SP_PDA_Socios_Alta3ReyesResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sp_PDA_Socio_Alta3ReyesServicio.getSp_PDA_Socio_Alta3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		SP_PDA_Socio_Alta3ReyesRequest beanRequest = new SP_PDA_Socio_Alta3ReyesRequest();
		
       ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		
        parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		
		
		/* Valida los datos del request y despues ejecuta la consulta */
		
		
		try {
						
						/* Settea los valores de la solicitud */
				    	beanRequest.setNombre(request.getNombre());
						beanRequest.setApPaterno(request.getApPaterno());
						beanRequest.setApMaterno(request.getApMaterno());
						beanRequest.setFecNacimiento(request.getFecNacimiento().substring(0,10));
						beanRequest.setRfc(request.getRfc());
						beanRequest.setCurp(request.getCurp());
						beanRequest.setMonto(request.getMonto());	

						
						String arreglo [];	
						String valor = "";
						
						for(byte numParametros = 0; numParametros < 29;  numParametros++ ){
							arreglo = request.getParametros().get(0).get(numParametros).toString().split("<");
							valor = arreglo[5].substring(10, arreglo[5].length());
									
							if(valor.equals(">")){
								
								valor = "";
								
								
							}
							switch(numParametros) {
							 case 0: 
								 beanRequest.setSucursal(valor);	 
								 break;
							 case 1: 
								 beanRequest.setMail(valor);
							     break;
							 case 2: 
								 beanRequest.setPaisDeNacimiento(valor);
							     break;
							 case 3: 
								 beanRequest.setEntiFedNacimiento(valor);
							     break;
							 case 4: 
								 beanRequest.setNacionalidad(valor);
								 break;
							 case 5: 
								 beanRequest.setPaisDeResidencia(valor);
							     break;
							 case 6: 
								 beanRequest.setSexo(valor);
							     break;
							 case 7:  
								 beanRequest.setTelefonoParticular(valor);
							     break;
							 case 8:  
								 beanRequest.setSectorGeneral(valor);
							     break;
							 case 9:  
								 beanRequest.setActividadBMX(valor);
							     break;
							 case 10:  
								 beanRequest.setActividadFR(valor);
							     break;
							 case 11:  
								 beanRequest.setPromotorInicial(valor);
							     break;
							 case 12:  
								 beanRequest.setPromotorActual(valor);
							     break;
							 case 13:  
								 beanRequest.setEsMenor(valor);
							     break;
							 case 14:  
								 beanRequest.setNumero(valor);
							     break;
							 case 15:  
								 beanRequest.setTipoDeDireccion(valor);
							     break;
							 case 16:  
								 beanRequest.setEntidadFederativa(valor);
							     break;
							 case 17:  
								 beanRequest.setMunicipio(valor);
							     break;
							 case 18:  
								 beanRequest.setCodigoPostal(valor);
							     break;
							 case 19:  
								 beanRequest.setLocalidad(valor);
							     break;
							 case 20:  
								 beanRequest.setColonia(valor);
							     break;
							 case 21:  
								 beanRequest.setCalle(valor);
							     break;
							 case 22:  
								 beanRequest.setNumeroDireccion(valor);
							     break;
							 case 23:  
								 beanRequest.setOficial(valor);
							     break;
							 case 24:  
								 beanRequest.setFolio(valor);
							     break;
							 case 25:  
								 beanRequest.setTipo(valor);
							     break;
							 case 26:  
								 beanRequest.setEsOficial(valor);
							     break;
							 case 27:  
								 beanRequest.setFechaExpedicion(valor);
							     break;
							 case 28:  
								 beanRequest.setFechaVencimiento(valor);
							     break;
							 }
							
							
														
						}
						

						beanRequest.setFolio_Pda(request.getFolio_Pda());						
						beanRequest.setId_Usuario(request.getId_Usuario());
						beanRequest.setClave(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
						beanRequest.setDispositivo(request.getDispositivo());
					


			if(parametrosCajaBean.getVersionWS().equals(varYanga)){
				sp_PDA_Socios_AltaResponse  = (SP_PDA_Socios_Alta3ReyesResponse) sp_PDA_Socio_Alta3ReyesServicio.alta(beanRequest);
			}
			else{

			if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
				sp_PDA_Socios_AltaResponse  = (SP_PDA_Socios_Alta3ReyesResponse) sp_PDA_Socio_Alta3ReyesServicio.alta(beanRequest);

				}
			  }
			

		} catch (Exception e) {	
			e.printStackTrace();
			System.out.println("ERROR" + " " + e );	
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
			Date fecha = new Date();
			sp_PDA_Socios_AltaResponse.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
			sp_PDA_Socios_AltaResponse.setCodigoDesc("Transacción Rechazada");
			sp_PDA_Socios_AltaResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
			sp_PDA_Socios_AltaResponse.setEsValido("false");
			sp_PDA_Socios_AltaResponse.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
			sp_PDA_Socios_AltaResponse.setNumSocio(String.valueOf(Constantes.ENTERO_CERO));
		}
		
		return sp_PDA_Socios_AltaResponse;
	}// fin del metodo 


	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Socio_Alta3ReyesRequest sp_PDA_Socio_AltaRequest= (SP_PDA_Socio_Alta3ReyesRequest)arg0; 			
		return SP_PDA_Socios_Alta(sp_PDA_Socio_AltaRequest);
		
	}

	
	public SP_PDA_Socio_Alta3ReyesServicio getSp_PDA_Socio_Alta3ReyesServicio() {
		return sp_PDA_Socio_Alta3ReyesServicio;
	}

	public void setSp_PDA_Socio_Alta3ReyesServicio(
			SP_PDA_Socio_Alta3ReyesServicio sp_PDA_Socio_Alta3ReyesServicio) {
		this.sp_PDA_Socio_Alta3ReyesServicio = sp_PDA_Socio_Alta3ReyesServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	} 

}
