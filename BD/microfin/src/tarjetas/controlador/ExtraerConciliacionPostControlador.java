package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.ExtraerTarjetasBean;
import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.servicio.ExtraccionTarjetasServicio;
import tarjetas.servicio.TarDebConciliaPosServicio;

public class ExtraerConciliacionPostControlador extends  SimpleFormController {
	
	ExtraccionTarjetasServicio extraccionTarjetasServicio = null;
	
	public ExtraerConciliacionPostControlador(){
		setCommandClass(ExtraerTarjetasBean.class);
 		setCommandName("extraerTarjetasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		extraccionTarjetasServicio.getExtraerTarjetasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ExtraerTarjetasBean extraerTarjetasBean = (ExtraerTarjetasBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = extraccionTarjetasServicio.grabaTransaccion(tipoTransaccion, extraerTarjetasBean);
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ExtraccionTarjetasServicio getExtraccionTarjetasServicio() {
		return extraccionTarjetasServicio;
	}

	public void setExtraccionTarjetasServicio(
			ExtraccionTarjetasServicio extraccionTarjetasServicio) {
		this.extraccionTarjetasServicio = extraccionTarjetasServicio;
	}

		
	
}
