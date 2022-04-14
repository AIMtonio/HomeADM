package cuentas.controlador; 

 import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import cuentas.bean.TiposCuentaBean;
import cuentas.servicio.TiposCuentaServicio;

 public class TiposCuentaControlador extends SimpleFormController {
		
	   TiposCuentaServicio tiposCuentaServicio = null;
			
		public TiposCuentaControlador() {
				setCommandClass(TiposCuentaBean.class);
				setCommandName("tiposCuenta");
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
			tiposCuentaServicio.getTiposCuentaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			TiposCuentaBean tiposCtasAho = (TiposCuentaBean) command;
			int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
			

			MensajeTransaccionBean mensaje = null;
			mensaje = tiposCuentaServicio.grabaTransaccion(tipoTransaccion,tiposCtasAho);
											
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public void setTiposCuentaServicio(TiposCuentaServicio tiposCuentaServicio) {
			this.tiposCuentaServicio = tiposCuentaServicio;
		}
		
 }

