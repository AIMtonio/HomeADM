package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.EsquemaComisionCreBean;
import credito.servicio.EsquemaComisionCreServicio;

public class EsquemaComsionCreControlador  extends SimpleFormController {
	
private EsquemaComisionCreServicio esquemaComisionCreServicio;
	
	public EsquemaComsionCreControlador() {
		setCommandClass(EsquemaComisionCreBean.class);
		setCommandName("esquemaComisionCreBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		EsquemaComisionCreBean esquemaComisionCreBean = (EsquemaComisionCreBean) command;
		
		esquemaComisionCreServicio.getEsquemaComisionCreDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
					int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
					String datosGrid = request.getParameter("datosGrid");	
					
					MensajeTransaccionBean mensaje = null;
					mensaje = esquemaComisionCreServicio.grabaTransaccion(tipoTransaccion, esquemaComisionCreBean,datosGrid);
					
							
					return new ModelAndView(getSuccessView(), "mensaje", mensaje);
				}
	public EsquemaComisionCreServicio getEsquemaComisionCreServicio() {
		return esquemaComisionCreServicio;
	}
	public void setEsquemaComisionCreServicio(
			EsquemaComisionCreServicio esquemaComisionCreServicio) {
		this.esquemaComisionCreServicio = esquemaComisionCreServicio;
	}
	
	

}
