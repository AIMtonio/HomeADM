package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.bean.RG_ListaClienteBean;
import operacionesCRCB.bean.RG_ListaCreditoBean;
import operacionesCRCB.beanWS.request.RompimientoGrupoRequest;
import operacionesCRCB.beanWS.response.RompimientoGrupoResponse;

public class RompimientoGrupoValidacion {

	RompimientoGrupoRequest rompimientoGrupoRequest = null;
	RompimientoGrupoResponse rompimientoGrupoResponse = null;

	// Método de Validación General
	public RompimientoGrupoResponse isRequestValid(RompimientoGrupoRequest request){
		this.rompimientoGrupoRequest = request;
		rompimientoGrupoResponse = new RompimientoGrupoResponse();

		if( isCreditoID() 	 && isGrupoIDValid() 	 && isNumCicloValid() 	&& isClienteIDValid() &&
			isUsuarioValid() && isDireccionIPValid() && isProgramaIDValid() && isSucursalValid()){
			rompimientoGrupoResponse.setCodigoRespuesta("0");
			rompimientoGrupoResponse.setMensajeRespuesta("Request válido");
		}
		return rompimientoGrupoResponse;
	}

	// Validación de CreditoID
	private boolean isCreditoID(){

		RG_ListaCreditoBean listaCreditos = rompimientoGrupoRequest.getCreditoID();
		
		if( listaCreditos.getCreditoID().size() == 0 || listaCreditos.getCreditoID().isEmpty() ) {
			rompimientoGrupoResponse.setCodigoRespuesta("1");
			rompimientoGrupoResponse.setMensajeRespuesta("La lista de Créditos esta Vacía.");
			return false;
		}
		
		return true;
	}

	// Validación de Grupo
	private boolean isGrupoIDValid(){
		if(rompimientoGrupoRequest.getGrupoID().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getGrupoID().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("2");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Grupo está vacío.");
			return false;
		}

		if(!Utileria.esNumero(rompimientoGrupoRequest.getGrupoID())){
			rompimientoGrupoResponse.setCodigoRespuesta("012");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Grupo es incorrecto.");
			return false;
		}
		
		return true;
	}

	// Validación de Ciclo
	private boolean isNumCicloValid(){
		if(rompimientoGrupoRequest.getNumCiclo().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getNumCiclo().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("3");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Ciclo está vacío.");
			return false;
		}

		if(!Utileria.esNumero(rompimientoGrupoRequest.getNumCiclo())){
			rompimientoGrupoResponse.setCodigoRespuesta("013");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Ciclo es incorrecto.");
			return false;
		}
		
		return true;
	}
	
	// Validación de ClienteID
	private boolean isClienteIDValid(){
		RG_ListaClienteBean listaClientes = rompimientoGrupoRequest.getClienteID();
		
		if( listaClientes.getClienteID().size() == 0 || listaClientes.getClienteID().isEmpty() ) {
			rompimientoGrupoResponse.setCodigoRespuesta("4");
			rompimientoGrupoResponse.setMensajeRespuesta("La lista de Clientes esta Vacía.");
			return false;
		}
		
		return true;
	}

	// Validación de Usuario
	private boolean isUsuarioValid(){
		if(rompimientoGrupoRequest.getUsuario().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getUsuario().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("8");
			rompimientoGrupoResponse.setMensajeRespuesta("El Usuario está vacío.");
			return false;
		}

		if(!Utileria.esNumero(rompimientoGrupoRequest.getUsuario())){
			rompimientoGrupoResponse.setCodigoRespuesta("18");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Usuario es incorrecto.");
			return false;
		}

		if(rompimientoGrupoRequest.getUsuario().length() > 5){
			rompimientoGrupoResponse.setCodigoRespuesta("28");
			rompimientoGrupoResponse.setMensajeRespuesta("El Número de Usuario es incorrecto.");
			return false;
		}
		
		return true;
	}

	// Validación de Dirección IP
	private boolean isDireccionIPValid(){
		if(rompimientoGrupoRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getDireccionIP().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("9");
			rompimientoGrupoResponse.setMensajeRespuesta("La Dirección IP está vacía");
			return false;
		}

		if(rompimientoGrupoRequest.getDireccionIP().length() > 15){
			rompimientoGrupoResponse.setCodigoRespuesta("19");
			rompimientoGrupoResponse.setMensajeRespuesta("La Dirección IP es incorrecta.");
			return false;
		}
		
		return true;
	}

	// Validación de Programa ID
	private boolean isProgramaIDValid(){
		if(rompimientoGrupoRequest.getProgramaID().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getProgramaID().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("10");
			rompimientoGrupoResponse.setMensajeRespuesta("El Programa ID está vacío.");
			return false;
		}

		if(rompimientoGrupoRequest.getProgramaID().length() > 50){
			rompimientoGrupoResponse.setCodigoRespuesta("20");
			rompimientoGrupoResponse.setMensajeRespuesta("El Programa ID es incorrecto.");
			return false;
		}
		
		return true;
	}

	// Validación de Sucursal
	private boolean isSucursalValid(){
		if(rompimientoGrupoRequest.getSucursal().equals(Constantes.STRING_VACIO) || rompimientoGrupoRequest.getSucursal().equals("?")){
			rompimientoGrupoResponse.setCodigoRespuesta("30");
			rompimientoGrupoResponse.setMensajeRespuesta("El número de Sucursal está vacío.");
			return false;
		}

		if(!Utileria.esNumero(rompimientoGrupoRequest.getSucursal())){
			rompimientoGrupoResponse.setCodigoRespuesta("31");
			rompimientoGrupoResponse.setMensajeRespuesta("El número de Sucursal es incorrecto.");
			return false;
		}

		if(rompimientoGrupoRequest.getSucursal().length() > 10){
			rompimientoGrupoResponse.setCodigoRespuesta("32");
			rompimientoGrupoResponse.setMensajeRespuesta("El número de Sucursal es incorrecto.");
			return false;
		}
		
		return true;
	}

}
