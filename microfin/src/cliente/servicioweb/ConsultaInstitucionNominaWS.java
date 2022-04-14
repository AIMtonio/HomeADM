package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaInstitucionNominaRequest;
import cliente.BeanWS.Response.ConsultaInstitucionNominaResponse;
import cliente.bean.InstitucionNominaBean;
import cliente.servicio.InstitucionNominaServicio;
import cliente.servicio.InstitucionNominaServicio.Enum_Con_Institucion;

public class ConsultaInstitucionNominaWS extends AbstractMarshallingPayloadEndpoint {
	
	InstitucionNominaServicio institucionNominaServicio=null;

	public ConsultaInstitucionNominaWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}
	
	private ConsultaInstitucionNominaResponse consultaInstitucion( ConsultaInstitucionNominaRequest consultaInstitucionRequest){
		ConsultaInstitucionNominaResponse consultaInsitucionResponse= new ConsultaInstitucionNominaResponse();
		InstitucionNominaBean institucionNominaBean = new InstitucionNominaBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		institucionNominaServicio.getInstitucionNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		institucionNominaBean.setInstitNominaID(consultaInstitucionRequest.getInstitNominaID());
		
		institucionNominaBean= institucionNominaServicio.consulta(Enum_Con_Institucion.institucion, institucionNominaBean);
		
		if(institucionNominaBean==null){
			consultaInsitucionResponse.setNombreInstit(Constantes.STRING_VACIO);
		}
		else{
		consultaInsitucionResponse.setNombreInstit(institucionNominaBean.getNombreInstit());
		}
			
	return consultaInsitucionResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaInstitucionNominaRequest consultaInstitucionRequest = (ConsultaInstitucionNominaRequest)arg0; 			
		return consultaInstitucion(consultaInstitucionRequest);		
	}
	
	public InstitucionNominaServicio getInstitucionNominaServicio() {
		return institucionNominaServicio;
	}

	public void setInstitucionNominaServicio(
			InstitucionNominaServicio institucionNominaServicio) {
		this.institucionNominaServicio = institucionNominaServicio;
	}
}
