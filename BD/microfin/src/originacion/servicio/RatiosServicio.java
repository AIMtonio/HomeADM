package originacion.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import originacion.bean.RatiosBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.dao.RatiosDAO;
import originacion.dao.SolicitudCreditoDAO;
import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolCredito;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class RatiosServicio extends BaseServicio {
	RatiosDAO	ratiosDAO	= null;
	SolicitudCreditoDAO solicitudCreditoDAO = null;
	
	public static interface Enum_Tra_Ratios {
		int	calcular	= 1;
		int	guardar		= 2;
		int	regresar	= 3;
		int	rechazar	= 4;
		int	procesar	= 5;
	}
	
	public static interface Enum_Lis_Ratios {
		int	listaPorConcepto	= 2;
	}
	
	public static interface Enum_Con_Ratios {
		int	principal		= 1;
		int	consultaGeneral	= 2;
		int navales			= 3;
	}
	
	/**
	 * Método para procesar lastransacciones de la pantalla de ratios
	 * @param tipoTransaccion Numero de transaccion
	 * @param ratiosBean Bean con los datos para el procesamiento de la transaccion
	 * @return MensajeTransaccionBean con el mensaje de exito o error de la operacion
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RatiosBean ratiosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		SolicitudCreditoBean solicitudCredito=new SolicitudCreditoBean();
		solicitudCredito.setSolicitudCreditoID(ratiosBean.getSolicitudCreditoID());
		solicitudCredito.setComentarioEjecutivo(ratiosBean.getMotivo());
		switch (tipoTransaccion) {
			case Enum_Tra_Ratios.calcular:
				mensaje = ratiosDAO.calculoRatios(ratiosBean, tipoTransaccion);
				break;
			case Enum_Tra_Ratios.guardar:
				mensaje = ratiosDAO.calculoRatios(ratiosBean, tipoTransaccion);
				break;
			case Enum_Tra_Ratios.regresar:
				mensaje=solicitudCreditoDAO.regresarEjecSolicitudCredito(solicitudCredito, Enum_Act_SolCredito.regresarEjec);
				if(mensaje.getNumero()==0){
					mensaje = ratiosDAO.actualizar(ratiosBean, tipoTransaccion);
				}
				break;
			case Enum_Tra_Ratios.procesar:
				mensaje=solicitudCreditoDAO.actComentarioEjecutivo(solicitudCredito, Enum_Act_SolCredito.actComntEjecu);
				if(mensaje.getNumero()==0){
					mensaje = ratiosDAO.actualizar(ratiosBean, tipoTransaccion);
				}
				break;
			case Enum_Tra_Ratios.rechazar:
				mensaje=solicitudCreditoDAO.rechazarSolicitudCredito(solicitudCredito, Enum_Act_SolCredito.rechazar);
				if(mensaje.getNumero()==0){
					mensaje = ratiosDAO.actualizar(ratiosBean, tipoTransaccion);
				}
				break;
		}
		return mensaje;
	}
	
	/**
	 * Lista para el combobox
	 * @param tipoLista
	 * @param ratiosBean
	 * @return
	 */
	public Object[] listaCombo(int tipoLista, RatiosBean ratiosBean) {
		List listaCreditos = null;
		
		switch (tipoLista) {
			case Enum_Lis_Ratios.listaPorConcepto:
				listaCreditos = ratiosDAO.listaPorConcepto(ratiosBean, tipoLista);
				break;
		}
		return listaCreditos.toArray();
	}
	
	/**
	 * Metodo de consulta de ratios
	 * @param tipoConsulta Numero de Consulta
	 * @param ratiosBean Bean con la informacion para realizar la consulta de ratios
	 * @return
	 */
	public RatiosBean consulta(int tipoConsulta, RatiosBean ratiosBean) {
		RatiosBean ratios = null;
		switch (tipoConsulta) {
			case Enum_Con_Ratios.principal:
				ratios = ratiosDAO.consultaRatios(ratiosBean, tipoConsulta);
				break;
			case Enum_Con_Ratios.consultaGeneral:
				ratios = ratiosDAO.consultaDatosGenerales(ratiosBean, tipoConsulta);
				break;
			case Enum_Con_Ratios.navales:
				ratios = ratiosDAO.consultaNAvales(ratiosBean, tipoConsulta);
				break;
		}
		return ratios;
	}
	
	/**
	 * Reporte de Calculo de Ratios se llama en la pantalla de Ratios
	 * @param ratiosBean RatiosBean Bean con la información para generar el reporte
	 * @param nombreReporte Ruta del reporte
	 * @return retorna ByteArrayOutputStream con el PDF del reporte
	 * @throws Exception
	 */
	public ByteArrayOutputStream imprimeCalculoRatios(RatiosBean ratiosBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SolicitudCreditoID", Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()));
		parametrosReporte.agregaParametro("Par_Usuario",ratiosBean.getUsuarioClave());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public RatiosDAO getRatiosDAO() {
		return ratiosDAO;
	}
	
	public void setRatiosDAO(RatiosDAO ratiosDAO) {
		this.ratiosDAO = ratiosDAO;
	}

	public SolicitudCreditoDAO getSolicitudCreditoDAO() {
		return solicitudCreditoDAO;
	}

	public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
		this.solicitudCreditoDAO = solicitudCreditoDAO;
	}
	
}
