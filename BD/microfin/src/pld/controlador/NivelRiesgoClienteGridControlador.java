package pld.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MatrizRiesgoBean;
import pld.bean.NivelRiesgoClienteBean;
import pld.servicio.NivelRiesgoClienteServicio;

@SuppressWarnings("deprecation")
public class NivelRiesgoClienteGridControlador  extends AbstractCommandController{

	NivelRiesgoClienteServicio nivelRiesgoClienteServicio =null;
	
	public NivelRiesgoClienteGridControlador() {
		setCommandClass(MatrizRiesgoBean.class);
		setCommandName("nivelRiesgoClienteGrid");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)
			throws Exception {

		int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
		String clienteID=request.getParameter("clienteID");
		String tipoProceso=request.getParameter("tipoProceso");
		String operProcesoID=request.getParameter("operProcesoID");
		
		NivelRiesgoClienteBean nivelRiesgoClienteBean = new NivelRiesgoClienteBean();
		nivelRiesgoClienteBean.setClienteID(clienteID);
		nivelRiesgoClienteBean.setTipoProceso(tipoProceso);
		nivelRiesgoClienteBean.setOperProcesoID(operProcesoID);
		

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
