package tesoreria.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.servicio.ReferenciasPagosServicio;


public class ReferenciasPagosGridControlador extends SimpleFormController {

	ReferenciasPagosServicio referenciasPagosServicio;
	
	public ReferenciasPagosGridControlador() {
		setCommandClass(ReferenciasPagosBean.class);
		setCommandName("referenciasPagosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReferenciasPagosBean paisesBean = (ReferenciasPagosBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<ReferenciasPagosBean> lista = referenciasPagosServicio.lista(tipoLista, paisesBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public ReferenciasPagosServicio getReferenciasPagosServicio() {
		return referenciasPagosServicio;
	}

	public void setReferenciasPagosServicio(
			ReferenciasPagosServicio referenciasPagosServicio) {
		this.referenciasPagosServicio = referenciasPagosServicio;
	}

}