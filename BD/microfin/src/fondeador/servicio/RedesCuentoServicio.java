package fondeador.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;

import fondeador.bean.RedesCuentoBean;
import fondeador.dao.RedesCuentoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class RedesCuentoServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------
	RedesCuentoDAO redesCuentoDAO = null;
	
	public RedesCuentoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Creditos {
		int principal = 1;
		int foranea = 2;
		int tipConCredAsig =3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_RedesCue {
		int principal = 1;
		int foranea   =2;
		int alfanumerica = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_RedesCue {
		int alta = 1;
		int modifica = 2;
	}
	public static interface Enum_Lis_CredRep {
		//int principal      = 2;
		int detallFonRepEx = 1;
		int baseCredFommur = 2;
//		int pdf	 		   = 3;

	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RedesCuentoBean redesCuentoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_RedesCue.alta:		
				mensaje = altaCreditoFondeoAsig(redesCuentoBean);;				
				break;				
			case Enum_Tra_RedesCue.modifica:
				mensaje = null;				
				break;	
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaCreditoFondeoAsig(RedesCuentoBean redesCuentoBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaCreditos = (ArrayList) listaGridCreditos(redesCuentoBean);
		mensaje = redesCuentoDAO.altaCredFondAsig(redesCuentoBean,listaCreditos);		
		return mensaje;
	}
	
	
	public List listaGridCreditos(RedesCuentoBean redesCuentoBean){
		
		List<String> listaSeleccion   = redesCuentoBean.getListaSeleccion(); 
		List<String> listaCreditoID   = redesCuentoBean.getListaCreditoID();
		List<String> listaMontoCredito   = redesCuentoBean.getListaMontoCredito();
		List<String> listaSaldoCapCre   = redesCuentoBean.getListaSaldoCapCre();

		ArrayList listaDetalle = new ArrayList();

		RedesCuentoBean redesCuentoCreBean = new RedesCuentoBean();
		
		try{
			if(!listaCreditoID.isEmpty()){ 
				int tamanio = listaCreditoID.size();
			
				for(int i=0; i<tamanio; i++){
					redesCuentoCreBean = new RedesCuentoBean();
					redesCuentoCreBean.setFormaSeleccion(listaSeleccion.get(i));
					redesCuentoCreBean.setCreditoID(listaCreditoID.get(i));
					redesCuentoCreBean.setMontoCredito(listaMontoCredito.get(i));
					redesCuentoCreBean.setSaldoCapCre(listaSaldoCapCre.get(i));
					redesCuentoCreBean.setInstitutFondeoID(redesCuentoBean.getInstitutFondeoID());
					redesCuentoCreBean.setLineaFondeoID(redesCuentoBean.getLineaFondeoID());
					redesCuentoCreBean.setCreditoFondeoID(redesCuentoBean.getCreditoFondeoID());
					redesCuentoCreBean.setSaldoCapFon(redesCuentoBean.getSaldoCapFon());
					redesCuentoCreBean.setFechaAsignacion(redesCuentoBean.getFechaAsignacion());
                    redesCuentoCreBean.setUsuarioAsigna(redesCuentoBean.getUsuarioAsigna());
//                    redesCuentoCreBean.setPorcentajeExtraCob(redesCuentoBean.getPorcentajeExtraCob());
//                    redesCuentoCreBean.setCantidadIntegrar(redesCuentoBean.getCantidadIntegrar());
                   
					listaDetalle.add(redesCuentoCreBean);

				}
			}else{
				throw new Exception("Error en lista de Asignacion de Creditos de Fondeo");
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grid de Asignacion de Creditos de Fondeo.", e);
		}
		return listaDetalle;
	}
	
	
	
	
	public RedesCuentoBean consulta (int tipoConsulta, RedesCuentoBean redesCuentoBean){
		RedesCuentoBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal:		
				creditos = redesCuentoDAO.consultaPrincipal(redesCuentoBean, tipoConsulta);				
				break;
			case Enum_Con_Creditos.foranea:		
				creditos = redesCuentoDAO.consultaForanea(redesCuentoBean, tipoConsulta);				
				break;
			case Enum_Con_Creditos.tipConCredAsig:		
				creditos = redesCuentoDAO.consultaCredAsig(redesCuentoBean, tipoConsulta);				
				break;
				}	
		return creditos;
	}
	
	public List lista(int tipoLista, RedesCuentoBean redesCuentoBean){
		List listaCreditos = null;
		switch (tipoLista) {
			case Enum_Lis_RedesCue.principal:		
				listaCreditos=  redesCuentoDAO.listaPrincipal(redesCuentoBean, Enum_Lis_RedesCue.principal);				
				break;
			case Enum_Lis_RedesCue.foranea:		
				listaCreditos=  redesCuentoDAO.listaForanea(redesCuentoBean, Enum_Lis_RedesCue.foranea);				
				break;	
		}
		return listaCreditos;
	}
	 
	public ByteArrayOutputStream reporteDetalleFonPDF(RedesCuentoBean redesCuentoBean, 
			String nomReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_InstitutFondeoID",Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()));
				parametrosReporte.agregaParametro("Par_NombreInstitFon",redesCuentoBean.getNombreInstitFon());
				parametrosReporte.agregaParametro("Par_LineaFondeoID",Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()));
				parametrosReporte.agregaParametro("Par_DescripLinFon",redesCuentoBean.getDescripLinFon());
				parametrosReporte.agregaParametro("Par_CreditoFondeoID",Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()));
				parametrosReporte.agregaParametro("Par_SaldoCreditoFon",Utileria.convierteDoble(redesCuentoBean.getSaldoCreditoFon()));
				parametrosReporte.agregaParametro("Par_FechaIniCredFon",redesCuentoBean.getFechaIniCredFon());
				parametrosReporte.agregaParametro("Par_UsuarioAsigna",redesCuentoBean.getUsuarioAsigna());
				parametrosReporte.agregaParametro("Par_FechaAsignacion",redesCuentoBean.getFechaAsignacion());
				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporteCreditoBaseFommurPDF(RedesCuentoBean redesCuentoBean, 
			String nomReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_InstitutFondeoID",Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()));
				parametrosReporte.agregaParametro("Par_NombreInstitFon",redesCuentoBean.getNombreInstitFon());
				parametrosReporte.agregaParametro("Par_LineaFondeoID",Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()));
				parametrosReporte.agregaParametro("Par_DescripLinFon",redesCuentoBean.getDescripLinFon());
				parametrosReporte.agregaParametro("Par_CreditoFondeoID",Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()));
				parametrosReporte.agregaParametro("Par_FechaIniCredFon",redesCuentoBean.getFechaIniCredFon());
				parametrosReporte.agregaParametro("Par_UsuarioAsigna",redesCuentoBean.getUsuarioAsigna());
				parametrosReporte.agregaParametro("Par_FechaAsignacion",redesCuentoBean.getFechaAsignacion());
				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/*case para listas de reportes de credito*/
	public List listaReportesCreditos(int tipoLista, RedesCuentoBean redesCuentoBean, HttpServletResponse response){

		// List listaCreditos = null;
		 List listaCreditos=null;
	
		switch(tipoLista){
		
			case Enum_Lis_CredRep.detallFonRepEx:
				listaCreditos = redesCuentoDAO.reporteCreditofondeoExcel(redesCuentoBean, tipoLista); 
				break;	
//			case Enum_Lis_CredRep.baseCredFommur:
//				listaCreditos = redesCuentoDAO.repBaseCreditoFommurExcel(redesCuentoBean, tipoLista); 
//				break;

		}
		
		return listaCreditos;
	}
	public void setRedesCuentoDAO(RedesCuentoDAO redesCuentoDAO) {
		this.redesCuentoDAO = redesCuentoDAO;
	}
}
