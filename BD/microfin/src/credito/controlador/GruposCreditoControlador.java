package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.GruposCreditoBean;
import credito.servicio.GruposCreditoServicio;

public class GruposCreditoControlador extends SimpleFormController{
	

	private GruposCreditoServicio gruposCreditoServicio;
	
	public GruposCreditoControlador() {
		setCommandClass(GruposCreditoBean.class);
		setCommandName("gruposDeCredito");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		GruposCreditoBean gruposCredito = (GruposCreditoBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!="")?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;
		
		gruposCredito.setEsAgropecuario("N");
		gruposCredito.setTipoOperacion("");
		
		MensajeTransaccionBean mensaje = null;
		mensaje = gruposCreditoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, gruposCredito);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public GruposCreditoServicio getGruposCreditoServicio() {
		return gruposCreditoServicio;
	}
	public void setGruposCreditoServicio(GruposCreditoServicio gruposCreditoServicio) {
		this.gruposCreditoServicio = gruposCreditoServicio;
	}
		
	
}

