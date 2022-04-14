package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class AplicacionPagosCredNomControlador extends SimpleFormController{
	PagoNominaServicio pagoNominaServicio = null;

	public AplicacionPagosCredNomControlador() {
		setCommandClass(PagoNominaBean.class);
		setCommandName("pagoNominaBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		String folioPendienteID = (request.getParameter("foliosPendientes")!=null)? request.getParameter("foliosPendientes"):"";
		pagoNominaServicio.getPagoNominaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		PagoNominaBean pagoNominaBean = (PagoNominaBean) command;
		pagoNominaBean.setFolioPendienteID(folioPendienteID);
		MensajeTransaccionBean mensaje = null;

		List listaResultado = new ArrayList();
		listaResultado = (List) request.getSession().getAttribute(AplicacionPagosGridControlador.ListaAplicacionPagoInstitucion);
		PagedListHolder listaPaginada = (PagedListHolder) listaResultado.get(1);
		List<PagoNominaBean> listaPagoNominaBean = listaPaginada.getSource();

		mensaje = pagoNominaServicio.grabaTransaccion(tipoTransaccion, pagoNominaBean, listaPagoNominaBean);
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}
	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
	}
}
