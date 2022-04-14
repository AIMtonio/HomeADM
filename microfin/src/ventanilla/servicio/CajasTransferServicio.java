package ventanilla.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.SucursalesBean;
import soporte.dao.SucursalesDAO;
import soporte.servicio.SucursalesServicio;
import ventanilla.bean.CajasTransferBean;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.CajasTransferDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class CajasTransferServicio extends BaseServicio{

	ParametrosSesionBean parametrosSesionBean;
	CajasVentanillaServicio cajasVentanillaServicio = new CajasVentanillaServicio();
	
	public CajasTransferServicio(){
		super();
	}
	CajasTransferDAO cajasTransferDAO = null;
	SucursalesDAO sucursalesDAO = new SucursalesDAO();
	public static interface Enum_Trans_CajasTransfer{
		int alta= 1;
		int recepcion= 2;
	}
	public static interface Enum_Con_CajasTransfer{
		int principal= 1;
	}
	public static interface Enum_Lis_CajasTransfer{
		int principal= 1;
		int tipoCajaCon = 2;
	}
	public static interface Enum_Rep_CajasTransfer{
		int ticketCajasTransfer = 1;
		int ticketEnvioBanc=2;
	}
	
	//Transaccion
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CajasTransferBean cajasTransferBean, HttpServletRequest request ) {
	
		MensajeTransaccionBean mensaje = null;
		CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
		switch(tipoTransaccion){
			case Enum_Trans_CajasTransfer.alta:
				mensaje = altaCajasTransfer(cajasTransferBean, request);
				
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
				
			break;
			case Enum_Trans_CajasTransfer.recepcion:
				mensaje = altaRecepcionTransfer(cajasTransferBean, request, tipoTransaccion);
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		}
		return mensaje;
	}
	
	//Alta transferencia entre cajas
	public MensajeTransaccionBean altaCajasTransfer(CajasTransferBean cajasTransferBean, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		cajasTransferBean.setDenominaciones("Salida:["+request.getParameter("billetesMonedasSalida")+"]");
		mensaje = cajasTransferDAO.movCajasTransfer(cajasTransferBean, listaDenominaciones, request.getParameter("cantidad"));
		
		
		return mensaje;
	}
	//Actualizacion del campo Estatus para Recepcion de Efectivo entre cajas 
	public MensajeTransaccionBean altaRecepcionTransfer(CajasTransferBean cajasTransferBean, HttpServletRequest request, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;		
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominacionEntrada(request.getParameter("billetesMonedasEntrada"));
		cajasTransferBean.setDenominaciones("Entrada:["+request.getParameter("billetesMonedasEntrada")+"]");
		mensaje = cajasTransferDAO.movRecepcionTransfer(cajasTransferBean, listaDenominaciones, tipoTransaccion, request);

		return mensaje;
	}
	
	//Ticket de Transferencia de Efectivo entre cajas
	public String reporteTicketTransfer(int tipoTransaccion,HttpServletRequest request, String nombreReporte) throws Exception{
		String htmlString ="";
		switch(tipoTransaccion){
		case Enum_Rep_CajasTransfer.ticketCajasTransfer:
			htmlString= reporteTicketTransfer(request, nombreReporte);
			break;
		case Enum_Rep_CajasTransfer.ticketEnvioBanc:
			htmlString= reporteTicketEnvioBanc(request, nombreReporte);
			break;
		}
		return htmlString;
	}
	
	//Ticket de Recepcion de Efectivo entre cajas
	public String reporteTicketTransfer(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("monedaID"));
		parametrosReporte.agregaParametro("Par_NumSucursalDes", Utileria.completaCerosIzquierda(request.getParameter("numSucDestino"),4));
		parametrosReporte.agregaParametro("Par_NomSucursalDes", request.getParameter("nomSucDestino"));
		parametrosReporte.agregaParametro("Par_CajaDes", Utileria.completaCerosIzquierda(request.getParameter("cajaDestino"),6));
		parametrosReporte.agregaParametro("Par_NomEstado",  sucursalBean.getNombreEstado());
		sucursalBean.setSucursalID(request.getParameter("numSucDestino"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		parametrosReporte.agregaParametro("Par_PlazaDes", sucursalBean.getNombreMunicipio()); 
		parametrosReporte.agregaParametro("Par_FolioID", request.getParameter("folioID"));
		parametrosReporte.agregaParametro("Par_Referencia", request.getParameter("referencia"));
		parametrosReporte.agregaParametro("Par_NomEstadoDes", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_TipoCaja", request.getParameter("tipoCaja"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//Ticket de Recepcion de Efectivo a Bancos
	public String reporteTicketEnvioBanc(HttpServletRequest request, String nombreReporte) throws Exception{		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("monedaID"));
		parametrosReporte.agregaParametro("Par_NumSucursalDes", request.getParameter("numeroBanco"));
		parametrosReporte.agregaParametro("Par_NomSucursalDes", request.getParameter("nombreBanco"));
		parametrosReporte.agregaParametro("Par_CajaDes", request.getParameter("cuenta"));
		parametrosReporte.agregaParametro("Par_FolioID", request.getParameter("folioID"));
		parametrosReporte.agregaParametro("Par_Referencia", request.getParameter("referencia"));
		parametrosReporte.agregaParametro("Par_Estatus", request.getParameter("estatus"));

		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}	
	
	
	
	//Crea lista denominacion solo para la Entrada de Efectivo en Recepcion de Efectivo entre cajas
	private List creaListaDenominacionEntrada(String billetesMonedasEntrada){
		StringTokenizer tokensBean = new StringTokenizer(billetesMonedasEntrada, ",");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDenominaciones = new ArrayList();
		IngresosOperacionesBean ingresosOperacionesBean;
		
		while(tokensBean.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
			
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
			if(Utileria.convierteDoble(tokensCampos[1])>0){
				ingresosOperacionesBean.setDenominacionID(tokensCampos[0]);
				ingresosOperacionesBean.setCantidadDenominacion(tokensCampos[1]);
				ingresosOperacionesBean.setMontoDenominacion(tokensCampos[2]);
				ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenEntrada);
			
				listaDenominaciones.add(ingresosOperacionesBean);
			}
		}
	
		return listaDenominaciones;
	}
	
	//crea lista denominaciones para la salida de efectivo en Transferencia entre cajas
	private List creaListaDenominaciones(String billetesMonedasEntrada,String billetesMonedasSalida){
		StringTokenizer tokensBean = new StringTokenizer(billetesMonedasEntrada, ",");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDenominaciones = new ArrayList();
		IngresosOperacionesBean ingresosOperacionesBean;
		
		while(tokensBean.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
			
			stringCampos = tokensBean.nextToken();
				
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
			if(Utileria.convierteDoble(tokensCampos[1])>0){
				ingresosOperacionesBean.setDenominacionID(tokensCampos[0]);
				ingresosOperacionesBean.setCantidadDenominacion(tokensCampos[1]);
				ingresosOperacionesBean.setMontoDenominacion(tokensCampos[2]);
				ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenEntrada);
		
				listaDenominaciones.add(ingresosOperacionesBean);
			}
		}
			
		StringTokenizer tokensBeanSalida = new StringTokenizer(billetesMonedasSalida, ",");
		String stringCamposSalida;
		String tokensCamposSalida[];
		
		while(tokensBeanSalida.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
			
			stringCamposSalida = tokensBeanSalida.nextToken();
			
			tokensCamposSalida = herramientas.Utileria.divideString(stringCamposSalida, "-");
			if(Utileria.convierteDoble(tokensCamposSalida[1])>0){
				ingresosOperacionesBean.setDenominacionID(tokensCamposSalida[0]);
				ingresosOperacionesBean.setCantidadDenominacion(tokensCamposSalida[1]);
				ingresosOperacionesBean.setMontoDenominacion(tokensCamposSalida[2]);
				ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenSalida);
			
				listaDenominaciones.add(ingresosOperacionesBean);
			}
		}
			
		return listaDenominaciones;
	}
	//lista de folios para llenar combo de Recepcion de Efectivo entre cajas 
	public  Object[] listaCombo(int tipoLista, CajasTransferBean cajasTransferBean) {
		List listaFolios = null;
		switch(tipoLista){
			case (Enum_Lis_CajasTransfer.principal): 
				listaFolios =  cajasTransferDAO.listaFolios(tipoLista, cajasTransferBean);
				break;
			case (Enum_Lis_CajasTransfer.tipoCajaCon): 
				listaFolios =  cajasTransferDAO.listaFolios(tipoLista, cajasTransferBean);
				break;
		}
		return listaFolios.toArray();		
	}

	// Lista para la entrada disponible por denominacion
	public  Object[] listaConsulta(int tipoConsulta, CajasTransferBean cajasTransferBean){
		List listCajasTransferBean = null;
		switch(tipoConsulta){
			case Enum_Con_CajasTransfer.principal:
				listCajasTransferBean  = cajasTransferDAO.consultaEntradaDenominacion(cajasTransferBean, tipoConsulta);
			break;
		}
		return listCajasTransferBean .toArray();
		
	}


	
	public CajasTransferDAO getCajasTransferDAO() {
		return cajasTransferDAO;
	}
	public void setCajasTransferDAO(CajasTransferDAO cajasTransferDAO) {
		this.cajasTransferDAO = cajasTransferDAO;
	}

	public SucursalesDAO getSucursalesDAO() {
		return sucursalesDAO;
	}

	public void setSucursalesDAO(SucursalesDAO sucursalesDAO) {
		this.sucursalesDAO = sucursalesDAO;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}
		
	
}
