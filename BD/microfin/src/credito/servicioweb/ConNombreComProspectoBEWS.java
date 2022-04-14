package credito.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.ProspectosBean;
import credito.beanWS.request.ConNombreComProspectoBERequest;
import credito.beanWS.request.ConsultaCreditoBERequest;
import credito.beanWS.response.ConNombreComProspectoBEResponse;
import credito.servicio.ProspectosServicio;

public class ConNombreComProspectoBEWS extends AbstractMarshallingPayloadEndpoint {

	public ConNombreComProspectoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	ProspectosServicio prospectosServicio=null;
	
	private ConNombreComProspectoBEResponse nombreCompletoProspectos(ConNombreComProspectoBERequest conNombreComProspectoBERequest ){
		
		ConNombreComProspectoBEResponse conNombreComProspectoBEResponse = new ConNombreComProspectoBEResponse();
		ProspectosBean prospectosBean =new ProspectosBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");		
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		prospectosBean.setProspectoID(conNombreComProspectoBERequest.getProspectoID());
		prospectosBean.setInstitucionNominaID(conNombreComProspectoBERequest.getInstitNominaID());
		prospectosBean.setNegocioAfiliadoID(conNombreComProspectoBERequest.getNegocioAfiliadoID());
		prospectosBean.setNumCon(conNombreComProspectoBERequest.getNumCon());
		
		prospectosBean=prospectosServicio.consulta(ProspectosServicio.Enum_Con_Prospecto.nombre, prospectosBean);
		
		if(prospectosBean==null){
			conNombreComProspectoBEResponse.setNombreCompleto(Constantes.STRING_VACIO);
			conNombreComProspectoBEResponse.setCalificaProspecto(Constantes.STRING_VACIO);
		}
		else{
			conNombreComProspectoBEResponse.setNombreCompleto(prospectosBean.getNombreCompleto());
			conNombreComProspectoBEResponse.setCalificaProspecto(prospectosBean.getCalificaProspectos());
		}
		
		return conNombreComProspectoBEResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConNombreComProspectoBERequest conNombreComProspectoBERequest = (ConNombreComProspectoBERequest)arg0;
		return nombreCompletoProspectos(conNombreComProspectoBERequest);
	}

	public ProspectosServicio getProspectosServicio() {
		return prospectosServicio;
	}

	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}
	
	

}
