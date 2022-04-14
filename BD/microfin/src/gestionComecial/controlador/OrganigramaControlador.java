package gestionComecial.controlador;

import general.bean.MensajeTransaccionBean;
import gestionComecial.bean.EmpleadosBean;
import gestionComecial.bean.OrganigramaBean;
import gestionComecial.servicio.EmpleadosServicio;
import gestionComecial.servicio.OrganigramaServicio;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasFirmaBean;
import cuentas.servicio.CuentasFirmaServicio;

import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.servicio.PresupSucursalServicio;

public class OrganigramaControlador extends SimpleFormController {

 	OrganigramaServicio organigramaServicio = null;

 	public OrganigramaControlador(){
 		setCommandClass(OrganigramaBean.class);
 		setCommandName("organigrama");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		OrganigramaBean organigramaBean = (OrganigramaBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;

		String organigramaDetalle = request.getParameter("dependencias");
		
 		MensajeTransaccionBean mensaje = null;
 	
 		
 		mensaje = organigramaServicio.grabaListaOrganigrama(tipoTransaccion, organigramaBean, organigramaDetalle);
 				return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setOrganigramaServicio(OrganigramaServicio organigramaServicio){
                     this.organigramaServicio = organigramaServicio;
 	}
 } 
