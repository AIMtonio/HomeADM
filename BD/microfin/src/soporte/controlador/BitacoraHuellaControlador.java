package soporte.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.BitacoraHuellaBean;
import soporte.servicio.BitacoraHuellaServicio;

@SuppressWarnings("deprecation")
public class BitacoraHuellaControlador extends AbstractCommandController {

	BitacoraHuellaServicio bitacoraHuellaServicio = null;
	
	public BitacoraHuellaControlador() {
		setCommandClass(BitacoraHuellaBean.class);
		setCommandName("bitacoraHuellaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		BitacoraHuellaBean bitacoraHuellaBean = (BitacoraHuellaBean) command;
		
		bitacoraHuellaServicio.getBitacoraHuellaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = bitacoraHuellaServicio.grabaTransaccion(tipoTransaccion, bitacoraHuellaBean);
		
		if(mensaje == null){
			mensaje = new MensajeTransaccionBean();
		}
		
		Utileria.respuestaJsonTransaccion(mensaje, response);
		
		return null;
	}

	public BitacoraHuellaServicio getBitacoraHuellaServicio() {
		return bitacoraHuellaServicio;
	}

	public void setBitacoraHuellaServicio(
			BitacoraHuellaServicio bitacoraHuellaServicio) {
		this.bitacoraHuellaServicio = bitacoraHuellaServicio;
	}
}