
package originacion.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import originacion.bean.SolicidocreqBean;
import originacion.bean.SolicitudesArchivoBean;
import originacion.dao.SolicitudArchivoDAO;
import originacion.servicio.SolicidocreqServicio.Enum_Lis_SolDocReq;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ClienteArchivosBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.FileUploadServicio.Enum_Con_File;

public class SolicitudArchivoServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------
	SolicitudArchivoDAO solicitudArchivoDAO = null;

	public static interface Enum_Tra_ArchivoSolicitud {
		int altaSolDoc		= 1; //Alta de Archivos de Solicitud de Crédito
		int modificacion	= 2; //Modifcacion para los vistos buenos del analista
		
	}
	public static interface Enum_Con_ArchivoSolicitud {
		int principalSol   = 1; //Consulta principal de Archivos de Solicitud de Crédito
	}
	public static interface Enum_Lis_ArchivoSolCredito{
		int principalSolLis    = 1; //Lista principal de Archivos de Solicitud de Crédito
		int LisPorTipoDoc       = 2; //Lista de Archivos de Solicitud de Crédito por tipo de documento
		int comboDoc			= 3; // Lista de Documentos
	}
	public static interface Enum_Tra_ArchivoSolicitudConsulta{
		int ConsulCantDoc    = 1; //Consulta Cantidad de Archivos de Solicitud de Crédito
		int ConsulsizeDoc 	 =2;// Consulta del tamaño permitido para el archivo
	}
	public static interface Enum_Tra_ArchivoSolicitudBaja{
		int bajaPorFolio    = 1; //baja principal de Archivos de Solicitud de Crédito
		
	}
	
	/* Graba transaccion para Archivos o Documentos de las Solicitudes de  Credito */
	
	public MensajeTransaccionArchivoBean grabaTransaccionCredito(int tipoTransaccion, SolicitudesArchivoBean solicitudesArchivoBean) {
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_ArchivoSolicitud.altaSolDoc:
			mensaje = altaArchivosCredito(solicitudesArchivoBean);
			break;			
		case Enum_Tra_ArchivoSolicitud.modificacion:
			mensaje = actualizacionAnalista(solicitudesArchivoBean);
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean altaArchivosCredito(SolicitudesArchivoBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = solicitudArchivoDAO.altaArchivosSolCredito(file);		
		return mensaje;
	}
	
	
	/* transaccion para Baja de Archivos o Documentos de los creditos*/
	public MensajeTransaccionArchivoBean bajaArchivoCredito(int tipoBaja,SolicitudesArchivoBean solicitudesArchivoBean) {
		
			MensajeTransaccionArchivoBean mensaje = null;
			switch (tipoBaja) {
				case Enum_Tra_ArchivoSolicitudBaja.bajaPorFolio:
						mensaje = bajaArchivosCreditoPorFolio(solicitudesArchivoBean, tipoBaja);
						
						break;	

			}
			return mensaje;
	}

	public MensajeTransaccionArchivoBean bajaArchivosCreditoPorFolio(SolicitudesArchivoBean file, int tipoBaja){
			MensajeTransaccionArchivoBean mensaje = null;
			mensaje = solicitudArchivoDAO.procBajaArchivosSolCredito(file, tipoBaja);		
			return mensaje;
	}

	/*Lista de archivos de Solicitud de Crédito principal*/
	public List listaArchivosSolCredito(int tipoLista, SolicitudesArchivoBean solicitudesArchivoBean){		
		List listaArchSol = null;
		switch (tipoLista) {
			case Enum_Lis_ArchivoSolCredito.principalSolLis:		
				listaArchSol = solicitudArchivoDAO.listaArchivosSolCredito(solicitudesArchivoBean, tipoLista);				
				break;	
			case Enum_Lis_ArchivoSolCredito.LisPorTipoDoc:		
				listaArchSol = solicitudArchivoDAO.listaArchivosSolCreditoTipoDoc(solicitudesArchivoBean, tipoLista);				
				break;
		}		
		return listaArchSol;
	}
	
	//Consulta de archivos de Solicitud de Crédito
	public SolicitudesArchivoBean consulta(int tipoConsulta, SolicitudesArchivoBean solicitudesArchivoBean){
		SolicitudesArchivoBean archivo = null;
		switch (tipoConsulta) {
			case Enum_Tra_ArchivoSolicitudConsulta.ConsulCantDoc:		
				archivo = solicitudArchivoDAO.consultaCantDocumentos(solicitudesArchivoBean, tipoConsulta);	
				break;	
		
			
		}
				
		return archivo;
	}
	
	public ParamGeneralesBean consulParam(int tipoConsulta, ParamGeneralesBean param){
		ParamGeneralesBean para = null;
		switch (tipoConsulta) {
			case Enum_Tra_ArchivoSolicitudConsulta.ConsulsizeDoc:
				para = solicitudArchivoDAO.consultaSizeArchivo(param,tipoConsulta);	
				break;	
		}
				
		return para;
	}
	
	public List listaCombo(int tipoLista, SolicitudesArchivoBean solicitudesArchivoBean) {
		
		List listaTiposDocumentos = null;
		switch(tipoLista){
			case (Enum_Lis_ArchivoSolCredito.comboDoc): 
				listaTiposDocumentos =  solicitudArchivoDAO.listaDocumentosRequeridosProducto(solicitudesArchivoBean, tipoLista);
				break;
		
		}
		
		
		return listaTiposDocumentos;		
	}
	
	//Metodo para realizar el proceso de actualizacion analista
	private MensajeTransaccionArchivoBean actualizacionAnalista(SolicitudesArchivoBean archivosBean){
		MensajeTransaccionArchivoBean mensaje = null;
		ArrayList listaAnalista = (ArrayList) creaListaAnalista(archivosBean);
		mensaje = solicitudArchivoDAO.procesoActualizacionAnalista(archivosBean, listaAnalista);
		return mensaje;
	}
	
	/**
	 * @author olegario
	 * @descripcion Creacion de Listas para la actualizacion de documentos
	 */
	private List creaListaAnalista(SolicitudesArchivoBean bean){
		String digSolID 					= bean.getDigSolID();;
		String comentario					= bean.getComentario();
		String voBoAnalista					= bean.getVoBoAnalista();
		String comentarioAnalista			= bean.getComentarioAnalista();
		
		 List<String> listaDigSolID  			= new ArrayList<String>(Arrays.asList(digSolID.split(",")));
		 List<String> listaComentario   		= new ArrayList<String>(Arrays.asList(comentario.split(",")));
		 List<String> listaVoBoAnalista			= new ArrayList<String>(Arrays.asList(voBoAnalista.split(",")));
		 List<String> listaComentarioAnalista	= new ArrayList<String>(Arrays.asList(comentarioAnalista.split(",")));
		 
		ArrayList<SolicitudesArchivoBean> listAnalista = new ArrayList<SolicitudesArchivoBean>();
		
		SolicitudesArchivoBean beanAux = null;	
		
		if(listaDigSolID != null){
			int tamanio = listaDigSolID.size();			
				for (int iterador = 0; iterador < tamanio; iterador++) {
						beanAux = new SolicitudesArchivoBean();
						
						beanAux.setDigSolID(listaDigSolID.get(iterador));
						beanAux.setComentario(listaComentario.get(iterador));
						beanAux.setVoBoAnalista(listaVoBoAnalista.get(iterador));
						beanAux.setComentarioAnalista(listaComentarioAnalista.get(iterador));
						listAnalista.add(beanAux);
				}
			}
		return listAnalista;
	 }
	//Reporte de Archivos de credito PDF
	public ByteArrayOutputStream reporteArchivosSolicitudPDF(SolicitudesArchivoBean solicitudesArchivoBean , String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SolicitudCreditoID",solicitudesArchivoBean.getSolicitudCreditoID());
		parametrosReporte.agregaParametro("Par_TipoDocumentoID",solicitudesArchivoBean.getTipoDocumentoID());
		parametrosReporte.agregaParametro("Par_ClienteID",solicitudesArchivoBean.getClienteID());
		parametrosReporte.agregaParametro("Par_Estatus",solicitudesArchivoBean.getEstatus());
		parametrosReporte.agregaParametro("Par_NombreCliente",solicitudesArchivoBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_GrupoID",solicitudesArchivoBean.getGrupoID());
		parametrosReporte.agregaParametro("Par_NombreGrupo",solicitudesArchivoBean.getNombreGrupo());
		parametrosReporte.agregaParametro("Par_Ciclo",solicitudesArchivoBean.getCiclo());
		parametrosReporte.agregaParametro("Par_ProductoCredID",solicitudesArchivoBean.getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_NombreProdCred",solicitudesArchivoBean.getNombreProducto());
		parametrosReporte.agregaParametro("Par_Usuario",solicitudesArchivoBean.getNombreusuario());//isEmpty();//?creditosArchivoBean.getNombreusuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudesArchivoBean.getNombreInstitucion());//isEmpty())?creditosArchivoBean.getNombreInstitucion(): "TODOS");
		parametrosReporte.agregaParametro("Par_fecha",solicitudesArchivoBean.getParFechaEmision());
	
	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public SolicitudArchivoDAO getSolicitudArchivoDAO() {
		return solicitudArchivoDAO;
	}

	public void setSolicitudArchivoDAO(SolicitudArchivoDAO solicitudArchivoDAO) {
		this.solicitudArchivoDAO = solicitudArchivoDAO;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	
	
	
}
