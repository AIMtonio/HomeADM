package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import nomina.bean.ConvenioNominaBean;
import nomina.servicio.BitacoraConveniosNominaServicio;

public class BitacoraCambiosInstitNomControlador extends SimpleFormController {

	private BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio;

	public BitacoraCambiosInstitNomControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;
		ConvenioNominaBean convenioNominaBean = (ConvenioNominaBean) command;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BitacoraConveniosNominaServicio getBitacoraConveniosNominaServicio() {
		return bitacoraConveniosNominaServicio;
	}

	public void setBitacoraConveniosNominaServicio(BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio) {
		this.bitacoraConveniosNominaServicio = bitacoraConveniosNominaServicio;
	}
}
