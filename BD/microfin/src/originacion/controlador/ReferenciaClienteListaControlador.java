package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ReferenciaClienteBean;
import originacion.servicio.ReferenciaClienteServicio;

public class ReferenciaClienteListaControlador extends SimpleFormController {

	ReferenciaClienteServicio referenciaClienteServicio = null;

	public ReferenciaClienteListaControlador() {
		setCommandClass(ReferenciaClienteBean.class);
		setCommandName("referenciaClienteBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReferenciaClienteBean referenciaClienteBean = (ReferenciaClienteBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List<ReferenciaClienteBean> lista = referenciaClienteServicio.lista(tipoLista, referenciaClienteBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public void setReferenciaClienteServicio(ReferenciaClienteServicio referenciaClienteServicio) {
		this.referenciaClienteServicio = referenciaClienteServicio;
	}
}
