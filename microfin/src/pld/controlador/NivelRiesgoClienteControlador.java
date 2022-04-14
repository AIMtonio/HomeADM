package pld.controlador;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.MatrizRiesgoBean;
import pld.bean.NivelRiesgoClienteBean;
import pld.servicio.NivelRiesgoClienteServicio;

@SuppressWarnings("deprecation")
public class NivelRiesgoClienteControlador extends SimpleFormController{

	NivelRiesgoClienteServicio nivelRiesgoClienteServicio =null;
	public NivelRiesgoClienteControlador() {
		setCommandClass(NivelRiesgoClienteBean.class);
		setCommandName("nivelRiesgoCliente");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		NivelRiesgoClienteBean nivelRiesgoClienteBean = (NivelRiesgoClienteBean) command;
			int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
			List listaResultado=nivelRiesgoClienteServicio.consultaNivelRiesgoPLD(nivelRiesgoClienteBean,tipoConsulta);
			return new ModelAndView("pld/nivelRiesgoClienteGridVista", "listaResultado",listaResultado);
}

	public NivelRiesgoClienteServicio getNivelRiesgoClienteServicio() {
		return nivelRiesgoClienteServicio;
	}

	public void setNivelRiesgoClienteServicio(
			NivelRiesgoClienteServicio nivelRiesgoClienteServicio) {
		this.nivelRiesgoClienteServicio = nivelRiesgoClienteServicio;
	}
	
	
}
