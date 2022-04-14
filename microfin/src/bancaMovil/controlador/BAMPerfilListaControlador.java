package bancaMovil.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.servicio.BAMPerfilServicio;
import bancaMovil.bean.BAMPerfilBean;

@SuppressWarnings("deprecation")
public class BAMPerfilListaControlador extends AbstractCommandController {

	BAMPerfilServicio perfilServicio = null;

	public BAMPerfilListaControlador() {
		setCommandClass(BAMPerfilBean.class);
		setCommandName("perfil");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		BAMPerfilBean perfil = (BAMPerfilBean) command;
		List perfiles = perfilServicio.lista(tipoLista, perfil);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(perfiles);

		return new ModelAndView("bancaMovil/perfilListaVista", "listaResultado", listaResultado);
	}

	public void setPerfilServicio(BAMPerfilServicio perfilServicio) {
		this.perfilServicio = perfilServicio;
	}

}
