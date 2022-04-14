package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClavePresupBean;
import nomina.servicio.NomClavePresupServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class NomClavePresupControlador extends SimpleFormController{
	NomClavePresupServicio nomClavePresupServicio = null;
		
	public NomClavePresupControlador(){
		setCommandClass(NomClavePresupBean.class);
		setCommandName("nomClavePresupBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		//Establecemos el Parametro de Auditoria del Nombre del Programa
		nomClavePresupServicio.getNomClavePresupDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;

		NomClavePresupBean clavesPresup = (NomClavePresupBean) command;
				
		String[] clavePresupID = request.getParameterValues("nomClavePresupID");
		String[] tipoClavePresupID = request.getParameterValues("tipoClavePresupID");
		String[] desClavePresup    = request.getParameterValues("descripcion");
		String[] clavePresup  = request.getParameterValues("clave");
		
		String strClavesPresupBaj = request.getParameter("clavesPresupBaj");
		String[] clavesPresupBaj = (Constantes.STRING_VACIO.equals(strClavesPresupBaj)?null:strClavesPresupBaj.split(","));
		String strClavesPresupMod = request.getParameter("clavesPresupMod");
		String[] clavesPresupMod = (Constantes.STRING_VACIO.equals(strClavesPresupMod)?null:strClavesPresupMod.split(","));
		
		clavesPresup.setClavesPresupID(clavePresupID);
		clavesPresup.setTiposClavePresupID(tipoClavePresupID);
		clavesPresup.setDesClavePresup(desClavePresup);
		clavesPresup.setClavePresup(clavePresup);
		
		clavesPresup.setNomClavePresupModID(clavesPresupMod);
		clavesPresup.setNomClavePresupBajID(clavesPresupBaj);
		
		clavesPresup.setNomClasifClavPresupID(request.getParameter("nomClasifClavPresup"));
		
		System.out.println("clavesPresupBaj:" + strClavesPresupBaj);
		System.out.println("clavesPresupMod:" + strClavesPresupMod);

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
		
		mensaje = nomClavePresupServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, clavesPresup);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}

	public NomClavePresupServicio getNomClavePresupServicio() {
		return nomClavePresupServicio;
	}

	public void setNomClavePresupServicio(
			NomClavePresupServicio nomClavePresupServicio) {
		this.nomClavePresupServicio = nomClavePresupServicio;
	}

}
