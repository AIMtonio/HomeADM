package operacionesPDA.servicioweb;


import herramientas.Constantes;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_Solicitud3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_Solicitud3ReyesResponse;
import operacionesPDA.servicio.SP_PDA_Creditos_Solicitud3ReyesServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class SP_PDA_Creditos_Solicitud3ReyesWS extends AbstractMarshallingPayloadEndpoint{
	SP_PDA_Creditos_Solicitud3ReyesServicio sp_PDA_Creditos_Solicitud3ReyesServicio = null;
		
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	
	
	
	public SP_PDA_Creditos_Solicitud3ReyesWS(Marshaller marshaller) {
		super(marshaller);
			// TODO Auto-generated constructor stub
	}
		
	private SP_PDA_Creditos_Solicitud3ReyesResponse SP_PDA_Creditos_Solicitud(SP_PDA_Creditos_Solicitud3ReyesRequest request ){	
		SP_PDA_Creditos_Solicitud3ReyesResponse  sp_PDA_Creditos_SolicitudResponse = new SP_PDA_Creditos_Solicitud3ReyesResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sp_PDA_Creditos_Solicitud3ReyesServicio.getSp_PDA_Creditos_Solicitud3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		SP_PDA_Creditos_Solicitud3ReyesRequest beanRequest = new SP_PDA_Creditos_Solicitud3ReyesRequest();
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

		
        parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
	
	 	   	
	/* Valida los datos del request y despues ejecuta la consulta */
			
			try {
				if(Double.parseDouble(request.getMonto()) > 0){
									
					/* Settea los valores de la solicitud */
					beanRequest.setNum_Socio(request.getNum_Socio());
					beanRequest.setMonto(request.getMonto());
					beanRequest.setFecha_Mov(request.getFecha_Mov().substring(0,10));							
	
					
					
					String arreglo [];	
					String valor = "";
					
					for(byte numParametros = 0; numParametros < 7;  numParametros++ ){
						arreglo = request.getParametros().get(0).get(numParametros).toString().split("<");
						valor = arreglo[5].substring(10, arreglo[5].length());
													
						switch(numParametros) {
						 case 0: 
							 beanRequest.setDestinoCred(valor);
						     break;
						 case 1: 
							 beanRequest.setDispercion(valor);
						     break;
						 case 2: 
							 beanRequest.setTipoPago(valor);
							 break;
						 case 3: 
							 beanRequest.setNumCuota(valor);
						     break;
						 case 4:  
							 beanRequest.setPlazo(valor);
						     break;
						 case 5:  
							 beanRequest.setFecuenciaCap(valor);
						     break;
						 case 6:  
							 beanRequest.setFecuenciaInt(valor);
						     break;
						 }
													
					}
					
					
					beanRequest.setFolio_Pda(request.getFolio_Pda());
					beanRequest.setId_Usuario(request.getId_Usuario());
					beanRequest.setClave(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
					beanRequest.setDispositivo(request.getDispositivo());
					
					
					if(parametrosCajaBean.getVersionWS().equals(varYanga)){
						sp_PDA_Creditos_SolicitudResponse = sp_PDA_Creditos_Solicitud3ReyesServicio.solicitud(beanRequest);
					}
					else{

					if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
						sp_PDA_Creditos_SolicitudResponse = sp_PDA_Creditos_Solicitud3ReyesServicio.solicitud(beanRequest);

						}
					}
				}
				else{
					sp_PDA_Creditos_SolicitudResponse.setCodigoDesc("Transacción Rechazada");
					sp_PDA_Creditos_SolicitudResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
					sp_PDA_Creditos_SolicitudResponse.setEsValido("false");
					sp_PDA_Creditos_SolicitudResponse.setFolioSol(String.valueOf(Constantes.ENTERO_CERO));


					}
			
			} catch (Exception e) {		
				e.printStackTrace();
				System.out.println("ERROR" + " " + e );		
				sp_PDA_Creditos_SolicitudResponse.setCodigoDesc("Transacción Rechazada");
				sp_PDA_Creditos_SolicitudResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
				sp_PDA_Creditos_SolicitudResponse.setEsValido("false");
				sp_PDA_Creditos_SolicitudResponse.setFolioSol(String.valueOf(Constantes.ENTERO_CERO));

			}
			
			return sp_PDA_Creditos_SolicitudResponse;
		}// fin del metodo

		 
	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Creditos_Solicitud3ReyesRequest sp_PDA_Creditos_SolicitudRequest= (SP_PDA_Creditos_Solicitud3ReyesRequest)arg0; 			
		return SP_PDA_Creditos_Solicitud(sp_PDA_Creditos_SolicitudRequest);
		
	}

	public SP_PDA_Creditos_Solicitud3ReyesServicio getSp_PDA_Creditos_Solicitud3ReyesServicio() {
		return sp_PDA_Creditos_Solicitud3ReyesServicio;
	}

	public void setSp_PDA_Creditos_Solicitud3ReyesServicio(
			SP_PDA_Creditos_Solicitud3ReyesServicio sp_PDA_Creditos_Solicitud3ReyesServicio) {
		this.sp_PDA_Creditos_Solicitud3ReyesServicio = sp_PDA_Creditos_Solicitud3ReyesServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}
	
}
