package arrendamiento.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import reporte.ParametrosReporte;
import reporte.Reporte;
import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.bean.DetallePagoArrendaBean;
import arrendamiento.bean.EntregaArrendamientoBean;
import arrendamiento.bean.MesaControlArrendamientoBean;
import arrendamiento.dao.ArrendamientosDAO;

public class ArrendamientosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ArrendamientosDAO arrendamientosDAO = null;	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
		int arrendamientoPorID = 2;
		int consultaDetalleProducto = 4;
		int generalesArrendamiento=3;
		int estatusImpresionPagare = 5;
	}
	//---------- Tipo de Calculos ----------------------------------------------------------------
	public static interface Enum_Cal_Arrenda {
		int alta = 1;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
		int arrendamiento = 2;			// lista de arrendamiento para pagaré de arrendamiento
		int listaArrendamientos = 3;
		int listaArrendamientosAutorizados = 4;
		int arrendamientosSucursal = 5; // Lista de arrendmiento por sucursal
		int arrendamientosGeneral = 6; //Lista del boton general de la pantalla pago de arrendamiento
		int arrendaParaMovsCA = 7;		// lista de arrendamiento para movimientos de cargos y abonos
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Arrenda {
		int alta = 1;
		int modificacion = 2;
		int autorizacion = 3;
		int actualizaEstatusImpresoPagare = 4;
		int entrega = 5;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Rep_Arrendamiento {
		int contratoArrendamiento = 1;
		int AnexoContratoArrendamiento = 2;
		int pagareArrendamiento = 3;
	}
	
	public ArrendamientosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, ArrendamientosBean arrendamientosBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Arrenda.alta:		
				mensaje = arrendamientosDAO.alta(arrendamientosBean);				
				break;		
			case Enum_Tra_Arrenda.modificacion:		
				mensaje = arrendamientosDAO.modificacion(arrendamientosBean);				
				break;		
			case Enum_Tra_Arrenda.autorizacion:
				// Llamar al DAO para la modificación del estatus
				mensaje = arrendamientosDAO.autorizarProducto(tipoActualizacion, arrendamientosBean);
				break;
			case Enum_Tra_Arrenda.actualizaEstatusImpresoPagare:
				//Actualiza el estatus del arrendamiento cuando se imprime el pagare
				mensaje = arrendamientosDAO.actualizaEstatusImpPagare(tipoActualizacion, arrendamientosBean);
				break;
			case Enum_Tra_Arrenda.entrega:
				// Llamar al DAO para la modificación del estatus
				mensaje = arrendamientosDAO.entregaArrendamiento(arrendamientosBean);
				break;
		}
		return mensaje;
	}
	
	public MesaControlArrendamientoBean consultaDetalleProducto(int tipoConsulta, MesaControlArrendamientoBean mesaControlArrendamientoBean){
		MesaControlArrendamientoBean arrendamiento = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.consultaDetalleProducto:		
				arrendamiento = arrendamientosDAO.consultaDetalleProducto(tipoConsulta, mesaControlArrendamientoBean);				
				break;	
		}
		return arrendamiento;
	}
	
	public EntregaArrendamientoBean consultaEntregaArrendamiento(int tipoConsulta, EntregaArrendamientoBean entregaArrendamientoBean){
		EntregaArrendamientoBean arrendamiento = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.consultaDetalleProducto:		
				arrendamiento = arrendamientosDAO.consultaEntregaArrendamiento(tipoConsulta, entregaArrendamientoBean);				
				break;	
		}
		return arrendamiento;
	}
	
	public List lista(int tipoLista, MesaControlArrendamientoBean mesaControlArrendamientoBean){		
		List listaArrendamientos = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.listaArrendamientos:		
				listaArrendamientos = arrendamientosDAO.listaArrendamientosProductos(tipoLista, mesaControlArrendamientoBean);				
				break;
		}		
		return listaArrendamientos;
	}
	
	public List lista(int tipoLista, EntregaArrendamientoBean entregaArrendamientoBean){		
		List listaArrendamientos = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.listaArrendamientosAutorizados:		
				listaArrendamientos = arrendamientosDAO.listaArrendamientosAutorizados(tipoLista, entregaArrendamientoBean);				
				break;
		}		
		return listaArrendamientos;
	}

	/**
	 * Lista de Arrendamiento
	 * @param tipoLista
	 * @param arrendamientosBean
	 * @return
	 */
	public List lista(int tipoLista, ArrendamientosBean arrendamientosBean){		
		List listaArrendamientos = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.principal:		
				listaArrendamientos = arrendamientosDAO.listaPrincipal(arrendamientosBean, tipoLista);				
				break;
			case Enum_Lis_Arrenda.arrendamientosSucursal:		
				listaArrendamientos = arrendamientosDAO.listaArrendaSucursal(arrendamientosBean, tipoLista); 
				break;
			case Enum_Lis_Arrenda.arrendamientosGeneral:	
				listaArrendamientos = arrendamientosDAO.listaGralArrenda(arrendamientosBean, tipoLista); 
				break;
			case Enum_Lis_Arrenda.arrendaParaMovsCA:	
				listaArrendamientos = arrendamientosDAO.listaArrendaMovsCA(arrendamientosBean, tipoLista); 
				break;
		}	
		return listaArrendamientos;
	}


	/**
	 * Metodo de Consulta
	 * @param tipoConsulta
	 * @param arrendamientosBean
	 * @return ArrendamientosBean
	 */
	public ArrendamientosBean consulta(int tipoConsulta, ArrendamientosBean arrendamientosBean){
		ArrendamientosBean arrendamientos = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				arrendamientos = arrendamientosDAO.consultaPrincipal(arrendamientosBean, tipoConsulta);				
				break;	
			case Enum_Con_Arrenda.generalesArrendamiento:		
				arrendamientos = arrendamientosDAO.consultaGralArrendamiento(arrendamientosBean, tipoConsulta);
				break;
			case Enum_Con_Arrenda.arrendamientoPorID:		
				arrendamientos = arrendamientosDAO.consultaPorArrendaID(arrendamientosBean, tipoConsulta);				
				break;
			case Enum_Con_Arrenda.estatusImpresionPagare:		
				arrendamientos = arrendamientosDAO.consultaEstatusImpresionPagare(arrendamientosBean, tipoConsulta);				
				break;
		}
		return arrendamientos;
	}
	// consulta los detalles del pago  del arrendamiento
	public DetallePagoArrendaBean consultaDetallePagoArrenda(int tipoConsulta, DetallePagoArrendaBean detallePagoBean){
		DetallePagoArrendaBean detallePago = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:
				detallePago = arrendamientosDAO.consultaDetallePagoArrenda(detallePagoBean, tipoConsulta);				
				break;				
		}						
		return detallePago;
	}

	public ArrendamientosBean calculos(int tipoConsulta, ArrendamientosBean arrendamientosBean){
		ArrendamientosBean arrendamientos = null;
		switch (tipoConsulta) {
			case Enum_Cal_Arrenda.alta:		
				arrendamientos = arrendamientosDAO.calculoAlta(arrendamientosBean, tipoConsulta);				
				break;	
		}
		return arrendamientos;
	}
