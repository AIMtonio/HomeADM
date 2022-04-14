package pld.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import pld.dao.OperLimExcedidosRepDAO;
import pld.bean.OperLimExcedidosRepBean;

public class OperLimExcedidosRepServicio extends BaseServicio {

	/* Declaracion de Variables */
	OperLimExcedidosRepDAO operLimExcedidosRepDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;

	public OperLimExcedidosRepServicio() {
		super();
	}

	/* Enumera los tipos de lista para reportes */
	public static interface Enum_Tip_Reporte {
		int excel = 1;
	}

	/* ========================== TRANSACCIONES ============================== */

	/*
	 * Controla los tipos de lista para reportes de Operaciones Limites
	 * Excedidos
	 */
	public List listaReporte(int tipoLista,
			OperLimExcedidosRepBean operLimExcedidosRepBean,
			HttpServletResponse response) {
		List listaRep = null;
		switch (tipoLista) {
		case Enum_Tip_Reporte.excel:
			listaRep = operLimExcedidosRepDAO.listaReporte(operLimExcedidosRepBean, tipoLista);
			break;
		}
		return listaRep;
	}

	/* ========= Reporte de Operaciones de Limites Excedidos =========== */
	public ByteArrayOutputStream reporteLimitesExced(int tipoReporte, OperLimExcedidosRepBean operLimExcedidosRepBean, String nomReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", Utileria.convierteFecha(operLimExcedidosRepBean.getFechaInicio()));
		parametrosReporte.agregaParametro("Par_FechaFin", Utileria.convierteFecha(operLimExcedidosRepBean.getFechaFin()));
		parametrosReporte.agregaParametro("Par_Monto", operLimExcedidosRepBean.getMonto());
		parametrosReporte.agregaParametro("Par_MontoDes", operLimExcedidosRepBean.getMontoDes());
		parametrosReporte.agregaParametro("Par_PeriodoRep", operLimExcedidosRepBean.getPeriodo());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", operLimExcedidosRepBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", Utileria.convierteFecha(operLimExcedidosRepBean.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario", operLimExcedidosRepBean.getNombreUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_NomSucursal", operLimExcedidosRepBean.getNombreSucurs());
		parametrosReporte.agregaParametro("Par_MontoOpe", operLimExcedidosRepBean.getMontoOp());
		parametrosReporte.agregaParametro("Par_TipoPersona", operLimExcedidosRepBean.getTipoPersona());
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/* ===================== GETTER's Y SETTER's ======================= */

	public OperLimExcedidosRepDAO getOperLimExcedidosRepDAO() {
		return operLimExcedidosRepDAO;
	}

	public void setOperLimExcedidosRepDAO(
			OperLimExcedidosRepDAO operLimExcedidosRepDAO) {
		this.operLimExcedidosRepDAO = operLimExcedidosRepDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

}// fin de la clase

