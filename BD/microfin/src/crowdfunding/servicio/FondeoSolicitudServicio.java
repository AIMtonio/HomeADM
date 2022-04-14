package crowdfunding.servicio;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import crowdfunding.bean.FondeoSolicitudBean;
import crowdfunding.dao.FondeoSolicitudDAO;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.servicio.CorreoServicio;
import credito.servicio.CreditosServicio.Enum_Tra_Creditos;

public class FondeoSolicitudServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	FondeoSolicitudDAO fondeoSolicitudDAO = null;
	private CorreoServicio correoServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	String codigo = "";


	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_FondeoSolicitud {
		int principal = 1;
		int gridFondeador = 2;
		int gridInversiones = 3;
		int altoRiesgo = 4;
	}


	//---------- tipos Transacciones ------------------------------------------------------------------------

	public static interface Enum_Tra_FondeoSolicitud {
		int alta = 1;
		int proceso = 2;
		int cancelar = 3;
	}



	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, FondeoSolicitudBean fondeoSolicitudBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Creditos.alta:
			mensaje = fondeoSolicitudDAO.alta(fondeoSolicitudBean);
			break;
		case Enum_Tra_FondeoSolicitud.cancelar:
			mensaje = fondeoSolicitudDAO.cancelar(fondeoSolicitudBean);
			break;
		}
		return mensaje;
	}
/*
	public Object solicitudInversion(FondeoSolicitudBean fondeoSolicitudBean){
		Object obj= null;
		SolicitudInversionResponse res=new SolicitudInversionResponse();
		String cadena;
		codigo = "01";
		try{
			List<SolicitudInversionResponse> tmpDetalleCotizador= fondeoSolicitudDAO.proceso(fondeoSolicitudBean);
			if (!tmpDetalleCotizador.isEmpty()){
				codigo= ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getCodigoRespuesta();
				if (Integer.parseInt(codigo)==0){
					cadena=transformArray(tmpDetalleCotizador);
					if (Integer.parseInt(codigo)==0){
						res.setCodigoRespuesta( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getCodigoRespuesta());
						res.setMensajeRespuesta( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getMensajeRespuesta());
						res.setSolicitudFondeo( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getSolicitudFondeo());
						res.setGat( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getGat());
						res.setGatReal(((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getGatReal());

						res.setInfoDetalleCuotas(cadena);
					}
				}else{
					res.setCodigoRespuesta( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getCodigoRespuesta());
					res.setMensajeRespuesta( ((SolicitudInversionResponse) tmpDetalleCotizador.get(0)).getMensajeRespuesta());
					res.setSolicitudFondeo(Constantes.STRING_CERO);
					res.setGat(Constantes.STRING_CERO);
					res.setGatReal(Constantes.STRING_CERO);
					res.setInfoDetalleCuotas(Constantes.STRING_VACIO);
				}
			} else{
				res.setInfoDetalleCuotas(Constantes.STRING_CERO);
				res.setSolicitudFondeo(Constantes.STRING_CERO);
				res.setGat(Constantes.STRING_CERO);
				res.setGatReal(Constantes.STRING_CERO);
				res.setCodigoRespuesta("99");
				res.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
			}
			obj=(Object)res;
		}catch(Exception e){
			e.printStackTrace();
			res.setInfoDetalleCuotas(Constantes.STRING_CERO);
			res.setSolicitudFondeo(Constantes.STRING_CERO);
			res.setGat(Constantes.STRING_CERO);
			res.setGatReal(Constantes.STRING_CERO);
			res.setCodigoRespuesta("99");
			res.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
		}
		return obj;
	}

	private String transformArray(List  a)
	{
		String res ="";
		SolicitudInversionResponse temp;
		if(a!=null)
		{
			Iterator<SolicitudInversionResponse> it = a.iterator();
			while(it.hasNext())
			{
				temp = (SolicitudInversionResponse)it.next();
				res+= temp.getInfoDetalleCuotas()+"&|&";
				codigo = temp.getCodigoRespuesta();
			}
		}
		return res;
	}

*/

	public List listaGrid(int tipoLista,FondeoSolicitudBean fondeoSolicitud){
		List listaFondeos = null;
		switch (tipoLista) {
			/* nt principal = 1;
		int gridFondeador = 2;
		int gridInversiones = 3;
		int altoRiesgo = 4;*/
		case Enum_Lis_FondeoSolicitud.principal:
			//listaFondeos = fondeoSolicitudDAO.listaPrincipal(fondeoSolicitud, tipoLista);
			break;
		case Enum_Lis_FondeoSolicitud.gridFondeador:
			// lista 2 de fondeadores Para pantalla de alta de credito kubo
			listaFondeos = fondeoSolicitudDAO.listaGridFondeadores(fondeoSolicitud, tipoLista);
			break;
		case Enum_Lis_FondeoSolicitud.gridInversiones:
			//lista 3 de fondeadores Para pantalla de consulta originacion
			listaFondeos = fondeoSolicitudDAO.listaGridInverKubo(fondeoSolicitud, tipoLista);
			break;
		case Enum_Lis_FondeoSolicitud.altoRiesgo:
			//lista 4 de fondeadores de Alto Riesgo
			listaFondeos = fondeoSolicitudDAO.listaInversionistasAltoRiesgo(fondeoSolicitud, tipoLista);
			break;

		}
		return listaFondeos;
	}
	//Reporte de Detalle de Inversion en PDF
	public ByteArrayOutputStream reporteDetalleInversionPDF(FondeoSolicitudBean fondeoSolicitudBean , String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucion", parametrosSesionBean.getNombreInstitucion().toUpperCase());
		parametrosReporte.agregaParametro("Par_NombreUsuario",parametrosSesionBean.getClaveUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_FechaEmision",parametrosSesionBean.getFechaAplicacion().toString());
		parametrosReporte.agregaParametro("Par_CreditoID",fondeoSolicitudBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_solicitudCreditoID",fondeoSolicitudBean.getSolicitudCreditoID());
		parametrosReporte.agregaParametro("Par_Acreditado",fondeoSolicitudBean.getClienteID());
		parametrosReporte.agregaParametro("Par_DescripcionAcreditado",fondeoSolicitudBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_Monto",fondeoSolicitudBean.getMontoAutorizado());
		parametrosReporte.agregaParametro("Par_Estatus",fondeoSolicitudBean.getEstatus());
		parametrosReporte.agregaParametro("Par_ProductoID",fondeoSolicitudBean .getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_DescripcionProducto",fondeoSolicitudBean.getDescripProducto());
		parametrosReporte.agregaParametro("Par_FechaInicio",fondeoSolicitudBean.getFechaIniCre());
		parametrosReporte.agregaParametro("Par_FechaFin",fondeoSolicitudBean.getFechaVenCre());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//---------- Asignaciones -----------------------------------------------------------------------

	public void setFondeoSolicitudDAO(FondeoSolicitudDAO fondeoSolicitudDAO) {
		this.fondeoSolicitudDAO = fondeoSolicitudDAO;
	}


	public FondeoSolicitudDAO getFondeoSolicitudDAO() {
		return fondeoSolicitudDAO;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(
			ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}