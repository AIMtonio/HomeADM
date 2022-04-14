package pld.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import pld.bean.PersInvListasBean;
import pld.dao.PersInvListasDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class PersInvListasServicio extends BaseServicio {

	PersInvListasDAO	persInvListasDAO	= null;

	public PersInvListasServicio() {
		super();
	}
	public List<PersInvListasBean> lista(PersInvListasBean persInvListasBean) {
		List<PersInvListasBean> lista = null;
		int tipoLista = Utileria.convierteEntero(persInvListasBean.getTipoLista());
		lista = persInvListasDAO.listaReporte(tipoLista,persInvListasBean);
		return lista;
	}

	public ByteArrayOutputStream reportePDF(PersInvListasBean persInvListasBean, String nombreReporte) {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", persInvListasBean.getNombreInstitucion() != null ? persInvListasBean.getNombreInstitucion().toUpperCase() : Constantes.STRING_VACIO);
			parametrosReporte.agregaParametro("Par_Sucursal", persInvListasBean.getSucursal());
			parametrosReporte.agregaParametro("Par_TipoLista", persInvListasBean.getTipoLista());
			parametrosReporte.agregaParametro("Par_Usuario", persInvListasBean.getUsuario());
			parametrosReporte.agregaParametro("Par_FechaSistema", persInvListasBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_NombreSucursal", persInvListasBean.getSucursalDes());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en el Reporte de Clientes en Listas PLD", e);
		}
		return null;
	}

	public PersInvListasDAO getPersInvListasDAO() {
		return persInvListasDAO;
	}

	public void setPersInvListasDAO(PersInvListasDAO persInvListasDAO) {
		this.persInvListasDAO = persInvListasDAO;
	}

}
