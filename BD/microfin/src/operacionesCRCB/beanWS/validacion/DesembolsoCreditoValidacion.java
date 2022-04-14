package operacionesCRCB.beanWS.validacion;
import java.util.regex.Pattern;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.DesembolsoCreditoRequest;
import operacionesCRCB.beanWS.response.DesembolsoCreditoResponse;

public class DesembolsoCreditoValidacion {

	private DesembolsoCreditoRequest desembolsoCreditoRequest = null;
	private DesembolsoCreditoResponse desembolsoCreditoResponse  = null;

	public boolean isCreditoIDValid(){
		if(desembolsoCreditoRequest.getGrupoID().equals(Constantes.STRING_CERO) & desembolsoCreditoRequest.getCreditoID().equals(Constantes.STRING_VACIO)
			|| desembolsoCreditoRequest.getCreditoID().equals("?")){

			desembolsoCreditoResponse.setCodigoRespuesta("20");
			desembolsoCreditoResponse.setMensajeRespuesta("El Número de Crédito está vacío");
			return false;
		}
		if (!Utileria.esLong(desembolsoCreditoRequest.getCreditoID())){
			desembolsoCreditoResponse.setCodigoRespuesta("400");
			desembolsoCreditoResponse.setMensajeRespuesta("El Número de Credito es Incorrecto.");
			return false;
		}
	return true;
	}

	public boolean isGrupoIDValid(){
		if(desembolsoCreditoRequest.getCreditoID().equals(Constantes.STRING_CERO) & desembolsoCreditoRequest.getGrupoID().equals(Constantes.STRING_VACIO)
			|| desembolsoCreditoRequest.getGrupoID().equals("?")){

			desembolsoCreditoResponse.setCodigoRespuesta("21");
			desembolsoCreditoResponse.setMensajeRespuesta("El Número de Grupo está vacío");
			return false;
		}
		if (!Utileria.esNumero(desembolsoCreditoRequest.getGrupoID())){
			desembolsoCreditoResponse.setCodigoRespuesta("400");
			desembolsoCreditoResponse.setMensajeRespuesta("El Número de Grupo es Incorrecto.");
			return false;
		}
	return true;
	}


	public boolean isUsuarioValid(){
		if(desembolsoCreditoRequest.getUsuario().equals(Constantes.STRING_VACIO) || desembolsoCreditoRequest.getUsuario().equals("?")){ 

		  desembolsoCreditoResponse.setCodigoRespuesta("901");
		  desembolsoCreditoResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
		  return false;
		}
		if (!Utileria.esNumero(desembolsoCreditoRequest.getUsuario())){
			desembolsoCreditoResponse.setCodigoRespuesta("901");
	    	desembolsoCreditoResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
			return false;
		}
	return true;
	}

	public boolean isDireccionIPValid(){
		if(desembolsoCreditoRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || desembolsoCreditoRequest.getDireccionIP().equals("?")){ 

		  desembolsoCreditoResponse.setCodigoRespuesta("902");
		  desembolsoCreditoResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
		  return false;
		}
	return true;
	}

	public boolean isProgramaIDValid(){
	if(desembolsoCreditoRequest.getProgramaID().equals(Constantes.STRING_VACIO) || desembolsoCreditoRequest.getProgramaID().equals("?")){  

		  desembolsoCreditoResponse.setCodigoRespuesta("903");
		  desembolsoCreditoResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
		  return false;
		}
	return true;
	}

	public boolean isSucursalValid(){
		if(desembolsoCreditoRequest.getSucursal().equals(Constantes.STRING_VACIO) || desembolsoCreditoRequest.getSucursal().equals("?")){  

			  desembolsoCreditoResponse.setCodigoRespuesta("904");
			  desembolsoCreditoResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
			  return false;
		}
		if (!Utileria.esNumero(desembolsoCreditoRequest.getSucursal())){
			desembolsoCreditoResponse.setCodigoRespuesta("904");
			desembolsoCreditoResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
			return false;
      	}
	return true;
	}

	public DesembolsoCreditoResponse isRequestValid(DesembolsoCreditoRequest desembolsoCreditoRequest){
	this.desembolsoCreditoRequest = desembolsoCreditoRequest;
	desembolsoCreditoResponse = new DesembolsoCreditoResponse();

	if(     isUsuarioValid()  &
			isDireccionIPValid()  &
			isProgramaIDValid()  &
			isSucursalValid()    &
			isCreditoIDValid()   &
			isGrupoIDValid()
			){
		desembolsoCreditoResponse.setCodigoRespuesta("0");
		desembolsoCreditoResponse.setMensajeRespuesta("Request valido");
	}

	return desembolsoCreditoResponse;
	}
		

	
}
