package ventanilla.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import ventanilla.bean.CatalogoServBean;
import ventanilla.beanWS.request.ConsultaMontoServRequest;
import ventanilla.beanWS.response.ConsultaMontoServResponse;
import ventanilla.servicio.CatalogoServServicio;

public class ConsultaMontoServWS extends AbstractMarshallingPayloadEndpoint{
	CatalogoServServicio catalogoServServicio=null;
	public ConsultaMontoServWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaMontoServResponse consultaMontoServicio (ConsultaMontoServRequest consultaMontoServRequest){
		CatalogoServBean catalogoServBean = new CatalogoServBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		catalogoServServicio.getCatalogoServDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
		ConsultaMontoServResponse consultaMontoServResponse= new ConsultaMontoServResponse();
		
		catalogoServBean.setCatalogoServID(consultaMontoServRequest.getCatalogoServID());
		catalogoServBean = catalogoServServicio.montoCatServiciosWS(CatalogoServServicio.Enum_Con_CatalogoServ.montos,consultaMontoServRequest);
		
		consultaMontoServResponse.setMontoComision(catalogoServBean.getMontoComision());
		consultaMontoServResponse.setMontoServicio(catalogoServBean.getMontoServicio());
		consultaMontoServResponse.setOrigen(catalogoServBean.getOrigen());
		return consultaMontoServResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaMontoServRequest  consultaMontoServRequest = (ConsultaMontoServRequest)arg0;
		return consultaMontoServicio (consultaMontoServRequest);
	}

	
	public CatalogoServServicio getCatalogoServServicio() {
		return catalogoServServicio;
	}
	public void setCatalogoServServicio(CatalogoServServicio catalogoServServicio) {
		this.catalogoServServicio = catalogoServServicio;
	}
}
