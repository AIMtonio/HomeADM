package nomina.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ConvenioNominaBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CrearFromulaClaveControlador extends SimpleFormController{
	
	public CrearFromulaClaveControlador(){
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		ConvenioNominaBean convenioNomina = (ConvenioNominaBean) command;
		
		String control = request.getParameter("control");
		String formula = request.getParameter("formula");
		String desFormula = request.getParameter("desFormula");
		
		mensaje.setNombreControl(control);
		mensaje.setNumero(Constantes.CODIGO_SIN_ERROR);
		mensaje.setDescripcion("Formula Agregada Exitosamente");
		mensaje.setRecursoOrigen(formula);
		mensaje.setConsecutivoString(desFormula);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
