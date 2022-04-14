package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AsignaCartaLiqBean;
import originacion.servicio.AsignaCartaLiqServicio;

public class AsignaCartaLiqControlador extends SimpleFormController{
	AsignaCartaLiqServicio asignaCartaLiqServicio;
	
	public AsignaCartaLiqControlador(){
		setCommandClass(AsignaCartaLiqBean.class);
		setCommandName("asignaCarta");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		AsignaCartaLiqBean cartaLiqBean = (AsignaCartaLiqBean) command;
		MensajeTransaccionBean mensaje = null;
		String detalleCartas = null;
		try{
			
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			detalleCartas = (tipoTransaccion>2)? request.getParameter("detalleCartas"): "";
			
			asignaCartaLiqServicio.getAsignaCartaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = asignaCartaLiqServicio.grabaTransaccion(tipoTransaccion, cartaLiqBean, detalleCartas);
			
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar las Cartas de Liquidacion.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public AsignaCartaLiqServicio getAsignaCartaLiqServicio(){
		return asignaCartaLiqServicio;
	}
	
	public void setAsignaCartaLiqServicio(AsignaCartaLiqServicio asignaCartaLiqServicio){
		this.asignaCartaLiqServicio = asignaCartaLiqServicio;
	}
}
