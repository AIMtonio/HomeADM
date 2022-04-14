package contabilidad.controlador;


import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.CatIngresosEgresosBean;
import contabilidad.servicio.CatIngresosEgresosServicio;
public class CatIngresosEgresosControlador extends SimpleFormController {
	
	CatIngresosEgresosServicio	catIngresosEgresosServicio	= null;
	
	public CatIngresosEgresosControlador() {
		setCommandClass(CatIngresosEgresosBean.class);
		setCommandName("catalogos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			
			catIngresosEgresosServicio.getCatIngresosEgresosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			CatIngresosEgresosBean catIngresosEgresosBean = (CatIngresosEgresosBean) command;
			
			mensaje = catIngresosEgresosServicio.grabaTransaccion(tipoTransaccion, catIngresosEgresosBean);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje=new MensajeTransaccionBean();
			mensaje.setNumero(800);
			mensaje.setDescripcion("No se pudo realizar la operación ha ocurrido un error.");
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CatIngresosEgresosServicio getCatIngresosEgresosServicio() {
		return catIngresosEgresosServicio;
	}

	public void setCatIngresosEgresosServicio(
			CatIngresosEgresosServicio catIngresosEgresosServicio) {
		this.catIngresosEgresosServicio = catIngresosEgresosServicio;
	}
	

}
