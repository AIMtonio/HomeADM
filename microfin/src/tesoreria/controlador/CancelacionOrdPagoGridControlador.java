package tesoreria.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CancelacionOrdPagoBean;
import tesoreria.servicio.CancelacionOrdPagoServicio;

public class CancelacionOrdPagoGridControlador extends SimpleFormController {

	CancelacionOrdPagoServicio cancelacionOrdPagoServicio;
	
	public CancelacionOrdPagoGridControlador() {
		setCommandClass(CancelacionOrdPagoBean.class);
		setCommandName("cancelacionOrdPagoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CancelacionOrdPagoBean cancelacionOrdPagoBean = (CancelacionOrdPagoBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<CancelacionOrdPagoBean> lista = cancelacionOrdPagoServicio.lista(tipoLista, cancelacionOrdPagoBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public CancelacionOrdPagoServicio getCancelacionOrdPagoServicio() {
		return cancelacionOrdPagoServicio;
	}

	public void setCancelacionOrdPagoServicio(
			CancelacionOrdPagoServicio cancelacionOrdPagoServicio) {
		this.cancelacionOrdPagoServicio = cancelacionOrdPagoServicio;
	}


}