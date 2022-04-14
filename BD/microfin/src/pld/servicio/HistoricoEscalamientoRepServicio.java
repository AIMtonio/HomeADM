package pld.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import pld.bean.ParametrosEscalaBean;

import reporte.ParametrosReporte;
import reporte.Reporte;

public class HistoricoEscalamientoRepServicio extends BaseServicio {

	private ParametrosSesionBean parametrosSesionBean;

	public HistoricoEscalamientoRepServicio() {
		super();
	}

	public ByteArrayOutputStream reporteHistorico(ParametrosEscalaBean repEscalaBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", parametrosSesionBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_TipoPersona",repEscalaBean.getTipoPersona());
			parametrosReporte.agregaParametro("Par_TipoInstrumento",repEscalaBean.getTipoInstrumento());
			parametrosReporte.agregaParametro("Par_NacMoneda", repEscalaBean.getNacMoneda());
			parametrosReporte.agregaParametro("Par_TipoReporte",repEscalaBean.getTipoReporte());
			parametrosReporte.agregaParametro("Par_Usuario",parametrosSesionBean.getClaveUsuario().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaSistema",parametrosSesionBean.getFechaAplicacion().toString());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte del Historico Parametros Escalamiento", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(
			ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
