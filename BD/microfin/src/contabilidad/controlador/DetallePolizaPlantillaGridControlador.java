package contabilidad.controlador;
import herramientas.Constantes;
import herramientas.Utileria;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.DetallePolizaBean;
import contabilidad.servicio.DetallePolizaServicio;
public class DetallePolizaPlantillaGridControlador extends AbstractCommandController{
		
	DetallePolizaServicio detallePolizaServicio = null;
	public DetallePolizaPlantillaGridControlador() {
		setCommandClass(DetallePolizaBean.class);
		setCommandName("detallePoliza");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		DetallePolizaBean detallePoliza = (DetallePolizaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List detallePolizaList = detallePolizaServicio.lista(tipoLista, detallePoliza);
	
		return new ModelAndView("contabilidad/detallePolizaPlantillaGridVista", "listaResultado", detallePolizaList);
	}

	public void setDetallePolizaServicio(DetallePolizaServicio detallePolizaServicio) {
		this.detallePolizaServicio = detallePolizaServicio;
	}
}

