package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ReporteLocalidadesMarginadasBean;
import cliente.servicio.LocalidadRepubServicio;

public class ReporteLocalidadesMarginadasControlador extends SimpleFormController{
	LocalidadRepubServicio localidadRepubServicio = null;

	public ReporteLocalidadesMarginadasControlador() {
		setCommandClass(ReporteLocalidadesMarginadasBean.class);
		setCommandName("reporteLocalidadesMarginadasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		localidadRepubServicio.getLocalidadRepubDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadas = (ReporteLocalidadesMarginadasBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
							
	MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			
	}

	public void setLocalidadRepubServicio(
			LocalidadRepubServicio localidadRepubServicio) {
		this.localidadRepubServicio = localidadRepubServicio;
	}

}




