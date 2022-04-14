package operacionesPDM.servicioweb;

import herramientas.Constantes;

import java.util.regex.Pattern;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaSaldoRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaSaldoResponse;
import operacionesPDM.servicio.SP_PDM_Ahorros_ConsultaSaldoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;

public class SP_PDM_Ahorros_ConsultaSaldoWS  extends AbstractMarshallingPayloadEndpoint {
	
	public SP_PDM_Ahorros_ConsultaSaldoServicio consultaSaldoCtaServicio = null;
	
	public SP_PDM_Ahorros_ConsultaSaldoWS(Marshaller marshaller){
		super(marshaller);
	}
	
	private SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoResponse(SP_PDM_Ahorros_ConsultaSaldoRequest request){		
		SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoResponse = new SP_PDM_Ahorros_ConsultaSaldoResponse();
		SP_PDM_Ahorros_ConsultaSaldoRequest beanRequest= new SP_PDM_Ahorros_ConsultaSaldoRequest();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		consultaSaldoCtaServicio.getSP_PDM_Ahorros_ConsultaSaldoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		try{
			
			//Validar que no este vacio el Campo
			if(request.getCuentaID().isEmpty()){				
				consultaSaldoResponse.setCodigoRespuesta("1");
				consultaSaldoResponse.setMensajeRespuesta("El numero de Cuenta esta Vacio.");				
			}else{
				String variable=request.getCuentaID().replace(" ","");
				boolean b = Pattern.matches("^\\d+$",variable);
		        if(b){
		        	      	
		        	SP_PDM_Ahorros_ConsultaSaldoResponse mensaje = new SP_PDM_Ahorros_ConsultaSaldoResponse();
					beanRequest.setCuentaID(variable);
					mensaje = consultaSaldoCtaServicio.consultaSaldoServicio(beanRequest);	
					 
					if(!mensaje.getCodigoRespuesta().equals("0")){
					 
						consultaSaldoResponse.setCodigoRespuesta(mensaje.getCodigoRespuesta());
						consultaSaldoResponse.setMensajeRespuesta(mensaje.getMensajeRespuesta());
						throw new Exception(mensaje.getMensajeRespuesta());						 
					 
					}else{
						
						consultaSaldoResponse.setDescripTipoCuenta(mensaje.getDescripTipoCuenta());
						consultaSaldoResponse.setSaldoDisp(mensaje.getSaldoDisp());
						consultaSaldoResponse.setCelular(mensaje.getCelular());
						consultaSaldoResponse.setCodigoRespuesta(mensaje.getCodigoRespuesta());
						consultaSaldoResponse.setMensajeRespuesta(mensaje.getMensajeRespuesta());
						
					}					 
					 
		        }else{
		        	
		        	consultaSaldoResponse.setCodigoRespuesta("2");
					consultaSaldoResponse.setMensajeRespuesta("El numero de Cuenta no existe.");
					throw new Exception("El numero de Cuenta no existe.");		
		        }
		        
			}			 
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(consultaSaldoResponse.getCodigoRespuesta().isEmpty() || consultaSaldoResponse.getCodigoRespuesta().equals("0")){				
				consultaSaldoResponse.setCodigoRespuesta("999");
				consultaSaldoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CUENTASAHOCON");
			}			
			
		}
		
		return consultaSaldoResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDM_Ahorros_ConsultaSaldoRequest consultaSaldoRequest=(SP_PDM_Ahorros_ConsultaSaldoRequest)arg0;
		return consultaSaldoResponse(consultaSaldoRequest);
	}
	

	public SP_PDM_Ahorros_ConsultaSaldoServicio getConsultaSaldoCtaServicio() {
		return consultaSaldoCtaServicio;
	}
	public void setConsultaSaldoCtaServicio(SP_PDM_Ahorros_ConsultaSaldoServicio consultaSaldoCtaServicio) {
		this.consultaSaldoCtaServicio = consultaSaldoCtaServicio;
	}

}
