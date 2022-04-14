package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ParamDiasFrecuenciaBean;
import originacion.servicio.ParamDiasFrecuenciaServicio;

public class ParamDiasFrecuenciaGridControlador extends SimpleFormController {
	
	ParamDiasFrecuenciaServicio paramDiasFrecuenciaServicio;
	
	public ParamDiasFrecuenciaGridControlador() {
		setCommandClass(ParamDiasFrecuenciaBean.class);
		setCommandName("paramDiasFrecuenciaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ParamDiasFrecuenciaBean referenciaClienteBean = (ParamDiasFrecuenciaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List<ParamDiasFrecuenciaBean> lista = paramDiasFrecuenciaServicio.lista(tipoLista, referenciaClienteBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public ParamDiasFrecuenciaServicio getParamDiasFrecuenciaServicio() {
		return paramDiasFrecuenciaServicio;
	}

	public void setParamDiasFrecuenciaServicio(ParamDiasFrecuenciaServicio paramDiasFrecuenciaServicio) {
		this.paramDiasFrecuenciaServicio = paramDiasFrecuenciaServicio;
	}

}
