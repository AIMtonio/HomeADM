package credito.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CirculoCreTipConBean;
import credito.servicio.CirculoCreTipConServicio;

public class CirculoCreTipConListaControlador extends AbstractCommandController{
	
	CirculoCreTipConServicio circuloCreTipConServicio = null;

	public CirculoCreTipConListaControlador() {
			setCommandClass(CirculoCreTipConBean.class);
			setCommandName("tipoContrato");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		CirculoCreTipConBean contrato = (CirculoCreTipConBean) command;
		List contratoList =	circuloCreTipConServicio.lista(tipoLista, contrato);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(contratoList);

		return new ModelAndView("credito/circuloCreTipConListaVista", "listaResultado", listaResultado);
	}

		public CirculoCreTipConServicio getCirculoCreTipConServicio() {
			return circuloCreTipConServicio;
		}

		public void setCirculoCreTipConServicio(
				CirculoCreTipConServicio circuloCreTipConServicio) {
			this.circuloCreTipConServicio = circuloCreTipConServicio;
		}
}