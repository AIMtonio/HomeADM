package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CarteraVencidaDAO;
import general.servicio.BaseServicio;

public class CarteraVencidaServicio extends BaseServicio{
	CarteraVencidaDAO carteraVencidaDAO = null;
	
	public CarteraVencidaServicio() {
		super();
	}
	
	 /* ====== Tipo de Lista para Cartera Vencida ======= */
	public static interface Enum_Lis_CarteraVencida	{
		int excel	 = 1;
	}

	 /* ======== Tipo de Consulta para Cartera Vencida ======= */
	public static interface Enum_Con_CarteraVencida	{
		int carteraVencida	 = 1;
	}
		
	public List <UACIRiesgosBean>listaReporteCarteraVencida(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CarteraVencida.excel:
				listaReportes = carteraVencidaDAO.reporteCarteraVencida(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgosCarteraVen = null;
		switch (tipoConsulta) {
			case Enum_Con_CarteraVencida.carteraVencida:	
				riesgosCarteraVen = carteraVencidaDAO.consultaCarteraVencida(riesgosBean,tipoConsulta);
				break;									
		}				
		return riesgosCarteraVen;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public CarteraVencidaDAO getCarteraVencidaDAO() {
		return carteraVencidaDAO;
	}

	public void setCarteraVencidaDAO(CarteraVencidaDAO carteraVencidaDAO) {
		this.carteraVencidaDAO = carteraVencidaDAO;
	}

}
