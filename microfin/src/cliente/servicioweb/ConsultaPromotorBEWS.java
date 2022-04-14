package cliente.servicioweb;

import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaPromotorBERequest;
import cliente.BeanWS.Response.ConsultaPromotorBEResponse;
import cliente.bean.InstitucionNominaBean;
import cliente.bean.NegocioAfiliadoBean;
import cliente.servicio.InstitucionNominaServicio;
import cliente.servicio.InstitucionNominaServicio.Enum_Con_Institucion;
import cliente.servicio.NegocioAfiliadoServicio.Enum_Con_NegocioAfiliado ;
import cliente.servicio.NegocioAfiliadoServicio;

public class ConsultaPromotorBEWS extends AbstractMarshallingPayloadEndpoint {
	
	InstitucionNominaServicio institucionNominaServicio=null;
	NegocioAfiliadoServicio  negocioAfiliadoServicio=null;

	public ConsultaPromotorBEWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}
	
	private ConsultaPromotorBEResponse consultaPromotor(ConsultaPromotorBERequest consultaPromotorBERequest){
		ConsultaPromotorBEResponse consultaPromotorResponse= new ConsultaPromotorBEResponse();
		InstitucionNominaBean institucionNominaBean = new InstitucionNominaBean();
		NegocioAfiliadoBean negocioAfiliado= new NegocioAfiliadoBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		negocioAfiliadoServicio.getNegocioAfiliadoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		if(Utileria.convierteEntero(consultaPromotorBERequest.getInstitNominaID())!=0){
		institucionNominaBean.setInstitNominaID(consultaPromotorBERequest.getInstitNominaID());
		
			institucionNominaBean= institucionNominaServicio.consulta(Enum_Con_Institucion.promotor, institucionNominaBean);
			
			consultaPromotorResponse.setPromotorID(institucionNominaBean.getPromotorID());
			consultaPromotorResponse.setNombrePromotor(institucionNominaBean.getNombrePromotor());
			consultaPromotorResponse.setTelefono(institucionNominaBean.getTelefono());
			
		}
		if(Utileria.convierteEntero(consultaPromotorBERequest.getNegocioAfiliadoID())!= 0){
			negocioAfiliado.setNegocioAfiliadoID(consultaPromotorBERequest.getNegocioAfiliadoID());
			

			negocioAfiliado= negocioAfiliadoServicio.consulta(Enum_Con_NegocioAfiliado .promotor, negocioAfiliado);

			consultaPromotorResponse.setPromotorID(negocioAfiliado.getPromotorID());
			consultaPromotorResponse.setNombrePromotor(negocioAfiliado.getNombrePromotor());
			consultaPromotorResponse.setTelefono(negocioAfiliado.getTelefono());
		}

			
	return consultaPromotorResponse;
	}
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaPromotorBERequest consultaPromotorBERequest = (ConsultaPromotorBERequest)arg0; 			
		return consultaPromotor(consultaPromotorBERequest);		
	}

	
// Getters y Setters
	public InstitucionNominaServicio getInstitucionNominaServicio() {
		return institucionNominaServicio;
	}

	public void setInstitucionNominaServicio(
			InstitucionNominaServicio institucionNominaServicio) {
		this.institucionNominaServicio = institucionNominaServicio;
	}

	public NegocioAfiliadoServicio getNegocioAfiliadoServicio() {
		return negocioAfiliadoServicio;
	}

	public void setNegocioAfiliadoServicio(
			NegocioAfiliadoServicio negocioAfiliadoServicio) {
		this.negocioAfiliadoServicio = negocioAfiliadoServicio;
	}
	

}
