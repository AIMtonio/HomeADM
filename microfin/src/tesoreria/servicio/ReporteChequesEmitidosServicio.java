package tesoreria.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReporteChequesEmitidosBean;

public class ReporteChequesEmitidosServicio extends BaseServicio {

	private ParametrosSesionBean parametrosSesionBean;

	public ReporteChequesEmitidosServicio() {
		super();
	}
 
	public ByteArrayOutputStream reporteChequesEmitidosPDF(
			ReporteChequesEmitidosBean repChequesEmitidosbBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		String NombreInstBancaria =repChequesEmitidosbBean.getNombreInstitucionBancaria();
		byte[] bytes = NombreInstBancaria.getBytes("ISO-8859-1");
		NombreInstBancaria = new String(bytes, "UTF-8");
		String NombreSucursalEmision=repChequesEmitidosbBean.getNombreSucursalEmision();
		byte[] bytes2 = NombreSucursalEmision.getBytes("ISO-8859-1");
		NombreSucursalEmision = new String(bytes2, "UTF-8");
		try {

			parametrosReporte.agregaParametro("Par_NombreInstitucion", parametrosSesionBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio",repChequesEmitidosbBean.getFechaInicioEmision());
			parametrosReporte.agregaParametro("Par_FechaFin",repChequesEmitidosbBean.getFechaFinalEmision());
			parametrosReporte.agregaParametro("Par_InstiBancaria",repChequesEmitidosbBean.getInstitucionBancaria() == null || repChequesEmitidosbBean.getInstitucionBancaria().equals("") ? "0" : repChequesEmitidosbBean.getInstitucionBancaria());
			parametrosReporte.agregaParametro("Par_CtaBancaria",repChequesEmitidosbBean.getNumeroCuentaBancaria());
			parametrosReporte.agregaParametro("Par_TipoChequera",repChequesEmitidosbBean.getTipoChequera());
			parametrosReporte.agregaParametro("Par_NumCheque",repChequesEmitidosbBean.getNumeroCheque() == null || repChequesEmitidosbBean.getNumeroCheque().equals("") ? "0" : repChequesEmitidosbBean.getNumeroCheque());
			parametrosReporte.agregaParametro("Par_Estatus",repChequesEmitidosbBean.getEstatus() == null|| repChequesEmitidosbBean.getEstatus().equals("T") ? null: repChequesEmitidosbBean.getEstatus());
			parametrosReporte.agregaParametro("Par_Sucursal",repChequesEmitidosbBean.getSucursalEmision());
			parametrosReporte.agregaParametro("Par_NomSucEmision", NombreSucursalEmision);
			parametrosReporte.agregaParametro("Par_NomInstBancaria", NombreInstBancaria);
			parametrosReporte.agregaParametro("Par_Usuario",parametrosSesionBean.getClaveUsuario().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaSistema",parametrosSesionBean.getFechaAplicacion().toString());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Avalados", e);
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
