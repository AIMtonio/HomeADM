package soporte.servicio;
import soporte.bean.CargosObjArchivosBean;
import soporte.bean.ResultadoCargaArchivosObjetadosBean;
import soporte.dao.CargosObjArchivosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CargosObjArchivosServicio extends BaseServicio {
	public CargosObjArchivosDAO cargosObjArchivosDAO  = null;
	public static interface Enum_Tra_Activos{
		int grabar	 = 1;
	}
		// TODO Auto-generated constructor stub
	
	public ResultadoCargaArchivosObjetadosBean grabaTransaccion(int tipoTransaccion, CargosObjArchivosBean cargosObjArchivosBean){		
		ResultadoCargaArchivosObjetadosBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_Activos.grabar):
				mensaje = cargosObjArchivosDAO.cargaCargosObjetados(cargosObjArchivosBean);
				break;
		}
		return mensaje;
	}

	public CargosObjArchivosDAO getCargosObjArchivosDAO() {
		return cargosObjArchivosDAO;
	}

	public void setCargosObjArchivosDAO(CargosObjArchivosDAO cargosObjArchivosDAO) {
		this.cargosObjArchivosDAO = cargosObjArchivosDAO;
	}


	

}
