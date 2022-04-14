package seguimiento.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import seguimiento.bean.SeguimientoBean;
import seguimiento.dao.SeguimientoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class SeguimientoServicio extends BaseServicio {

	SeguimientoDAO seguimientoDAO = null;
	public SeguimientoServicio(){
		super();
	}
	
	public static interface Enum_Tra_Segto{
		int alta = 1;
		int modifica = 2;
		int elimina = 3;
	}
	public static interface Enum_Con_Segto{
		int principal = 1;
		int productos = 2;
		int seleccion = 3;
		int programa = 4;
		int clasifica =5;
		int plazas    = 6;
		int sucursal  = 7;
		int ejecutivo = 8;
		int fondeador = 9;
		int gestorCategoria = 10;
		int supervisorGestor = 11;
	}
	public static interface Enum_Con_Categoria{
		int principal 	= 1;
	}
	
	public static interface Enum_Lis_Segto{
		int foranea				= 2;
		int gestorCategoria		= 3;
	}
	public static interface Enum_Lis_Categoria{
		int principal = 1;
	}

	public static interface Enum_Lis_SegtoRep {
        int segtoCampoRepDetEX= 1;
        int segtoCampoRepSumEX= 2;
	}
	public static interface Enum_Lis_EficaciaSegtoRep {
        int eficaciaSegtoRepDetEX= 1;
        int eficaciaSegtoRepSumEX= 2;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SeguimientoBean seguimientoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Segto.alta:
				mensaje = altaSeguimiento(seguimientoBean);
				break;
			case Enum_Tra_Segto.modifica:
				mensaje = modificaSeguimiento(seguimientoBean);
				break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaSeguimiento(SeguimientoBean seguimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = seguimientoDAO.altaDefinicionSeguimiento(seguimiento);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaSeguimiento(SeguimientoBean seguimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = seguimientoDAO.modificaSeguimiento(seguimiento);
		return mensaje;
	}
	public SeguimientoBean consulta(int tipoConsulta, SeguimientoBean seguimiento){
		SeguimientoBean seguimientoBean = null;
		switch(tipoConsulta){
			case  Enum_Con_Segto.principal:
				seguimientoBean = seguimientoDAO.consulta(tipoConsulta, seguimiento);
			break;
			case  Enum_Con_Segto.gestorCategoria:
				seguimientoBean = seguimientoDAO.conGestorCategoria(tipoConsulta, seguimiento);
			break;
			case  Enum_Con_Segto.supervisorGestor:
				seguimientoBean = seguimientoDAO.conSupervisorGestor(tipoConsulta, seguimiento);
			break;

		}
		return seguimientoBean;
	}

	public List lista(int tipoLista, SeguimientoBean seguimiento){
		List listaCategoria = null;
		switch (tipoLista) {
			case Enum_Lis_Segto.foranea:
				listaCategoria = seguimientoDAO.lista(seguimiento, tipoLista);
				break;
			case Enum_Lis_Segto.gestorCategoria:
				listaCategoria = seguimientoDAO.listaGestorCategoria(seguimiento, tipoLista);
				break;
		}
		return listaCategoria;
	}

	public  Object[] listaConsulta(int tipoConsulta, SeguimientoBean seguimientoBean){
		List listSeguimiento = null;
		switch(tipoConsulta){
			case Enum_Con_Segto.productos:
				listSeguimiento = seguimientoDAO.consultaSegtoProducto(seguimientoBean, tipoConsulta);
			break;
			case Enum_Con_Segto.seleccion:
				listSeguimiento = seguimientoDAO.consultaSegtoCriterio(seguimientoBean, tipoConsulta);
			break;
			case Enum_Con_Segto.programa:
				listSeguimiento = seguimientoDAO.consultaSegtoPrograma(seguimientoBean, tipoConsulta);
			break;
			case Enum_Con_Segto.clasifica:
				listSeguimiento = seguimientoDAO.consultaSegtoClasifica(seguimientoBean, tipoConsulta);
			break;
			case  Enum_Con_Segto.plazas:
				listSeguimiento = seguimientoDAO.consultaPlazas(seguimientoBean, tipoConsulta);
			break;
			case  Enum_Con_Segto.sucursal:
				listSeguimiento = seguimientoDAO.consultaSucursal(seguimientoBean, tipoConsulta);
			break;
			case  Enum_Con_Segto.ejecutivo:
				listSeguimiento = seguimientoDAO.consultaEjecutivo(seguimientoBean, tipoConsulta);
			break;
			case  Enum_Con_Segto.fondeador:
				listSeguimiento = seguimientoDAO.consultaFondeador(seguimientoBean, tipoConsulta);
			break;
		}
		return listSeguimiento.toArray();
	}
	
	/* Case para listas de reportes de seguimiento*/
	public List listaReporteSeguimiento(int tipoLista, SeguimientoBean seguimientoBean, HttpServletResponse response){
		 List listaSeguimiento=null;
		switch(tipoLista){
			case Enum_Lis_SegtoRep.segtoCampoRepDetEX:
				listaSeguimiento = seguimientoDAO.consultaRepSegtoExcel(seguimientoBean, tipoLista); 
				break;	
			case Enum_Lis_SegtoRep.segtoCampoRepSumEX:
				listaSeguimiento = seguimientoDAO.consultaRepSegtoExcel(seguimientoBean, tipoLista); 
				break;		
		}
		
		return listaSeguimiento;
	}
	
	/* Case para listas de reportes de seguimiento*/
	public List listaReporteEficaciaSeguimiento(int tipoLista, SeguimientoBean seguimientoBean, HttpServletResponse response){
		 List listaSeguimiento=null;
		switch(tipoLista){
			case Enum_Lis_EficaciaSegtoRep.eficaciaSegtoRepDetEX:
				listaSeguimiento = seguimientoDAO.consultaRepEficaciaSegtoExcel(seguimientoBean, tipoLista); 
				break;	
			case Enum_Lis_EficaciaSegtoRep.eficaciaSegtoRepSumEX:
				listaSeguimiento = seguimientoDAO.consultaRepEficaciaSegtoExcel(seguimientoBean, tipoLista); 
				break;	
		}
		
		return listaSeguimiento;
	}
	
	public ByteArrayOutputStream reporteSegtoCampoPDF(SeguimientoBean segtoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", segtoBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", segtoBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_CategoriaID", (!segtoBean.getCategoriaID().isEmpty() ? segtoBean.getCategoriaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_CategoriaDes", (!segtoBean.getCategoriaID().isEmpty() ? segtoBean.getCategoriaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_PlazaID", (!segtoBean.getPlazaID().isEmpty() ? segtoBean.getPlazaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_PlazaDes", (!segtoBean.getPlazaID().isEmpty() ? segtoBean.getPlazaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_SucursalID", (!segtoBean.getSucursalID().isEmpty() ? segtoBean.getSucursalID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SucursalDesc", (!segtoBean.getSucursalID().isEmpty() ? segtoBean.getSucursalDesc() : "TODOS"));		
		parametrosReporte.agregaParametro("Par_ProdCredID", (!segtoBean.getProdCreditoID().isEmpty() ? segtoBean.getProdCreditoID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_ProdCredDesc", (!segtoBean.getProdCreditoID().isEmpty() ? segtoBean.getProdCreditoDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_GestorID", (!segtoBean.getEjecutorID().isEmpty() ? segtoBean.getEjecutorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_GestorDesc", (!segtoBean.getEjecutorID().isEmpty() ? segtoBean.getGestorDesc() : "TODOS"));		
		parametrosReporte.agregaParametro("Par_SupervisorID", (!segtoBean.getSupervisorID().isEmpty() ? segtoBean.getSupervisorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SupervisorDesc", (!segtoBean.getSupervisorID().isEmpty() ? segtoBean.getSupervisorDesc() :"TODOS"));
		parametrosReporte.agregaParametro("Par_ResultadoID", (!segtoBean.getResultadoID().isEmpty() ? segtoBean.getResultadoID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_ResultadoDesc", (!segtoBean.getResultadoID().isEmpty() ? segtoBean.getResultadoDesc() :"TODOS"));		
		parametrosReporte.agregaParametro("Par_RecomendacionID", (!segtoBean.getRecomendacionID().isEmpty() ? segtoBean.getRecomendacionID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_RecomendaDesc", (!segtoBean.getRecomendacionID().isEmpty() ? segtoBean.getRecomendaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_MunicipioID", (!segtoBean.getMunicipioID().isEmpty() ? segtoBean.getMunicipioID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_NumeroReporte",Utileria.convierteEntero(segtoBean.getNumeroReporte()));

		parametrosReporte.agregaParametro("Par_NomInstitucion", segtoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision", segtoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",segtoBean.getNomUsuario());

		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporteEficaciaSegtoCampoPDF(SeguimientoBean segtoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", segtoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", segtoBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_FechaIniSeg", segtoBean.getFechaInicioSeg());
		parametrosReporte.agregaParametro("Par_FechaFinSeg", segtoBean.getFechaFinSeg());
		parametrosReporte.agregaParametro("Par_CategoriaID", (!segtoBean.getCategoriaID().isEmpty() ? segtoBean.getCategoriaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_CategoriaDes", (!segtoBean.getCategoriaID().isEmpty() ? segtoBean.getCategoriaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_PlazaID", (!segtoBean.getPlazaID().isEmpty() ? segtoBean.getPlazaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_PlazaDes", (!segtoBean.getPlazaID().isEmpty() ? segtoBean.getPlazaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_SucursalID", (!segtoBean.getSucursalID().isEmpty() ? segtoBean.getSucursalID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SucursalDesc", (!segtoBean.getSucursalID().isEmpty() ? segtoBean.getSucursalDesc() : "TODOS"));		
		parametrosReporte.agregaParametro("Par_ProdCredID", (!segtoBean.getProdCreditoID().isEmpty() ? segtoBean.getProdCreditoID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_ProdCredDesc", (!segtoBean.getProdCreditoID().isEmpty() ? segtoBean.getProdCreditoDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_GestorID", (!segtoBean.getEjecutorID().isEmpty() ? segtoBean.getEjecutorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_GestorDesc", (!segtoBean.getEjecutorID().isEmpty() ? segtoBean.getGestorDesc() : "TODOS"));	
		parametrosReporte.agregaParametro("Par_TipoGestorID", (!segtoBean.getTipoGestorID().isEmpty() ? segtoBean.getTipoGestorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_TipoGestorDesc", (!segtoBean.getTipoGestorID().isEmpty() ? segtoBean.getTipoGestorDesc() : "TODOS"));		
		parametrosReporte.agregaParametro("Par_SupervisorID", (!segtoBean.getSupervisorID().isEmpty() ? segtoBean.getSupervisorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SupervisorDesc", (!segtoBean.getSupervisorID().isEmpty() ? segtoBean.getSupervisorDesc() :"TODOS"));
		parametrosReporte.agregaParametro("Par_ResultadoID", (!segtoBean.getResultadoID().isEmpty() ? segtoBean.getResultadoID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_ResultadoDesc", (!segtoBean.getResultadoID().isEmpty() ? segtoBean.getResultadoDesc() :"TODOS"));		
		parametrosReporte.agregaParametro("Par_RecomendacionID", (!segtoBean.getRecomendacionID().isEmpty() ? segtoBean.getRecomendacionID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_RecomendaDesc", (!segtoBean.getRecomendacionID().isEmpty() ? segtoBean.getRecomendaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_MunicipioID", (!segtoBean.getMunicipioID().isEmpty() ? segtoBean.getMunicipioID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_Programado", segtoBean.getSelecProgramada());
		parametrosReporte.agregaParametro("Par_Seguimiento", segtoBean.getSelecSeguimiento());
		parametrosReporte.agregaParametro("Par_NumeroReporte",Utileria.convierteEntero(segtoBean.getNumeroReporte()));

		parametrosReporte.agregaParametro("Par_NomInstitucion", segtoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision", segtoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",segtoBean.getNomUsuario());

		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public SeguimientoDAO getSeguimientoDAO() {
		return seguimientoDAO;
	}

	public void setSeguimientoDAO(SeguimientoDAO seguimientoDAO) {
		this.seguimientoDAO = seguimientoDAO;
	}	
}