package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;


import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.DispersionGridBean;
import tesoreria.bean.PresuSucurGridBean;
import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.dao.PresupuestoSucursalDAO;

public class PresupSucursalServicio extends BaseServicio {

	
	//------Constructor
	public PresupSucursalServicio() {
		super();

	}
	// ---------- Variables
	public PresupuestoSucursalDAO presupSucursalDAO = null;
	// ------------------------------------------------------------------------
	

	public static interface Enum_TipoCon_PresupSucursal {
		int principal = 1;
		int foranea = 2;
		int folio = 3;
		int saldoDispon =4;
	};
	public static interface Enum_TipoLis_PresupSucursal {
		int presupPendientes=1 ;
		int combo = 2;

	};

	public static interface Enum_Tra_PresupSucursal {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Act_PresupSucursal {
		int estatus = 1;
		int Elimina = 2;
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
			PresupuestoSucursalBean presupSucBean) {
		MensajeTransaccionBean mensaje = null;
	
		ArrayList listaDetalleGrid = (ArrayList) DetalleGrid(presupSucBean);// DetalleGrid(dispersionBean);
		switch (tipoTransaccion) {
		case Enum_Tra_PresupSucursal.alta:
			mensaje = presupSucursalDAO.altaPresupSucursal(listaDetalleGrid, presupSucBean);
			break;
	  case Enum_Tra_PresupSucursal.modificacion:
		 mensaje = modificarPresupuesto(listaDetalleGrid,presupSucBean);
		 break;
		}

		return mensaje;

	}

	public MensajeTransaccionBean modificarPresupuesto(ArrayList listaDetalleGrid ,	PresupuestoSucursalBean presupSucBean) {
		MensajeTransaccionBean mensaje = null;
		 String str = presupSucBean.getEliminados();
		  String[] listaEliminados;
		 int encabezadoID = Integer.parseInt(presupSucBean.getFolio());
		  String coma = ",";
		  listaEliminados = str.split(coma);
		  PresuSucurGridBean   preSucGridBean= null;
		  for(int i =1; i < listaEliminados.length ; i++){
		 
		    preSucGridBean = new PresuSucurGridBean();
	        
			preSucGridBean.setFolioID(listaEliminados[i]);
			preSucGridBean.setGridConcepto("0");
			preSucGridBean.setGridDescripcion("");
			preSucGridBean.setGridEstatus("E");
			preSucGridBean.setGridMonto("0.00");
			preSucGridBean.setObservaciones("");
		
			mensaje = presupSucursalDAO.ActualizaCuerpo(preSucGridBean, encabezadoID, Enum_Act_PresupSucursal.Elimina);
		  }	
		
		  
		 mensaje = presupSucursalDAO.ActPresupSucursal(listaDetalleGrid, presupSucBean, Enum_Act_PresupSucursal.estatus);
		return mensaje;
	}
	public PresupuestoSucursalBean consulta(int tipoConsulta,
			PresupuestoSucursalBean presupSucBean) {

		PresupuestoSucursalBean preSucBean = new PresupuestoSucursalBean();

		switch (tipoConsulta) {
		
		case Enum_TipoCon_PresupSucursal.folio:

			preSucBean= presupSucursalDAO.consultaFolio(tipoConsulta, presupSucBean);
			break;
		case Enum_TipoCon_PresupSucursal.principal:
		
			preSucBean= presupSucursalDAO.consultaFolio(tipoConsulta, presupSucBean);
			break;
			
		case Enum_TipoCon_PresupSucursal.foranea:
			preSucBean= presupSucursalDAO.consultaPresupConcep(presupSucBean, tipoConsulta);
			break;		
		
		}
		

		return preSucBean;
	}

	public List DetalleGrid(PresupuestoSucursalBean preSucBean) {

		List<String> folioID  = preSucBean.getFolioID();
		List<String> concepto = preSucBean.getConcepto();
		List<String> descripcion = preSucBean.getDescripcion();
		List<String> estatus = preSucBean.getEstatus();
		List<String> monto = preSucBean.getMonto();
		List<String> listaObservaciones = preSucBean.getLobservaciones();

		ArrayList listaDetalle = new ArrayList();
		PresuSucurGridBean preSucGridBean = null;

		
		int tamanio = descripcion.size();

		for (int i = 0; i < tamanio; i++) {
			preSucGridBean = new PresuSucurGridBean();
	        
			preSucGridBean.setFolioID(folioID.get(i));
			preSucGridBean.setGridConcepto(concepto.get(i));
			preSucGridBean.setGridDescripcion(descripcion.get(i));
			preSucGridBean.setGridEstatus(estatus.get(i));
			preSucGridBean.setGridMonto(monto.get(i).trim().replaceAll(",","").replaceAll("\\$",""));
			preSucGridBean.setObservaciones(listaObservaciones.get(i));

			listaDetalle.add(preSucGridBean);
		}

		return listaDetalle;
	}


	public List listaPartidaPre(int tipoLista, PresupuestoSucursalBean preSucBean){
		List partidaPresupuestoLista = null;

		switch (tipoLista) {
	        case  Enum_TipoLis_PresupSucursal.combo:
	        	partidaPresupuestoLista = presupSucursalDAO.listaPartidaPre(preSucBean, tipoLista); 
	        break; 
	        
	        case  Enum_TipoLis_PresupSucursal.presupPendientes:
	        	partidaPresupuestoLista = presupSucursalDAO.listaPresupuestosPendientes(preSucBean, tipoLista);
	        break;   
		}
		return partidaPresupuestoLista;
	}
	
