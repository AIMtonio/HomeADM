package regulatorios.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA1713Bean;
import regulatorios.servicio.RegulatorioA1713Servicio;

public class RegulatorioA1713GridControlador extends AbstractCommandController{
	RegulatorioA1713Servicio	regulatorioA1713Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RegulatorioA1713GridControlador() {
		setCommandClass(RegulatorioA1713Bean.class);
		setCommandName("regulatorioA1713");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		RegulatorioA1713Bean regulatorioA1713Bean = (RegulatorioA1713Bean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = regulatorioA1713Servicio.lista(tipoLista, regulatorioA1713Bean);

		return new ModelAndView("regulatorios/regulatorioA1713GridVista", "listaResultado", listaResultado);
	}
//------------------setter-------------
	public void setRegulatorioA1713Servicio(
			RegulatorioA1713Servicio regulatorioA1713Servicio) {
		this.regulatorioA1713Servicio = regulatorioA1713Servicio;
	}
	
	
}