package cuentas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cuentas.dao.RepCtasLimitesExcedDAO;
import cuentas.bean.RepCtasLimitesExcedBean;


	public class RepCtasLimitesExcedServicio extends BaseServicio{

		
		/* Declaracion de Variables */
		RepCtasLimitesExcedDAO repCtasLimitesExcedDAO = null;
		ParametrosAuditoriaBean parametrosAuditoriaBean = null;
		public RepCtasLimitesExcedServicio() {
			super();
		}
		
		/* Enumera los tipos de lista para reportes */
		public static interface Enum_Tip_Reporte { 
			int excel = 1;
		}

	

		/* ========================== TRANSACCIONES ==============================  */


		/* Controla los tipos de lista para reportes de Limites Excedidos*/
		public List listaReporte(int tipoLista, RepCtasLimitesExcedBean repCtasLimitesExcedBean , HttpServletResponse response){
			 List listasolicitudesAE=null;
			 switch(tipoLista){		
				case  Enum_Tip_Reporte.excel:
					listasolicitudesAE = repCtasLimitesExcedDAO.listaReporte(repCtasLimitesExcedBean, tipoLista);
					break;				
			}	
			return listasolicitudesAE;
		}
		
		/* =========  Reporte de Solicitudes de Limites Excedidos  =========== */
			public ByteArrayOutputStream reporteLimitesExced(int tipoReporte, RepCtasLimitesExcedBean repCtasLimitesExcedBean , String nomReporte) throws Exception{
				
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_FechaInicio",Utileria.convierteFecha(repCtasLimitesExcedBean.getFechaInicio()) );
				parametrosReporte.agregaParametro("Par_FechaFin",Utileria.convierteFecha(repCtasLimitesExcedBean.getFechaFin()) );
				parametrosReporte.agregaParametro("Par_Motivo",repCtasLimitesExcedBean.getMotivo());
				parametrosReporte.agregaParametro("Par_SucursalID",repCtasLimitesExcedBean.getSucursalID());
				
				parametrosReporte.agregaParametro("Par_NombreInstitucion", repCtasLimitesExcedBean.getNombreInstitucion());
				parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(repCtasLimitesExcedBean.getFechaSistema()));
				parametrosReporte.agregaParametro("Par_Usuario",repCtasLimitesExcedBean.getNombreUsuario().toUpperCase());
				parametrosReporte.agregaParametro("Par_NomSucursal",repCtasLimitesExcedBean.getNombreSucurs());
				parametrosReporte.agregaParametro("Par_MotivoDesc",repCtasLimitesExcedBean.getDescripcion());

				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
			

		/* ===================== GETTER's Y SETTER's ======================= */
		public RepCtasLimitesExcedDAO getRepCtasLimitesExcedDAO() {
			return repCtasLimitesExcedDAO;
		}

		public void setRepCtasLimitesExcedDAO(
				RepCtasLimitesExcedDAO repCtasLimitesExcedDAO) {
			this.repCtasLimitesExcedDAO = repCtasLimitesExcedDAO;
		}

		public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
			return parametrosAuditoriaBean;
		}

		public void setParametrosAuditoriaBean(
				ParametrosAuditoriaBean parametrosAuditoriaBean) {
			this.parametrosAuditoriaBean = parametrosAuditoriaBean;
		}
			
	}// fin de la clase

