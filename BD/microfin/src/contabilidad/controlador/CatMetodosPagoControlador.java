package contabilidad.controlador;


import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.CatMetodosPagoBean;
import contabilidad.servicio.CatMetodosPagoServicio;

public class CatMetodosPagoControlador extends SimpleFormController {
	
	CatMetodosPagoServicio	catMetodosPagoServicio	= null;
	
	public CatMetodosPagoControlador() {
		setCommandClass(CatMetodosPagoBean.class);
		setCommandName("metodosPago");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			
			catMetodosPagoServicio.getCatMetodosPagoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			CatMetodosPagoBean catMetodosPagoBean = (CatMetodosPagoBean) command;
			
			mensaje = catMetodosPagoServicio.grabaTransaccion(tipoTransaccion, catMetodosPagoBean);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje=new MensajeTransaccionBean();
			mensaje.setNumero(800);
			mensaje.setDescripcion("No se pudo realizar la operación ha ocurrido un error.");
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CatMetodosPagoServicio getCatMetodosPagoServicio() {
		return catMetodosPagoServicio;
	}

	public void setCatMetodosPagoServicio(
			CatMetodosPagoServicio catMetodosPagoServicio) {
		this.catMetodosPagoServicio = catMetodosPagoServicio;
	}

	

	

}
