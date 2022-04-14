package pld.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import pld.bean.ProcesoEscalamientoInternoBean;
import pld.dao.ProcesoEscalamientoInternoDAO;

public class ProcesoEscalamientoInternoServicio extends BaseServicio{

	//------------Constantes------------------
	
	//---------- Variables ------------------------------------------------------------------------
	ProcesoEscalamientoInternoDAO procesoEscalamientoInternoDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ProcesoEscalamientoInterno {
		int principal = 1;
		
	} 

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_ProcesoEscalamientoInterno {
		int principal = 1;
		int reporte =2;
	}

	//---------- Constructor ------------------------------------------------------------------------
	public ProcesoEscalamientoInternoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaTiposCtas = null;

		ProcesoEscalamientoInternoBean procesoEscBean = new ProcesoEscalamientoInternoBean();
		procesoEscBean.setDescripcion(Constantes.STRING_VACIO);

		switch(tipoLista){
		case Enum_Lis_ProcesoEscalamientoInterno.principal:
		case Enum_Lis_ProcesoEscalamientoInterno.reporte:
			try{
				listaTiposCtas =  procesoEscalamientoInternoDAO.procesoEscalamientoIntlistaPrincipal(procesoEscBean, tipoLista);
			}catch (Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista combo", e);
			}
			break;
		}
		return listaTiposCtas.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public ProcesoEscalamientoInternoDAO getProcesoEscalamientoInternoDAO() {
		return procesoEscalamientoInternoDAO;
	}

	public void setProcesoEscalamientoInternoDAO(
			ProcesoEscalamientoInternoDAO procesoEscalamientoInternoDAO) {
		this.procesoEscalamientoInternoDAO = procesoEscalamientoInternoDAO;
	}	
	
}