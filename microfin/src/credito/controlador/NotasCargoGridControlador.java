package credito.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.NotasCargoBean;
import credito.servicio.NotasCargoServicio;

public class NotasCargoGridControlador extends AbstractCommandController {

	private NotasCargoServicio notasCargoServicio = null;

	public NotasCargoGridControlador() {
		setCommandClass(NotasCargoBean.class);
		setCommandName("notasCargoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;
		String creditoID = request.getParameter("creditoID");

		NotasCargoBean notaCargoBean = (NotasCargoBean) command;
		notaCargoBean.setCreditoID(creditoID);

		List notasCargo =	notasCargoServicio.lista(tipoLista, notaCargoBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(notasCargo);

		return new ModelAndView("credito/notasCargoGridVista", "listaResultado", listaResultado);
	}

	public NotasCargoServicio getNotasCargoServicio() {
		return notasCargoServicio;
	}

	public void setNotasCargoServicio(NotasCargoServicio notasCargoServicio) {
		this.notasCargoServicio = notasCargoServicio;
	}
}
