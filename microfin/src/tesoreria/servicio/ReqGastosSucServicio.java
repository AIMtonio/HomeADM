package tesoreria.servicio;

   
import java.io.ByteArrayOutputStream;

import java.util.List;

import contabilidad.dao.PolizaDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
 
import tesoreria.bean.ReqGastosSucBean;
import tesoreria.dao.ReqGastosSucDAO;
import tesoreria.dao.OperDispersionDAO;

import tesoreria.bean.CuentasAhoSucBean;

public class ReqGastosSucServicio extends BaseServicio{
	
	ReqGastosSucDAO reqGastosSucDAO = null;
	OperDispersionDAO operDispersionDAO=null;
	ParametrosAuditoriaBean parametrosAuditoriaBean =null;
	PolizaDAO polizaDAO = null;
	 
	private ReqGastosSucServicio(){
		super();
	}
	
	public static interface Enum_Tra_ReqGastos {
		int alta 		 = 1;
		int modificar    = 2;
		int autoriza	 = 3;
	}
	public static interface Enum_Con_ReqGastos {
		int principal	 = 1;
		int foranea		 = 2;
	}
	public static interface Enum_Lis_ReqGastos {
		int estatusAlta	 		= 1;
		int estatusProcesado 	= 2;
	}
	public static interface Enum_Act_ReqGastos {
		int principal	 = 1;
		int foranea		 = 2;
	}
	public static interface Enum_TipoDeposito {
		 String proveedores = "P"; 
		 String sucursales  = "S"; 
	}
	public static interface Enum_Lis_MovReqGastos {
		int principal	 		= 1;
		int dentroPresupuesto 	= 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ReqGastosSucBean reqGastosSucBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_ReqGastos.alta:		
				mensaje = reqGastosSucDAO.altaRequisicionGasto(reqGastosSucBean);			
				break;				
			case Enum_Tra_ReqGastos.modificar:		
				mensaje = reqGastosSucDAO.actualizaRequisicionGasto(reqGastosSucBean, Enum_Act_ReqGastos.principal);			
				break;		
		}
		return mensaje;
	}
	
	// consulta
	public ReqGastosSucBean consulta(int tipoConsulta, ReqGastosSucBean reqGastosSucBean){
		ReqGastosSucBean reqGasBeanReturn = null;
		switch(tipoConsulta){
		case Enum_Con_ReqGastos .principal:
			reqGasBeanReturn = reqGastosSucDAO.consultaPrincipalEnc(reqGastosSucBean, tipoConsulta);
			break;
		}
		return reqGasBeanReturn;
	}
	
	// lista
	public List lista(int tipoLista, ReqGastosSucBean cuentasAho){
		List ListaReqGastosSuc = null;
		switch (tipoLista) {
	        case Enum_Lis_ReqGastos.estatusAlta:
	        	ListaReqGastosSuc = reqGastosSucDAO.listaEstatusAlta(cuentasAho, tipoLista);
	        break;
	        case Enum_Lis_ReqGastos.estatusProcesado:
	        	ListaReqGastosSuc = reqGastosSucDAO.listaEstatusProcesado(cuentasAho, tipoLista);
	        break;
		}
		return ListaReqGastosSuc;
	}
	
	public CuentasAhoSucBean consultaCtaSucursal(int tipoConsulta, ReqGastosSucBean reqGastosSucBean){
		CuentasAhoSucBean cuentaAhoSuc = null;
		switch(tipoConsulta){
		case Enum_Con_ReqGastos.foranea:
			cuentaAhoSuc = reqGastosSucDAO.consultaCtaSucur(reqGastosSucBean, tipoConsulta);
			break;
		}	
	  return cuentaAhoSuc;
	}
		

	public List reqSucurGridlist(int tipoLista, ReqGastosSucBean reqGastosSucBean){
		List presupSucursalLista = null;
		switch(tipoLista){
			case Enum_Lis_MovReqGastos.principal:
				presupSucursalLista = reqGastosSucDAO.ReqGastsGridLis(tipoLista, reqGastosSucBean);
				break;
			case Enum_Lis_MovReqGastos.dentroPresupuesto:
				presupSucursalLista = reqGastosSucDAO.reqGastsGridLisDentroPresupuesto(tipoLista, reqGastosSucBean);
				break;
		}	
		return presupSucursalLista;
	}
	
	public List cuentasAhoSuc(int tipoLista, CuentasAhoSucBean cuentasAhoSucBean){
		List cuentas = null;
	 	cuentas = reqGastosSucDAO.cuentasSucursal(tipoLista, cuentasAhoSucBean);
		return cuentas;
	}
	
 

	
	public ByteArrayOutputStream reporteRequisicionGastPDF(ReqGastosSucBean reqGastosSucBean, String nomReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", reqGastosSucBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", reqGastosSucBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_EstatusEnc", reqGastosSucBean.getEstatusEnc() );
		parametrosReporte.agregaParametro("Par_EstatusDet", reqGastosSucBean.getEstatusDet() );
		parametrosReporte.agregaParametro("Par_Sucursal", Utileria.convierteEntero(reqGastosSucBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", reqGastosSucBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!reqGastosSucBean.getNombreSucursal().isEmpty())? reqGastosSucBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!reqGastosSucBean.getNombreUsuario().isEmpty())?reqGastosSucBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!reqGastosSucBean.getNombreInstitucion().isEmpty())?reqGastosSucBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomEstatus",(!reqGastosSucBean.getNombreEstatusEnc().isEmpty())?reqGastosSucBean.getNombreEstatusEnc(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatusMov",(!reqGastosSucBean.getNombreEstatusDet().isEmpty())?reqGastosSucBean.getNombreEstatusDet(): "TODOS");
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
 
	public String reporteRequisicionPantalla(ReqGastosSucBean reqGastosSucBean, String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", reqGastosSucBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", reqGastosSucBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_EstatusEnc", reqGastosSucBean.getEstatusEnc() );
		parametrosReporte.agregaParametro("Par_EstatusDet", reqGastosSucBean.getEstatusDet() );
		parametrosReporte.agregaParametro("Par_Sucursal",  Utileria.convierteEntero(reqGastosSucBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", reqGastosSucBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!reqGastosSucBean.getNombreSucursal().isEmpty())? reqGastosSucBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!reqGastosSucBean.getNombreUsuario().isEmpty())?reqGastosSucBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!reqGastosSucBean.getNombreInstitucion().isEmpty())?reqGastosSucBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomEstatus",(!reqGastosSucBean.getNombreEstatusEnc().isEmpty())?reqGastosSucBean.getNombreEstatusEnc(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatusMov",(!reqGastosSucBean.getNombreEstatusDet().isEmpty())?reqGastosSucBean.getNombreEstatusDet(): "TODOS");
		
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	 // Reporte Fondeo Sucursales a PDF
	public ByteArrayOutputStream reporteFondeoSucursalPDF(ReqGastosSucBean reqGastosSucBean, String nomReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha",reqGastosSucBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaEmision",reqGastosSucBean.getParFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!reqGastosSucBean.getNombreUsuario().isEmpty())?reqGastosSucBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!reqGastosSucBean.getNombreInstitucion().isEmpty())?reqGastosSucBean.getNombreInstitucion(): "");

	return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

	}
	public void setReqGastosSucDAO(ReqGastosSucDAO reqGastosSucDAO){
		this.reqGastosSucDAO = reqGastosSucDAO;
	}
	public ReqGastosSucDAO getReqGastosSucDAO(){
		return reqGastosSucDAO;
	}
	
	public void setOperDispersionDAO(OperDispersionDAO operDispersionDAO){
		this.operDispersionDAO = operDispersionDAO;	
	}
	public  OperDispersionDAO getOperDispersionDAO(){
		return operDispersionDAO;
	
	}
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}
	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}
	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}	
}
