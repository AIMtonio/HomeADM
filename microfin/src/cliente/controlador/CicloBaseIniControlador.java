package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CicloBaseIniBean;
import cliente.servicio.CicloBaseIniServicio;

public class CicloBaseIniControlador extends SimpleFormController {
	
	CicloBaseIniServicio cicloBaseIniServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public CicloBaseIniControlador() {
		setCommandClass(CicloBaseIniBean.class);
		setCommandName("cicloBaseIni");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		cicloBaseIniServicio.getCicloBaseIniDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CicloBaseIniBean cliente = (CicloBaseIniBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = cicloBaseIniServicio.grabaTransaccion(tipoTransaccion,cliente);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setcicloBaseIniServicio(CicloBaseIniServicio cicloBaseIniServicio) {
		this.cicloBaseIniServicio = cicloBaseIniServicio;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
