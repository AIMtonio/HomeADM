package tesoreria.controlador;


import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tesoreria.bean.CuentasAhoSucBean;
import tesoreria.servicio.CuentasAhoSucServicio;

public class CuentasAhoSucControlador extends SimpleFormController{

	CuentasAhoSucServicio cuentasAhoSucServicio = null;

	public CuentasAhoSucControlador(){
		setCommandClass(CuentasAhoSucBean.class);
		setCommandName("cuentasAhoSucur"); 
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		cuentasAhoSucServicio.getcuentasAhoSucDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CuentasAhoSucBean cuentasAhoSucBean = (CuentasAhoSucBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoSucServicio.grabaTransaccion(tipoTransaccion, cuentasAhoSucBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setCuentasAhoSucServicio(CuentasAhoSucServicio cuentasAhoSucServicio){
		this.cuentasAhoSucServicio =  cuentasAhoSucServicio;
	}
}
