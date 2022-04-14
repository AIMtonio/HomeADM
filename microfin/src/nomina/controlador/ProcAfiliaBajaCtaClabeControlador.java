package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.ProcAfiliaBajaCtaClabeBean;
import nomina.servicio.ProcAfiliaBajaCtaClabeServicio;

public class ProcAfiliaBajaCtaClabeControlador extends SimpleFormController{
	
	ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio = null;
	
	public ProcAfiliaBajaCtaClabeControlador() {
		setCommandClass(ProcAfiliaBajaCtaClabeBean.class);
		setCommandName("procAfiliaBajaCtaClabeBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean = (ProcAfiliaBajaCtaClabeBean) command;
		
		MensajeTransaccionBean mensaje = null;
		
		procAfiliaBajaCtaClabeServicio.getProcAfiliaBajaCtaClabeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		List listaResultado = new ArrayList();
		
		PagedListHolder afiliacionList;
		
		listaResultado = (List) request.getSession().getAttribute("afiliacionList");
		afiliacionList = (PagedListHolder) listaResultado.get(0);

		List listaProcesar = afiliacionList.getSource();
		
		mensaje = procAfiliaBajaCtaClabeServicio.grabaTransaccion(tipoTransaccion,listaProcesar);
		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// ============== GETTER & SETTER ============= //
	
	public ProcAfiliaBajaCtaClabeServicio getProcAfiliaBajaCtaClabeServicio() {
		return procAfiliaBajaCtaClabeServicio;
	}

	public void setProcAfiliaBajaCtaClabeServicio(ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio) {
		this.procAfiliaBajaCtaClabeServicio = procAfiliaBajaCtaClabeServicio;
	}
}
