package guardaValores.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import guardaValores.bean.CatInstGuardaValoresBean;
import guardaValores.dao.CatInstGuardaValoresDAO;

public class CatInstGuardaValoresServicio extends BaseServicio {

	CatInstGuardaValoresDAO catInstGuardaValoresDAO = null;

	public static interface Enum_Con_CatInstrumentos {
		int principal = 1;
		int activo	  = 2;
	}

	public static interface Enum_Lis_CatInstrumentos {
		int Lis_Principal		= 1;
		int Lis_Combo			= 2;
		int Lis_Filtra			= 3;
		int Lis_FiltraActivos	= 4;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatInstGuardaValoresBean catInstGuardaValoresBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{
			switch (tipoTransaccion) {
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transaccion desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transaccion");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public CatInstGuardaValoresBean consulta(int tipoConsulta, CatInstGuardaValoresBean catInstGuardaValoresBean) {

		CatInstGuardaValoresBean instrumentos = null;
		try{
			switch(tipoConsulta){
			case Enum_Con_CatInstrumentos.principal:
				instrumentos = catInstGuardaValoresDAO.consultaPrincipal(catInstGuardaValoresBean, tipoConsulta);
			break;
			case Enum_Con_CatInstrumentos.activo:
				instrumentos = catInstGuardaValoresDAO.consultaCatalogoActivo(catInstGuardaValoresBean, tipoConsulta);
			break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Instrumentos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return instrumentos;
	}

	public List<CatInstGuardaValoresBean> lista(int tipoLista, CatInstGuardaValoresBean catInstGuardaValoresBean) {

		List<CatInstGuardaValoresBean> listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CatInstrumentos.Lis_Principal:
					listaInstrumentos = catInstGuardaValoresDAO.listaPrincipal(catInstGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_CatInstrumentos.Lis_Combo:
					listaInstrumentos = catInstGuardaValoresDAO.listaPrincipal(catInstGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_CatInstrumentos.Lis_Filtra:
					listaInstrumentos = catInstGuardaValoresDAO.listaFiltrado(catInstGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_CatInstrumentos.Lis_FiltraActivos:
					listaInstrumentos = catInstGuardaValoresDAO.listaFiltradoActivo(catInstGuardaValoresBean, tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Instrumentos Guarda Valores ", exception);
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
					listaInstrumentos = catInstGuardaValoresDAO.listaCombo(tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista Combo de Instrumentos Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}

	public CatInstGuardaValoresDAO getCatInstGuardaValoresDAO() {
		return catInstGuardaValoresDAO;
	}

	public void setCatInstGuardaValoresDAO(CatInstGuardaValoresDAO catInstGuardaValoresDAO) {
		this.catInstGuardaValoresDAO = catInstGuardaValoresDAO;
	}
	
}
