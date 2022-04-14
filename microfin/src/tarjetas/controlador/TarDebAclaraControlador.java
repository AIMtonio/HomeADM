package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebAclaraBean;
import tarjetas.servicio.TarDebAclaraServicio;
import tarjetas.servicio.TarDebArchAclaServicio;

public class TarDebAclaraControlador  extends SimpleFormController {
	
	TarDebAclaraServicio aclaracionServicio= null;
	TarDebArchAclaServicio tarDebArchAclaServicio= null;

	private ParametrosSesionBean parametrosSesionBean = null;

	public TarDebAclaraControlador() {
		setCommandClass(TarDebAclaraBean.class);
		setCommandName("registro");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		aclaracionServicio.getTarDebAclaraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TarDebAclaraBean tarDebAclaraBean = (TarDebAclaraBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")):0;
								
		MensajeTransaccionBean mensaje = null;
		
		String lisFolioID = request.getParameter("lisFolio");
		String lisTipoArchivo = request.getParameter("lisTipoArchivo");
		String lisRuta = request.getParameter("lisRuta");
		String lisNombreArchivo = request.getParameter("lisNombreArchivo");
		mensaje = aclaracionServicio.grabaTransaccion(tipoTransaccion,tarDebAclaraBean,lisFolioID,lisTipoArchivo,lisRuta, lisNombreArchivo );
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TarDebArchAclaServicio getTarDebArchAclaServicio() {
		return tarDebArchAclaServicio;
	}

	public void setTarDebArchAclaServicio(
			TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}

	public TarDebAclaraServicio getAclaracionServicio() {
		return aclaracionServicio;
	}

	public void setAclaracionServicio(TarDebAclaraServicio aclaracionServicio) {
		this.aclaracionServicio = aclaracionServicio;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}