public List simuladorAmortizaciones(int tipoLista, ArrendamientosBean arrendamientosBean){		
		List resultado = null;
		resultado = arrendamientosDAO.simuladorPagos(arrendamientosBean);
		return resultado;
	}
	
	/**
	 * Metodo para la generacion de reportes
	 * @param tipoTransaccion
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 * @author vsanmiguel
	 */
	public ByteArrayOutputStream reporteArrendamiento(int tipoTransaccion,HttpServletRequest request, String nombreReporte) throws Exception{
		ByteArrayOutputStream htmlString = null;
		switch(tipoTransaccion){
		case Enum_Rep_Arrendamiento.contratoArrendamiento:
			htmlString = reporteContratoArrendamiento(request, nombreReporte);
			break;
		case Enum_Rep_Arrendamiento.AnexoContratoArrendamiento:
			htmlString = reporteAnexoArrendamiento(request, nombreReporte);
			break;
		case Enum_Rep_Arrendamiento.pagareArrendamiento:
			htmlString = reportePagareArrendamiento(request, nombreReporte);
			break;
		}
		return htmlString;
	}
	
	/**
	 * Reporte de Contrato de pagare de arrendamiento
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 * @author vsanmiguel
	 */
	private ByteArrayOutputStream reporteContratoArrendamiento(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_InstitucionID", request.getParameter("institucionID"));
		parametrosReporte.agregaParametro("Par_NumCtaInstit", request.getParameter("numCtaInstit"));
		parametrosReporte.agregaParametro("Par_ArrendamientoID", request.getParameter("arrendamientoID"));
		parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("clienteID"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_RutaImgReportes", request.getParameter("rutaImgReportes"));
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Reporte de Anexos del contrato de arrendamiento
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 * @author vsanmiguel
	 */
	private ByteArrayOutputStream reporteAnexoArrendamiento(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_InstitucionID", request.getParameter("institucionID"));
		parametrosReporte.agregaParametro("Par_NumCtaInstit", request.getParameter("numCtaInstit"));
		parametrosReporte.agregaParametro("Par_ArrendamientoID", request.getParameter("arrendamientoID"));
		parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("clienteID"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_RutaImgReportes", request.getParameter("rutaImgReportes"));
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	private ByteArrayOutputStream reportePagareArrendamiento(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_InstitucionID", request.getParameter("institucionID"));
		parametrosReporte.agregaParametro("Par_NumCtaInstit", request.getParameter("numCtaInstit"));
		parametrosReporte.agregaParametro("Par_ArrendamientoID", request.getParameter("arrendamientoID"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_RutaImgReportes", request.getParameter("rutaImgReportes"));
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//------------------ Geters y Seters ------------------------------------------------------	
	public ArrendamientosDAO getArrendamientosDAO() {
		return arrendamientosDAO;
	}


	public void setArrendamientosDAO(ArrendamientosDAO arrendamientosDAO) {
		this.arrendamientosDAO = arrendamientosDAO;
	}
	
			
}


