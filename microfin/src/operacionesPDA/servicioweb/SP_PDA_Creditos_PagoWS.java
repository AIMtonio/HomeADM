package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Creditos_PagoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_PagoResponse;
import operacionesPDA.servicio.SP_PDA_Creditos_PagoServicio;
import operacionesPDA.servicio.SP_PDA_Creditos_PagoServicio.Enum_Act_Pda_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class SP_PDA_Creditos_PagoWS  extends AbstractMarshallingPayloadEndpoint {
	SP_PDA_Creditos_PagoServicio sP_PDA_Creditos_PagoServicio = null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	
	public SP_PDA_Creditos_PagoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDA_Creditos_PagoResponse SP_PDA_Creditos_Pago(SP_PDA_Creditos_PagoRequest sP_PDA_Creditos_PagoRequest ){	
		SP_PDA_Creditos_PagoResponse  sP_PDA_Creditos_PagoResponse = new SP_PDA_Creditos_PagoResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sP_PDA_Creditos_PagoServicio.getSP_PDA_Creditos_PagoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		  ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

	        parametrosCajaBean.setEmpresaID("1");
			parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
			
		
		String strFecha; 
		String [] campos;
		
		/* Valida los datos del request y despues ejecuta la consulta */
		
		try {
			
					sP_PDA_Creditos_PagoRequest.setClave(SeguridadRecursosServicio.encriptaPass(sP_PDA_Creditos_PagoRequest.getId_Usuario(),sP_PDA_Creditos_PagoRequest.getClave()));
					

					if(parametrosCajaBean.getVersionWS().equals(varYanga)){
						sP_PDA_Creditos_PagoResponse = sP_PDA_Creditos_PagoServicio.pagoCreditoWS(sP_PDA_Creditos_PagoRequest,Enum_Act_Pda_WS.pagoCredWSYanga);
					}
					else{

					if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
						sP_PDA_Creditos_PagoResponse = sP_PDA_Creditos_PagoServicio.pagoCreditoWS(sP_PDA_Creditos_PagoRequest,Enum_Act_Pda_WS.pagoCredWSWS3Reyes);

						}
					}	
					
					
					if(Integer.parseInt(sP_PDA_Creditos_PagoResponse.getCodigoResp())==1){
						sP_PDA_Creditos_PagoResponse.setCodigoDesc("Transacción Aceptada");
					}else{
						throw new Exception("Transacción Rechazada");
					}
			
		
		
		} catch (Exception e) {			
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
			Date fecha = new Date();
			sP_PDA_Creditos_PagoResponse.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
			sP_PDA_Creditos_PagoResponse.setCodigoDesc("Transacción Rechazada");
			sP_PDA_Creditos_PagoResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Creditos_PagoResponse.setEsValido("false");
			sP_PDA_Creditos_PagoResponse.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Creditos_PagoResponse.setSaldo(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Creditos_PagoResponse.setCapitalPagado(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Creditos_PagoResponse.setIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Creditos_PagoResponse.setIvaIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Creditos_PagoResponse.setIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Creditos_PagoResponse.setIvaIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
			e.printStackTrace();
		}
		return sP_PDA_Creditos_PagoResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Creditos_PagoRequest CreditoPagoRequest = (SP_PDA_Creditos_PagoRequest)arg0; 			
		return SP_PDA_Creditos_Pago(CreditoPagoRequest);
		
	}

	public SP_PDA_Creditos_PagoServicio getsP_PDA_Creditos_PagoServicio() {
		return sP_PDA_Creditos_PagoServicio;
	}

	public void setsP_PDA_Creditos_PagoServicio(
			SP_PDA_Creditos_PagoServicio sP_PDA_Creditos_PagoServicio) {
		this.sP_PDA_Creditos_PagoServicio = sP_PDA_Creditos_PagoServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}

