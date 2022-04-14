package nomina.servicioweb;

import herramientas.Constantes;
import nomina.beanWS.request.ConsultaCorreoInstitRequest;
import nomina.beanWS.response.ConsultaCorreoInstitResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;
import nomina.servicio.PagoNominaServicio.Enum_Con_PagoNomina;

public class ConsultaCorreoInstitWS extends AbstractMarshallingPayloadEndpoint {
	PagoNominaServicio pagoNominaServicio = null;
 
	public ConsultaCorreoInstitWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaCorreoInstitResponse consultaCorreoInstitucion(ConsultaCorreoInstitRequest consultaCorreoInstitRequest){
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		pagoNominaServicio.getPagoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		ConsultaCorreoInstitResponse consultaCorreoInstitResponse = new ConsultaCorreoInstitResponse();
		PagoNominaBean pagosNominaBean = new PagoNominaBean();
		
		pagosNominaBean.setInstitNominaID(consultaCorreoInstitRequest.getInstitNominaID());
		
		try{
			if(Integer.parseInt(pagosNominaBean.getInstitNominaID())!=0){
				pagosNominaBean = pagoNominaServicio.consulta(Enum_Con_PagoNomina.conCorreoInstit, pagosNominaBean);
				if(pagosNominaBean != null){
					consultaCorreoInstitResponse.setCodigoRespuesta("00");
					consultaCorreoInstitResponse.setMensajeRespuesta("Consulta Exitosa");
					consultaCorreoInstitResponse.setCorreoElectronico(pagosNominaBean.getCorreoElectronico());
				}else{
					consultaCorreoInstitResponse.setCodigoRespuesta("03");
					consultaCorreoInstitResponse.setMensajeRespuesta("El Número de Institución no Existe");
					consultaCorreoInstitResponse.setCorreoElectronico(Constantes.STRING_CERO);
				}
			}else{
				consultaCorreoInstitResponse.setCodigoRespuesta("01");
				consultaCorreoInstitResponse.setMensajeRespuesta("El Número de Institución es Requerido");
				consultaCorreoInstitResponse.setCorreoElectronico(Constantes.STRING_CERO);
			}
	
			}catch(NumberFormatException e)	{
				consultaCorreoInstitResponse.setCodigoRespuesta("02");
				consultaCorreoInstitResponse.setMensajeRespuesta("Ingresar Sólo Números");
				consultaCorreoInstitResponse.setCorreoElectronico(Constantes.STRING_CERO);
				}		
		return consultaCorreoInstitResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCorreoInstitRequest consultaCorreoInstitRequest = (ConsultaCorreoInstitRequest)arg0; 							
		return consultaCorreoInstitucion(consultaCorreoInstitRequest);

	}
	/* declaracion de getter y setter */

	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}

	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
	}

}
