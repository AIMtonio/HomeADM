package bancaMovil.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMUsuariosBean;
import bancaMovil.servicio.BAMUsuariosServicio;

@SuppressWarnings("deprecation")
public class BAMUsuariosListaControlador extends AbstractCommandController {
	BAMUsuariosServicio usuariosServicio = null;

	public BAMUsuariosListaControlador() {
		setCommandClass(BAMUsuariosBean.class);
		setCommandName("usuarios");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		BAMUsuariosBean usuariosBean = (BAMUsuariosBean) command;
		List usuarios = usuariosServicio.lista(tipoLista, usuariosBean);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(usuarios);

		return new ModelAndView("bancaMovil/BAMUsuariosListaVista", "listaResultado", listaResultado);
	}

	public void setBAMUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}
}