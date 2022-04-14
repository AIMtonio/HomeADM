package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.CorreoServicio;
import soporte.servicio.GeneralServicio;
import soporte.servicio.ParametrosSisServicio;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class CierreDiaControlador extends SimpleFormController {

	GeneralServicio generalServicio = null;
	ParametrosSisServicio parametrosSisServicio = new ParametrosSisServicio();
	CreditosServicio creditosServicio = null;
	private CorreoServicio correoServicio = null;
	String nombreReporte = null;
	String successView = null;

	public CierreDiaControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("usuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeCobranza = null;
		MensajeTransaccionBean mensajeCobranzaRefe = null;
		CreditosBean creditosBean =new CreditosBean();
		
		int tipoConsulta = 1;
		String numEmpresa = "1";
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID(numEmpresa);
		parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);
		String cobranzaAutomatica = parametrosSisBean.getCobranzaAutCie();
		String cobranzaAutomaticaRefe = parametrosSisBean.getCobranzaxReferencia();
		//Se evalua si se realiza el cierre aut. para Pago x Referencia.
		// Primero se ejecuta el cierre de Pago x Referencia que toma el saldo bloqueado para este caso de cada Cta.
		if (cobranzaAutomaticaRefe.equals("S")) {
			creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma("CierreDiaControlador");
			CreditosBean bean=new CreditosBean();
			bean.setFecha(parametrosSisBean.getFechaSistema());
			mensajeCobranzaRefe = creditosServicio.realizaCobranzaAutomaticaReferencia(bean);
			if (mensajeCobranzaRefe.getNumero()!=0) {
				return new ModelAndView(getSuccessView(), "mensaje", mensajeCobranzaRefe);
			}
		}

		// Se realiza la evalución del parámetro CobranzaAutCie para saber si se va a
		// ejecutar la cobranza automática antes del cierre.
		if (cobranzaAutomatica.equals("S")) {
			creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma("CobranzaAutomaticaControlador");
			
			creditosBean.setCobranzaCierre("S");
			// Se ejecuta la cobranza automática
			mensajeCobranza = creditosServicio.realizaCobranzaAutomatica(creditosBean);
			
			// Si la cobranza se ejecuta de manera exitosa, se procede con la ejecución de
			if (mensajeCobranza.getNumero()!=0) {
				return new ModelAndView(getSuccessView(), "mensaje", mensajeCobranza);
			}
		} 
			
		//Se Ejecuta el cierre de día una vez finalizado los cierres automaticos para pagos.
		mensaje = generalServicio.cerrarDia();
		//Se Ejecuta el envio de corre
		try {
			//No quitar este try con esto se controla si hay error en el envio continua con la operacion
			correoServicio.EjecutaEnvioCorreo();//Ejecuta el envio de correo
		} catch (Exception exa) {
			exa.printStackTrace();
		}

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	// Getters y Setters
	public void setGeneralServicio(GeneralServicio generalServicio) {
		this.generalServicio = generalServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

}
