package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TiposCuentaValidoTipoTarjetaBean;
import tarjetas.servicio.TiposCuentaValidoTipoTarjetaServicio;



public class TiposCuentaValidoTipoTarjetaControlador extends SimpleFormController {
		
	TiposCuentaValidoTipoTarjetaServicio tiposCuentaValidoTipoTarjetaServicio = null;
			
		public TiposCuentaValidoTipoTarjetaControlador() {
				setCommandClass(TiposCuentaValidoTipoTarjetaBean.class);
				setCommandName("tiposCuentaValidoTipoTarjetaBean");
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

			TiposCuentaValidoTipoTarjetaBean tiposCuentaValidoTipoTarjetaBean = (TiposCuentaValidoTipoTarjetaBean) command;
			tiposCuentaValidoTipoTarjetaServicio.getTiposCuentaValidoTipoTarjetaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

				int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccion")):0;
						
			MensajeTransaccionBean mensaje = null;
			mensaje = tiposCuentaValidoTipoTarjetaServicio.grabaTransaccion(tipoTransaccion,tiposCuentaValidoTipoTarjetaBean);
											
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}


		public void setTiposCuentaValidoTipoTarjetaServicio(
				TiposCuentaValidoTipoTarjetaServicio tiposCuentaValidoTipoTarjetaServicio) {
			this.tiposCuentaValidoTipoTarjetaServicio = tiposCuentaValidoTipoTarjetaServicio;
		}

}
