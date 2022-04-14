package regulatorios.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioC0922Bean;
import regulatorios.servicio.RegulatorioC0922Servicio;

public class RegulatorioC0922GridControlador extends AbstractCommandController{
	RegulatorioC0922Servicio	regulatorioC0922Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RegulatorioC0922GridControlador() {
		setCommandClass(RegulatorioC0922Bean.class);
		setCommandName("regulatorioC0922");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		RegulatorioC0922Bean regulatorioC0922Bean = (RegulatorioC0922Bean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = regulatorioC0922Servicio.lista(tipoLista, regulatorioC0922Bean);

		return new ModelAndView("regulatorios/regulatorioC0922GridVista", "listaResultado", listaResultado);
	}
//------------------setter-------------
	public void setRegulatorioC0922Servicio(
			RegulatorioC0922Servicio regulatorioC0922Servicio) {
		this.regulatorioC0922Servicio = regulatorioC0922Servicio;
	}
	
	
}