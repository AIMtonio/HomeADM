package sms.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import sms.bean.ResumenActividadSMSBean;
import sms.bean.SMSCapaniasBean;
import sms.bean.SMSTiposCampaniasBean;
import sms.dao.ResumenActividadSMSDAO;
 

public class ResumenActividadSMSServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ResumenActividadSMSDAO resumenActividadSMSDAO = null;
	SMSTiposCampaniasServicio	smsTiposCampaniasServicio =null;
	SMSCapaniasServicio smsCapaniasServicio = null;
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Resumen {
		int principal	= 1;
		int resumen		= 2;
	}
	public static interface Enum_Tra_Resumen {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_Resumen {
		int principal = 1;
		int foranea =2;
	}
	
	
	public ResumenActividadSMSServicio () {
		super();
		// TODO Auto-generated constructor stub
	}


	// Lista resumen actividad
		public List lista(int tipoLista, ResumenActividadSMSBean resumenActividadSMSBean){
			List resumenLista = null;
			switch (tipoLista) {
		        case  Enum_Lis_Resumen.principal:
		        	
		        break;
		        case  Enum_Lis_Resumen.resumen:
		        	resumenLista = resumenActividadSMSDAO.listaResumenAct(resumenActividadSMSBean, tipoLista);
		        break;
		        
		    
			}
			return resumenLista;
		}
		

		
		// Reporte  de detalle de resumen de actividad sms PDF
		public ByteArrayOutputStream reporteDetalleResumenActPDF(ResumenActividadSMSBean resumenActividadSMSBean, 
				String nombreReporte) throws Exception{
			
				SMSTiposCampaniasBean smsTiposCampaniasBean = new SMSTiposCampaniasBean();
				SMSTiposCampaniasBean smsTiposCampanias =null;
				smsTiposCampaniasBean.setTipoCampaniaID(resumenActividadSMSBean.getTipo());
				smsTiposCampanias = smsTiposCampaniasServicio.consulta(Enum_Con_Resumen.foranea, smsTiposCampaniasBean);
				
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_Campania",Utileria.convierteEntero(resumenActividadSMSBean.getCampaniaID()));
				parametrosReporte.agregaParametro("Par_Clasificacion",resumenActividadSMSBean.getClasificacion());
				parametrosReporte.agregaParametro("Par_Categoria",resumenActividadSMSBean.getCategoria());
				parametrosReporte.agregaParametro("Par_Tipo",resumenActividadSMSBean.getTipo()+"- "+smsTiposCampanias.getNombre());
				parametrosReporte.agregaParametro("Par_CodigoResp",resumenActividadSMSBean.getCodigoRespuesta());
				parametrosReporte.agregaParametro("Par_NomInstitucion",resumenActividadSMSBean.getEmpresaID());
				parametrosReporte.agregaParametro("Par_RutaImagen", resumenActividadSMSBean.getRutaImagen());

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		// Reporte de actividad sms PDF
		public ByteArrayOutputStream reporteActividadSMSPDF(ResumenActividadSMSBean resumenActividadSMSBean, 
			String nombreReporte) throws Exception{
			String descEstatus= "";
			if(resumenActividadSMSBean.getEstatus().equals("E")){
				descEstatus = "ENVIADO";
			}else if(resumenActividadSMSBean.getEstatus().equals("N")){
				descEstatus = "NO ENVIADO";
			}else if(resumenActividadSMSBean.getEstatus().equals("C")){
				descEstatus = "CANCELADO";
			}
			SMSCapaniasBean smsCampaniasBean = new SMSCapaniasBean();
			SMSCapaniasBean smsCampanias =null;
			smsCampaniasBean.setCampaniaID(resumenActividadSMSBean.getCampaniaID());
			smsCampanias = smsCapaniasServicio.consulta(Enum_Con_Resumen.foranea, smsCampaniasBean);
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Campania",Utileria.convierteEntero(resumenActividadSMSBean.getCampaniaID()));
			parametrosReporte.agregaParametro("Par_Estatus",resumenActividadSMSBean.getEstatus());
			parametrosReporte.agregaParametro("Par_FechaInicio",resumenActividadSMSBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",resumenActividadSMSBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_NomInstitucion",resumenActividadSMSBean.getNomInstitucion());
			parametrosReporte.agregaParametro("Par_NomUsuario",resumenActividadSMSBean.getNomUsuario());
			parametrosReporte.agregaParametro("Par_NomCampania", ((resumenActividadSMSBean.getCampaniaID().equals("0"))?"TODAS":smsCampanias.getNombre()));
			parametrosReporte.agregaParametro("Par_FechaEmision", resumenActividadSMSBean.getFechaEmision());
			parametrosReporte.agregaParametro("Par_RutaImagen", resumenActividadSMSBean.getRutaImagen());
			parametrosReporte.agregaParametro("Par_DescEstatus",  descEstatus);
	
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
	//------------------ Geters y Seters ------------------------------------------------------	
	
		public ResumenActividadSMSDAO getResumenActividadSMSDAO() {
			return resumenActividadSMSDAO;
		}

		public void setResumenActividadSMSDAO(
				ResumenActividadSMSDAO resumenActividadSMSDAO) {
			this.resumenActividadSMSDAO = resumenActividadSMSDAO;
		}


		public void setSmsTiposCampaniasServicio(
				SMSTiposCampaniasServicio smsTiposCampaniasServicio) {
			this.smsTiposCampaniasServicio = smsTiposCampaniasServicio;
		}


		public void setSmsCapaniasServicio(SMSCapaniasServicio smsCapaniasServicio) {
			this.smsCapaniasServicio = smsCapaniasServicio;
		}
	
	
}

