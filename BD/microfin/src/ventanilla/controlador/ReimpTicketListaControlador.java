package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.ReimpresionTicketBean;
import ventanilla.servicio.ReimpresionTicketServicio;

public class ReimpTicketListaControlador extends AbstractCommandController {
	ReimpresionTicketServicio	reimpresionTicketServicio	= null;

	public ReimpTicketListaControlador() {
		setCommandClass(ReimpresionTicketBean.class);
		setCommandName("ReimpTicket");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		ReimpresionTicketBean reimpresionTicketBean = (ReimpresionTicketBean) command;

		List listaReimpresion = reimpresionTicketServicio.lista(tipoLista, reimpresionTicketBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaReimpresion);
		return new ModelAndView("ventanilla/reimpresionTicketListaVista", "listaResultado", listaResultado);
	}

	public ReimpresionTicketServicio getReimpresionTicketServicio() {
		return reimpresionTicketServicio;
	}

	public void setReimpresionTicketServicio(ReimpresionTicketServicio reimpresionTicketServicio) {
		this.reimpresionTicketServicio = reimpresionTicketServicio;
	}
}
