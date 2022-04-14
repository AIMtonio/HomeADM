package operacionesPDA.servicioweb;

import java.util.regex.Pattern;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_ConsultaSaldoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_ConsultaSaldoResponse;
import operacionesPDA.servicio.SP_PDA_Ahorros_ConsultaSaldoServicio;

import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;

public class SP_PDA_Ahorros_ConsultaSaldoWS extends AbstractMarshallingPayloadEndpoint {
   public SP_PDA_Ahorros_ConsultaSaldoServicio consultaSaldoServicio=null;
	
	
	public SP_PDA_Ahorros_ConsultaSaldoWS(Marshaller marshaller){
		super(marshaller);
	}
	

    
	private SP_PDA_Ahorros_ConsultaSaldoResponse consultaSaldoResponse(SP_PDA_Ahorros_ConsultaSaldoRequest request){
		SP_PDA_Ahorros_ConsultaSaldoResponse consultaSaldoResponse = new SP_PDA_Ahorros_ConsultaSaldoResponse();
		SP_PDA_Ahorros_ConsultaSaldoRequest beanRequest= new SP_PDA_Ahorros_ConsultaSaldoRequest();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		consultaSaldoServicio.getsP_PDA_Ahorros_ConsultaSaldoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		
		try{
		
			//Validar que no este vacio el Campo
			if(request.getCuentaAltaID().isEmpty()){
				System.out.println("Entre al vacio");
				consultaSaldoResponse.setCelular(String.valueOf(Constantes.STRING_VACIO));
				consultaSaldoResponse.setDescripTipoCuenta(String.valueOf(Constantes.STRING_VACIO));
				consultaSaldoResponse.setSaldoDisp(String.valueOf(Constantes.STRING_VACIO));
				consultaSaldoResponse.setCodigoRespuesta("1");
				consultaSaldoResponse.setMensajeRespuesta("El numero de Cuenta esta Vacio.");
				
			}

			else{
				String variable=request.getCuentaAltaID().replace(" ","");
				boolean b = Pattern.matches("^\\d+$",variable);
		        if(b){
					 beanRequest.setCuentaAltaID(variable);
					 consultaSaldoResponse=consultaSaldoServicio.consultaSaldoServicio(beanRequest);		            
		        }else{
		        	consultaSaldoResponse.setCelular(String.valueOf(Constantes.STRING_VACIO));
					consultaSaldoResponse.setDescripTipoCuenta(String.valueOf(Constantes.STRING_VACIO));
					consultaSaldoResponse.setSaldoDisp(String.valueOf(Constantes.STRING_VACIO));
		        	consultaSaldoResponse.setCodigoRespuesta("2");
					consultaSaldoResponse.setMensajeRespuesta("El numero de Cuenta no existe.");
		        }
		        
		      }
			 
			
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("ERROR FATAL..");
			consultaSaldoResponse.setCelular(String.valueOf(Constantes.STRING_VACIO));
			consultaSaldoResponse.setDescripTipoCuenta(String.valueOf(Constantes.STRING_VACIO));
			consultaSaldoResponse.setSaldoDisp(String.valueOf(Constantes.STRING_VACIO));
			
		}
		
		return consultaSaldoResponse;
	}
	

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Ahorros_ConsultaSaldoRequest consultaSaldoRequest=(SP_PDA_Ahorros_ConsultaSaldoRequest)arg0;
		return consultaSaldoResponse(consultaSaldoRequest);
	}
	
	public SP_PDA_Ahorros_ConsultaSaldoServicio getConsultaSaldoServicio() {
		return consultaSaldoServicio;
	}
	public void setConsultaSaldoServicio(
			SP_PDA_Ahorros_ConsultaSaldoServicio consultaSaldoServicio) {
		this.consultaSaldoServicio = consultaSaldoServicio;
	}

}
