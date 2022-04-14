package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.servicio.PLDListasPersBloqServicio;
import pld.bean.PLDListasPersBloqBean;

public class PLDPersBloqListaControlador extends AbstractCommandController {
	
	PLDListasPersBloqServicio pldListasPersBloqServicio = null;

	public PLDPersBloqListaControlador() {
		setCommandClass(PLDListasPersBloqBean.class);
		setCommandName("listaPersBlog");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		PLDListasPersBloqBean listaPersBloqList = (PLDListasPersBloqBean) command;
		List listaPersBlog = pldListasPersBloqServicio.lista(tipoLista, listaPersBloqList);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaPersBlog);

		return new ModelAndView("pld/pldListasPersBListaVista", "listaResultado", listaResultado);
	}

	public PLDListasPersBloqServicio getPldListasPersBloqServicio() {
		return pldListasPersBloqServicio;
	}

	public void setPldListasPersBloqServicio(
			PLDListasPersBloqServicio pldListasPersBloqServicio) {
		this.pldListasPersBloqServicio = pldListasPersBloqServicio;
	}

}
