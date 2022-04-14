package originacion.servicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import originacion.bean.SocDemogViviendaBean;
import originacion.dao.SosDemogViviendaDAO;

public class SocDemoViviendaServicio extends BaseServicio {

	SosDemogViviendaDAO sosDemogViviendaDAO=null;
	
	public static interface Enum_Con_Conyugue {
		int principal = 1;
		 
	}
 
	public static interface Enum_Tra_Conyugue {
		int grabar = 1;
	}
	
	public SocDemoViviendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SocDemogViviendaBean socDemogViviendaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Conyugue.grabar:
			mensaje = sosDemogViviendaDAO.grabaDatosSocioDemoVivienda(socDemogViviendaBean);
			break;
		}
	return mensaje;	
	}
	
	public SocDemogViviendaBean consulta(int tipoConsulta, SocDemogViviendaBean socDemogViviendaBean){
		SocDemogViviendaBean SocDemogViviendaResulBean = null;
		switch(tipoConsulta){
		case Enum_Con_Conyugue.principal:
			SocDemogViviendaResulBean = sosDemogViviendaDAO.consultaPrincipal(socDemogViviendaBean, tipoConsulta);
			break;
		
		}
		return SocDemogViviendaResulBean;		
	}
	
	
	public List comboMaterialVivienda(int tipoConsulta, SocDemogViviendaBean socDemogViviendaBean){
		List 	listaTiposMatVivienda = null;
				listaTiposMatVivienda =   sosDemogViviendaDAO.listaTiposMaterVivienda(socDemogViviendaBean, tipoConsulta);
 		return listaTiposMatVivienda;		
	}
	
	
	
	public List comboTiposVivienda(int tipoConsulta, SocDemogViviendaBean socDemogViviendaBean){
		List 	listaTiposVivienda = null;
				listaTiposVivienda =   sosDemogViviendaDAO.listaTiposVivienda(socDemogViviendaBean, tipoConsulta);
 		return listaTiposVivienda;		
	}
	
	
	
	public SocDemogViviendaBean restableceParamsConyugue(SocDemogViviendaBean socDemogViviendaBean,
			HttpServletRequest request){
		SocDemogViviendaBean socDemViviendaResBean = new SocDemogViviendaBean();
		
		socDemViviendaResBean.setProspectoID(request.getParameter("forma4ProspectoID")!=null? request.getParameter("forma4ProspectoID"):"0");
		socDemViviendaResBean.setClienteID(request.getParameter("forma4ClienteID")!=null? request.getParameter("forma4ClienteID"):"0");
		socDemViviendaResBean.setConAgua(socDemogViviendaBean.getConAgua());
		socDemViviendaResBean.setConDrenaje(socDemogViviendaBean.getConDrenaje());
		socDemViviendaResBean.setConElectricidad(socDemogViviendaBean.getConElectricidad());
		socDemViviendaResBean.setConGas(socDemogViviendaBean.getConGas());
		socDemViviendaResBean.setConPavimento(socDemogViviendaBean.getConPavimento());
		socDemViviendaResBean.setDescripcion(socDemogViviendaBean.getDescripcion());
		socDemViviendaResBean.setTipoMaterialID(socDemogViviendaBean.getTipoMaterialID());
		socDemViviendaResBean.setTipoViviendaID(socDemogViviendaBean.getTipoViviendaID());
		socDemViviendaResBean.setValorVivienda(socDemogViviendaBean.getValorVivienda());
		socDemViviendaResBean.setTiempoHabitarDom(socDemogViviendaBean.getTiempoHabitarDom());
		return socDemViviendaResBean;
		
	}
	public void setSosDemogViviendaDAO(SosDemogViviendaDAO sosDemogViviendaDAO){
		this.sosDemogViviendaDAO = sosDemogViviendaDAO;
	}
	
	public SosDemogViviendaDAO getSosDemogViviendaDAO(){
		return this.sosDemogViviendaDAO;
	}
}
