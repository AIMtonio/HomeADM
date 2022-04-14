package cuentas.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.BloqueoSaldoBean;
import cuentas.servicio.BloqueoSaldoServicio;;

public class BloqueoSaldoPetControlador extends SimpleFormController {
	BloqueoSaldoServicio bloqueoSaldoServicio = null;


 	public BloqueoSaldoPetControlador(){
 		setCommandClass(BloqueoSaldoBean.class);
 		setCommandName("bloqueoSaldoPet");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 	
 		bloqueoSaldoServicio.getBloqueoSaldoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		BloqueoSaldoBean bloqueoSaldoBean = (BloqueoSaldoBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
 		String lisDesbloq = (request.getParameter("lisDesbloq")!=null) ? request.getParameter("lisDesbloq") : Constantes.STRING_VACIO;
 		String lisCuentas = (request.getParameter("lisCuentas")!=null) ? request.getParameter("lisCuentas") : Constantes.STRING_VACIO;
		String lisDescrip = (request.getParameter("lisDesc")!=null) ? request.getParameter("lisDesc") : Constantes.STRING_VACIO;
		String lisTipoD = (request.getParameter("lisTipoD")!=null) ? request.getParameter("lisTipoD") : Constantes.STRING_VACIO;
		String lisMonto = (request.getParameter("lisMonto")!=null) ? request.getParameter("lisMonto") : Constantes.STRING_VACIO;
		bloqueoSaldoBean.setClaveUsuAuto((request.getParameter("claveUsuarioAut")!=null) ? request.getParameter("claveUsuarioAut") : Constantes.STRING_VACIO);
		bloqueoSaldoBean.setContraseniaUsu((request.getParameter("contraseniaAut")!=null) ? request.getParameter("contraseniaAut") : Constantes.STRING_VACIO);
		bloqueoSaldoBean.setSucursalID((request.getParameter("sucursalID")!=null) ? request.getParameter("sucursalID") : Constantes.STRING_VACIO);
		bloqueoSaldoBean.setCajaID((request.getParameter("cajaID")!=null) ? request.getParameter("cajaID") : Constantes.STRING_VACIO);
		MensajeTransaccionBean mensaje = null;
 		mensaje = bloqueoSaldoServicio.grabaTransaccion(tipoTransaccion, bloqueoSaldoBean, lisDesbloq, lisCuentas, lisDescrip, lisTipoD, lisMonto );
  
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}
 	
 	public void setBloqueoSaldoServicio(BloqueoSaldoServicio bloqueoSaldoServicio){
 		this.bloqueoSaldoServicio = bloqueoSaldoServicio;
 	}
 		
}
