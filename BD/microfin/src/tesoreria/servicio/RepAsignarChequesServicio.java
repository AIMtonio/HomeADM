package tesoreria.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.RepAsignarChequesBean;

public class RepAsignarChequesServicio extends BaseServicio {

	private ParametrosSesionBean parametrosSesionBean;

	public RepAsignarChequesServicio() {
		super();
	}

	public ByteArrayOutputStream reporteChequesAsignados(RepAsignarChequesBean repChequesAsigBean,	String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		String NombreInstBancaria =repChequesAsigBean.getNombreInstitucionBancaria();
		byte[] bytes = NombreInstBancaria.getBytes("ISO-8859-1");
		NombreInstBancaria = new String(bytes, "UTF-8");
		String NombreSucursal =repChequesAsigBean.getNombreSucursal();
		byte[] bytes2 = NombreSucursal.getBytes("ISO-8859-1");
		NombreSucursal = new String(bytes2, "UTF-8");
		
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", parametrosSesionBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio",repChequesAsigBean.getFechaInicioEmision());
			parametrosReporte.agregaParametro("Par_FechaFin",repChequesAsigBean.getFechaFinalEmision());
			parametrosReporte.agregaParametro("Par_InstitucionID",repChequesAsigBean.getInstitucionID() == null || repChequesAsigBean.getInstitucionID().equals("") ? "0" : repChequesAsigBean.getInstitucionID());
			parametrosReporte.agregaParametro("Par_NomInstBancaria", NombreInstBancaria);
			parametrosReporte.agregaParametro("Par_NumCtaInstit",repChequesAsigBean.getNumCtaInstit());
			parametrosReporte.agregaParametro("Par_TipoChequera",repChequesAsigBean.getTipoChequera());
			parametrosReporte.agregaParametro("Par_SucursalID", repChequesAsigBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_NombreSucursal", NombreSucursal);
			parametrosReporte.agregaParametro("Par_TipoReporte", repChequesAsigBean.getTipoReporte());
			parametrosReporte.agregaParametro("Par_Usuario",parametrosSesionBean.getClaveUsuario().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaSistema",parametrosSesionBean.getFechaAplicacion().toString());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte de Cheques Asignados", e);
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
