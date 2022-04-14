package credito.servicio;
import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import credito.bean.CastigosCarteraBean;
import credito.bean.CreCastigosRepBean;
import credito.dao.CastigosCarteraDAO;

public class CastigosCarteraServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------

	CastigosCarteraDAO castigosCarteraDAO = null;

	public CastigosCarteraServicio() {
		super();
	}
	
	//---------- Tipos de Listas combo--------------------------------------------------------------

	public static interface Enum_Lis_combo{
		int principal = 1;
		int foranea = 2;
	}
	public static interface Enum_Lis_ReporteCastigos{
		int carteraCastigada = 1;
	}
	public static interface Enum_Tra_EsquemaComisionPrepago {
		int proceso = 1;
	}
	public static interface Enum_ConCastigosCartera{
		int consultaPrincipal		=1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CastigosCarteraBean  request){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_EsquemaComisionPrepago.proceso:
			mensaje = castigaCartera(request);
			break; 
		}
		return mensaje;
	}

	
	public MensajeTransaccionBean castigaCartera(CastigosCarteraBean castiga){
		MensajeTransaccionBean mensaje = null;
		mensaje = castigosCarteraDAO.castigosCartera(castiga);	
		return mensaje;
	}
	
	
	public CastigosCarteraBean consulta(int tipoConsulta,CastigosCarteraBean castigosCarteraBean){
		CastigosCarteraBean castigosCartera =null;
		switch (tipoConsulta){
			case  Enum_ConCastigosCartera.consultaPrincipal:
				castigosCartera=castigosCarteraDAO.consultaCastigo(castigosCarteraBean, tipoConsulta);
			break;
		}
		return castigosCartera;
		
	}
	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaCastigos = null;
		switch(tipoLista){
			case (Enum_Lis_combo.principal): 
				listaCastigos =  castigosCarteraDAO.listaCombo(tipoLista);
				break;			
			
		}
		
		return listaCastigos.toArray();		
	}
	
	public List listaReportesCredCastigados(int tipoLista, CreCastigosRepBean castigosCarteraBean, HttpServletResponse response){
		 List listaCreditos=null;
		switch(tipoLista){
			case Enum_Lis_ReporteCastigos.carteraCastigada:
				listaCreditos = castigosCarteraDAO.listaCarteraCastigada(castigosCarteraBean, tipoLista); 
				break;	
		}
		
		return listaCreditos;
	}
	
	
	public ByteArrayOutputStream creaRepCastigosPDF(CreCastigosRepBean castigosCarteraBean,String nombreReporte) throws Exception{
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
			parametrosReporte.agregaParametro("Par_Moneda",Utileria.convierteEntero(castigosCarteraBean.getMonedaID()));
			parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(castigosCarteraBean.getPromotorID()));
			parametrosReporte.agregaParametro("Par_NombrePromotor",(!castigosCarteraBean.getNombrePromotor().isEmpty())? castigosCarteraBean.getNombrePromotor() : "TODOS");
			
			parametrosReporte.agregaParametro("Par_MotivoCastigo",(Utileria.convierteEntero(castigosCarteraBean.getMotivoCastigoID())));
			parametrosReporte.agregaParametro("Par_NombreMotivoCastigo",(!castigosCarteraBean.getDesMotivoCastigo().isEmpty())? castigosCarteraBean.getDesMotivoCastigo() : "TODOS");
			parametrosReporte.agregaParametro("Par_NombreMoneda",(!castigosCarteraBean.getNombreMoneda().isEmpty())? castigosCarteraBean.getNombreMoneda() : "TODOS");
			parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));
			parametrosReporte.agregaParametro("Par_InstitucionID",castigosCarteraBean.getInstitucionNominaID());
			parametrosReporte.agregaParametro("Par_ConvenioNominaID",castigosCarteraBean.getConvenioNominaID());
			parametrosReporte.agregaParametro("Par_NombreEmpresa",castigosCarteraBean.getNombreInstit());
			parametrosReporte.agregaParametro("Par_NombreConvenio",castigosCarteraBean.getDesConvenio());
			parametrosReporte.agregaParametro("Par_EsproducNomina",castigosCarteraBean.getEsproducNomina());
			parametrosReporte.agregaParametro("Par_ManejaConvenio",castigosCarteraBean.getManejaConvenio());
		
		

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	//------------------ Geters y Seters ------------------------------------------------------	

	public CastigosCarteraDAO getCastigosCarteraDAO() {
		return castigosCarteraDAO;
	}

	public void setCastigosCarteraDAO(CastigosCarteraDAO castigosCarteraDAO) {
		this.castigosCarteraDAO = castigosCarteraDAO;
	}

}
