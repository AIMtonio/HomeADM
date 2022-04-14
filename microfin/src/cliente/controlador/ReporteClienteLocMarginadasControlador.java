package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.servicio.DireccionesClienteServicio;


public class ReporteClienteLocMarginadasControlador extends SimpleFormController  {

	DireccionesClienteServicio direccionesClienteServicio = null;

	public ReporteClienteLocMarginadasControlador() {
		setCommandClass(ReporteClienteLocMarginadasBean.class);
		setCommandName("reporteClienteLocMarginadasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		direccionesClienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ReporteClienteLocMarginadasBean reporteClienteLocMarginadas = (ReporteClienteLocMarginadasBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
							
	MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			
	}

	public DireccionesClienteServicio getDireccionesClienteServicio() {
		return direccionesClienteServicio;
	}

	public void setDireccionesClienteServicio(
			DireccionesClienteServicio direccionesClienteServicio) {
		this.direccionesClienteServicio = direccionesClienteServicio;
	}

	
}




