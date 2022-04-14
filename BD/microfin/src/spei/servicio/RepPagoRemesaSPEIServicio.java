package spei.servicio;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import spei.bean.RepPagoRemesaSPEIBean;
import spei.dao.RepPagoRemesaSPEIDAO;

	public class RepPagoRemesaSPEIServicio extends BaseServicio {

		private RepPagoRemesaSPEIServicio() {
			super();
		}

		RepPagoRemesaSPEIDAO repPagoRemesaSPEIDAO = null;
		ParametrosAuditoriaBean parametrosAuditoriaBean = null;



		/* =========  Reporte PDF de pago de remesas SPEI (resumen) =========== */
		public ByteArrayOutputStream reportePagoRemesas(RepPagoRemesaSPEIBean repPagoRemesaSPEIBean , String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_TipoReporte",repPagoRemesaSPEIBean.getTipoReporte());
			parametrosReporte.agregaParametro("Par_NombreInstitucion", repPagoRemesaSPEIBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_FechaSistema",repPagoRemesaSPEIBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_ClaveUsuario",repPagoRemesaSPEIBean.getClaveUsuario());
			parametrosReporte.agregaParametro("Par_SucursalID",repPagoRemesaSPEIBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_FechaInicio",repPagoRemesaSPEIBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",repPagoRemesaSPEIBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_TipoOperacion",repPagoRemesaSPEIBean.getTipoOperacion());
			parametrosReporte.agregaParametro("Par_Estado",repPagoRemesaSPEIBean.getEstado());
			parametrosReporte.agregaParametro("Par_NivelReporte",repPagoRemesaSPEIBean.getNivelReporte());

			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}

		public RepPagoRemesaSPEIDAO getRepPagoRemesaSPEIDAO() {
			return repPagoRemesaSPEIDAO;
		}

		public void setRepPagoRemesaSPEIDAO(RepPagoRemesaSPEIDAO repPagoRemesaSPEIDAO) {
			this.repPagoRemesaSPEIDAO = repPagoRemesaSPEIDAO;
		}

		public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
			return parametrosAuditoriaBean;
		}

		public void setParametrosAuditoriaBean(
				ParametrosAuditoriaBean parametrosAuditoriaBean) {
			this.parametrosAuditoriaBean = parametrosAuditoriaBean;
		}

	}
