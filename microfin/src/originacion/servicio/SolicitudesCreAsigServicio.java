package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.SolicitudesCreAsigBean;
import originacion.dao.SolicitudesCreAsigDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class SolicitudesCreAsigServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	SolicitudesCreAsigDAO solicitudesCreAsigDAO;
	String codigo= "";
	int entero_uno=1;

	private SolicitudesCreAsigServicio(){
		super();
	}
	
	//---------- Tipos de Lista para Reportes----------------
	public static interface Enum_Tip_Reporte {
		int excel = 2;
	}
	
	public static interface Enum_Transaccion {
		int altaSolicitudAsignada = 1;
		int altaSolicitudMasiva = 2;
	}
	
	
	public static interface Enum_Lis_SolicitudesAsignadas{
        int listaGeneral = 1;
		int listaPorUsuario = 2;

	}
	public static interface Enum_Con_SolicitudAsgnaciones{
        int principal = 1;
        int analistasAsig = 2;
	}
	


	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SolicitudesCreAsigBean solicitudesCreAsigBean,String detalles){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Transaccion.altaSolicitudAsignada:
			mensaje = solicitudesCreAsigDAO.grabaSolicitudAsignacion(solicitudesCreAsigBean);
			break;
		case Enum_Transaccion.altaSolicitudMasiva:
			mensaje = grabaSolicitudMasiva(tipoTransaccion,solicitudesCreAsigBean,detalles);
			break;
		}

		return mensaje;
	}
	
	

	private MensajeTransaccionBean grabaSolicitudMasiva(int tipoTransaccion, SolicitudesCreAsigBean solicitudesCreAsigBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case Enum_Transaccion.altaSolicitudMasiva:
				detalles = solicitudesCreAsigBean.getListaAsignacionSol();
				break;
			}
			List<SolicitudesCreAsigBean> listaDetalle = creaListaSolicitudes(detalles);
			mensaje=solicitudesCreAsigDAO.grabaSolicitudMasiva(solicitudesCreAsigBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}
	
	private List<SolicitudesCreAsigBean> creaListaSolicitudes(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
	
		String stringCampos;
		String tokensCampos[];
		List<SolicitudesCreAsigBean> listaDetalle = new ArrayList<SolicitudesCreAsigBean>();
		SolicitudesCreAsigBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new SolicitudesCreAsigBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setSolicitudCreditoID(tokensCampos[0]);
			detalle.setTipoAsignacionID(tokensCampos[1]);
			detalle.setProductoID(tokensCampos[2]);
			detalle.setUsuarioID(tokensCampos[3]);

			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}
	
	
	public SolicitudesCreAsigBean consulta(int tipoConsulta, SolicitudesCreAsigBean solicitudesCreAsigBean){
		SolicitudesCreAsigBean solicitudesCreAsigCon = null;
		switch (tipoConsulta) {
			case Enum_Con_SolicitudAsgnaciones.principal:		
				solicitudesCreAsigCon = solicitudesCreAsigDAO.consultaPrincipal(solicitudesCreAsigBean, tipoConsulta);				
				break;
			case Enum_Con_SolicitudAsgnaciones.analistasAsig:		
				solicitudesCreAsigCon = solicitudesCreAsigDAO.consultaAnalistasAsig(solicitudesCreAsigBean, tipoConsulta);				
				break;
		}
		return solicitudesCreAsigCon;
	}
	
	public List lista(int tipoLista, SolicitudesCreAsigBean solicitudesCreAsigBean){
		List productosCreditoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_SolicitudesAsignadas.listaGeneral:
	        	productosCreditoLista = solicitudesCreAsigDAO.lista(solicitudesCreAsigBean,tipoLista);
	        break;
	        case  Enum_Lis_SolicitudesAsignadas.listaPorUsuario:
	        	productosCreditoLista = solicitudesCreAsigDAO.listaSolicitudesPorUsuario(solicitudesCreAsigBean,tipoLista);
	        break;

		}
		return productosCreditoLista;
	}
	
	public ByteArrayOutputStream reporteAsignacionSolCrePDF(SolicitudesCreAsigBean solicitudesCreAsigBean, String nombreReporte) throws Exception {
		// TODO Auto-generated method stub
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", solicitudesCreAsigBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio", solicitudesCreAsigBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin", solicitudesCreAsigBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_FechaEmision", solicitudesCreAsigBean.getHoraEmision());
			
			parametrosReporte.agregaParametro("Par_NomUsuario", solicitudesCreAsigBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_NombreAnalista", solicitudesCreAsigBean.getNombreAnalista());
			parametrosReporte.agregaParametro("Par_AnalistaID", solicitudesCreAsigBean.getAnalistaID());

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de asignacion de solicitudes de credito", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List<SolicitudesCreAsigBean> listaReporte(int tipoLista,SolicitudesCreAsigBean solicitudesCreAsigBean) {
		List<SolicitudesCreAsigBean> listaRep = null;
		switch (tipoLista) {
		case Enum_Tip_Reporte.excel:
			listaRep = solicitudesCreAsigDAO.listaReporte(solicitudesCreAsigBean);
			break;
		}
		return listaRep;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setSolicitudesCreAsigDAO(SolicitudesCreAsigDAO solicitudesCreAsigDAO) {
		this.solicitudesCreAsigDAO = solicitudesCreAsigDAO;
	}

	public SolicitudesCreAsigDAO getSolicitudesCreAsigDAO() {
		return solicitudesCreAsigDAO;
	}
	


}
