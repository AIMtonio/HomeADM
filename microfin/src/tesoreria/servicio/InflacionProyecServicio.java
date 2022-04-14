package tesoreria.servicio;

import tesoreria.bean.InflacionProyecBean;
import tesoreria.dao.InflacionProyecDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class InflacionProyecServicio extends BaseServicio{		
		InflacionProyecDAO inflacionProyecDAO =null;
		
		public InflacionProyecServicio(){
			super();
		}
		
		public interface Enum_Tran_InflacionProyec{
			int alta = 1;
		}
		public interface Enum_Con_InflacionProyec{
			int principal = 1;
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InflacionProyecBean inflacionProyecBean){
			MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
			switch(tipoTransaccion){
				case Enum_Tran_InflacionProyec.alta:
						mensaje= inflacionProyecDAO.altaInflacion(inflacionProyecBean);
					break;
			}
			return mensaje;
		}
		
		public InflacionProyecBean consulta(int tipoConsulta){
			InflacionProyecBean inflacion=null;
			switch(tipoConsulta){
				case Enum_Con_InflacionProyec.principal:
						inflacion=inflacionProyecDAO.consultaPrincipal(tipoConsulta);
					break;
			}
			return inflacion;
		}
		
		
		public InflacionProyecDAO getInflacionProyecDAO() {
			return inflacionProyecDAO;
		}
		public void setInflacionProyecDAO(InflacionProyecDAO inflacionProyecDAO) {
			this.inflacionProyecDAO = inflacionProyecDAO;
		}
				
}
