package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaAvalRequest;
import operacionesVBC.beanWS.response.VbcAltaAvalResponse;
import operacionesVBC.dao.VbcAltaAvalDAO;
import general.servicio.BaseServicio;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class VbcAltaAvalServicio extends BaseServicio{

	VbcAltaAvalDAO vbcAltaAvalDAO = null;
	public VbcAltaAvalServicio(){
		super();
	}
	
	public VbcAltaAvalResponse altaAval(VbcAltaAvalRequest request){
		VbcAltaAvalResponse mensaje= new VbcAltaAvalResponse();
		
		if (request.getTelefono().length()>13){
			mensaje.setCodigoRespuesta("30");
			mensaje.setMensajeRespuesta("El telefono debe tener como maximo 13 digitos");
		}else if (request.getTelefonoCel().length()>13){
			mensaje.setCodigoRespuesta("31");
			mensaje.setMensajeRespuesta("El telefono celular debe tener como maximo 13 digitos");
		}else if(request.getCalle().length()>50){
			mensaje.setCodigoRespuesta("33");
			mensaje.setMensajeRespuesta("La calle debe tener como maximo 50 digitos");
		}else if(!Utileria.esNumero(request.getCp() )){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("El Codigo Postal debe ser solo numeros");
		}else if(request.getCp().length()!=5){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("El codigo postal debe ser de 5 digitos");
		}else if(request.getRfc().length()>13){
			mensaje.setCodigoRespuesta("35");
			mensaje.setMensajeRespuesta("El RFC debe ser de 13 caracteres");
		}else if (!OperacionesFechas.validarFecha(request.getFechaNac())){
			mensaje.setCodigoRespuesta("36");
			mensaje.setMensajeRespuesta("Formato de Fecha de Nacimiento Invalido.");
		}else{
			mensaje= vbcAltaAvalDAO.altaAvalWs(request);
		}
		return mensaje;
	}

	public VbcAltaAvalDAO getVbcAltaAvalDAO() {
		return vbcAltaAvalDAO;
	}

	public void setVbcAltaAvalDAO(VbcAltaAvalDAO vbcAltaAvalDAO) {
		this.vbcAltaAvalDAO = vbcAltaAvalDAO;
	}
	
	
}