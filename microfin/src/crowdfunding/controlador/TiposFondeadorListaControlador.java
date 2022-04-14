package crowdfunding.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import crowdfunding.bean.TiposFondeadoresBean;
import crowdfunding.servicio.TiposFondeadoresServicio;

public class TiposFondeadorListaControlador extends AbstractCommandController {

	TiposFondeadoresServicio tiposFondeadoresServicio = null;

	public TiposFondeadorListaControlador() {
		setCommandClass(TiposFondeadoresBean.class);
		setCommandName("listaFond");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TiposFondeadoresBean listaBean = (TiposFondeadoresBean) command;
		List listaPersBlog = tiposFondeadoresServicio.lista(tipoLista, listaBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaPersBlog);

		return new ModelAndView("crowdfunding/fondCRWListaVista", "listaResultado", listaResultado);
	}

	public TiposFondeadoresServicio getTiposFondeadoresServicio() {
		return tiposFondeadoresServicio;
	}

	public void setTiposFondeadoresServicio(
			TiposFondeadoresServicio tiposFondeadoresServicio) {
		this.tiposFondeadoresServicio = tiposFondeadoresServicio;
	}
}