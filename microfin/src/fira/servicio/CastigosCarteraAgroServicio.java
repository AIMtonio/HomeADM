package fira.servicio;
import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletResponse;
import reporte.ParametrosReporte;
import reporte.Reporte;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import fira.bean.CastigosCarteraAgroBean;
import fira.bean.CatReportesFIRABean;
import fira.bean.CreCastigosAgroRepBean;
import fira.dao.CastigosCarteraAgroDAO;
import fira.servicio.CatReportesFIRAServicio.Enum_Lista_TipoReporte;


public class CastigosCarteraAgroServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------

		CastigosCarteraAgroDAO castigosCarteraAgroDAO = null;

		public CastigosCarteraAgroServicio() {
			super();			

		}
		
		//---------- Tipos de Listas combo--------------------------------------------------------------

		public static interface Enum_Lis_combo{
			int principal = 1;
			int foranea = 2;
			int creditoCastigo = 3;
		}
		public static interface Enum_Lis_ReporteCastigos{
			int carteraCastigada = 1;
		}
		public static interface Enum_Tra_Castigo {
			int principal = 1;
		}
		public static interface Enum_ConCastigosCartera{
			int consultaPrincipal		=1;
			int creditoCastigo			=2;
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CastigosCarteraAgroBean  request){
			MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
			case Enum_Tra_Castigo.principal:
				mensaje = castigaCartera(request);
				break; 
			}
			return mensaje;
		}

		
		public MensajeTransaccionBean castigaCartera(CastigosCarteraAgroBean castiga){
			MensajeTransaccionBean mensaje = null;
			mensaje = castigosCarteraAgroDAO.castigosCarteraAgro(castiga);	
			return mensaje;
		}
		
		
		public CastigosCarteraAgroBean consulta(int tipoConsulta,CastigosCarteraAgroBean castigosCarteraAgroBean){
			CastigosCarteraAgroBean castigosCartera =null;
			switch (tipoConsulta){
				case  Enum_ConCastigosCartera.consultaPrincipal:
					castigosCartera=castigosCarteraAgroDAO.consultaCastigoAgro(castigosCarteraAgroBean, tipoConsulta);
				break;
				case  Enum_ConCastigosCartera.creditoCastigo:					
					castigosCartera=castigosCarteraAgroDAO.consultaCreditoCastigoAgro(castigosCarteraAgroBean, tipoConsulta);
				break;
			}
			return castigosCartera;
			
		}
		
		
		// listas para comboBox
		public  Object[] listaCombo(int tipoLista) {
			List listaCastigos = null;
			switch(tipoLista){
				case (Enum_Lis_combo.principal): 
					listaCastigos =  castigosCarteraAgroDAO.listaCombo(tipoLista);
					break;				
			}
			
			return listaCastigos.toArray();		
		}
		
		public List listaReportesCredCastigados(int tipoLista, CreCastigosAgroRepBean castigosCarteraAgroBean, HttpServletResponse response){
			 List listaCreditos=null;
			switch(tipoLista){
				case Enum_Lis_ReporteCastigos.carteraCastigada:
					listaCreditos = castigosCarteraAgroDAO.listaCarteraCastigada(castigosCarteraAgroBean, tipoLista); 
					break;	
			}
			
			return listaCreditos;
		}
		
		
		public ByteArrayOutputStream creaRepCastigosPDF(CreCastigosAgroRepBean castigosCarteraBean,String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				 
				parametrosReporte.agregaParametro("Par_FechaInicio",castigosCarteraBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_FechaFin",castigosCarteraBean.getFechaFin());
				parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(castigosCarteraBean.getSucursalID()));
				parametrosReporte.agregaParametro("Par_ProductoCreditoID",Utileria.convierteEntero(castigosCarteraBean.getProducCreditoID()));
				parametrosReporte.agregaParametro("Par_NomProductoCre",(!castigosCarteraBean.getNombreProducto().isEmpty())? castigosCarteraBean.getNombreProducto() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomSucursal",(!castigosCarteraBean.getNombreSucursal().isEmpty())? castigosCarteraBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!castigosCarteraBean.getNombreInstitucion().isEmpty())?castigosCarteraBean.getNombreInstitucion(): "TODOS");
				
				parametrosReporte.agregaParametro("Par_NomUsuario",castigosCarteraBean.getClaveUsuario());
				parametrosReporte.agregaParametro("Par_FechaEmision",castigosCarteraBean.getFechaEmision());			
				parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(castigosCarteraBean.getPromotorID()));
				parametrosReporte.agregaParametro("Par_NombrePromotor",(!castigosCarteraBean.getNombrePromotor().isEmpty())? castigosCarteraBean.getNombrePromotor() : "TODOS");
				
				parametrosReporte.agregaParametro("Par_MotivoCastigo",(Utileria.convierteEntero(castigosCarteraBean.getMotivoCastigoID())));
				parametrosReporte.agregaParametro("Par_NombreMotivoCastigo",(!castigosCarteraBean.getDesMotivoCastigo().isEmpty())? castigosCarteraBean.getDesMotivoCastigo() : "TODOS");
				

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		
		//------------------ Geters y Seters ------------------------------------------------------	

		public CastigosCarteraAgroDAO getCastigosCarteraAgroDAO() {
			return castigosCarteraAgroDAO;
		}

		public void setCastigosCarteraAgroDAO(CastigosCarteraAgroDAO castigosCarteraAgroDAO) {
			this.castigosCarteraAgroDAO = castigosCarteraAgroDAO;
		}

}
	

