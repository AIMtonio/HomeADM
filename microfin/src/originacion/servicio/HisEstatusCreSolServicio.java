

package originacion.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.hibernate.loader.custom.Return;

import originacion.bean.HisEstatusCreSolBean;
import originacion.dao.HisEstatusCreSolDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio.Enum_Transaccion;

public class HisEstatusCreSolServicio extends BaseServicio{
	
	HisEstatusCreSolDAO hisEstatusCreSolDAO = null;
	
	private HisEstatusCreSolServicio(){
		super();
	}
	//---------- Tipos de Lista para Reportes----------------
	public static interface Enum_Tip_Reporte {
		int excel = 2;
	}
	

	public ByteArrayOutputStream reporteHisEstatusSolPDF(HisEstatusCreSolBean hisEstatusCreSolBean, String nombreReporte) throws Exception {
		// TODO Auto-generated method stub
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", hisEstatusCreSolBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio", hisEstatusCreSolBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin", hisEstatusCreSolBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_FechaSistema", hisEstatusCreSolBean.getFechaSistema());		
			parametrosReporte.agregaParametro("Par_Usuario", hisEstatusCreSolBean.getUsuario());
			parametrosReporte.agregaParametro("Par_SolicCredID", hisEstatusCreSolBean.getSolicitudCreID());

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte de Historial de estatus de solicitud credito", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}

	public List<HisEstatusCreSolBean> listaReporte(int tipoLista,HisEstatusCreSolBean hisEstatusCreSolBean) {
		List<HisEstatusCreSolBean> listaRep = null;
		switch (tipoLista) {
		case Enum_Tip_Reporte.excel:
			listaRep = hisEstatusCreSolDAO.listaReporte(hisEstatusCreSolBean);
			break;
		}
		return listaRep;
	}
	
	
	public HisEstatusCreSolDAO getHisEstatusCreSolDAO() {
		return hisEstatusCreSolDAO;
	}

	public void setHisEstatusCreSolDAO(HisEstatusCreSolDAO hisEstatusCreSolDAO) {
		this.hisEstatusCreSolDAO = hisEstatusCreSolDAO;
	}

}
