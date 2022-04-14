package guardaValores.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import guardaValores.bean.CatOrigenesDocumentosBean;
import guardaValores.dao.CatOrigenesDocumentosDAO;

public class CatOrigenesDocumentosServicio extends BaseServicio {

	CatOrigenesDocumentosDAO catOrigenesDocumentosDAO = null;

	public static interface Enum_Con_CatOrigenDatos {
		int principal = 1;
		int activo	  = 2;
	}

	public static interface Enum_Lis_CatOrigenDatos {
		int Lis_Principal		= 1;
		int Lis_Combo			= 2;
		int Lis_Filtra			= 3;
		int Lis_FiltraActivos	= 4;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatOrigenesDocumentosBean catOrigenesDocumentosBean) {

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

	public CatOrigenesDocumentosBean consulta(int tipoConsulta, CatOrigenesDocumentosBean catOrigenesDocumentosBean) {

		CatOrigenesDocumentosBean instrumentos = null;
		try{
			switch(tipoConsulta){
			case Enum_Con_CatOrigenDatos.principal:
				instrumentos = catOrigenesDocumentosDAO.consultaPrincipal(catOrigenesDocumentosBean, tipoConsulta);
			break;
			case Enum_Con_CatOrigenDatos.activo:
				instrumentos = catOrigenesDocumentosDAO.consultaCatalogoActivo(catOrigenesDocumentosBean, tipoConsulta);
			break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Instrumentos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return instrumentos;
	}

	public List<CatOrigenesDocumentosBean> lista(int tipoLista, CatOrigenesDocumentosBean catOrigenesDocumentosBean) {

		List<CatOrigenesDocumentosBean> listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CatOrigenDatos.Lis_Principal:
					listaInstrumentos = catOrigenesDocumentosDAO.listaPrincipal(catOrigenesDocumentosBean, tipoLista);
				break;
				case Enum_Lis_CatOrigenDatos.Lis_Filtra:
					listaInstrumentos = catOrigenesDocumentosDAO.listaFiltrado(catOrigenesDocumentosBean, tipoLista);
				break;
				case Enum_Lis_CatOrigenDatos.Lis_FiltraActivos:
					listaInstrumentos = catOrigenesDocumentosDAO.listaFiltradoActivo(catOrigenesDocumentosBean, tipoLista);
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
				case Enum_Lis_CatOrigenDatos.Lis_Combo: 
					listaInstrumentos = catOrigenesDocumentosDAO.listaCombo(tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista Combo de Instrumentos Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}

	public CatOrigenesDocumentosDAO getCatOrigenesDocumentosDAO() {
		return catOrigenesDocumentosDAO;
	}

	public void setCatOrigenesDocumentosDAO( CatOrigenesDocumentosDAO catOrigenesDocumentosDAO) {
		this.catOrigenesDocumentosDAO = catOrigenesDocumentosDAO;
	}

}
