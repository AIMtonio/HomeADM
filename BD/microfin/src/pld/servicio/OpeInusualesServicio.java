package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.task.TaskExecutor;
import org.springframework.util.StringUtils;

import pld.bean.OpeInusualesBean;
import pld.bean.PLDCNBVopeInuBean;
import pld.bean.ReportesSITIBean;
import pld.dao.OpeInusualesDAO;
import pld.servicio.MotivosInuServicio.Enum_Con_MotivosInu;
import pld.servicio.PLDCNBVopeInuServicio;
import pld.bean.MotivosInuBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.PropiedadesSAFIBean;
import soporte.bean.EnvioCorreoBean;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.dao.EnvioCorreoDAO;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class OpeInusualesServicio extends BaseServicio{

	private OpeInusualesServicio(){
		super();
	}
	
	EnvioCorreoDAO	envioCorreoDAO = null;
	OpeInusualesDAO opeInusualesDAO = null;
	PLDCNBVopeInuServicio pldCNBVopeInuServicio=null;
	CorreoServicio correoServicio = null;
	UsuarioServicio usuarioServicio = null;
	ParametrosSisServicio parametrosSisServicio=null;
	MotivosInuServicio motivosInuServicio =null;
	
	TaskExecutor taskExecutor;
	
	public static interface Enum_Con_OpeInusuales{
		int principal = 1;
		int nomArchivo = 2;
		int listaDatosRepTXT = 3;
	}
	
	public static interface Enum_Tra_OpeInusuales {
		int actualizacion = 1;
		int	alta =2;	

	}
	public static interface Enum_Lis_OpeInusuales{
		int alfanumerica = 1;
		int grid 		 = 2;
		int listaReporte = 3;
		int listaReporteExcel = 3;
		int listaAlertas = 4;
		int listaFraccionadas = 5;
	}
	public static interface Enum_Act_OpeInusuales {
		int principal=1;
		int actQuitarFolioInt = 2;	
		int actGenerarReporte = 3;	
		int grabaFolioSITI=4;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OpeInusualesBean opeInusuales){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_OpeInusuales.actualizacion:
				mensaje = actualizacion(opeInusuales, tipoTransaccion);				
				break;
			case Enum_Tra_OpeInusuales.alta:
				mensaje = alta(opeInusuales);				
				break;
				
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizacion(OpeInusualesBean opeInusuales, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = opeInusualesDAO.actualizacion(opeInusuales, tipoTransaccion);						
		return mensaje;
		
	}
	
	public MensajeTransaccionBean alta(final OpeInusualesBean opeInusuales){
		MensajeTransaccionBean mensaje = null;
		mensaje = opeInusualesDAO.alta(opeInusuales);
		return mensaje;
	}
		

	public OpeInusualesBean consulta(int tipoConsulta, OpeInusualesBean opeInusuales){
		OpeInusualesBean opeInusualesBean = null;
		switch(tipoConsulta){
			case Enum_Con_OpeInusuales.principal:
				opeInusualesBean = opeInusualesDAO.consultaPrincipal(opeInusuales, Enum_Con_OpeInusuales.principal);
			break;
			case Enum_Con_OpeInusuales.nomArchivo:
				opeInusualesBean = opeInusualesDAO.consultaNombreArchivo(opeInusuales, Enum_Con_OpeInusuales.nomArchivo);

			break;
		}
		return opeInusualesBean;
		
	}
	
	public List lista(int tipoLista, OpeInusualesBean opInusualesBean){		
		List listaOpInusuales = null;
		switch (tipoLista) {
			case Enum_Lis_OpeInusuales.alfanumerica:		
				listaOpInusuales=  opeInusualesDAO.listaAlfanumerica(opInusualesBean, Enum_Lis_OpeInusuales.alfanumerica);				
				break;
			case Enum_Lis_OpeInusuales.grid:		
				listaOpInusuales=  opeInusualesDAO.listaGrid(Enum_Lis_OpeInusuales.grid);	
				break;	
			case Enum_Lis_OpeInusuales.listaReporteExcel:		
				listaOpInusuales=  opeInusualesDAO.listaGrid(Enum_Lis_OpeInusuales.grid);	
				break;
			case Enum_Lis_OpeInusuales.listaAlertas:		
				listaOpInusuales=  opeInusualesDAO.listaReporteOpInu(opInusualesBean);	
				break;
			case Enum_Lis_OpeInusuales.listaFraccionadas:		
				listaOpInusuales=  opeInusualesDAO.listaReporteOpFrac(opInusualesBean);	
				break;
		}		
		return listaOpInusuales;
	}
	
	public List listaExcel(int tipoAct,int tipoTransaccion, ReportesSITIBean opeInusuales, String listaOperaciones){
		ArrayList listaDatosGrid= (ArrayList) creaListaGridExcel(listaOperaciones);		
		List listaOpInusuales = null;
		switch (tipoAct) {
			case Enum_Lis_OpeInusuales.listaReporteExcel:		
				listaOpInusuales = opeInusualesDAO.generaReporteExcel(Enum_Act_OpeInusuales.actGenerarReporte,Enum_Act_OpeInusuales.actQuitarFolioInt ,opeInusuales,listaDatosGrid, Enum_Lis_OpeInusuales.listaReporte);	
				break;	
		}		
		return listaOpInusuales;
	}

	//-----------------reporte------------
	public MensajeTransaccionBean actualizaReporte(int tipoAct,int tipoTransaccion, OpeInusualesBean opeInusuales, String listaOperaciones){
		ArrayList listaDatosGrid= (ArrayList) creaListaGrid(listaOperaciones);
		MensajeTransaccionBean mensaje = null;
		switch (tipoAct) {
			case Enum_Act_OpeInusuales.actGenerarReporte:
				mensaje = opeInusualesDAO.actPLDReporte(Enum_Act_OpeInusuales.actGenerarReporte,Enum_Act_OpeInusuales.actQuitarFolioInt ,opeInusuales,listaDatosGrid, Enum_Lis_OpeInusuales.listaReporte);			
				break;	
			case Enum_Act_OpeInusuales.grabaFolioSITI:
				mensaje = grabaFolioSITI(tipoTransaccion,opeInusuales);				
				break;	
		}
		return mensaje;
	}
	

	 private List creaListaGrid(String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDatosGrid = new ArrayList();
		OpeInusualesBean opeInusualesBean;
		
		while(tokensBean.hasMoreTokens()){
			opeInusualesBean = new OpeInusualesBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			opeInusualesBean.setOpeInusualID(tokensCampos[0]);
			opeInusualesBean.setFolioInterno(tokensCampos[1]);	
			listaDatosGrid.add(opeInusualesBean);			
		}		
		
		return listaDatosGrid;
	 }

	 private List creaListaGridExcel(String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDatosGrid = new ArrayList();
		ReportesSITIBean opeInusualesBean;
		
		while(tokensBean.hasMoreTokens()){
			opeInusualesBean = new ReportesSITIBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			opeInusualesBean.setOpeInusualID(tokensCampos[0]);
			opeInusualesBean.setFolioInterno(tokensCampos[1]);	
			listaDatosGrid.add(opeInusualesBean);			
		}		
		
		return listaDatosGrid;
	 }

	 public MensajeTransaccionBean grabaFolioSITI(int tipoTransaccion,OpeInusualesBean opeInusuales){
			PLDCNBVopeInuBean pldCNBVopeInuBean=new PLDCNBVopeInuBean();
		
			MensajeTransaccionBean mensaje = null;
			pldCNBVopeInuBean.setFolioSITI(opeInusuales.getFolioSITI());
			pldCNBVopeInuBean.setUsuarioSITI(opeInusuales.getUsuarioSITI());
			pldCNBVopeInuBean.setNombreArchivo(opeInusuales.getNombreArchivo());
			
			mensaje = pldCNBVopeInuServicio.grabaTransaccion(tipoTransaccion, pldCNBVopeInuBean );
			
			return mensaje;
			
		}
	
	public ByteArrayOutputStream reporteOpeInusualesPDF(OpeInusualesBean opeInusualesBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", opeInusualesBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFinal", opeInusualesBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Estatus", opeInusualesBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDes", opeInusualesBean.getEstatusDes());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", opeInusualesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", opeInusualesBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario", opeInusualesBean.getUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_HoraEmision", opeInusualesBean.getHoraEmision());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporteOpeFraccionadas(OpeInusualesBean opeInusualesBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Periodo", opeInusualesBean.getPeriodo());
		parametrosReporte.agregaParametro("Par_PeriodoDes", opeInusualesBean.getPeriodoDes());
		parametrosReporte.agregaParametro("Par_ClienteID", opeInusualesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NombresPersonaInv", opeInusualesBean.getNombresPersonaInv());
		parametrosReporte.agregaParametro("Par_Operaciones", opeInusualesBean.getOperaciones());
		parametrosReporte.agregaParametro("Par_OperacionesDes", opeInusualesBean.getDescOperaciones());
		parametrosReporte.agregaParametro("Par_UsuarioServicioID", opeInusualesBean.getUsuarioServicioID());
		parametrosReporte.agregaParametro("Par_NombreUsuario", opeInusualesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", opeInusualesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", opeInusualesBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario", opeInusualesBean.getUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_HoraEmision", opeInusualesBean.getHoraEmision());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//--------------setter y getter-----------------
	public OpeInusualesDAO getOpeInusualesDAO() {
		return opeInusualesDAO;
	}

	public void setOpeInusualesDAO(OpeInusualesDAO opeInusualesDAO) {
		this.opeInusualesDAO = opeInusualesDAO;
	}

	public PLDCNBVopeInuServicio getPldCNBVopeInuServicio() {
		return pldCNBVopeInuServicio;
	}

	public void setPldCNBVopeInuServicio(PLDCNBVopeInuServicio pldCNBVopeInuServicio) {
		this.pldCNBVopeInuServicio = pldCNBVopeInuServicio;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public MotivosInuServicio getMotivosInuServicio() {
		return motivosInuServicio;
	}

	public void setMotivosInuServicio(MotivosInuServicio motivosInuServicio) {
		this.motivosInuServicio = motivosInuServicio;
	}
	
	public EnvioCorreoDAO getEnvioCorreoDAO() {
		return envioCorreoDAO;
	}

	public void setEnvioCorreoDAO(EnvioCorreoDAO envioCorreoDAO) {
		this.envioCorreoDAO = envioCorreoDAO;
	}

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}



	
}
