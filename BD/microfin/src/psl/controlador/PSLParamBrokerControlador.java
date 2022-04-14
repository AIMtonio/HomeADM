package psl.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import psl.bean.PSLParamBrokerBean;
import psl.servicio.PSLParamBrokerServicio;
import cedes.bean.CedesAnclajeBean;

public class PSLParamBrokerControlador extends SimpleFormController {
	PSLParamBrokerServicio pslParamBrokerServicio = null;
	
	public PSLParamBrokerControlador(){
		setCommandClass(PSLParamBrokerBean.class);
 		setCommandName("pslParamBrokerBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		pslParamBrokerServicio.getPslParamBrokerDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		PSLParamBrokerBean paramBrokerBean = (PSLParamBrokerBean) command;
		paramBrokerBean.setActualizacionDiaria(request.getParameter("rbActualizacionDiaria"));
		paramBrokerBean.setHoraActualizacion(request.getParameter("txtHoraActualizacion"));
		paramBrokerBean.setUsuario(request.getParameter("txtUsuario"));
		paramBrokerBean.setContrasenia(request.getParameter("txtContrasenia"));
		paramBrokerBean.setUrlConexion(request.getParameter("txtURLConexion"));
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		MensajeTransaccionBean mensaje = null;
		mensaje = pslParamBrokerServicio.grabaTransaccion(tipoTransaccion, paramBrokerBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public PSLParamBrokerServicio getPslParamBrokerServicio() {
		return pslParamBrokerServicio;
	}

	public void setPslParamBrokerServicio(
			PSLParamBrokerServicio pslParamBrokerServicio) {
		this.pslParamBrokerServicio = pslParamBrokerServicio;
	}
}
