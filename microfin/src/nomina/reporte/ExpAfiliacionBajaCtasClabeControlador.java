package nomina.reporte;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.AfiliacionBajaCtasClabeBean;
import nomina.servicio.AfiliacionBajaCtasClabeServicio;


public class ExpAfiliacionBajaCtasClabeControlador  extends AbstractCommandController {
AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
	
	public ExpAfiliacionBajaCtasClabeControlador(){
		setCommandClass(AfiliacionBajaCtasClabeBean.class);
		setCommandName("afiliacionBajaCtasClabe");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {
		
			afiliacionBajaCtasClabeServicio.getAfiliacionBajaCtasClabeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			int folioAfiliacion =(request.getParameter("consecutivo")!=null) ?
					Integer.parseInt(request.getParameter("consecutivo")): 0;
			

			List listaResultado = new ArrayList();
			PagedListHolder listaAfilia;
			listaResultado = (List) request.getSession().getAttribute("listaAfilia");
			listaAfilia = (PagedListHolder) listaResultado.get(0);
			
			List listaGuarda = listaAfilia.getSource();
           System.out.println("entro aca");

			afiliacionBajaCtasClabeServicio.generaLayout(listaGuarda,folioAfiliacion,response);

		return null;
	}

	public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
		return afiliacionBajaCtasClabeServicio;
	}

	public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
		this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
	}

}
