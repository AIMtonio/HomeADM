package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaClienteResponse;
import operacionesVBC.dao.VbcAltaClienteDAO;
import general.servicio.BaseServicio;
import herramientas.OperacionesFechas;

public class VbcAltaClienteServicio extends BaseServicio{

	VbcAltaClienteDAO vbcAltaClienteDAO = null;
	public VbcAltaClienteServicio(){
		super();
	}
	
	public VbcAltaClienteResponse altaClienteServicio(VbcAltaClienteRequest request){
		VbcAltaClienteResponse mensaje = new VbcAltaClienteResponse();
		
		if (request.getClienteID().trim().isEmpty()){
			mensaje.setCodigoRespuesta("13");
			mensaje.setMensajeRespuesta("Especifique un Valor para el Cliente");
		}else if (!OperacionesFechas.validarFecha(request.getFechaNacimiento())){
			mensaje.setCodigoRespuesta("24");
			mensaje.setMensajeRespuesta("Formato de Fecha de Nacimiento Invalido.");
		}else if (request.getCurp().trim().length() > 18 ){
			mensaje.setCodigoRespuesta("14");
			mensaje.setMensajeRespuesta("La CURP debe tener como maximo 18 Caracteres");
		}else if (request.getRfc().trim().length() > 13 ){
			mensaje.setCodigoRespuesta("15");
			mensaje.setMensajeRespuesta("El RFC debe tener como maximo 13 Caracteres");
		}else{
			mensaje= vbcAltaClienteDAO.altaClienteWS(request);
		}
		return mensaje;
	}	
	
	public VbcAltaClienteResponse modificaClienteServicio(VbcAltaClienteRequest request){
		VbcAltaClienteResponse mensaje = new VbcAltaClienteResponse();;
		if (!OperacionesFechas.validarFecha(request.getFechaNacimiento())){
			mensaje.setCodigoRespuesta("24");
			mensaje.setMensajeRespuesta("Formato de Fecha de Nacimiento Invalido.");
		}else if (request.getCurp().trim().length() > 18 ){
			mensaje.setCodigoRespuesta("14");
			mensaje.setMensajeRespuesta("La CURP debe tener como maximo 18 Caracteres");
		}else{
		  mensaje= vbcAltaClienteDAO.modificaClienteWS(request);
		}
		return mensaje;
	}	
	

	public VbcAltaClienteDAO getVbcAltaClienteDAO() {
		return vbcAltaClienteDAO;
	}
	public void setVbcAltaClienteDAO(VbcAltaClienteDAO vbcAltaClienteDAO) {
		this.vbcAltaClienteDAO = vbcAltaClienteDAO;
	}
	
	
}
