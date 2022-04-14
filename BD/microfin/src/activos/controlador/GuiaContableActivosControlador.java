package activos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.CuentaMayorActivosBean;
import activos.servicio.GuiaContableActivosServicio;

public class GuiaContableActivosControlador extends SimpleFormController {

	private GuiaContableActivosServicio guiaContableActivosServicio = null;

	public GuiaContableActivosControlador(){
		setCommandClass(CuentaMayorActivosBean.class);
		setCommandName("cuentaMayorActivosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		guiaContableActivosServicio.getGuiaContableActivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		CuentaMayorActivosBean cuentaMayorActivosBean =(CuentaMayorActivosBean)command;
		MensajeTransaccionBean mensaje = null;

		int tipoTransaccion = 0;
		int tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)? Integer.parseInt(request.getParameter("tipoTransaccionCM")):	0;
		int tipoTransaccionSC = (request.getParameter("tipoTransaccionSC")!=null)? Integer.parseInt(request.getParameter("tipoTransaccionSC")):	0;
		int tipoTransaccionCA = (request.getParameter("tipoTransaccionCA")!=null)? Integer.parseInt(request.getParameter("tipoTransaccionCA")):	0;

		if( tipoTransaccionCM == GuiaContableActivosServicio.Enum_Trans_GuiaConta.altaCtaMayor ||
			tipoTransaccionCM == GuiaContableActivosServicio.Enum_Trans_GuiaConta.modificaCtaMayor ||
			tipoTransaccionCM == GuiaContableActivosServicio.Enum_Trans_GuiaConta.eliminaCtaMayor ){
			tipoTransaccion = tipoTransaccionCM;
		}

		if( tipoTransaccionSC == GuiaContableActivosServicio.Enum_Trans_GuiaConta.altaSubCta ||
			tipoTransaccionSC == GuiaContableActivosServicio.Enum_Trans_GuiaConta.modificaSubCta ||
			tipoTransaccionSC == GuiaContableActivosServicio.Enum_Trans_GuiaConta.eliminaSubCta ){
			tipoTransaccion = tipoTransaccionSC;
			cuentaMayorActivosBean.setConceptoActivoID(request.getParameter("conceptoActivoID2"));
		}

		if( tipoTransaccionCA == GuiaContableActivosServicio.Enum_Trans_GuiaConta.altaClaAct ||
			tipoTransaccionCA == GuiaContableActivosServicio.Enum_Trans_GuiaConta.modificaClaAct ||
			tipoTransaccionCA == GuiaContableActivosServicio.Enum_Trans_GuiaConta.eliminaClaAct ){
			cuentaMayorActivosBean.setTipoActivoID(request.getParameter("tipoActivoID3"));
			cuentaMayorActivosBean.setSubCuenta(request.getParameter("subCuenta3"));
			cuentaMayorActivosBean.setConceptoActivoID(request.getParameter("conceptoActivoID3"));
			tipoTransaccion = tipoTransaccionCA;
		}

		mensaje = guiaContableActivosServicio.grabaTransaccion(tipoTransaccion, cuentaMayorActivosBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableActivosServicio getGuiaContableActivosServicio() {
		return guiaContableActivosServicio;
	}

	public void setGuiaContableActivosServicio(
			GuiaContableActivosServicio guiaContableActivosServicio) {
		this.guiaContableActivosServicio = guiaContableActivosServicio;
	}
}