	// **********  servicios para reportes *****************
		// Reporte  de Presupuestos en formato PDF
			public ByteArrayOutputStream reportePresupPDF(PresupuestoSucursalBean presupuestoSucursalBean, String nomReporte) throws Exception{
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					parametrosReporte.agregaParametro("Par_AnioInicio",Utileria.convierteEntero(presupuestoSucursalBean.getAnioInicio()));
					parametrosReporte.agregaParametro("Par_MesInicio",presupuestoSucursalBean.getMesInicio());
					parametrosReporte.agregaParametro("Par_AnioFin",Utileria.convierteEntero(presupuestoSucursalBean.getAnioFin()));
					parametrosReporte.agregaParametro("Par_MesFin",presupuestoSucursalBean.getMesFin());
					parametrosReporte.agregaParametro("Par_Estatus",presupuestoSucursalBean.getEstatusPre());
					parametrosReporte.agregaParametro("Par_EstatusMov",presupuestoSucursalBean.getEstatusPet());
					parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(presupuestoSucursalBean.getSucursal()));
					parametrosReporte.agregaParametro("Par_FechaEmision",presupuestoSucursalBean.getParFechaEmision());
					parametrosReporte.agregaParametro("Par_NombreMesIni",presupuestoSucursalBean.getNombreMesIni());
					parametrosReporte.agregaParametro("Par_NombreMesFin",presupuestoSucursalBean.getNombreMesFin());
						
					parametrosReporte.agregaParametro("Par_NomSucursal",(!presupuestoSucursalBean.getNombreSucursal().isEmpty())? presupuestoSucursalBean.getNombreSucursal():"TODAS");
					parametrosReporte.agregaParametro("Par_NomUsuario",(!presupuestoSucursalBean.getNombreUsuario().isEmpty())?presupuestoSucursalBean.getNombreUsuario(): "");
					parametrosReporte.agregaParametro("Par_NomInstitucion",(!presupuestoSucursalBean.getNombreInstitucion().isEmpty())?presupuestoSucursalBean.getNombreInstitucion(): "");
					parametrosReporte.agregaParametro("Par_NomEstatus",(!presupuestoSucursalBean.getNombreEstatus().isEmpty())?presupuestoSucursalBean.getNombreEstatus(): "TODOS");
					parametrosReporte.agregaParametro("Par_NomEstatusMov",(!presupuestoSucursalBean.getNomEstatusMov().isEmpty())?presupuestoSucursalBean.getNomEstatusMov(): "TODOS");
					
					return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				}
			
			
			// Reporte  de Presupuestos en formato Pantalla
					public  String  reportePresupPantalla(PresupuestoSucursalBean presupuestoSucursalBean, String nomReporte) throws Exception{
						ParametrosReporte parametrosReporte = new ParametrosReporte();
						parametrosReporte.agregaParametro("Par_AnioInicio",Utileria.convierteEntero(presupuestoSucursalBean.getAnioInicio()));
						parametrosReporte.agregaParametro("Par_MesInicio",presupuestoSucursalBean.getMesInicio());
						parametrosReporte.agregaParametro("Par_AnioFin",Utileria.convierteEntero(presupuestoSucursalBean.getAnioFin()));
						parametrosReporte.agregaParametro("Par_MesFin",presupuestoSucursalBean.getMesFin());
						parametrosReporte.agregaParametro("Par_Estatus",presupuestoSucursalBean.getEstatusPre());
						parametrosReporte.agregaParametro("Par_EstatusMov",presupuestoSucursalBean.getEstatusPet());
						parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(presupuestoSucursalBean.getSucursal()));
						parametrosReporte.agregaParametro("Par_FechaEmision",presupuestoSucursalBean.getParFechaEmision());
						parametrosReporte.agregaParametro("Par_NombreMesIni",presupuestoSucursalBean.getNombreMesIni());
						parametrosReporte.agregaParametro("Par_NombreMesFin",presupuestoSucursalBean.getNombreMesFin());
							
						parametrosReporte.agregaParametro("Par_NomSucursal",(!presupuestoSucursalBean.getNombreSucursal().isEmpty())? presupuestoSucursalBean.getNombreSucursal():"TODAS");
						parametrosReporte.agregaParametro("Par_NomUsuario",(!presupuestoSucursalBean.getNombreUsuario().isEmpty())?presupuestoSucursalBean.getNombreUsuario(): "");
						parametrosReporte.agregaParametro("Par_NomInstitucion",(!presupuestoSucursalBean.getNombreInstitucion().isEmpty())?presupuestoSucursalBean.getNombreInstitucion(): "");
						parametrosReporte.agregaParametro("Par_NomEstatus",(!presupuestoSucursalBean.getNombreEstatus().isEmpty())?presupuestoSucursalBean.getNombreEstatus(): "TODOS");
						parametrosReporte.agregaParametro("Par_NomEstatusMov",(!presupuestoSucursalBean.getNomEstatusMov().isEmpty())?presupuestoSucursalBean.getNomEstatusMov(): "TODOS");
						
						return Reporte.creaHtmlReporte (nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
						}
					
					
					
	
					
		/*reporte de Presupuesto*/
		public List listaReportesPresupuestos(int tipoLista, PresupuestoSucursalBean creditosBean, HttpServletResponse response){

			 List listaPresupuestos=null;
			 listaPresupuestos = presupSucursalDAO.presucrepExcel(creditosBean, tipoLista);
			return listaPresupuestos;
		}

		//------------------ Geters y Seters ------------------------------------------------------	
	
	// ---Getters y Setters
	public PresupuestoSucursalDAO getPresupSucursalDAO() {
		return presupSucursalDAO;
	}

	public void setPresupSucursalDAO(PresupuestoSucursalDAO presupSucursalDAO) {
		this.presupSucursalDAO = presupSucursalDAO;
	}

}
