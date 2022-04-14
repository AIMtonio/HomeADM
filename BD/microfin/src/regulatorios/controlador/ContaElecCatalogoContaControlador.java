package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.ContaElecCatalogoContaBean;
import regulatorios.servicio.ContaElecCatalogoContaServicio;


	public class ContaElecCatalogoContaControlador extends SimpleFormController {
		
		ContaElecCatalogoContaServicio contaElecCatalogoContaServicio = null;
		public ContaElecCatalogoContaControlador() {
			setCommandClass(ContaElecCatalogoContaBean.class);
			setCommandName("ArchivoCatalogo");
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

											
			return new ModelAndView(getSuccessView());
		}

		public ContaElecCatalogoContaServicio getContaElecCatalogoContaServicio() {
			return contaElecCatalogoContaServicio;
		}

		public void setContaElecCatalogoContaServicio(
				ContaElecCatalogoContaServicio contaElecCatalogoContaServicio) {
			this.contaElecCatalogoContaServicio = contaElecCatalogoContaServicio;
		}


		
	}
