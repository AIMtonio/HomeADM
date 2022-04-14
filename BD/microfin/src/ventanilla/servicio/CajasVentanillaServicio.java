package ventanilla.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.CajasVentanillaDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import ventanilla.bean.CajasTransferBean;

public class CajasVentanillaServicio extends BaseServicio{	
	
	public CajasVentanillaServicio(){
		super();
	}
	CajasVentanillaDAO cajasVentanillaDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	
	public static interface Enum_Trans_CajasVentanilla{
		int alta= 1;
		int modifica=3;
		int activa = 4;
		int cancela = 5;
		int inactiva= 6;
		int asignaCaja = 7;
		int cierreOpe	= 8;
		int aperOpe	=9;
		int ejecProSi	=11;
		int ejecProNo	=10;
	}
	public static interface Enum_Lis_CajasVentanilla{
		int cajasTransfer	= 1;
		int principal 		= 2;
		int arqueoCaja 		= 3;
		int hisBalance		= 4;
		int conTipoCaja 	= 5;
		int porSucursal 	= 6;
		int arqueoCajaHis 	= 7;
		int gridCajas		= 8;
	}
	public static interface Enum_LisObjetos_CajasVentanilla{
		int arqTicket = 1;
        int detTicket = 2;
        int detTicketHis = 3;
        int arqTicketHis = 4;
	}
	
	public static interface Enum_Lis_HistCajasVentanilla{
		int historicoBalance= 1;

	}
	public static interface Enum_Lis_HistArqCajasVentanilla{
		int historicoArqueoCaja= 1;

	}
	public static interface Enum_Con_CajasVentanilla{
		int cajasTransfer= 1;
		int saldos= 2;
		int principal = 3;
		int usuario = 4;
		int tipoCajas = 6;
		int CajaPrinEO = 7;
		int CajaPrinCA = 8;
		int nTransPenSuc = 9;
		int nTransPenCaj = 10;
	}
	
	public static interface Enum_Rep_Ventanilla{
		int tiraAuditora= 1;
		int opVentanilla=2;
		int opVentanillaComer=3;
	}
	
