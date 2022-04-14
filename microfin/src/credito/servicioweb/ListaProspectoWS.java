package credito.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.beanWS.request.ListaProspectoRequest;
import credito.beanWS.response.ListaProspectoResponse;
import credito.servicio.ProspectosServicio;

public class ListaProspectoWS extends AbstractMarshallingPayloadEndpoint{
	ProspectosServicio prospectosServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ListaProspectoWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	private ListaProspectoResponse listaProspecto(ListaProspectoRequest listaProspectoRequest){
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaProspectoResponse  listaProspectoResponse = (ListaProspectoResponse)
		prospectosServicio.listaProspectoWS( listaProspectoRequest);
		return listaProspectoResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaProspectoRequest listaProspectoRequest = (ListaProspectoRequest)arg0; 			
		return listaProspecto(listaProspectoRequest);
}
	public ProspectosServicio getProspectosServicio() {
		return prospectosServicio;
	}
	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}
}
