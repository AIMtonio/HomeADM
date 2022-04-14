package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaReferenciaRequest;
import operacionesVBC.beanWS.response.VbcAltaReferenciaResponse;
import operacionesVBC.dao.VbcAltaReferenciaDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class VbcAltaReferenciaServicio extends BaseServicio{

	VbcAltaReferenciaDAO vbcAltaReferenciaDAO = null;
	public VbcAltaReferenciaServicio(){
		super();
	}
	
	public VbcAltaReferenciaResponse altaModificaReferencia(VbcAltaReferenciaRequest request){
		VbcAltaReferenciaResponse mensaje = new VbcAltaReferenciaResponse();
		if (request.getTelefono().length()>13){
			mensaje.setCodigoRespuesta("30");
			mensaje.setMensajeRespuesta("El telefono debe tener como maximo 13 digitos");
		}else if(!Utileria.esNumero(request.getCp() )){
			mensaje.setCodigoRespuesta("32");
			mensaje.setMensajeRespuesta("El Codigo Postal debe ser solo numeros");			
		}else if(request.getCp().length()!=5){
			mensaje.setCodigoRespuesta("32");
			mensaje.setMensajeRespuesta("El codigo postal debe ser de 5 digitos");
		}else if(request.getCalle().length()>50){
			mensaje.setCodigoRespuesta("33");
			mensaje.setMensajeRespuesta("La calle debe tener como maximo 50 digitos");
		}else{
			mensaje= vbcAltaReferenciaDAO.procesoReferencia(request);
		}
		return mensaje;
	}

	public VbcAltaReferenciaDAO getVbcAltaReferenciaDAO() {
		return vbcAltaReferenciaDAO;
	}

	public void setVbcAltaReferenciaDAO(VbcAltaReferenciaDAO vbcAltaReferenciaDAO) {
		this.vbcAltaReferenciaDAO = vbcAltaReferenciaDAO;
	}
	
	
}