	//Transaccion
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean, HttpServletRequest request) {
		int cajaID=0;
		if(parametrosSesionBean.getCajaID()==null){
			cajaID=0;
		}
		else{
			cajaID=Integer.parseInt(parametrosSesionBean.getCajaID());
		}
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Trans_CajasVentanilla.alta:
				mensaje = altaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);				
				cajasVentanillaBean.setCajaID(String.valueOf(cajaID));
				cajasVentanillaBean.setCajaID(String.valueOf(cajaID));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
				
			break;
			case Enum_Trans_CajasVentanilla.modifica:
				mensaje = actCajasVentanilla(tipoTransaccion, cajasVentanillaBean);				
				cajasVentanillaBean.setCajaID(String.valueOf(cajaID));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
				
			break;
			case Enum_Trans_CajasVentanilla.activa:
				mensaje = activaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.cancela:
				mensaje = cancelaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.inactiva:
				mensaje = cancelaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.asignaCaja:
				mensaje = asignaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.aperOpe:
				mensaje = aperturaCajasVentanilla(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.cierreOpe:
				mensaje = cierreCajasVentanilla(tipoTransaccion, cajasVentanillaBean, request);
			break;
			case Enum_Trans_CajasVentanilla.ejecProSi:
				mensaje = ejecutaProcesoSi(tipoTransaccion, cajasVentanillaBean);
			break;
			case Enum_Trans_CajasVentanilla.ejecProNo:
				mensaje = ejecutaProcesoNo(tipoTransaccion, cajasVentanillaBean);
			break;
		}
		return mensaje;
	}
	
	//Alta Cajas Ventanilla
	public MensajeTransaccionBean altaCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.altaCajasVentanilla(cajasVentanillaBean);
		return mensaje;
	}
	
	//Actualizacion de Cajas Ventanilla
	public MensajeTransaccionBean actCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
		return mensaje;
	}
	
	//Activación de Cajas Ventanilla
	public MensajeTransaccionBean activaCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
		return mensaje;
	}
	//Cancelación de Cajas Ventanilla
	public MensajeTransaccionBean cancelaCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
		return mensaje;
	}
	//Apertura de dia de Caja
		public MensajeTransaccionBean aperturaCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
			return mensaje;
		}
	//Cierre de dia de Caja
	public MensajeTransaccionBean cierreCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean,HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		try{
			if(request.getParameter("tipoCaja").endsWith("CP"))
			{
				mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
			}
			else{
			////obtener datos para el bean para transferencia
			CajasVentanillaBean consultasaldo =  new CajasVentanillaBean();
			CajasTransferBean cajasTransferBean = new CajasTransferBean();
			cajasTransferBean = getTransferBean(request);
			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"));
			
			mensaje = cajasVentanillaDAO.transfiereActualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion, cajasTransferBean , listaDenominaciones, request.getParameter("cantidad") );
			
			consultasaldo.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			consultasaldo = consulta(Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(consultasaldo.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(consultasaldo.getSaldoEfecMN());
		
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"cierre de caja en ventanilla ", e);
		}
		return mensaje;
	}
	
	
	//Actualiza estatus de ejecuta proceso a S=si
	public MensajeTransaccionBean ejecutaProcesoSi(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaEjecProSi(cajasVentanillaBean, tipoTransaccion, false);
		return mensaje;
	}

	//Actualiza estatus de ejecuta proceso a N=NO 
	
	public MensajeTransaccionBean ejecutaProcesoNo(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaEjecProNo(cajasVentanillaBean, tipoTransaccion);
		return mensaje;
	}
	
	//crea lista denominaciones para la salida de efectivo en Transferencia entre cajas
		private List creaListaDenominaciones(String billetesMonedasEntrada){
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
					ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenSalida);
					listaDenominaciones.add(ingresosOperacionesBean);
				}
			}
				
			return listaDenominaciones;
		}
	
	//Asignación de Cajas Ventanilla
	public MensajeTransaccionBean asignaCajasVentanilla(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBean, tipoTransaccion);
		return mensaje;
	}
	//
	public CajasVentanillaBean consulta(int tipoConsulta, CajasVentanillaBean cajasVentanillaBean){
		CajasVentanillaBean cajasVentanilla = null;
		switch(tipoConsulta){
			case Enum_Con_CajasVentanilla.cajasTransfer:
				cajasVentanilla = cajasVentanillaDAO.consultaPrincipal(cajasVentanillaBean, tipoConsulta);
			break;	
			case Enum_Con_CajasVentanilla.principal:
				cajasVentanilla = cajasVentanillaDAO.consultaPrincipal(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.usuario:
				cajasVentanilla = cajasVentanillaDAO.consultaPrincipal(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.saldos:
				cajasVentanilla = cajasVentanillaDAO.consultaSaldosCaja(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.tipoCajas:
				cajasVentanilla = cajasVentanillaDAO.consultaPrincipal(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.CajaPrinEO:
				cajasVentanilla = cajasVentanillaDAO.consultaCajaPrincipalEO(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.CajaPrinCA:
				cajasVentanilla = cajasVentanillaDAO.consultaCajaPrincipalEO(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.nTransPenSuc:
				cajasVentanilla = cajasVentanillaDAO.consultaCajaPrincipalEO(cajasVentanillaBean, tipoConsulta);
			break;
			case Enum_Con_CajasVentanilla.nTransPenCaj:
				cajasVentanilla = cajasVentanillaDAO.consultaCajaPrincipalEO(cajasVentanillaBean, tipoConsulta);
			break;
			
		}
		return cajasVentanilla;
	}
	
	public  Object[] listaConsulta(int tipoConsulta, CajasVentanillaBean cajasVentanillaBean){
		List listaHistoricoBalance = null;
		switch(tipoConsulta){
			case Enum_Lis_HistCajasVentanilla.historicoBalance:
				listaHistoricoBalance = cajasVentanillaDAO.hisBalanceCon(Enum_Lis_HistCajasVentanilla.historicoBalance,cajasVentanillaBean);
				break;
			}
		return listaHistoricoBalance.toArray();
		
	}
	
	public  Object[] listaTicketVentanilla(int tipoLista, CajasVentanillaBean cajasVentanillaBean){
		List listaResultados = null;
		try{
			switch(tipoLista){
				case Enum_LisObjetos_CajasVentanilla.arqTicket:
					listaResultados=  cajasVentanillaDAO.arqTicket(cajasVentanillaBean, tipoLista);
					break;	
				case Enum_LisObjetos_CajasVentanilla.detTicket:
					listaResultados=  cajasVentanillaDAO.detTicket(cajasVentanillaBean, tipoLista);
					break;	
				case Enum_LisObjetos_CajasVentanilla.detTicketHis:
					listaResultados=  cajasVentanillaDAO.detTicketHis(cajasVentanillaBean, tipoLista);
					break;	
				case Enum_LisObjetos_CajasVentanilla.arqTicketHis:
					listaResultados=  cajasVentanillaDAO.arqTicketHis(cajasVentanillaBean, tipoLista);
					break;	
		}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Devuelve lista en detalle tira auditora", e);
		}
		return listaResultados.toArray();
		
		
			}

	public CajasTransferBean getTransferBean(HttpServletRequest request){
		CajasTransferBean cajasTransferBean = new CajasTransferBean();
		cajasTransferBean.setSucursalOrigen(request.getParameter("sucursalID"));
		cajasTransferBean.setCajaOrigen(request.getParameter("cajaID"));
		cajasTransferBean.setFecha(request.getParameter("fecha"));
		cajasTransferBean.setMonedaID(request.getParameter("monedaID"));
		cajasTransferBean.setCajaDestino(request.getParameter("cajaDestino"));
		cajasTransferBean.setSucursalDestino(request.getParameter("sucursalID"));

		return cajasTransferBean;
		
	}
	public ByteArrayOutputStream reporteTiraAuditora(CajasVentanillaBean cajasVentanillaBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreEmpresa",cajasVentanillaBean.getProgramaID());
		parametrosReporte.agregaParametro("Par_NumSucursal",cajasVentanillaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NomSucursal",cajasVentanillaBean.getSucursal());
		parametrosReporte.agregaParametro("Par_NumCaja",cajasVentanillaBean.getCajaID());
		parametrosReporte.agregaParametro("Par_NumUsuario",cajasVentanillaBean.getUsuarioID());
		parametrosReporte.agregaParametro("Par_NomUsuario",cajasVentanillaBean.getUsuario());
		parametrosReporte.agregaParametro("Par_Fecha",cajasVentanillaBean.getFecha());
		parametrosReporte.agregaParametro("Par_Hora",cajasVentanillaBean.getFechaActual()); // Hora Par_Hora
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public String reporteDetalleArqueoTransfer(HttpServletRequest request, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_NombreEmpresa",request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal",request.getParameter("numeroSucursal"));
		parametrosReporte.agregaParametro("Par_NomSucursal",request.getParameter("nombreSucursal"));
		parametrosReporte.agregaParametro("Par_NumCaja",request.getParameter("numCaja"));
		parametrosReporte.agregaParametro("Par_NumUsuario",request.getParameter("numUsuario"));
		parametrosReporte.agregaParametro("Par_NomUsuario",request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_Fecha",request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_Hora",request.getParameter("hora")); 
		parametrosReporte.agregaParametro("Par_Operacion",request.getParameter("numOperacion"));
		parametrosReporte.agregaParametro("Par_Estatus",request.getParameter("estatus"));
		
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public String reporteDetalleArqueo(HttpServletRequest request, String nomReporte) throws Exception{
				
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreEmpresa",request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal",request.getParameter("numeroSucursal"));
		parametrosReporte.agregaParametro("Par_NomSucursal",request.getParameter("nombreSucursal"));
		parametrosReporte.agregaParametro("Par_NumCaja",request.getParameter("numCaja"));
		parametrosReporte.agregaParametro("Par_NumUsuario",request.getParameter("numUsuario"));
		parametrosReporte.agregaParametro("Par_NomUsuario",request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_Fecha",request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_Hora",request.getParameter("hora")); 
		parametrosReporte.agregaParametro("Par_Operacion",request.getParameter("numOperacion")); 
		
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	public ByteArrayOutputStream creaRepOpVentanillaPDF(CajasVentanillaBean cajasVentanillaBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		//System.out.println("Pdf1"+cajasVentanillaBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaIni",cajasVentanillaBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaFin",cajasVentanillaBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_Sucursal",cajasVentanillaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_Caja",cajasVentanillaBean.getCajaID());
		parametrosReporte.agregaParametro("Par_Naturaleza",cajasVentanillaBean.getNaturaleza());
		parametrosReporte.agregaParametro("Par_NombreSucursal",cajasVentanillaBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreCaja",cajasVentanillaBean.getDescripcionCaja());
		parametrosReporte.agregaParametro("Par_Usuario",cajasVentanillaBean.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",cajasVentanillaBean.getFecha());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",cajasVentanillaBean.getNombreInstitucion());
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//Lista Cajas Ventanilla
	public List lista(int tipoLista, CajasVentanillaBean cajasVentanillaBean, String sucursalOrigen){
		List listaCajasVentanilla = null;
		switch (tipoLista) {
		case Enum_Lis_CajasVentanilla.cajasTransfer:
			listaCajasVentanilla=  cajasVentanillaDAO.listaPrincipal(cajasVentanillaBean, tipoLista, sucursalOrigen);
			break;
		case Enum_Lis_CajasVentanilla.principal:
			listaCajasVentanilla=  cajasVentanillaDAO.listaPrincipal(cajasVentanillaBean, tipoLista, sucursalOrigen);
			break;
		case Enum_Lis_CajasVentanilla.arqueoCaja:
			listaCajasVentanilla=  cajasVentanillaDAO.arqueoCaja(cajasVentanillaBean, tipoLista);
			break;
		case Enum_Lis_CajasVentanilla.hisBalance:
			listaCajasVentanilla=  cajasVentanillaDAO.hisBalanceLis(cajasVentanillaBean);
			break;
		case Enum_Lis_CajasVentanilla.conTipoCaja:
			listaCajasVentanilla=  cajasVentanillaDAO.listaPrincipal(cajasVentanillaBean, tipoLista, sucursalOrigen);
			break;
		case Enum_Lis_CajasVentanilla.porSucursal:
			listaCajasVentanilla=  cajasVentanillaDAO.listaPrincipal(cajasVentanillaBean, tipoLista, sucursalOrigen);
			break;
		case Enum_Lis_CajasVentanilla.arqueoCajaHis:
			listaCajasVentanilla=  cajasVentanillaDAO.arqueoCajaHis(cajasVentanillaBean,tipoLista);
			break;
		case Enum_Lis_CajasVentanilla.gridCajas:						
			listaCajasVentanilla=  cajasVentanillaDAO.listaCajasGrid(cajasVentanillaBean,tipoLista);
			break;
		
		}
		return listaCajasVentanilla;
	}
	//Reporte Operaciones Ventanilla
	
public List	listaOpVentanilla( int tipoLista,CajasVentanillaBean cajasBean, HttpServletResponse response ){
	 List listaVentanilla=null;		
		switch(tipoLista){		
			case Enum_Rep_Ventanilla.opVentanilla:
					listaVentanilla = cajasVentanillaDAO.consultaOpVentanilla(cajasBean); 
				break;
			case Enum_Rep_Ventanilla.opVentanillaComer:				
					listaVentanilla = cajasVentanillaDAO.consultaOpVentanillaComer(cajasBean); 
				break ;
				
		}
	
	return listaVentanilla;
}
	
// actualiza bandera a 'N'

	public MensajeTransaccionBean actualizaProceso(int tipoTransaccion, CajasVentanillaBean cajasVentanillaBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasVentanillaDAO.actualizaEjecProNo(cajasVentanillaBean, tipoTransaccion);
	return mensaje;
	}


	
	public  Object[] listaCombo(int tipoLista, CajasVentanillaBean sucursalOrigen) {
		List listacajas = null;
		listacajas =  cajasVentanillaDAO.cajaCombo(tipoLista, sucursalOrigen);
		return listacajas.toArray();		
	}
	
	public  Object[] listacomboCajasSucursal(int tipoLista, CajasVentanillaBean sucursalOrigen) {
		List listacajas = null;
		listacajas =  cajasVentanillaDAO.listaCajasSucursal(tipoLista, sucursalOrigen);
		return listacajas.toArray();		
	}
	
	public CajasVentanillaDAO getCajasVentanillaDAO() {
		return cajasVentanillaDAO;
	}

	public void setCajasVentanillaDAO(CajasVentanillaDAO cajasVentanillaDAO) {
		this.cajasVentanillaDAO = cajasVentanillaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
