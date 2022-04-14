package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.GruposFamiliarBean;
import aportaciones.servicio.GruposFamiliarServicio;

public class GruposFamiliarControlador extends SimpleFormController{
	
	GruposFamiliarServicio gruposFamiliarServicio;
	
	public GruposFamiliarControlador(){
		setCommandClass(GruposFamiliarBean.class);
		setCommandName("gruposFamiliarBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		GruposFamiliarBean gruposFamiliarBean = (GruposFamiliarBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			gruposFamiliarServicio.getGruposFamiliarDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = gruposFamiliarServicio.grabaTransaccion(tipoTransaccion, gruposFamiliarBean);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar el Grupo.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GruposFamiliarServicio getGruposFamiliarServicio() {
		return gruposFamiliarServicio;
	}

	public void setGruposFamiliarServicio(
			GruposFamiliarServicio gruposFamiliarServicio) {
		this.gruposFamiliarServicio = gruposFamiliarServicio;
	}

}