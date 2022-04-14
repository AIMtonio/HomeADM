package sms.controlador;

import java.text.SimpleDateFormat;
import java.util.Date;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.servicio.ParametrosSMSServicio;
import sms.servicio.SMSEnvioMensajeServicio;

public class EnvioMasivoControlador extends SimpleFormController {
	
	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	ParametrosSMSServicio parametrosSMSServicio = null;
	
	public String opcAhora = "1";
	public String opcEnvioHora = "2";
	public String opcEnvioCalendar = "3";
	public String tipoEnvioRepetido = "R";
	public EnvioMasivoControlador(){
		setCommandClass(SMSEnvioMensajeBean.class);
		setCommandName("smsEnvioMensajeBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception{
		SMSEnvioMensajeBean smsEnvioMensaje = (SMSEnvioMensajeBean) command;
		smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		String listaFechas = request.getParameter("listaFechas");
		String numTransaccion = request.getParameter("numTrans");
		//Seteamos los valores del Bean SMSCONDICICARGABEAN
		SMSCondiciCargaBean smsCondiciCargaBean = new SMSCondiciCargaBean();
		smsCondiciCargaBean.setCampaniaID(request.getParameter("campaniaID"));
		smsCondiciCargaBean.setOpcionEnvio(request.getParameter("opcEnvio"));
		if (smsCondiciCargaBean.getOpcionEnvio().equals(opcAhora)){
			Date f= new Date();
			SimpleDateFormat formateador = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String fecha = formateador.format(f);
			smsEnvioMensaje.setFechaProgEnvio(fecha);
			smsCondiciCargaBean.setTipoEnvio(request.getParameter("tipoEnvio"));
		}
		if (smsCondiciCargaBean.getOpcionEnvio().equals(opcEnvioHora)){
			smsCondiciCargaBean.setFechaProgEnvio(request.getParameter("fechaEnvio")+" "+request.getParameter("horaEnvio"));
			smsCondiciCargaBean.setHoraPeriodicidad(request.getParameter("horaEnvio"));
			smsCondiciCargaBean.setTipoEnvio(request.getParameter("tipoEnvio"));
		}
		else if (smsCondiciCargaBean.getOpcionEnvio().equals(opcEnvioCalendar)){
			smsCondiciCargaBean.setFechaInicio(request.getParameter("fechaInicio") + " "+ request.getParameter("horaPeriodicidad"));
			smsCondiciCargaBean.setFechaFin(request.getParameter("fechaFin")+ " "+ request.getParameter("horaPeriodicidad"));
			smsCondiciCargaBean.setPeriodicidad(request.getParameter("periodicidad"));
			smsCondiciCargaBean.setHoraPeriodicidad(request.getParameter("horaPeriodicidad"));
			smsCondiciCargaBean.setFechaProgEnvio(Constantes.FECHA_VACIA);
			smsEnvioMensaje.setFechaProgEnvio(request.getParameter("horaPeriodicidad"));
			smsCondiciCargaBean.setTipoEnvio("0");
		}
		if (smsCondiciCargaBean.getTipoEnvio().equals(tipoEnvioRepetido)){
			smsCondiciCargaBean.setNumVeces(request.getParameter("noVeces"));
			smsCondiciCargaBean.setDistancia(request.getParameter("distancia"));
		}
		
		smsEnvioMensaje.setColMensaje(request.getParameter("rutahidden"));
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = smsEnvioMensajeServicio.grabaTransaccion(tipoTransaccion, smsEnvioMensaje, smsCondiciCargaBean, listaFechas, numTransaccion);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setParametrosSMSServicio(ParametrosSMSServicio parametrosSMSServicio) {
		this.parametrosSMSServicio = parametrosSMSServicio;
	}

	public void setSmsEnvioMensajeServicio(
			SMSEnvioMensajeServicio smsEnvioMensajeServicio) {
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}
}