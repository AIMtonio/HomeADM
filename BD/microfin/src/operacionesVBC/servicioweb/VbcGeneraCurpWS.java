package operacionesVBC.servicioweb;

import herramientas.OperacionesFechas;
import operacionesVBC.beanWS.request.VbcGeneraCurpRequest;
import operacionesVBC.beanWS.response.VbcGeneraCurpResponse;
import operacionesVBC.servicio.VbcGeneraCurpServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;


public class VbcGeneraCurpWS extends AbstractMarshallingPayloadEndpoint {
	VbcGeneraCurpServicio vbcGeneraCurpServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcGeneraCurpWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private VbcGeneraCurpResponse generaCurpResponse(VbcGeneraCurpRequest generaCurpRequest){
		VbcGeneraCurpResponse generaCurpResponse = new VbcGeneraCurpResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcGeneraCurpServicio.getVbcGeneraCurpDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		generaCurpRequest.setClave(SeguridadRecursosServicio.encriptaPass(generaCurpRequest.getUsuario(), generaCurpRequest.getClave()));
		generaCurpRequest.setPrimerNombre(generaCurpRequest.getPrimerNombre().replace("?", ""));
		generaCurpRequest.setApellidoPaterno(generaCurpRequest.getApellidoPaterno().replace("?", ""));
		generaCurpRequest.setFechaNacimiento(generaCurpRequest.getFechaNacimiento().replace("?", ""));
		generaCurpRequest.setGenero(generaCurpRequest.getGenero().replace("?", ""));
		generaCurpRequest.setNacionalidad(generaCurpRequest.getNacionalidad().replace("?", ""));
		generaCurpRequest.setEstado(generaCurpRequest.getEstado().replace("?", ""));
		
		
		if (generaCurpRequest.getGenero().trim().toUpperCase().equals("M")){
			generaCurpRequest.setGenero("H");
		}
		if (generaCurpRequest.getGenero().trim().toUpperCase().equals("F")){
			generaCurpRequest.setGenero("M");
		} 
		if (generaCurpRequest.getPrimerNombre().isEmpty()){
			generaCurpResponse.setCodigoRespuesta("01");
			generaCurpResponse.setMensajeRespuesta("El Primer Nombre Esta Vacío.");
		}else if (generaCurpRequest.getApellidoPaterno().isEmpty()){
			generaCurpResponse.setCodigoRespuesta("02");
			generaCurpResponse.setMensajeRespuesta("El Apellido Paterno Esta Vacío.");
		}else if (generaCurpRequest.getFechaNacimiento().isEmpty()){
			generaCurpResponse.setCodigoRespuesta("03");
			generaCurpResponse.setMensajeRespuesta("La Fecha de Nacimiento esta Vacía.");
		}else if (!OperacionesFechas.validarFecha(generaCurpRequest.getFechaNacimiento())){
			generaCurpResponse.setCodigoRespuesta("07");
			generaCurpResponse.setMensajeRespuesta("Formato de Fecha Invalido. Verifique.");			
		}else if (generaCurpRequest.getGenero().isEmpty()){
			generaCurpResponse.setCodigoRespuesta("04");
			generaCurpResponse.setMensajeRespuesta("El Genero Esta Vacío.");
		}else if (generaCurpRequest.getGenero().trim().toUpperCase().equals("H") || generaCurpRequest.getGenero().trim().toUpperCase().equals("M")){
			if (generaCurpRequest.getNacionalidad().isEmpty()){
				generaCurpResponse.setCodigoRespuesta("05");
				generaCurpResponse.setMensajeRespuesta("La Nacionalidad Esta Vacía.");
			}else if(generaCurpRequest.getNacionalidad().trim().toUpperCase().equals("N") || generaCurpRequest.getNacionalidad().toUpperCase().trim().equals("E") ){
				if (generaCurpRequest.getNacionalidad().toUpperCase().equals("N") && generaCurpRequest.getEstado().isEmpty() ){
					generaCurpResponse.setCodigoRespuesta("06");
					generaCurpResponse.setMensajeRespuesta("La Entidad Federativa esta Vacía.");
				}else if (generaCurpRequest.getNacionalidad().toUpperCase().equals("N") && !generaCurpRequest.getEstado().isEmpty() ){
					try {
						Integer.parseInt(generaCurpRequest.getEstado());
						generaCurpResponse=vbcGeneraCurpServicio.generaCurpServicio(generaCurpRequest);
					} catch (NumberFormatException e){
						generaCurpResponse.setCodigoRespuesta("10");
						generaCurpResponse.setMensajeRespuesta("Valor Incorrecto para la Entidad Federativa.");
					}
				}else{
					if (generaCurpRequest.getNacionalidad().toUpperCase().equals("E")){
						generaCurpRequest.setEstado("0");
					}
					generaCurpResponse=vbcGeneraCurpServicio.generaCurpServicio(generaCurpRequest);
				}
			}else{
				generaCurpResponse.setCodigoRespuesta("09");
				generaCurpResponse.setMensajeRespuesta("Caracter Incorrecto para la Nacionalidad.");
			}
		}else {
			generaCurpResponse.setCodigoRespuesta("08");
			generaCurpResponse.setMensajeRespuesta("Caracter Incorrecto para el Genero.");
		}
		return generaCurpResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		// TODO Auto-generated method stub
		VbcGeneraCurpRequest generaCurpRequest = (VbcGeneraCurpRequest)arg0;
		return generaCurpResponse(generaCurpRequest);
	}

	public VbcGeneraCurpServicio getVbcGeneraCurpServicio() {
		return vbcGeneraCurpServicio;
	}

	public void setVbcGeneraCurpServicio(VbcGeneraCurpServicio vbcGeneraCurpServicio) {
		this.vbcGeneraCurpServicio = vbcGeneraCurpServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
}
