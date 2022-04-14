package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.RenovacionOrdenPagoBean;
import tesoreria.servicio.RenovacionOrdenPagoServicio;
public class RenovacionOrdenPagoListaControlador extends AbstractCommandController {
	
	RenovacionOrdenPagoServicio  renovacionOrdenPagoServicio= null;

	public RenovacionOrdenPagoListaControlador() {
		setCommandClass(RenovacionOrdenPagoBean.class);
		setCommandName("renovacionOrdenPago");		
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		RenovacionOrdenPagoBean renovacionOrdenPagoBean = (RenovacionOrdenPagoBean) command;
		List ordenesLis =	renovacionOrdenPagoServicio.listaOrdenesPago(tipoLista, renovacionOrdenPagoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ordenesLis);

		return new ModelAndView("tesoreria/ordenesPagoLista", "listaResultado", listaResultado);
		}

	public RenovacionOrdenPagoServicio getRenovacionOrdenPagoServicio() {
		return renovacionOrdenPagoServicio;
	}

	public void setRenovacionOrdenPagoServicio(
			RenovacionOrdenPagoServicio renovacionOrdenPagoServicio) {
		this.renovacionOrdenPagoServicio = renovacionOrdenPagoServicio;
	}
	
}
