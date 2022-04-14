package nomina.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;
import nomina.bean.AfiliacionBajaCtasClabeBean;
import nomina.servicio.AfiliacionBajaCtasClabeServicio;


public class AfiliacionBajaCtasClabeControlador extends SimpleFormController {
	public AfiliacionBajaCtasClabeControlador(){
		setCommandClass(AfiliacionBajaCtasClabeBean.class);
		setCommandName("afiliacionBajaCtasClabe");
	}
	AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {
		afiliacionBajaCtasClabeServicio.getAfiliacionBajaCtasClabeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) command;
		MensajeTransaccionBean mensaje = null;
		
		List listaResultado = new ArrayList();
		PagedListHolder listaAfilia;
		listaResultado = (List) request.getSession().getAttribute("listaAfilia");
		listaAfilia = (PagedListHolder) listaResultado.get(0);
		
		List listaGuarda = listaAfilia.getSource();
		
		mensaje = afiliacionBajaCtasClabeServicio.grabaTransaccion(tipoTransaccion, listaGuarda);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}

	public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
		return afiliacionBajaCtasClabeServicio;
	}

	public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
		this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
	}
	
}
