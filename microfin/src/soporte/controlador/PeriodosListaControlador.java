package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.servicio.EdoCtaEnvioCorreoServicio;

public class PeriodosListaControlador extends AbstractCommandController {
	EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio = null; 
	public PeriodosListaControlador(){
		setCommandClass(EdoCtaEnvioCorreoBean.class);
		setCommandName("edoCtaEnvioCorreoBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) command;
		List listaPeriodos = edoCtaEnvioCorreoServicio.lista(tipoLista, edoCtaEnvioCorreoBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaPeriodos);

		return new ModelAndView("soporte/periodosListaVista", "listaResultado", listaResultado);
	}

	//------------------setter---------------
	public void setEdoCtaEnvioCorreoServicio(EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio) {
		this.edoCtaEnvioCorreoServicio = edoCtaEnvioCorreoServicio;
	}
}
