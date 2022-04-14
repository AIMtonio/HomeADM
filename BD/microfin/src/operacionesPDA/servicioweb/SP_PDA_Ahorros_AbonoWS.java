package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_AbonoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_AbonoResponse;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_Retiro3ReyesResponse;
import operacionesPDA.servicio.SP_PDA_Ahorro_AbonoWSServicio;
import operacionesPDA.servicio.SP_PDA_Ahorro_AbonoWSServicio.Enum_Act_Pda_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class SP_PDA_Ahorros_AbonoWS  extends AbstractMarshallingPayloadEndpoint {
	SP_PDA_Ahorro_AbonoWSServicio sP_PDA_Ahorro_AbonoWSServicio = null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	public SP_PDA_Ahorros_AbonoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDA_Ahorros_AbonoResponse SP_PDA_Ahorros_Abono(SP_PDA_Ahorros_AbonoRequest request ){	
		SP_PDA_Ahorros_AbonoResponse  sP_PDA_Ahorros_AbonoResponse = new SP_PDA_Ahorros_AbonoResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sP_PDA_Ahorro_AbonoWSServicio.getsP_PDA_Ahorro_AbonoWSDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		SP_PDA_Ahorros_AbonoRequest beanRequest = new SP_PDA_Ahorros_AbonoRequest();
	
		  ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

			
	        parametrosCajaBean.setEmpresaID("1");
			parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
			
		/* Valida los datos del request y despues ejecuta la consulta */
		
		try {
			/*if(Integer.parseInt(request.getNum_Socio()) > 0	& Integer.parseInt(request.getNum_Cta()) > 0
				&	Double.parseDouble(request.getMonto()) > 0){*/
				/*campos = request.getFecha_Mov().substring(0, 10).split("/");
				strFecha = campos[2] + "-" + campos[1] + "-" + campos[0];	*/
								
						/* Settea los valores de la solicitud */
						beanRequest.setNum_Socio(request.getNum_Socio());
						beanRequest.setNum_Cta(request.getNum_Cta());
						beanRequest.setMonto(request.getMonto());
						beanRequest.setFecha_Mov(request.getFecha_Mov().substring(0,10));
						beanRequest.setFolio_Pda(request.getFolio_Pda());
						beanRequest.setId_Usuario(request.getId_Usuario());
						beanRequest.setClave(SeguridadRecursosServicio.encriptaPass(request.getId_Usuario(),request.getClave()));
						beanRequest.setDispositivo(request.getDispositivo());
						
						
						
						if(parametrosCajaBean.getVersionWS().equals(varYanga)){
							sP_PDA_Ahorros_AbonoResponse = sP_PDA_Ahorro_AbonoWSServicio.actualizacion(beanRequest, Enum_Act_Pda_WS.ahorroAbonoWSYanga);
						}
						else{

						if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
							sP_PDA_Ahorros_AbonoResponse = sP_PDA_Ahorro_AbonoWSServicio.actualizacion(beanRequest, Enum_Act_Pda_WS.ahorroAbonoWS3Reyes);

							}
						}		
		/*		}
				else{
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
					Date fecha = new Date();
					sP_PDA_Ahorros_AbonoResponse.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
					sP_PDA_Ahorros_AbonoResponse.setCodigoDesc("Transacción Rechazada");
					sP_PDA_Ahorros_AbonoResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
					sP_PDA_Ahorros_AbonoResponse.setEsValido("false");
					sP_PDA_Ahorros_AbonoResponse.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
					sP_PDA_Ahorros_AbonoResponse.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
					sP_PDA_Ahorros_AbonoResponse.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));
				}*/
		
		} catch (Exception e) {			
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
			Date fecha = new Date();
			sP_PDA_Ahorros_AbonoResponse.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
			sP_PDA_Ahorros_AbonoResponse.setCodigoDesc("Transacción Rechazada");
			sP_PDA_Ahorros_AbonoResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Ahorros_AbonoResponse.setEsValido("false");
			sP_PDA_Ahorros_AbonoResponse.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Ahorros_AbonoResponse.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Ahorros_AbonoResponse.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));
		}
		
				

		return sP_PDA_Ahorros_AbonoResponse;
	}// fin del metodo

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Ahorros_AbonoRequest AhorroAbonoRequest = (SP_PDA_Ahorros_AbonoRequest)arg0; 			
		return SP_PDA_Ahorros_Abono(AhorroAbonoRequest);
		
	}

	public SP_PDA_Ahorro_AbonoWSServicio getsP_PDA_Ahorro_AbonoWSServicio() {
		return sP_PDA_Ahorro_AbonoWSServicio;
	}
	public void setsP_PDA_Ahorro_AbonoWSServicio(
			SP_PDA_Ahorro_AbonoWSServicio sP_PDA_Ahorro_AbonoWSServicio) {
		this.sP_PDA_Ahorro_AbonoWSServicio = sP_PDA_Ahorro_AbonoWSServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}

