package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarBinParamsBean;
import tarjetas.servicio.TarBinParamsServicio;

public class TarParametrosBINControlador extends SimpleFormController{
	TarBinParamsServicio tarjetaBinParamsServicio = null;
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		TarBinParamsBean tarBinParamsBean = (TarBinParamsBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			tarjetaBinParamsServicio.getTarBinParamsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
			
			mensaje = tarjetaBinParamsServicio.grabaTransaccion(tipoTransaccion, tarBinParamsBean);
		}catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar la configuración de BIN.");
			}
		}
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	
	public TarBinParamsServicio getTarjetaBinParamsServicio() {
		return tarjetaBinParamsServicio;
	}
	public void setTarjetaBinParamsServicio(
			TarBinParamsServicio tarjetaBinParamsServicio) {
		this.tarjetaBinParamsServicio = tarjetaBinParamsServicio;
	}
	
}
