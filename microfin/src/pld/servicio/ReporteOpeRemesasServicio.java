package pld.servicio;

import java.util.List;

import pld.bean.ReporteOpeRemesasBean;
import pld.dao.ReporteOpeRemesasDAO;
import ventanilla.bean.CatalogoRemesasBean;
import ventanilla.servicio.CatalogoRemesasServicio.Enum_Con_CatalogoRemesas;
import ventanilla.servicio.CatalogoRemesasServicio.Enum_Lis_CatalogoRemesas;

import general.servicio.BaseServicio;

public class ReporteOpeRemesasServicio extends BaseServicio{
	
	ReporteOpeRemesasDAO reporteOpeRemesasDAO = null;
	
	private ReporteOpeRemesasServicio(){
		super();
	}
	
	public List listaReporteOperaRemesas(ReporteOpeRemesasBean reporteOpeRemesasBean){
		List<ReporteOpeRemesasBean> listaRepOpeRem = null;	
		listaRepOpeRem = reporteOpeRemesasDAO.reporteOperaRemeExcel(reporteOpeRemesasBean); 				
		return listaRepOpeRem;
	}

	public ReporteOpeRemesasDAO getReporteOpeRemesasDAO() {
		return reporteOpeRemesasDAO;
	}

	public void setReporteOpeRemesasDAO(ReporteOpeRemesasDAO reporteOpeRemesasDAO) {
		this.reporteOpeRemesasDAO = reporteOpeRemesasDAO;
	}

}
