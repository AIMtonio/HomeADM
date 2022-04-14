package guardaValores.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import guardaValores.bean.CatalogoAlmacenesBean;
import guardaValores.dao.CatalogoAlmacenesDAO;

public class CatalogoAlmacenesServicio extends BaseServicio {

	CatalogoAlmacenesDAO catalogoAlmacenesDAO = null;

	public static interface Enum_Tran_CatAlmacenes {
		int alta	 = 1;
		int modifica = 2;
	}

	public static interface Enum_Con_CatAlmacenes {
		int principal = 1;
		int almacenesActivosSucursal = 2;
	}

	public static interface Enum_Lis_CatAlmacenes {
		int listaPrincipal				 = 1;
		int listaAlmacenActivosSucursal  = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatalogoAlmacenesBean catalogoAlmacenesBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{
			switch (tipoTransaccion) {
				case Enum_Tran_CatAlmacenes.alta:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = catalogoAlmacenesDAO.altaCatalogoAlmacenes(catalogoAlmacenesBean);
				break;
				case Enum_Tran_CatAlmacenes.modifica:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = catalogoAlmacenesDAO.modificaCatalogoAlmacenes(catalogoAlmacenesBean);
				break;
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

	public CatalogoAlmacenesBean consulta(int tipoConsulta, CatalogoAlmacenesBean catalogoAlmacenesBean) {

		CatalogoAlmacenesBean almacenes = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_CatAlmacenes.principal:
					almacenes = catalogoAlmacenesDAO.consultaPrincipal(catalogoAlmacenesBean, tipoConsulta);
				break;
				case Enum_Con_CatAlmacenes.almacenesActivosSucursal:
					almacenes = catalogoAlmacenesDAO.consultaAlmacenActSuc(catalogoAlmacenesBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Almacenes en Guarda Valores", exception);
			exception.printStackTrace();
		}
		return almacenes;
	}

	public List<CatalogoAlmacenesBean> lista(int tipoLista, CatalogoAlmacenesBean catalogoAlmacenesBean) {

		List<CatalogoAlmacenesBean> listaAlmacenes = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CatAlmacenes.listaPrincipal:
					listaAlmacenes = catalogoAlmacenesDAO.listaPrincipal(catalogoAlmacenesBean, tipoLista);
				break;
				case Enum_Lis_CatAlmacenes.listaAlmacenActivosSucursal:
					listaAlmacenes = catalogoAlmacenesDAO.listaAlmacenesActivo(catalogoAlmacenesBean, tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Almacenes en Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaAlmacenes;
	}

	public CatalogoAlmacenesDAO getCatalogoAlmacenesDAO() {
		return catalogoAlmacenesDAO;
	}

	public void setCatalogoAlmacenesDAO(CatalogoAlmacenesDAO catalogoAlmacenesDAO) {
		this.catalogoAlmacenesDAO = catalogoAlmacenesDAO;
	}

}
