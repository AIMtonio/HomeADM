package ventanilla.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import ventanilla.beanWS.request.ConsultaListaServRequest;
import ventanilla.beanWS.response.ConsultaListaServResponse;
import ventanilla.servicio.CatalogoServServicio;

public class ConsultaListaServWS extends AbstractMarshallingPayloadEndpoint{
	CatalogoServServicio catalogoServServicio=null;
	public ConsultaListaServWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaListaServResponse consultaListaServicio (ConsultaListaServRequest consultaListaServRequest){
		
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		catalogoServServicio.getCatalogoServDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
		ConsultaListaServResponse consultaListaServResponse= (ConsultaListaServResponse)
				catalogoServServicio.listaCatServiciosWS(consultaListaServRequest);
		return consultaListaServResponse ;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaListaServRequest  consultaListaServRequest = (ConsultaListaServRequest )arg0;
		return consultaListaServicio (consultaListaServRequest);
	}
	
	
	public CatalogoServServicio getCatalogoServServicio() {
		return catalogoServServicio;
	}
	public void setCatalogoServServicio(CatalogoServServicio catalogoServServicio) {
		this.catalogoServServicio = catalogoServServicio;
	}	
}
