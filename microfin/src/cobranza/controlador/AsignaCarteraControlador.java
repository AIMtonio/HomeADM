package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.AsignaCarteraBean;
import cobranza.servicio.AsignaCarteraServicio;

public class AsignaCarteraControlador extends SimpleFormController{
	private AsignaCarteraServicio asignaCarteraServicio = null;
	
	private AsignaCarteraControlador(){
		setCommandClass(AsignaCarteraBean.class);
		setCommandName("asignaCarteraBean");		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		asignaCarteraServicio.getAsignaCarteraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		AsignaCarteraBean asignaCartera = (AsignaCarteraBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String  credAsig = request.getParameter("listaGridCreditos");
		MensajeTransaccionBean mensaje = null;
		
		mensaje = asignaCarteraServicio.grabaTransaccion(tipoTransaccion,asignaCartera,credAsig);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		
	}

		
	public AsignaCarteraServicio getAsignaCarteraServicio() {
		return asignaCarteraServicio;
	}

	public void setAsignaCarteraServicio(AsignaCarteraServicio asignaCarteraServicio) {
		this.asignaCarteraServicio = asignaCarteraServicio;
	}

}
