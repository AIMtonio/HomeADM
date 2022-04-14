package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAltaIdentificaCteRequest;
import operacionesVBC.beanWS.response.VbcAltaIdentificaCteResponse;
import operacionesVBC.dao.VbcAltaIdentificaCteDAO;
import general.servicio.BaseServicio;
import herramientas.OperacionesFechas;

public class VbcAltaIdentificaCteServicio extends BaseServicio{
	VbcAltaIdentificaCteDAO vbcAltaIdentificaCteDAO = null;
	public VbcAltaIdentificaCteServicio(){
		super();
	}

	public VbcAltaIdentificaCteResponse altaIdentificaServicio(VbcAltaIdentificaCteRequest request){
		VbcAltaIdentificaCteResponse mensaje= new VbcAltaIdentificaCteResponse();
		if(request.getFecExIden().isEmpty()){
			request.setFecExIden("1900-01-01");
		}
		if(request.getFecVenIden().isEmpty()){
			request.setFecVenIden("1900-01-01");
		}
		if(request.getClienteID().isEmpty()){
			mensaje.setCodigoRespuesta("13");
			mensaje.setMensajeRespuesta("Especifique un Valor para el Cliente");
		}else if (request.getIdentificaID().isEmpty()){
			mensaje.setCodigoRespuesta("04");
			mensaje.setMensajeRespuesta("El Id de la Identificacion esta Vacio.");
		}else if(request.getTipoIdentiID().isEmpty()){
			mensaje.setCodigoRespuesta("05");
			mensaje.setMensajeRespuesta("El Tipo de Identificacion esta Vacio.");
		}else if(request.getNumIdentifica().isEmpty()){
			mensaje.setCodigoRespuesta("03");
			mensaje.setMensajeRespuesta("El Numero de Identificacion esta Vacio.");
		}else if (!OperacionesFechas.validarFecha(request.getFecExIden())){
			mensaje.setCodigoRespuesta("06");
			mensaje.setMensajeRespuesta("Formato de Fecha de Expedicion Invalido.");
		}else if (!OperacionesFechas.validarFecha(request.getFecVenIden())){
			mensaje.setCodigoRespuesta("06");
			mensaje.setMensajeRespuesta("Formato de Fecha de Vencimiento Invalido.");
		}else{
			mensaje= vbcAltaIdentificaCteDAO.altaIdentificacionWS(request);
		}
		return mensaje;
	}	

	public VbcAltaIdentificaCteResponse modificaIdentificaServicio(VbcAltaIdentificaCteRequest request){
		VbcAltaIdentificaCteResponse mensaje = new VbcAltaIdentificaCteResponse();
		if(request.getFecExIden().isEmpty()){
			request.setFecExIden("1900-01-01");
		}
		if(request.getFecVenIden().isEmpty()){
			request.setFecVenIden("1900-01-01");
		}
		if(request.getClienteID().isEmpty()){
			mensaje.setCodigoRespuesta("13");
			mensaje.setMensajeRespuesta("Especifique un Valor para el Cliente");
		}else if (request.getIdentificaID().isEmpty()){
			mensaje.setCodigoRespuesta("04");
			mensaje.setMensajeRespuesta("El Id de la Identificacion esta Vacio.");
		}else if(request.getTipoIdentiID().isEmpty()){
			mensaje.setCodigoRespuesta("05");
			mensaje.setMensajeRespuesta("El Tipo de Identificacion esta Vacio.");
		}else if(request.getNumIdentifica().isEmpty()){
			mensaje.setCodigoRespuesta("03");
			mensaje.setMensajeRespuesta("El Numero de Identificacion esta Vacio.");
		}else if (!OperacionesFechas.validarFecha(request.getFecExIden())){
			mensaje.setCodigoRespuesta("06");
			mensaje.setMensajeRespuesta("Formato de Fecha de Expedicion Invalido.");
		}else if (!OperacionesFechas.validarFecha(request.getFecVenIden())){
			mensaje.setCodigoRespuesta("06");
			mensaje.setMensajeRespuesta("Formato de Fecha de Vencimiento Invalido.");
		}else{			
			mensaje= vbcAltaIdentificaCteDAO.modificaIdentificacionWS(request);
		}
		return mensaje;
	}

	public VbcAltaIdentificaCteDAO getVbcAltaIdentificaCteDAO() {
		return vbcAltaIdentificaCteDAO;
	}

	public void setVbcAltaIdentificaCteDAO(
			VbcAltaIdentificaCteDAO vbcAltaIdentificaCteDAO) {
		this.vbcAltaIdentificaCteDAO = vbcAltaIdentificaCteDAO;
	}	
	

}
