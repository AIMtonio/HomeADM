package fira.servicio;

import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;

import credito.bean.CreditosBean;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class ContratosFiraServicio extends BaseServicio {
	public ContratosFiraServicio() {
		super();
	}
	/**
	 * Genera el reporte del Contrato Fira (Fisica, Refaccionario
	 * @param request : {@link HttpServletRequest} request de pantalla
	 * @param nomReporte : Nombre del PRPT
	 * @param bean : {@link CreditosBean} Bean con la información de pantalla
	 * @return {@link ByteArrayOutputStream}
	 * @throws Exception
	 */
	public ByteArrayOutputStream contrato(HttpServletRequest request, String nomReporte, CreditosBean bean) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CreditoID", bean.getCreditoID());
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
}
