package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.GruposNosolidariosBean;
import cliente.servicio.ClienteServicio;
import cliente.servicio.GruposNosolidariosServicio;
import cliente.servicio.IntegraGrupoNosolServicio;

public class GruposNosolidariosControlador extends SimpleFormController {
	
	GruposNosolidariosServicio gruposNosolidariosServicio = null;
	IntegraGrupoNosolServicio integraGrupoNosolServicio =null;


	public GruposNosolidariosControlador() {
		setCommandClass(GruposNosolidariosBean.class);
		setCommandName("gruposNosolidariosBean");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		gruposNosolidariosServicio.getGruposNosolidariosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		GruposNosolidariosBean gruposNosolidariosBean = (GruposNosolidariosBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int tipoTransaccionG = Integer.parseInt(request.getParameter("tipoTransaccionGrid"));
		MensajeTransaccionBean mensaje = null;
		if( tipoTransaccion > 0){
		mensaje = gruposNosolidariosServicio.grabaTransaccion(tipoTransaccion,gruposNosolidariosBean);
		}
		if(tipoTransaccionG > 0){
			mensaje = integraGrupoNosolServicio.grabaTransaccion(tipoTransaccionG,gruposNosolidariosBean);
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public GruposNosolidariosServicio getGruposNosolidariosServicio() {
		return gruposNosolidariosServicio;
	}


	public void setGruposNosolidariosServicio(
			GruposNosolidariosServicio gruposNosolidariosServicio) {
		this.gruposNosolidariosServicio = gruposNosolidariosServicio;
	}


	public IntegraGrupoNosolServicio getIntegraGrupoNosolServicio() {
		return integraGrupoNosolServicio;
	}


	public void setIntegraGrupoNosolServicio(
			IntegraGrupoNosolServicio integraGrupoNosolServicio) {
		this.integraGrupoNosolServicio = integraGrupoNosolServicio;
	}

	
	
	
}
