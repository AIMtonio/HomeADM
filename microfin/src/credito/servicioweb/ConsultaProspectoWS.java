package credito.servicioweb;


import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.ProspectosBean;
import credito.beanWS.request.ConsultaProspectoRequest;
import credito.beanWS.response.ConsultaProspectoResponse;
import credito.servicio.ProspectosServicio;


public class ConsultaProspectoWS extends AbstractMarshallingPayloadEndpoint{
	ProspectosServicio prospectosServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		
	public ConsultaProspectoWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	private ConsultaProspectoResponse consultaProspecto(ConsultaProspectoRequest consultaProspectoRequest){
		ProspectosBean prospectosBean = new ProspectosBean();
		ConsultaProspectoResponse consultaProspectoResponse = new ConsultaProspectoResponse();
		
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		prospectosBean.setProspectoID(consultaProspectoRequest.getProspectoID());
		prospectosBean.setInstitucionNominaID(consultaProspectoRequest.getInstitNominaID());
		
		try{
			if(Integer.parseInt(prospectosBean.getProspectoID())!=0 || Integer.parseInt(prospectosBean.getInstitucionNominaID())!=0){
				prospectosBean = prospectosServicio.consultaWS(ProspectosServicio.Enum_Con_ProspectoWS.principal,prospectosBean);
				if(prospectosBean != null){
					consultaProspectoResponse.setCodigoRespuesta("00");
					consultaProspectoResponse.setMensajeRespuesta("Consulta Exitosa");
					consultaProspectoResponse.setProspectoID(prospectosBean.getProspectoID());
					consultaProspectoResponse.setPrimerNombre(prospectosBean.getPrimerNombre());
					consultaProspectoResponse.setSegundoNombre(prospectosBean.getSegundoNombre());
					consultaProspectoResponse.setTercerNombre(prospectosBean.getTercerNombre());
					consultaProspectoResponse.setApellidoPaterno(prospectosBean.getApellidoPaterno());

					consultaProspectoResponse.setApellidoMaterno(prospectosBean.getApellidoMaterno());
					consultaProspectoResponse.setTipoPersona(prospectosBean.getTipoPersona());
					consultaProspectoResponse.setFechaNacimiento(prospectosBean.getFechaNacimiento());
					consultaProspectoResponse.setRFC(prospectosBean.getRFC());
					consultaProspectoResponse.setSexo(prospectosBean.getSexo());
					
					consultaProspectoResponse.setEstadoCivil(prospectosBean.getEstadoCivil());
					consultaProspectoResponse.setTelefono(prospectosBean.getTelefono());
					consultaProspectoResponse.setRazonSocial(prospectosBean.getRazonSocial());
					consultaProspectoResponse.setEstadoID(prospectosBean.getEstadoID());
					consultaProspectoResponse.setMunicipioID(prospectosBean.getMunicipioID());
					
					consultaProspectoResponse.setLocalidadID(prospectosBean.getLocalidadID());
					consultaProspectoResponse.setColoniaID(prospectosBean.getColoniaID());
					consultaProspectoResponse.setCalle(prospectosBean.getCalle());
					consultaProspectoResponse.setNumExterior(prospectosBean.getNumExterior());
					consultaProspectoResponse.setNumInterior(prospectosBean.getNumInterior());
					
					consultaProspectoResponse.setCP(prospectosBean.getCP());
					consultaProspectoResponse.setManzana(prospectosBean.getManzana());
					consultaProspectoResponse.setLote(prospectosBean.getLote());
					consultaProspectoResponse.setLatitud(prospectosBean.getLatitud());
					consultaProspectoResponse.setLongitud(prospectosBean.getLongitud());
					
					consultaProspectoResponse.setTipoDireccionID(prospectosBean.getTipoDireccionID());
					consultaProspectoResponse.setCalificaProspecto(prospectosBean.getCalificaProspectos());
				}
				else{
					consultaProspectoResponse.setCodigoRespuesta("02");
					consultaProspectoResponse.setMensajeRespuesta("El Número de Institucion no Corresponde al Prospecto Indicado");
					consultaProspectoResponse.setProspectoID(Constantes.STRING_CERO);
					consultaProspectoResponse.setPrimerNombre(Constantes.STRING_VACIO);
					consultaProspectoResponse.setSegundoNombre(Constantes.STRING_VACIO);
					consultaProspectoResponse.setTercerNombre(Constantes.STRING_VACIO);
					consultaProspectoResponse.setApellidoPaterno(Constantes.STRING_VACIO);

					consultaProspectoResponse.setApellidoMaterno(Constantes.STRING_VACIO);
					consultaProspectoResponse.setTipoPersona(Constantes.STRING_VACIO);
					consultaProspectoResponse.setFechaNacimiento(Constantes.STRING_VACIO);
					consultaProspectoResponse.setRFC(Constantes.STRING_VACIO);
					consultaProspectoResponse.setSexo(Constantes.STRING_VACIO);
					
					consultaProspectoResponse.setEstadoCivil(Constantes.STRING_VACIO);
					consultaProspectoResponse.setTelefono(Constantes.STRING_CERO);
					consultaProspectoResponse.setRazonSocial(Constantes.STRING_VACIO);
					consultaProspectoResponse.setEstadoID(Constantes.STRING_CERO);
					consultaProspectoResponse.setMunicipioID(Constantes.STRING_CERO);
					
					consultaProspectoResponse.setLocalidadID(Constantes.STRING_CERO);
					consultaProspectoResponse.setColoniaID(Constantes.STRING_CERO);
					consultaProspectoResponse.setCalle(Constantes.STRING_CERO);
					consultaProspectoResponse.setNumExterior(Constantes.STRING_CERO);
					consultaProspectoResponse.setNumInterior(Constantes.STRING_CERO);
					
					consultaProspectoResponse.setCP(Constantes.STRING_CERO);
					consultaProspectoResponse.setManzana(Constantes.STRING_CERO);
					consultaProspectoResponse.setLote(Constantes.STRING_CERO);
					consultaProspectoResponse.setLatitud(Constantes.STRING_CERO);
					consultaProspectoResponse.setLongitud(Constantes.STRING_CERO);
					
					consultaProspectoResponse.setTipoDireccionID(Constantes.STRING_CERO);
					consultaProspectoResponse.setCalificaProspecto(Constantes.STRING_CERO);
				}
			  }
			}catch(NumberFormatException e)	{
				consultaProspectoResponse.setCodigoRespuesta("04");
				consultaProspectoResponse.setMensajeRespuesta("Ingresar Sólo Números");
				consultaProspectoResponse.setProspectoID(Constantes.STRING_CERO);
				consultaProspectoResponse.setPrimerNombre(Constantes.STRING_VACIO);
				consultaProspectoResponse.setSegundoNombre(Constantes.STRING_VACIO);
				consultaProspectoResponse.setTercerNombre(Constantes.STRING_VACIO);
				consultaProspectoResponse.setApellidoPaterno(Constantes.STRING_VACIO);

				consultaProspectoResponse.setApellidoMaterno(Constantes.STRING_VACIO);
				consultaProspectoResponse.setTipoPersona(Constantes.STRING_VACIO);
				consultaProspectoResponse.setFechaNacimiento(Constantes.STRING_VACIO);
				consultaProspectoResponse.setRFC(Constantes.STRING_VACIO);
				consultaProspectoResponse.setSexo(Constantes.STRING_VACIO);
				
				consultaProspectoResponse.setEstadoCivil(Constantes.STRING_VACIO);
				consultaProspectoResponse.setTelefono(Constantes.STRING_CERO);
				consultaProspectoResponse.setRazonSocial(Constantes.STRING_VACIO);
				consultaProspectoResponse.setEstadoID(Constantes.STRING_CERO);
				consultaProspectoResponse.setMunicipioID(Constantes.STRING_CERO);
				
				consultaProspectoResponse.setLocalidadID(Constantes.STRING_CERO);
				consultaProspectoResponse.setColoniaID(Constantes.STRING_CERO);
				consultaProspectoResponse.setCalle(Constantes.STRING_CERO);
				consultaProspectoResponse.setNumExterior(Constantes.STRING_CERO);
				consultaProspectoResponse.setNumInterior(Constantes.STRING_CERO);
				
				consultaProspectoResponse.setCP(Constantes.STRING_CERO);
				consultaProspectoResponse.setManzana(Constantes.STRING_CERO);
				consultaProspectoResponse.setLote(Constantes.STRING_CERO);
				consultaProspectoResponse.setLatitud(Constantes.STRING_CERO);
				consultaProspectoResponse.setLongitud(Constantes.STRING_CERO);
				
				consultaProspectoResponse.setTipoDireccionID(Constantes.STRING_CERO);
				consultaProspectoResponse.setCalificaProspecto(Constantes.STRING_CERO);
				
			}
		return consultaProspectoResponse;
		}
		protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaProspectoRequest consultaProspectoRequest = (ConsultaProspectoRequest)arg0; 							
		return consultaProspecto(consultaProspectoRequest);
		}
		
		/* declaracion de getter y setter */
		public ProspectosServicio getProspectosServicio() {
			return prospectosServicio;
		}
		public void setProspectosServicio(ProspectosServicio prospectosServicio) {
			this.prospectosServicio = prospectosServicio;
		}
}
