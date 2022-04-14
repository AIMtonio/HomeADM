package guardaValores.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import guardaValores.bean.CatalogoMovGuardaValoresBean;
import guardaValores.dao.CatalogoMovGuardaValoresDAO;

public class CatalogoMovGuardaValoresServicio extends BaseServicio {

	CatalogoMovGuardaValoresDAO catalogoMovGuardaValoresDAO = null;

	public static interface Enum_Con_CatMovimientos {
		int principal	= 1;
	}
	
	public static interface Enum_Lis_CatInstrumentos {
		int Lis_Principal	= 1;
		int Lis_Combo		= 2;
	}
	
	public CatalogoMovGuardaValoresBean consulta(int tipoConsulta, CatalogoMovGuardaValoresBean catalogoMovGuardaValoresBean) {

		CatalogoMovGuardaValoresBean instrumentos = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_CatMovimientos.principal:
					instrumentos = catalogoMovGuardaValoresDAO.consultaPrincipal(catalogoMovGuardaValoresBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Movimientos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return instrumentos;
	}
	
	public List<CatalogoMovGuardaValoresBean> lista(int tipoLista, CatalogoMovGuardaValoresBean catalogoMovGuardaValoresBean) {

		List<CatalogoMovGuardaValoresBean> listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CatInstrumentos.Lis_Principal:
					listaInstrumentos = catalogoMovGuardaValoresDAO.listaPrincipal(catalogoMovGuardaValoresBean, tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Movimientos Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CatInstrumentos.Lis_Combo: 
					listaInstrumentos = catalogoMovGuardaValoresDAO.listaComboPantalla(tipoLista);
				break;
			}
			
		}catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Combo Movimientos de Pantalla Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}

	public CatalogoMovGuardaValoresDAO getCatalogoMovGuardaValoresDAO() {
		return catalogoMovGuardaValoresDAO;
	}

	public void setCatalogoMovGuardaValoresDAO(CatalogoMovGuardaValoresDAO catalogoMovGuardaValoresDAO) {
		this.catalogoMovGuardaValoresDAO = catalogoMovGuardaValoresDAO;
	}
}	

