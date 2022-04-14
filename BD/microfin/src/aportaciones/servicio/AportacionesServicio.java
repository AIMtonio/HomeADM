package aportaciones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.PropiedadesSAFIBean;
import aportaciones.bean.AportacionesBean;
import aportaciones.bean.ReciboAportContratoBean;
import aportaciones.dao.AportDispersionesDAO;
import aportaciones.dao.AportacionesDAO;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class AportacionesServicio extends BaseServicio{

	AportacionesDAO aportacionesDAO = null;
	AportDispersionesDAO aportDispersionesDAO = null;
	MonedasServicio monedasServicio = null;

	//---------- Constructor ------------------------------------------------------------------------
	public AportacionesServicio(){
		super();
	}


	public static interface Enum_Tra_Aportaciones {
		int alta				= 1;
		int modifica			= 2;
		int autoriza			= 3;
		int imprimePagare		= 4;
		int reinvertitr			= 5;
		int cancelarReinver		= 6;
		int autorizaAnclaje		= 7;
		int cancelaAportacion         = 10;
		int vencimientoAportacion     = 11;

	}

	public static interface Enum_Con_Aportaciones {
		int principal		= 1;
		int pagare			= 2;
		int numAportaciones		= 3;
		int checkList		= 4;
		int reinversion 	= 5;
		int anclaje			= 6;
		int montosAnclados	= 7;
		int ajuste			= 8;
		int vencimiAnt		= 9;
		int montoGlobal		= 10;
		int consolidaciones	= 11;
		int montoGlobalvenc	= 12;
	}

	public static interface Enum_Lis_Aportaciones{
		int principal	     	= 1;
		int simulador	      	= 2;
		int resumenCte	      	= 3;
		int checklist         	= 4;
		int digitaDod         	= 5;
		int	reinversionManual 	= 6;
		int reimpresion	      	= 7;
		int aportacionesVencidas     	= 8;
		int aportacionesVigentes     	= 9;
		int aportacionesCancela      	= 10;
		int aportacionesVencimiento  	= 11;
		int aportacionesOrigVigentes 	= 12;
		int reinversiconPosterior		= 13;
		int aportacionesPorAutorizar	= 14;
		int comentariosAportaciones		= 16;
		int opcionesAportaciones		= 17;
		int aportacionesPorIniciar		= 18;
		int aportDispersiones			= 19;
		int busqConsolidacion			= 20;
	}

	public static interface Enum_Act_Aportaciones {
		int actProcesoAportacionSI 		= 3;  // Se usa para actualizar el valor parametro: SI
		int actProcesoAportacionNO 		= 4;  // Se usa para actualizar el valor parametro: NO
	}

	public static interface Enum_Tip_Reporte {
		int renovacionExcel 	= 1;		// reporte en excel renovaciones
	}

	public static interface Enum_Con_ReciboAport {
		int reciboCapitaliza = 1;
		int reciboIrregular  = 2;
		int reciboRegular    = 3;
		int tipoRecibo		 = 4;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AportacionesBean aportacionesBean){

		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case(Enum_Tra_Aportaciones.alta):
			mensaje = aportacionesDAO.alta(aportacionesBean, tipoTransaccion);
		break;
		case(Enum_Tra_Aportaciones.modifica):
			mensaje = aportacionesDAO.modificar(aportacionesBean, tipoTransaccion);
		break;
		case(Enum_Tra_Aportaciones.autoriza):
			mensaje = aportacionesDAO.autoriza(aportacionesBean, tipoTransaccion);
		break;
		case(Enum_Tra_Aportaciones.imprimePagare):
			mensaje = aportacionesDAO.actualizaAportacion(aportacionesBean, tipoTransaccion);
		break;
		case(Enum_Tra_Aportaciones.reinvertitr):
			mensaje = aportacionesDAO.reinvertir(aportacionesBean);
		break;
		case(Enum_Tra_Aportaciones.cancelarReinver):
			mensaje = aportacionesDAO.abonar(aportacionesBean);
		break;
		case(Enum_Tra_Aportaciones.autorizaAnclaje):
			mensaje = aportacionesDAO.autoriza(aportacionesBean, 5);
		break;
		case(Enum_Tra_Aportaciones.cancelaAportacion):
			mensaje = aportacionesDAO.cancelaAportacion(aportacionesBean, tipoTransaccion);
		break;
		case(Enum_Tra_Aportaciones.vencimientoAportacion):
			mensaje = aportacionesDAO.cancelaAportacion(aportacionesBean, tipoTransaccion);
		break;
		}
		return mensaje;
	}

	public AportacionesBean consulta(int tipoConsulta,AportacionesBean aportacionesBean){
		AportacionesBean aportaciones = null;
		switch (tipoConsulta) {
		case Enum_Con_Aportaciones.principal:
			aportaciones = aportacionesDAO.consultaPrincipal(aportacionesBean, Enum_Con_Aportaciones.principal);
			break;
		case Enum_Con_Aportaciones.numAportaciones:
			aportaciones = aportacionesDAO.consultaNumeroAportaciones(aportacionesBean, Enum_Con_Aportaciones.numAportaciones);
			break;
		case Enum_Con_Aportaciones.checkList:
			aportaciones = aportacionesDAO.consultaCheckList(aportacionesBean, Enum_Con_Aportaciones.checkList);
			break;
		case Enum_Con_Aportaciones.reinversion:
			aportaciones = aportacionesDAO.consultaReinversion(aportacionesBean, Enum_Con_Aportaciones.reinversion);
			break;
		case Enum_Con_Aportaciones.anclaje:
			aportaciones = aportacionesDAO.consultaAnclaje(aportacionesBean, Enum_Con_Aportaciones.anclaje);
			break;
		case Enum_Con_Aportaciones.montosAnclados:
			aportaciones = aportacionesDAO.consultaMontosAnclados(aportacionesBean, Enum_Con_Aportaciones.montosAnclados);
			break;
		case Enum_Con_Aportaciones.ajuste:
			aportaciones = aportacionesDAO.AjusteAnclaje(aportacionesBean,1);
			break;
		case Enum_Con_Aportaciones.vencimiAnt:
			aportaciones = aportacionesDAO.consultaVencimientoAnt(aportacionesBean, Enum_Con_Aportaciones.vencimiAnt);
			break;
		case Enum_Con_Aportaciones.montoGlobal:
			aportaciones = aportacionesDAO.consultaMontoGlobal(aportacionesBean, tipoConsulta);
			break;
		case Enum_Con_Aportaciones.consolidaciones:
			aportaciones = aportacionesDAO.consultaConsolida(aportacionesBean, tipoConsulta);
		break;
			case Enum_Con_Aportaciones.montoGlobalvenc:
				aportaciones = aportacionesDAO.consultaMontoGlobalVencimiento(aportacionesBean, tipoConsulta);
			break;
		}
		return aportaciones;
	}

	public ReciboAportContratoBean consultaRecibo(int tipoConsulta, AportacionesBean aportaciones){
		ReciboAportContratoBean recibo = null;
		switch (tipoConsulta) {
			case Enum_Con_ReciboAport.reciboCapitaliza:
				recibo = aportacionesDAO.consultaReciboCapitaliza(tipoConsulta, aportaciones);
			break;
			case Enum_Con_ReciboAport.reciboIrregular:
				recibo = aportacionesDAO.consultaReciboIrregular(tipoConsulta, aportaciones);
			break;
			case Enum_Con_ReciboAport.reciboRegular:
				recibo = aportacionesDAO.consultaReciboRegular(tipoConsulta, aportaciones);
			break;
			case Enum_Con_ReciboAport.tipoRecibo:
				recibo = aportacionesDAO.consultaTipoRecibo(aportaciones);
			break;
		}
		return recibo;
	}

	public List lista(int tipoLista, AportacionesBean aportacionesBean){
		List listaAportaciones = null;
		switch (tipoLista) {
		case Enum_Lis_Aportaciones.principal:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.simulador:
			listaAportaciones = aportacionesDAO.simulador(aportacionesBean);
			break;
		case Enum_Lis_Aportaciones.resumenCte:
			listaAportaciones = aportacionesDAO.resumenCte(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.checklist:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.digitaDod:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.reinversionManual:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.reimpresion:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesVencidas:
			listaAportaciones = aportacionesDAO.listaReporteAportacionesVencidas(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesVigentes:
			listaAportaciones = aportacionesDAO.listaReporteAportacionesVigentes(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesCancela:
			listaAportaciones = aportacionesDAO.listaCancelacion(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesVencimiento:
			listaAportaciones = aportacionesDAO.listaCancelacion(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesOrigVigentes:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.reinversiconPosterior:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesPorAutorizar:
			listaAportaciones = aportacionesDAO.reporteAportacionesPorAurtorizar(aportacionesBean);
			break;
		case Enum_Lis_Aportaciones.comentariosAportaciones:
			listaAportaciones = aportacionesDAO.listaComentarios(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.opcionesAportaciones:
			listaAportaciones = aportacionesDAO.listaOpcionesAport(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportacionesPorIniciar:
			listaAportaciones = aportacionesDAO.listaAportPorIniciar(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.aportDispersiones:
			listaAportaciones = aportDispersionesDAO.listaClientes(aportacionesBean, tipoLista);
			break;
		case Enum_Lis_Aportaciones.busqConsolidacion:
			listaAportaciones = aportacionesDAO.listaPrincipal(aportacionesBean, tipoLista);
			break;
		}

		return listaAportaciones;
	}

	public ByteArrayOutputStream reporteAportaciones(AportacionesBean aportacionesBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		MonedasBean monedaBean =null ;
		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
				aportacionesBean.getMonedaID());

		String pathImgInverCamex = PropiedadesSAFIBean.propiedadesSAFI.getProperty("RutaImgInvercamex");

		parametrosReporte.agregaParametro("Par_AportID",Utileria.completaCerosIzquierda(aportacionesBean.getAportacionID(), 6));
		parametrosReporte.agregaParametro("Par_TipoConsulta", Enum_Con_Aportaciones.pagare);
		parametrosReporte.agregaParametro("Par_NombreInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_MontoEnLetras", Utileria.cantidadEnLetras(Utileria.convierteDoble(
				aportacionesBean.getTotal()),
				Integer.parseInt(monedaBean.getMonedaID()),
				monedaBean.getSimbolo(),
				monedaBean.getDescripcion()));

		parametrosReporte.agregaParametro("Par_NombreCliente",aportacionesBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_SucursalID",aportacionesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NombreSucursal",aportacionesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_DesTipoAportacion",aportacionesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_FechaApertura",aportacionesBean.getFechaApertura());
		parametrosReporte.agregaParametro("Par_FechaVencimiento",aportacionesBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_CuentaAhoID",Utileria.completaCerosIzquierda(aportacionesBean.getCuentaAhoID(), 12));
		parametrosReporte.agregaParametro("Par_Plazo",aportacionesBean.getPlazo());
		parametrosReporte.agregaParametro("Par_CalculoInteres",aportacionesBean.getCalculoInteres());
		parametrosReporte.agregaParametro("Par_TasaBase",aportacionesBean.getTasaBase());
		parametrosReporte.agregaParametro("Par_SobreTasa",aportacionesBean.getSobreTasa());
		parametrosReporte.agregaParametro("Par_PisoTasa",aportacionesBean.getPisoTasa());
		parametrosReporte.agregaParametro("Par_TechoTasa",aportacionesBean.getTechoTasa());
		parametrosReporte.agregaParametro("Par_Importe",aportacionesBean.getTotalRecibir());
		parametrosReporte.agregaParametro("Par_DireccionInst",aportacionesBean.getDireccionInstit());
		parametrosReporte.agregaParametro("Par_TasaFija",aportacionesBean.getTasaFija());
		parametrosReporte.agregaParametro("Par_TasaISR",aportacionesBean.getTasaISR());
		parametrosReporte.agregaParametro("Par_TasaNeta",aportacionesBean.getTasaNeta());
		parametrosReporte.agregaParametro("Par_InteresRecibir",aportacionesBean.getInteresRecibir());
		parametrosReporte.agregaParametro("Par_ValorGat", aportacionesBean.getValorGat());
		parametrosReporte.agregaParametro("Par_RutaInvercamex",pathImgInverCamex);

		// Actualiza el Estatus del Pagare de la Inversion a Impreso
		MensajeTransaccionBean mensaje = grabaTransaccion(Enum_Tra_Aportaciones.imprimePagare, aportacionesBean);

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

	}

	public ByteArrayOutputStream reporteAportacionesVigPDF(AportacionesBean aportacionesBean, String nombreReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_TipoAportacionID", aportacionesBean.getTipoAportacionID());
		parametrosReporte.agregaParametro("Par_PromotorID", aportacionesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_SucursalID",aportacionesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID", aportacionesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_FechaApertura", aportacionesBean.getFechaApertura());
		parametrosReporte.agregaParametro("Par_NombreUsuario", aportacionesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision", aportacionesBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_FechaFin", aportacionesBean.getFinalDate());
		parametrosReporte.agregaParametro("Par_Estatus", aportacionesBean.getEstatus());
		parametrosReporte.agregaParametro("Par_NumRep", aportacionesBean.getNumReporte());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public  ByteArrayOutputStream repVencimientoPDF(AportacionesBean aportacionesBean, String nombreReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicial", aportacionesBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFinal", aportacionesBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_Sucursal", aportacionesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_TipoMoneda", aportacionesBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_Promotor", aportacionesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_Aportacion", aportacionesBean.getAportacionID());
		parametrosReporte.agregaParametro("Par_DescripcionAportacion", aportacionesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_NomPromotor", aportacionesBean.getNombrePromotor());
		parametrosReporte.agregaParametro("Par_NomSucursal", aportacionesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NomMoneda", aportacionesBean.getNombreMoneda());
		parametrosReporte.agregaParametro("Par_NomUsuario", aportacionesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NomInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Estatus", aportacionesBean.getEstatus());
		parametrosReporte.agregaParametro("Par_FechaActual", aportacionesBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_NombreEstatus", aportacionesBean.getDesEstatus());


		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * Método que crea el reporte en formato pdf de Aportaciones No Autorizadas.
	 * @param aportacionesBean : Clase bean con los valores de los parámetros que recibe el prpt.
	 * @param nombreReporte : Nombre del archivo prpt definido en el xml de aportaciones.
	 * @param request : HttpServletRequest que trae por parámetro el valor para safilocale.cliente.
	 * @return ByteArrayOutputStream : Reporte generado.
	 * @throws Exception : Error al crear el reporte.
	 * @author avelasco
	 */
	public ByteArrayOutputStream aportacionesNoAutorizadasPDF(AportacionesBean aportacionesBean, String nombreReporte, HttpServletRequest request) throws Exception {
		String safilocaleCliente = request.getParameter("safilocaleCliente");
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TipoAportacionID", aportacionesBean.getTipoAportacionID());
		parametrosReporte.agregaParametro("Par_PromotorID", aportacionesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_SucursalID", aportacionesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID", aportacionesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NomPromotor", aportacionesBean.getNombrePromotor());
		parametrosReporte.agregaParametro("Par_NomSucursal", aportacionesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_Usuario", aportacionesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreCliente", aportacionesBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_NomTipoAportacion", aportacionesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_FechaSistema", parametrosAuditoriaBean.getFecha().toString());
		parametrosReporte.agregaParametro("Par_SafiLocale", safilocaleCliente);

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Método para crear el reporte de aportaciones por iniciar en formato PDF
	public ByteArrayOutputStream aportacionesPorIniciarPDF(AportacionesBean aportacionesBean, String nombreReporte, HttpServletRequest request) throws Exception {
		String safilocaleCliente = request.getParameter("safilocaleCliente");
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SucursalID", aportacionesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID", aportacionesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NomSucursal", aportacionesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_Usuario", aportacionesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreCliente", aportacionesBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_FechaSistema", parametrosAuditoriaBean.getFecha().toString());
		parametrosReporte.agregaParametro("Par_SafiLocale", safilocaleCliente);
		parametrosReporte.agregaParametro("Par_FechaInicial", aportacionesBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFinal", aportacionesBean.getFechaVencimiento());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public MensajeTransaccionBean vencimientoMasivoAportaciones(AportacionesBean aportacionesBean){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeActualiza = new MensajeTransaccionBean();
		AportacionesBean aportBean = null;

		mensajeActualiza = aportacionesDAO.actualizaProcesoAportaciones(aportBean,Enum_Act_Aportaciones.actProcesoAportacionSI);

		if(mensajeActualiza.getNumero()==0){
			mensaje = aportacionesDAO.vencimientoMasivoAportaciones(aportacionesBean);
			mensajeActualiza = aportacionesDAO.actualizaProcesoAportaciones(aportBean,Enum_Act_Aportaciones.actProcesoAportacionNO);
		}
		else{
			mensaje=mensajeActualiza;
		}
		return mensaje;
	}

	public ByteArrayOutputStream reporteRenovacionesPDF(AportacionesBean aportacionesBean, String nombreReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		aportacionesDAO.generaNumeroTransaccion();
		parametrosReporte.agregaParametro("Par_FechaInicial", aportacionesBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFinal", aportacionesBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Estatus",aportacionesBean.getEstatus());
		parametrosReporte.agregaParametro("Par_ClienteID", aportacionesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", aportacionesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSis", aportacionesBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_ClaveUsuario", aportacionesBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_DescEstatus", aportacionesBean.getDescEstatus());
		parametrosReporte.agregaParametro("Par_DescCliente", aportacionesBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	// REPORTE RENOVACIONES
		public List repRenovacion(int tipoLista, AportacionesBean aportacionesBean){
			 List <AportacionesBean>listaBean = null;

			switch(tipoLista){
				case  Enum_Tip_Reporte.renovacionExcel:
					listaBean = aportacionesDAO.repRenovacion(aportacionesBean);
				break;
			}

			return listaBean;
		}
	public AportacionesDAO getAportacionesDAO() {
		return aportacionesDAO;
	}

	public void setAportacionesDAO(AportacionesDAO aportacionesDAO) {
		this.aportacionesDAO = aportacionesDAO;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	public AportDispersionesDAO getAportDispersionesDAO() {
		return aportDispersionesDAO;
	}

	public void setAportDispersionesDAO(AportDispersionesDAO aportDispersionesDAO) {
		this.aportDispersionesDAO = aportDispersionesDAO;
	}

}
