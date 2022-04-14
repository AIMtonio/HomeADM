package fira.controlador;

import fira.bean.MinistracionCredAgroBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class DesembolsoCreditoControlador extends SimpleFormController {

	CreditosServicio creditosServicio = null;

	public DesembolsoCreditoControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
			Object command, BindException errors) throws Exception {

		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CreditosBean creditos = (CreditosBean) command;
		String forPagComGarantia = (request.getParameter("forPagComGarantia")!=null) ? request.getParameter("forPagComGarantia") : "";
		
		MinistracionCredAgroBean ministraciones = new MinistracionCredAgroBean();
		ministraciones.setCreditoID(creditos.getCreditoID());
		ministraciones.setNumero(request.getParameter("numeroID"));
		ministraciones.setUsuarioAutoriza(request.getParameter("usuarioAutoriza"));
		ministraciones.setContraseniaAutoriza(request.getParameter("contraseniaAutoriza"));
		ministraciones.setTipoCalculoInteres(request.getParameter("tipoCalculoInteres"));
		ministraciones.setComentariosAutoriza(creditos.getComentarioCred());
		ministraciones.setForPagComGarantia(forPagComGarantia);
		
		MensajeTransaccionBean mensaje = null;

		mensaje = creditosServicio.grabaTransaccionAgro(tipoTransaccion, tipoActualizacion, creditos, ministraciones, request);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}