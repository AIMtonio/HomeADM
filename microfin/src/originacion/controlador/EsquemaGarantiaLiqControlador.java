package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaGarantiaLiqBean;
import originacion.servicio.EsquemaGarantiaLiqServicio;

public class EsquemaGarantiaLiqControlador extends SimpleFormController{
	EsquemaGarantiaLiqServicio esquemaGarantiaLiqServicio = null;


	public EsquemaGarantiaLiqControlador() {
		setCommandClass(EsquemaGarantiaLiqBean.class); 
		setCommandName("esquemaGarantiaLiqBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		esquemaGarantiaLiqServicio.getEsquemaGarantiaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		EsquemaGarantiaLiqBean bean = (EsquemaGarantiaLiqBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = esquemaGarantiaLiqServicio.grabaTransaccion(tipoTransaccion,bean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	
	//* ============== GETTER & SETTER =============  //*

	public EsquemaGarantiaLiqServicio getEsquemaGarantiaLiqServicio() {
		return esquemaGarantiaLiqServicio;
	}
	public void setEsquemaGarantiaLiqServicio(
			EsquemaGarantiaLiqServicio esquemaGarantiaLiqServicio) {
		this.esquemaGarantiaLiqServicio = esquemaGarantiaLiqServicio;
	}

}
