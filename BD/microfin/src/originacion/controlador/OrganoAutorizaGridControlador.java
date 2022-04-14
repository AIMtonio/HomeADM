package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import originacion.bean.OrganoAutorizaBean;
import originacion.servicio.OrganoAutorizaServicio;

public class OrganoAutorizaGridControlador extends SimpleFormController {
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	OrganoAutorizaServicio organoAutorizaServicio = null;
	
	public OrganoAutorizaGridControlador() {
		setCommandClass(OrganoAutorizaBean.class);
		setCommandName("organoAutoriza");
	}
		
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response, Object command, BindException errors)
									throws Exception {
		
		OrganoAutorizaBean organoAutoriza = (OrganoAutorizaBean) command;
		organoAutorizaServicio.getOrganoAutorizaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		//El controlador es para la Lista del Grid
		if(request.getParameter("tipoLista")!= null){
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));			
			
			List listaOrganoAutoriza = organoAutorizaServicio.listaOrganoAutoriza(tipoLista, organoAutoriza);
			
			return new ModelAndView("originacion/esquemaOrganoAutorizaGridVista", "listaResultado", listaOrganoAutoriza);			
		}else{
			
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccionOrgano")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccionOrgano")):0;
			
			String datosAltaOrgano = (request.getParameter("datosGridOrganoAutoriza")!=null)?
									request.getParameter("datosGridOrganoAutoriza"):"";
					
			String datosBajaOrgano = (request.getParameter("datosGridBajaOrgano")!=null)?
									request.getParameter("datosGridBajaOrgano"):"";
									
			String datosModificaOrgano = (request.getParameter("datosGridModificaOrgano")!=null)?
									request.getParameter("datosGridModificaOrgano"):"";
			MensajeTransaccionBean mensaje = null;
			
			mensaje = organoAutorizaServicio.grabaTransaccion(tipoTransaccion,organoAutoriza,datosBajaOrgano,datosAltaOrgano,datosModificaOrgano);
			
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
	}
	
	//---------setter------------
	public void setOrganoAutorizaServicio(
			OrganoAutorizaServicio organoAutorizaServicio) {
		this.organoAutorizaServicio = organoAutorizaServicio;
	}



}
