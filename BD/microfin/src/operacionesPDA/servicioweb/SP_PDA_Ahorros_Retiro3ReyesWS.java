package operacionesPDA.servicioweb;

import herramientas.Constantes;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_Retiro3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_Retiro3ReyesResponse;
import operacionesPDA.servicio.SP_PDA_Ahorros_Retiro3ReyesServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;


public class SP_PDA_Ahorros_Retiro3ReyesWS extends AbstractMarshallingPayloadEndpoint{
	SP_PDA_Ahorros_Retiro3ReyesServicio sp_PDA_Ahorro_Retiro3ReyesServicio = null;
	
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varYanga = "YANGA";
	String var3Reyes = "3 REYES";
	
	public SP_PDA_Ahorros_Retiro3ReyesWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDA_Ahorros_Retiro3ReyesResponse SP_PDA_Ahorros_Retiro(SP_PDA_Ahorros_Retiro3ReyesRequest request ){	
		SP_PDA_Ahorros_Retiro3ReyesResponse  sP_PDA_Ahorros_Retiro3ReyesResponse = new SP_PDA_Ahorros_Retiro3ReyesResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		sp_PDA_Ahorro_Retiro3ReyesServicio.getSp_PDA_Ahorros_Retiro3ReyesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		SP_PDA_Ahorros_Retiro3ReyesRequest beanRequest = new SP_PDA_Ahorros_Retiro3ReyesRequest();
      
	   ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

		
        parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
	
	
		/* Valida los datos del request y despues ejecuta la consulta */
		
		try {
					
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
							sP_PDA_Ahorros_Retiro3ReyesResponse  = (SP_PDA_Ahorros_Retiro3ReyesResponse) sp_PDA_Ahorro_Retiro3ReyesServicio.retiro(beanRequest);
						}
						else{

						if(parametrosCajaBean.getVersionWS().equals(var3Reyes)){
							sP_PDA_Ahorros_Retiro3ReyesResponse  = (SP_PDA_Ahorros_Retiro3ReyesResponse) sp_PDA_Ahorro_Retiro3ReyesServicio.retiro(beanRequest);

							}
						}				

		
		} catch (Exception e) {			
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
			Date fecha = new Date();
			sP_PDA_Ahorros_Retiro3ReyesResponse.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Ahorros_Retiro3ReyesResponse.setCodigoDesc("Transacción Rechazada");
			sP_PDA_Ahorros_Retiro3ReyesResponse.setEsValido("false");
			sP_PDA_Ahorros_Retiro3ReyesResponse.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
			sP_PDA_Ahorros_Retiro3ReyesResponse.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
			sP_PDA_Ahorros_Retiro3ReyesResponse.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));
			sP_PDA_Ahorros_Retiro3ReyesResponse.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
		}
		
				

		return sP_PDA_Ahorros_Retiro3ReyesResponse;
	}// fin del metodo

	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDA_Ahorros_Retiro3ReyesRequest AhorroRetiroRequest = (SP_PDA_Ahorros_Retiro3ReyesRequest)arg0; 			
		return SP_PDA_Ahorros_Retiro(AhorroRetiroRequest);
		
	}

	public SP_PDA_Ahorros_Retiro3ReyesServicio getSp_PDA_Ahorro_Retiro3ReyesServicio() {
		return sp_PDA_Ahorro_Retiro3ReyesServicio;
	}

	public void setSp_PDA_Ahorro_Retiro3ReyesServicio(
			SP_PDA_Ahorros_Retiro3ReyesServicio sp_PDA_Ahorro_Retiro3ReyesServicio) {
		this.sp_PDA_Ahorro_Retiro3ReyesServicio = sp_PDA_Ahorro_Retiro3ReyesServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

}
