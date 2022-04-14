package tesoreria.servicio;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import tesoreria.bean.ResOrdPagoSantaBean;
import tesoreria.dao.ResOrdPagoSantaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class ResOrdPagoSantaServicio extends BaseServicio {
	ResOrdPagoSantaDAO resOrdPagoSantaDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	public static interface Enum_Tra_CuentaSantander {
		int respuestaOrdPago = 1;
	}
	
	public static interface Enum_Con_ResOrdenPago{
		int principal = 1;
	}
	
	public static interface Enum_Con_ArchivosSantander{
		int	cargaArchivoCtasActivas= 1; 		// Cuentas activas santander
		int	cargaArchivoCtasPendientes= 2; 		// Cuentas activas santander
		int	cargaArchivoTransferSantan=3;		// Carga de archivo de transferencia
		int	cargaArchivoOrdenPago=4;			// Carga archivo Orden de pago
	}
	
	
	
	public MensajeTransaccionBean grabaResOrdPagoSantander(int tipoTransaccion,ResOrdPagoSantaBean resOrdPagoSantaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_CuentaSantander.respuestaOrdPago:
			mensaje = ProcesaArchivoRes(resOrdPagoSantaBean);
			break;
		}

		return mensaje;
	}

	public synchronized MensajeTransaccionBean ProcesaArchivoRes(final ResOrdPagoSantaBean resOrdPagoSantaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			// VALIDAMOS LA CONFIGURACION ARCHIVO PROPETIES
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			paramGeneralesBean = paramGeneralesServicio.consulta(44,paramGeneralesBean);

			if (paramGeneralesBean.getValorParametro() == null || paramGeneralesBean.getValorParametro() == "") {
				mensaje.setNumero(800);
				mensaje.setDescripcion("El SAFI ha tenido un problema al concretar la operación."
										+ " Favor de revisar la Configuración de <b>Conexión</b>");

				Utileria.borraArchivo(resOrdPagoSantaBean.getRutaArchivo());
				throw new Exception(mensaje.getDescripcion());
			}

			mensaje = resOrdPagoSantaDAO.procesaArchivoTransfer(resOrdPagoSantaBean,paramGeneralesBean.getValorParametro());

			if (mensaje.getNumero() != 0) {
				throw new Exception(mensaje.getDescripcion());
			}

		} catch (Exception e) {
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error en Proceso el archivo");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-"
					+ "error en Proceso el archivo", e);
		}

		return mensaje;
	}
	
	
	public ResOrdPagoSantaBean consulta(ResOrdPagoSantaBean resOrdPagoSantaBean, int tipoConsulta){
		ResOrdPagoSantaBean resOrdPagoSanta = null;
		switch(tipoConsulta){
			case Enum_Con_ResOrdenPago.principal:
				resOrdPagoSanta = resOrdPagoSantaDAO.consultaPrincipal(resOrdPagoSantaBean,tipoConsulta);
			break;		
		}
		return resOrdPagoSanta;
	}
	
	public ResOrdPagoSantaBean consultaArchvio(ResOrdPagoSantaBean resOrdPagoSantaBean, int tipoConsulta){
		ResOrdPagoSantaBean resOrdPagoSanta = null;
		resOrdPagoSanta = resOrdPagoSantaDAO.consultaArchivo(resOrdPagoSantaBean,tipoConsulta);
		return resOrdPagoSanta;
	}
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public ResOrdPagoSantaDAO getResOrdPagoSantaDAO() {
		return resOrdPagoSantaDAO;
	}

	public void setResOrdPagoSantaDAO(ResOrdPagoSantaDAO resOrdPagoSantaDAO) {
		this.resOrdPagoSantaDAO = resOrdPagoSantaDAO;
	}

}
