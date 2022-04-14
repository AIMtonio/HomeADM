package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaDirecClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaDirecClienteResponse;
import operacionesVBC.dao.VbcAltaDirecClienteDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class VbcAltaDirecClienteServicio extends BaseServicio{
	VbcAltaDirecClienteDAO vbcAltaDirecClienteDAO = null;
	public VbcAltaDirecClienteServicio(){
		super();
	}

	public VbcAltaDirecClienteResponse altaDireccionServicio(VbcAltaDirecClienteRequest request){
		VbcAltaDirecClienteResponse mensaje = new VbcAltaDirecClienteResponse();	
		if (request.getClienteID().trim().isEmpty()){
			mensaje.setCodigoRespuesta("13");
			mensaje.setMensajeRespuesta("Especifique un Valor para el Cliente");
		}else if(request.getCalle().length()>50){
			mensaje.setCodigoRespuesta("33");
			mensaje.setMensajeRespuesta("La calle debe tener como maximo 50 digitos");
		}else if(!Utileria.esNumero(request.getCp() )){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("El Codigo Postal debe ser solo numeros");
		}else if(request.getCp().length()!=5){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("Se requieren 05 Digitos para el Codigo Postal");
		}else{
		  mensaje= vbcAltaDirecClienteDAO.altaDireccionWS(request);
		}
		return mensaje;
	}	
	
	public VbcAltaDirecClienteResponse modificaDireccionServicio(VbcAltaDirecClienteRequest request){
		VbcAltaDirecClienteResponse mensaje = new VbcAltaDirecClienteResponse();
		if (request.getClienteID().trim().isEmpty()){
			mensaje.setCodigoRespuesta("13");
			mensaje.setMensajeRespuesta("Especifique un Valor para el Cliente");
		}else if(request.getCalle().length()>50){
			mensaje.setCodigoRespuesta("33");
			mensaje.setMensajeRespuesta("La calle debe tener como maximo 50 digitos");
		}else if(!Utileria.esNumero(request.getCp() )){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("El Codigo Postal debe ser solo numeros");
		}else if(request.getCp().length()!=5){
			mensaje.setCodigoRespuesta("34");
			mensaje.setMensajeRespuesta("Se requieren 05 Digitos para el Codigo Postal");
		}else{
		  mensaje= vbcAltaDirecClienteDAO.modificaDireccionWS(request);
		}
		return mensaje;
	}

	public VbcAltaDirecClienteDAO getVbcAltaDirecClienteDAO() {
		return vbcAltaDirecClienteDAO;
	}

	public void setVbcAltaDirecClienteDAO(
			VbcAltaDirecClienteDAO vbcAltaDirecClienteDAO) {
		this.vbcAltaDirecClienteDAO = vbcAltaDirecClienteDAO;
	}	

}
